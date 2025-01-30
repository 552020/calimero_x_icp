#!/bin/bash
set -e

# Navigate to the directory containing the script
cd "$(dirname "$0")"

# Add the wasm target (if not already added)
rustup target add wasm32-unknown-unknown

# Build the project
cargo build --target wasm32-unknown-unknown --release

# Copy the resulting .wasm file to the `res` directory
mkdir -p res
cp target/wasm32-unknown-unknown/release/test_app.wasm ./res/
