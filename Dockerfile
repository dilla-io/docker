FROM node:latest AS node_base

FROM rust:latest

ARG NODE_VERSION=21
ARG IMAGE_VERSION=1.0.0
ARG GITHUB_TOKEN

ARG USERNAME=rusty
ARG USER_UID=1001
ARG USER_GID=$USER_UID

ENV github_token=$GITHUB_TOKEN

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
  # mkdir -p /etc/apt/keyrings ; \
  # curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
  #   | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg ; \
  # echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" \
  #   > /etc/apt/sources.list.d/nodesource.list ; \
  apt-get update ; \
  apt-get install --no-install-recommends -y \
    bash \
    curl \
    tar \
    make \
    cmake \
    sudo ; \
    # nodejs ; \
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
  cargo binstall -y \
    cargo-workspaces wasm-tools wasm-opt wasm-bindgen-cli cargo-component

RUN \
  npm install -g npm

USER $USERNAME

WORKDIR /app