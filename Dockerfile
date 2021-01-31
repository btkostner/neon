# Dockerfile
# A dockerfile for development

FROM alpine

ENV MIX_ENV=dev
ENV NODE_ENV=development

RUN mkdir -p /opt/app

WORKDIR /opt/app

RUN apk --no-cache --update add \
  bash \
  cargo \
  elixir \
  g++ \
  gcc \
  git \
  inotify-tools \
  libc-dev \
  make \
  nodejs \
  nodejs-npm \
  python \
  rust

RUN mix local.hex --force && mix local.rebar --force
RUN npm install npm -g --no-progress

COPY mix.exs .
COPY mix.lock .

COPY package.json .
COPY package-lock.json .

RUN cd /opt/app && \
  mix deps.get --all && \
  mix deps.compile --all

RUN cd /opt/app && \
  npm ci

VOLUME /opt/app
EXPOSE 4000

CMD ["mix", "phx.server"]
