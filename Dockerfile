FROM node:latest AS node_base

FROM rust:latest

ARG IMAGE_VERSION=1.1.1
ARG GITHUB_TOKEN

ARG USERNAME=rusty
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV GITHUB_TOKEN=$GITHUB_TOKEN

LABEL name="dillaio/docker"
LABEL maintainer="Jean Valverde <jean@dilla.io>"
LABEL version="${IMAGE_VERSION}"
LABEL description="Dilla Rust tools image for project https://dilla.io"
LABEL org.label-schema.schema-version="${IMAGE_VERSION}"
LABEL org.label-schema.name="dillaio/docker"
LABEL org.label-schema.description="Dilla Rust tools image for project https://dilla.io"
LABEL org.label-schema.url="https://gitlab.com/dilla-io/docker"
LABEL org.label-schema.vcs-url="https://gitlab.com/dilla-io/docker.git"
LABEL org.label-schema.vendor="dilla-io"

COPY --from=node_base . .

RUN \
  groupadd --gid $USER_GID $USERNAME ; \
  useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN \
  apt-get update ; \
  apt-get install --no-install-recommends -y \
    bash \
    curl \
    tar \
    make \
    cmake \
    sudo ; \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME ; \
  chmod 0440 /etc/sudoers.d/$USERNAME ; \
  apt-get clean ; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
  rustup update ; \
  rustup component add rustfmt clippy ; \
  rustup target add wasm32-unknown-unknown wasm32-wasi

RUN \
  curl -fsSL --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

RUN \
  cargo binstall --no-confirm \
    cargo-tarpaulin wasm-opt wasm-bindgen-cli ; \
  cargo binstall --no-confirm \
    cargo-component --version 0.8.0 ; \
  # Just
  cd /var/tmp && curl -sL "$(curl -s https://api.github.com/repos/casey/just/releases/latest | grep browser_download_url | cut -d \" -f4 | grep -E 'x86_64-unknown-linux-musl.tar.gz')" | tar zx ; \
  mv /var/tmp/just /usr/local/bin/ ; \
  chmod +x /usr/local/bin/just ; \
  rm -rf /var/tmp/*

RUN \
  npm install -g npm

COPY ./tests/ /tests/

RUN \
  chmod +x /tests/*.sh

USER $USERNAME

WORKDIR /app
