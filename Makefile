# Makefile for Calimero x ICP PoW Mining Project

# Configuration
DFX_VERSION=0.24.3
CARGO_VERSION=1.81.0
CANDID_EXTRACTOR_VERSION=0.1.5
PNPM_VERSION=9.6.0

# Control flags for each package
# Set DISABLE to 1 to skip the check
DFX_DISABLE=0
CARGO_DISABLE=0
CANDID_EXTRACTOR_DISABLE=0
PNPM_DISABLE=0

# Set to 1 for exact version matching, 0 for minimum version
DFX_EXACT_VERSION=1
CARGO_EXACT_VERSION=0
CANDID_EXTRACTOR_EXACT_VERSION=1
PNPM_EXACT_VERSION=0

NODE_NAME=default
SERVER_PORT=2428
SWARM_PORT=2528

# Check if cargo is installed and has correct version
check-cargo:
	@if [ $(CARGO_DISABLE) -eq 1 ]; then \
		echo "Cargo check disabled, skipping..."; \
		exit 0; \
	fi
	@if ! command -v cargo >/dev/null 2>&1; then \
		echo "cargo is not installed. Please install Rust and Cargo from https://rustup.rs/"; \
		exit 1; \
	fi
	@CURRENT_VERSION=$$(cargo --version | awk '{print $$2}'); \
	echo "Found cargo version: $$CURRENT_VERSION"; \
	if [ $(CARGO_EXACT_VERSION) -eq 1 ]; then \
		if ! echo "$$CURRENT_VERSION" | grep -q "^$(CARGO_VERSION)"; then \
			echo "Wrong cargo version. Current: $$CURRENT_VERSION, Required: $(CARGO_VERSION)"; \
			exit 1; \
		fi; \
		echo "✓ Cargo version matches exactly: $$CURRENT_VERSION"; \
	else \
		if ! echo "$$CURRENT_VERSION" | awk -v ver="$(CARGO_VERSION)" '{ if ($$1 < ver) exit 1; }'; then \
			echo "Cargo version too old. Current: $$CURRENT_VERSION, Minimum required: $(CARGO_VERSION)"; \
			exit 1; \
		fi; \
		echo "✓ Cargo version ($$CURRENT_VERSION) meets minimum requirement: $(CARGO_VERSION)"; \
	fi

# Check if candid-extractor is installed and has correct version
check-candid-extractor:
	@if [ $(CANDID_EXTRACTOR_DISABLE) -eq 1 ]; then \
		echo "Candid-extractor check disabled, skipping..."; \
		exit 0; \
	fi
	@if ! command -v candid-extractor >/dev/null 2>&1; then \
		echo "candid-extractor is not installed. Installing..."; \
		cargo install candid-extractor --version $(CANDID_EXTRACTOR_VERSION); \
	fi
	@CURRENT_VERSION=$$(candid-extractor --version); \
	echo "Found candid-extractor version: $$CURRENT_VERSION"; \
	if [ $(CANDID_EXTRACTOR_EXACT_VERSION) -eq 1 ]; then \
		if ! echo "$$CURRENT_VERSION" | grep -q $(CANDID_EXTRACTOR_VERSION); then \
			echo "Wrong candid-extractor version. Current: $$CURRENT_VERSION, Required: $(CANDID_EXTRACTOR_VERSION)"; \
			cargo install candid-extractor --version $(CANDID_EXTRACTOR_VERSION); \
		fi; \
		echo "✓ Candid-extractor version matches exactly: $$CURRENT_VERSION"; \
	fi

