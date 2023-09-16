# syntax=docker/dockerfile:1
# read the doc: https://huggingface.co/docs/hub/spaces-sdks-docker
# you will also find guides on how best to write your Dockerfile
FROM node:19 as builder-production

USER 0

# WORKDIR /app

ENV APP_ROOT=/app
RUN mkdir -p ${APP_ROOT}/{bin,src}
RUN chmod -R u+x ${APP_ROOT}/bin
RUN chgrp -R 0 ${APP_ROOT}
RUN chmod -R g=u ${APP_ROOT}

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

COPY --chown=1000:1000 package-lock.json package.json ./
RUN --mount=type=cache,target=/app/.npm \
        npm set cache /app/.npm && \
        npm ci --omit=dev

FROM builder-production as builder

RUN --mount=type=cache,target=/app/.npm \
        npm set cache /app/.npm && \
        npm ci

COPY --chown=1000:1000 . .

USER 1000

# RUN --mount=type=secret,id=DOTENV_LOCAL,dst=.env.local \
#     npm run build
RUN npm run build

FROM node:19-slim

RUN npm install -g pm2

COPY --from=builder-production /app/node_modules /app/node_modules
COPY --chown=1000:1000 package.json /app/package.json
COPY --from=builder /app/build /app/build

CMD pm2 start /app/build/index.js -i $CPU_CORES --no-daemon
