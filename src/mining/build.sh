#!/bin/bash
set -e

cd "$(dirname $0)"

TARGET="./target"
DESTINATION="./res"  

rustup target add wasm32-unknown-unknown

cargo build --target wasm32-unknown-unknown --release

mkdir -p res

mkdir -p "$DESTINATION"

if [ -f ./target/wasm32-unknown-unknown/release/mining.wasm ]; then
    cp ./target/wasm32-unknown-unknown/release/mining.wasm "$DESTINATION/"
else
    echo "Error: mining.wasm not found."
fi

