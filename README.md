# Dilla Rust Docker image

Share your design systems in a tiny universal package. [https://dilla.io](https://dilla.io)

## Docker tools image for Dilla Engine

Docker image tools for [Dilla Engine](https://gitlab.com/dilla-io/engine), including

- [Rust fmt](https://github.com/rust-lang/rustfmt)
- [Clippy](https://github.com/rust-lang/rust-clippy)
- [Cargo binary install](https://crates.io/crates/cargo-binstall)
- [Just](https://github.com/casey/just)
- NodeJS, required for [jco](https://github.com/bytecodealliance/jco)

Used by the project directly

- [cargo-component](https://crates.io/crates/cargo-component)
- [cargo-tarpaulin](https://crates.io/crates/cargo-tarpaulin)
- [wasm-opt](https://github.com/WebAssembly/binaryen)
- [wasm-bindgen-cli](https://github.com/rustwasm/wasm-bindgen)

## Tests

Tests against this Docker container and what's inside.

`GITHUB_TOKEN` is optional, but allow faster download for cargo binstall to avoid build.
See [Github Tate limits](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api)

```shell
GITHUB_TOKEN=_MY_TOKEN_ make build
make test
```
