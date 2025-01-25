# ICP Devnet 

The repository is for Calimero smart contracts and an ICP devnet setup script to configure the network and deploy required contracts.
https://github.com/calimero-network/icp-devnet

## Overview

This repository serves as a development environment scaffold for any Calimero x ICP projects. It provides the core infrastructure and tooling needed to start building applications that integrate Calimero with the Internet Computer Protocol, rather than being tied to any specific project's data or business logic.

The setup includes:
- Core smart contracts (context, proxy, ledger)
- Development environment configuration
- Test account creation
- Deployment scripts
- Local network setup

## Repository Structure

The ICP devnet repository is organized as follows:

```
icp-devnet/
├── context-config/
│   ├── calimero_context_config_icp.did    # Context contract interface
│   └── calimero_context_config_icp.wasm   # Context contract binary
├── context-proxy/
│   ├── calimero_context_proxy_icp.did     # Proxy contract interface
│   ├── calimero_context_proxy_icp.wasm    # Proxy contract binary
│   └── mock/
│       └── external/                       # Mock external contract files
├── dfx.json                               # DFX configuration
├── deploy_devnet_fresh.sh                 # Fresh deployment script
├── deploy_devnet_addon.sh                 # Addon deployment script
├── .gitignore                             # Git ignore rules
└── README.md                              # Documentation
```

### Core Components

1. **Configuration Files**
   - `dfx.json`: Defines three main canisters:
     - `context_contract`: A custom canister for managing Calimero contexts
     - `ledger`: The ICP ledger canister
     - `mock_external`: A mock external canister for testing

2. **Contract Definitions**
   - Context Config Contract:
     - `calimero_context_config_icp.did`: Candid interface definition file that describes the contract's public API. It defines:
       - Types like `ICApplication`, `ICCapability`, `ICSigned`
       - Service methods for managing applications, members, and privileges
     - `calimero_context_config_icp.wasm`: WebAssembly binary containing the compiled contract code that runs on the Internet Computer
   - Proxy Contract:
     - `calimero_context_proxy_icp.did`: Candid interface for proxy contract
     - `calimero_context_proxy_icp.wasm`: WebAssembly binary for proxy functionality
   - `context-proxy/mock/external/`: Contains mock external contract files for testing

3. **Deployment Scripts**
   - `deploy_devnet_fresh.sh`: Sets up a completely fresh devnet environment
   - `deploy_devnet_addon.sh`: Deploys contracts to an existing dfx environment

### Main Features

The setup provides:
- Local ICP ledger deployment
- Context management contract
- Proxy contract for cross-contract calls
- Mock external contract for testing
- Account creation (minting, initial, archive, and recipient accounts)
- Automatic cycle management

### Development Setup

- `.gitignore` handles common development files:
  - IDE configurations
  - Build artifacts
  - Temporary files
- Local network configuration bound to 127.0.0.1:4943
- Supports persistent network type for development

The repository provides a complete local development environment for building and testing ICP-based applications with Calimero integration, including all necessary contracts and configurations for a functioning devnet setup.

### Core Smart Contracts

The devnet setup includes three essential smart contracts that form the foundation of any Calimero x ICP application:

1. **Context Contract** (`context-config/`)
   - **Purpose**: Manages the configuration and permissions for Calimero contexts
   - **Key Features**:
     - Application Management
       - Store and retrieve application metadata
       - Track application revisions
     - Member Management
       - Add/remove members to contexts
       - Query member privileges
     - Permission Control
       - Define capabilities (Proxy, ManageMembers, ManageApplication)
       - Manage access rights for different members
     - Proxy Contract Management
       - Deploy and configure proxy contracts
       - Store proxy contract code

2. **Proxy Contract** (`context-proxy/`)
   - **Purpose**: Handles cross-contract communication and proposal management
   - **Key Features**:
     - Proposal System
       - Create and manage proposals for actions
       - Track proposal approvals and signers
     - Action Types:
       - Set number of required approvals
       - Configure context values
       - Execute token transfers
       - Make external function calls
     - Storage Management
       - Maintain context storage entries
       - Track active proposals
     - Security
       - Validate proposal signatures
       - Enforce approval thresholds

3. **Ledger Contract**
   - **Purpose**: Manages ICP token operations and account balances
   - **Key Features**:
     - Token Management
       - Track token balances
       - Process token transfers
     - Account System
       - Maintain account records
       - Handle minting operations
     - Transaction Processing
       - Execute and record transactions
       - Apply transfer fees
     - Archive Management
       - Store transaction history
       - Handle block archiving

### Contract Interactions

These contracts work together to enable:
1. Secure cross-chain operations through the context and proxy contracts
2. Token management and transfers via the ledger contract
3. Controlled access to resources through the context contract's permission system
4. Proposal-based governance for important operations
