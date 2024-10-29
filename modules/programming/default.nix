{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    # C / C++
    clang-tools
    cmake
    codespell
    conan
    cppcheck
    doxygen
    gtest
    lcov
    vcpkg
    # vcpkg-tool # Collision Error

    # Python
    python3

    # Rust
    rustup
    
    # Java
    maven
    gradle
    gcc
    ncurses
    patchelf
    zlib
    jdk

    # Flutter
    flutter

    # JavaScript (Node.js)
    nodejs
  ]; 
}
