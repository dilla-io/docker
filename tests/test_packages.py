import pytest

@pytest.mark.parametrize("name", [
  ("bash"),
  ("curl"),
  ("tar"),
  ("make"),
  ("cmake"),
  ("sudo"),
])
def test_packages_installed(host, name):
  ''' Test a minimum of required packages '''
  pkg = host.package(name)
  assert pkg.is_installed

@pytest.mark.parametrize("rust_bin", [
  ("rustc"),
  ("rustup"),
  ("rustfmt"),
  ("cargo"),
  ("cargo-fmt"),
  ("cargo-binstall"),
  ("cargo-component"),
  ("cargo-tarpaulin"),
  ("wasm-opt"),
  ("wasm-bindgen"),
])
def test_rust_bin(host, rust_bin):
  ''' Test Rust bin exist '''
  assert host.file("/usr/local/cargo/bin/" + rust_bin).exists

@pytest.mark.parametrize("bin", [
  ("just"),
  ("node"),
  ("npm"),
])
def test_bin(host, bin):
  ''' Test bin exist '''
  assert host.file("/usr/local/bin/" + bin).exists