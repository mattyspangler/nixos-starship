#!/usr/bin/env bash

# Test script to debug nixpak wrapper issues
# This will help us understand the structure of nixpak-generated packages

echo "Testing nixpak wrapper structure..."

# Try to build just one app to see what's generated
nix build --impure --expr '
let
  pkgs = import <nixpkgs> {};
  nixpak = (builtins.getFlake "github:nixpak/nixpak").lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };
  testApp = nixpak {
    config = { sloth, ... }: {
      app.package = pkgs.lynx;
      bubblewrap = {
        bind.rw = [ sloth.homeDir ];
      };
    };
  };
in
  testApp.config.script
' -o test-nixpak-output

if [ -d test-nixpak-output ]; then
  echo "Contents of nixpak output:"
  ls -la test-nixpak-output/
  
  if [ -d test-nixpak-output/bin ]; then
    echo "Contents of bin directory:"
    ls -la test-nixpak-output/bin/
    
    # Check what's actually in the wrapper script
    for file in test-nixpak-output/bin/*; do
      if [ -f "$file" ]; then
        echo "Content preview of $(basename $file):"
        head -n 20 "$file"
      fi
    done
  fi
  
  # Clean up
  rm -f test-nixpak-output
else
  echo "Failed to build test nixpak package"
fi