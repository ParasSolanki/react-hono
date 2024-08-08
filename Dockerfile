
FROM node:20.16-bullseye as base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM workspace as pruned

RUN pnpm --filter=server deploy dist/server
RUN pnpm --filter=wev deploy dist/web

WORKDIR /app

ENV NODE_ENV="production"

# Build the server and web
RUN cd dist/server && pnpm run build
RUN cd dist/web && pnpm run build

# Final stage
FROM base
# Copy only the necessary files from the cleanup stage
COPY --from=pruned /app/dist/server/dist /app/dist
COPY --from=pruned /app/dist/server/node_modules /app/node_modules
COPY --from=pruned /app/dist/web/dist /app/frontend/dist

EXPOSE 3000

CMD [ "node", "dist/index.js" ]