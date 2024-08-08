
FROM node:20.16-slim as base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base as build
WORKDIR /app
COPY --link ./pnpm-lock.yaml ./pnpm-workspace.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --frozen-lockfile

ENV NODE_ENV="production"
ADD . ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install -r --offline --frozen-lockfile

RUN pnpm run -r build

FROM base
# Copy only the necessary files from the cleanup stage
COPY --from=build /app/dist/server/dist /app/dist
COPY --from=build /app/dist/server/node_modules /app/node_modules
COPY --from=build /app/dist/web/dist /app/frontend/dist

EXPOSE 3000

CMD [ "node", "dist/index.js" ]