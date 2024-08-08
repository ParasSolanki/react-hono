
FROM node:20.16-bullseye as base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base as build
WORKDIR /app
COPY --link ./pnpm-workspace.yaml ./
COPY --link ./pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --prod --frozen-lockfile

ENV NODE_ENV="production"
COPY --link . .
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm recursive install --offline --frozen-lockfile

RUN pnpm build:api
RUN pnpm build:web

FROM base
# Copy only the necessary files from the cleanup stage
COPY --from=build /app/dist/server/dist /app/dist
COPY --from=build /app/dist/server/node_modules /app/node_modules
COPY --from=build /app/dist/web/dist /app/frontend/dist

EXPOSE 3000

CMD [ "node", "dist/index.js" ]