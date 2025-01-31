#!/bin/bash
set -e # Exit on error

# Change to the directory of the script
cd "$(dirname $0)"

TARGET="./target"
DESTINATION="./res"  # Define the destination directory

# Add the wasm target if it's not already installed
rustup target add wasm32-unknown-unknown

# Build the wasm binary
cargo build --target wasm32-unknown-unknown --release

# Create the res directory if it doesn't exist
mkdir -p res

# Create the destination directory if it doesn't exist
mkdir -p "$DESTINATION"

# Update the file name to match the actual output
if [ -f ./target/wasm32-unknown-unknown/release/mining.wasm ]; then
    cp ./target/wasm32-unknown-unknown/release/mining.wasm "$DESTINATION/"
else
    echo "Error: mining.wasm not found."
fi