# Check if pnpm is installed and has correct version
check-pnpm:
	@if [ $(PNPM_DISABLE) -eq 1 ]; then \
		echo "PNPM check disabled, skipping..."; \
		exit 0; \
	fi
	@if ! command -v pnpm >/dev/null 2>&1; then \
		echo "pnpm is not installed. Installing..."; \
		npm install -g pnpm@$(PNPM_VERSION); \
	fi
	@CURRENT_VERSION=$$(pnpm --version); \
	echo "Found pnpm version: $$CURRENT_VERSION"; \
	if [ $(PNPM_EXACT_VERSION) -eq 1 ]; then \
		if ! echo "$$CURRENT_VERSION" | grep -q $(PNPM_VERSION); then \
			echo "Wrong pnpm version. Current: $$CURRENT_VERSION, Required: $(PNPM_VERSION)"; \
			npm install -g pnpm@$(PNPM_VERSION); \
		fi; \
		echo "✓ PNPM version matches exactly: $$CURRENT_VERSION"; \
	else \
		if ! echo "$$CURRENT_VERSION" | awk -v ver="$(PNPM_VERSION)" '{ if ($$1 < ver) exit 1; }'; then \
			echo "pnpm version too old. Current: $$CURRENT_VERSION, Minimum required: $(PNPM_VERSION)"; \
			npm install -g pnpm@$(PNPM_VERSION); \
		fi; \
		echo "✓ PNPM version ($$CURRENT_VERSION) meets minimum requirement: $(PNPM_VERSION)"; \
	fi

# Check if dfx is installed and has correct version
check-dfx:
	@if [ $(DFX_DISABLE) -eq 1 ]; then \
		echo "DFX check disabled, skipping..."; \
		exit 0; \
	fi
	@if ! command -v dfx >/dev/null 2>&1; then \
		echo "dfx is not installed. Installing..."; \
		sh -ci "$$(curl -fsSL https://internetcomputer.org/install.sh)"; \
	fi
	@CURRENT_VERSION=$$(dfx --version); \
	echo "Found dfx version: $$CURRENT_VERSION"; \
	if [ $(DFX_EXACT_VERSION) -eq 1 ]; then \
		if ! echo "$$CURRENT_VERSION" | grep -q $(DFX_VERSION); then \
			echo "Wrong dfx version. Current: $$CURRENT_VERSION, Required: $(DFX_VERSION)"; \
			dfxvm default $(DFX_VERSION); \
		fi; \
		echo "✓ DFX version matches exactly: $$CURRENT_VERSION"; \
	else \
		if ! echo "$$CURRENT_VERSION" | awk -v ver="$(DFX_VERSION)" '{ if ($$1 < ver) exit 1; }'; then \
			echo "dfx version too old. Current: $$CURRENT_VERSION, Minimum required: $(DFX_VERSION)"; \
			dfxvm default $(DFX_VERSION); \
		fi; \
		echo "✓ DFX version ($$CURRENT_VERSION) meets minimum requirement: $(DFX_VERSION)"; \
	fi

# Check all prerequisites
check-prerequisites: check-dfx check-cargo check-candid-extractor check-pnpm
	@echo "✓ All prerequisites checked successfully"

# Deploy ICP devnet
deploy-icp-devnet: check-prerequisites
	@echo "Starting ICP devnet deployment..."
	@./tools/deploy_devnet.sh
	@echo "✓ ICP devnet deployment completed"

# Setup ICP devnet environment
setup-icp-devnet: deploy-icp-devnet
	@echo "ICP devnet environment setup completed"

# Update setup to use setup-icp-devnet
setup: setup-icp-devnet

# Deploy mining contract (requires working dfx environment)
deploy-mining: setup
	@echo "Deploying mining contract..."
	dfx deploy mining_contract
	@echo "Initializing mining parameters..."
	dfx canister call mining_contract init_mining '(record { initial_difficulty = 100; reward_amount = 50 })'

# Clean up
clean:
	@echo "Cleaning up..."
	-dfx stop
	rm -rf .dfx
	rm -rf canister_ids.json

# Development setup
dev: deploy-mining
	@echo "Development environment ready!"

# Help
help:
	@echo "Calimero x ICP PoW Mining Project Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make setup        - Set up ICP environment (auto-detects fresh/addon)"
	@echo "  make deploy-mining- Deploy mining contract (includes setup)"
	@echo "  make clean        - Clean up environment"
	@echo "  make dev          - Complete development setup"
	@echo "  make help         - Show this help message"

.PHONY: check-dfx check-cargo check-candid-extractor check-pnpm check-prerequisites deploy-icp-devnet setup-icp-devnet setup deploy-mining clean dev help 