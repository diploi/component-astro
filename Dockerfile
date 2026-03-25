FROM node:22-alpine AS base

# Enable corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Setup PNPM
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# This will be set by the GitHub action to the folder containing this component.
ARG FOLDER=/app

# Install dependencies only when needed
FROM base AS deps

COPY . /app
WORKDIR ${FOLDER}

# Install dependencies based on the preferred package manager
RUN \
  if [ -f yarn.lock ]; then \
  yarn install --frozen-lockfile || yarn install; \
  elif [ -f package-lock.json ]; then \
  npm ci || npm install; \
  elif [ -f pnpm-lock.yaml ]; then \
  pnpm install --frozen-lockfile || pnpm install; \
  elif [ -f package.json ]; then \
  echo "Lockfile not found. Falling back to npm install (non-deterministic install)."; \
  npm install; \
  else \
  echo "No package manifest found. Skipping install."; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
COPY . /app
WORKDIR ${FOLDER}
COPY --from=deps ${FOLDER}/node_modules ./node_modules

RUN \
  if [ -f yarn.lock ]; then yarn run build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then pnpm run build; \
  elif [ -f package.json ]; then npm run build; \
  else echo "No package manifest found. Skipping build step."; \
  fi

# Production image, copy all the files and run "npm start"
FROM base AS runner

COPY --from=builder --chown=1000:1000 /app /app
WORKDIR ${FOLDER}

ENV NODE_ENV=production

USER 1000:1000

EXPOSE 4321
ENV PORT=4321
ENV HOST="0.0.0.0"

CMD ["npm", "start"]
