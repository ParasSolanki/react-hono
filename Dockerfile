FROM node:20.16-bullseye-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

# Install node modules
FROM base AS build
COPY --link pnpm-lock.yaml package.json ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile 

# Copy the rest of the application code
COPY --link . .

# Build the server
RUN pnpm run -r build

# # Cleanup stage
# FROM build AS final
# # Remove all files in frontend except for the dist folder
# RUN find ./frontend -mindepth 1 ! -regex '^./frontend/dist\(/.*\)?' -delete
# # Remove unnecessary files from the main app directory
# RUN find . -maxdepth 1 ! -name 'dist' ! -name 'package.json' ! -name 'pnpm-lock.yaml' -type f -delete
# # Remove any other unnecessary directories (adjust as needed)
# RUN rm -rf node_modules src tests

# Final stage
FROM base
# Copy only the necessary files from the cleanup stage
COPY --from=build /app/apps/server/dist /app/dist
COPY --from=build /app/apps/server/package.json /app/package.json
COPY --from=build /app/apps/server/node_modules /app/node_modules
COPY --from=build /app/apps/web/dist /app/frontend/dist

EXPOSE 3000

CMD [ "pnpm", "start" ]