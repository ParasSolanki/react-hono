FROM node:20.16-bullseye AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

ENV NODE_ENV="production"

FROM base AS prod-deps

COPY --link . .
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --frozen-lockfile
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile 


FROM base AS build

COPY --link . .

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --frozen-lockfile 
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile 

# Build the server and web
RUN pnpm run -r build

# Final stage
FROM base
# Copy only the necessary files from the cleanup stage
COPY --from=build /app/apps/server/dist /app/dist
COPY --from=build /app/apps/server/package.json /app/package.json
COPY --from=build /app/apps/web/dist /app/frontend/dist
COPY --from=prod-deps /app/node_modules /app/node_modules

EXPOSE 3000

CMD [ "pnpm", "start" ]