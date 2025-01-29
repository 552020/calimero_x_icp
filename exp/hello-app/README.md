# HELLO APP

A simple Hello World application for Calimero Network nodes.

## Project Setup

1. Create a new Rust library project:

```bash
cargo new --lib hello-app
```

2. Project structure should look like this:

```bash
$ tree
.
├── Cargo.toml
└── src
    └── lib.rs

2 directories, 2 files
```

3. Configure your `Cargo.toml` with the necessary dependencies:

The Cargo.toml configuration specifies:

- Rust edition 2021 (latest stable version)
- cdylib crate type (required for WebAssembly compilation)
- Core dependencies from Calimero:
  - `calimero-sdk`: Core SDK for building Calimero applications
  - `calimero-storage`: For data persistence (if needed)
- Optimized release profile for WebAssembly output

```toml
[package]
name = "hello-app"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
calimero-sdk = { git = "https://github.com/calimero-network/core" }

[profile.app-release]
inherits = "release"
codegen-units = 1
opt-level = "z"
lto = true
debug = false
panic = "abort"
overflow-checks = true
```

4. Create a build script (`build.sh`):

```bash
#!/bin/bash
set -e

cd "$(dirname $0)"

TARGET="${CARGO_TARGET_DIR:-../../target}"

rustup target add wasm32-unknown-unknown

cargo build --target wasm32-unknown-unknown --profile app-release

mkdir -p res

cp $TARGET/wasm32-unknown-unknown/app-release/hello_app.wasm ./res/
```

5. Make the build script executable:

```bash
chmod +x build.sh
```

## Regular Rust Program (Optional)

When creating a new Rust project, you get a simple add function in `lib.rs`:

```rust
// src/lib.rs
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
```

You can create a `main.rs` to use this function as a regular Rust program:

```rust
// src/main.rs
use hello_app::add;

fn main() {
    let result = add(5, 7);
    println!("5 + 7 = {}", result);
}
```

To run this regular program:

```bash
cargo run
```

This will output:

```
5 + 7 = 12
```

Note: This regular Rust program is separate from the Calimero app functionality and won't be included in the WASM build that gets deployed to the Calimero node.

## Understanding Calimero Apps vs Regular Rust Programs

### Regular Rust Program

A typical Rust program has a `main.rs` file with an entry point:

```rust
// src/main.rs - Regular executable Rust program
fn main() {
    println!("Hello, world!");
}
```

This creates a standalone executable that runs directly on your computer.

### Calimero App

A Calimero app uses `lib.rs` instead and is structured differently:

```rust
// src/lib.rs - Calimero application
use calimero_sdk::borsh::{BorshDeserialize, BorshSerialize};
use calimero_sdk::app;

#[app::state]
#[derive(Default, BorshSerialize, BorshDeserialize)]
#[borsh(crate = "calimero_sdk::borsh")]
struct HelloApp {}

#[app::logic]
impl HelloApp {
    #[app::init]
    pub fn init() -> Self {
        HelloApp {}
    }

    pub fn say_hello(&self) -> String {
        "Hello from Calimero Node!".to_string()
    }
}
```

Key differences:

1. No `main()` function - the Calimero node provides the runtime environment
2. Uses special attributes (`#[app::state]`, `#[app::logic]`)
3. Compiles to WebAssembly (WASM) instead of a native executable
4. Functions are called via JSON-RPC by the node

## Writing the Application

Create a simple Hello World application in `src/lib.rs`:

```rust
use calimero_sdk::borsh::{BorshDeserialize, BorshSerialize};
use calimero_sdk::app;

#[app::state]
#[derive(Default, BorshSerialize, BorshDeserialize)]
#[borsh(crate = "calimero_sdk::borsh")]
struct HelloApp {}

#[app::logic]
impl HelloApp {
    #[app::init]
    pub fn init() -> Self {
        HelloApp {}
    }

    pub fn say_hello(&self) -> String {
        "Hello from Calimero Node!".to_string()
    }
}
```

This creates:

1. An empty state struct (we don't need to store anything)
2. Required initialization function
3. A simple `say_hello` method that returns a greeting

## Interacting with the App

After deploying the app to your Calimero node, you can interact with it using JSON-RPC calls. Here's how to call the `say_hello` function from your terminal:

```bash
curl -X POST http://localhost:2428 \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "query",
    "params": {
      "app_id": "hello_app",
      "method": "say_hello",
      "args": {}
    }
  }'
```

Expected response:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "Hello from Calimero Node!"
}
```

## Next Steps

- Build the application
- Deploy to Calimero node
- Test the interaction using curl command above

## Deploying the Application

There are two ways to deploy your application:

### 1. Using the Node's Interactive CLI

If you're inside the node's interactive CLI:

# Install the application

application install file ./res/hello_app.wasm

> Installed application: <APPLICATION_ID>

# Create a context for the application

context create <APPLICATION_ID>

> Created context <CONTEXT_ID> with identity <CONTEXT_IDENTITY>

````

### 2. Using meroctl Command Line Tool

If you're using meroctl from your terminal:

```bash
# Install the application
meroctl --node-name node1 app install --path ./res/hello_app.wasm
> Application installed successfully. Application ID: <appId>

# Create a context for the application
meroctl --node-name node1 context create --application <app-id>
> <context-id>
````

For development and testing, you can also use dev mode which combines both steps:

```bash
meroctl --node-name node1 context create --watch ./res/hello_app.wasm
```

## Interacting with the App

After deploying the app to your Calimero node, you can interact with it using JSON-RPC calls. Here's how to call the `say_hello` function from your terminal:

```bash
curl -X POST http://localhost:2428 \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "query",
    "params": {
      "app_id": "hello_app",
      "method": "say_hello",
      "args": {}
    }
  }'
```

Expected response:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "Hello from Calimero Node!"
}
```

## Next Steps

- Build the application
- Deploy to Calimero node
- Test the interaction using curl command above
