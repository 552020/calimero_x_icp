#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${GREEN}Compiling context, proxy, and external canister...${RESET}"
bash context/build.sh
bash proxy_contract/build.sh
bash external_contract/build.sh

# Check if devnet is running on port 4943
lsof -i :4943 > /dev/null
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Starting local devnet...${RESET}"
  dfx start --clean --background
fi

# Create context canister
dfx canister id context > /dev/null
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Creating context canister...${RESET}"
  dfx canister create context
fi
# dfx canister call context hello > /dev/null 2>&1
# if [ $? -ne 0 ]; then
#   echo -e "${GREEN}Uploading WASM for context canister...${RESET}"
#   dfx canister install context --mode=install --wasm ./context/res/kv_store.wasm
#   dfx canister call context hello > /dev/null 2>&1
#   if [ $? -ne 0 ]; then
#     echo -e "${RED}ERROR: could not reach context canister.${RESET}"
#     exit 1
#   fi
# fi

# Fetch context canister ID and echo
CONTEXT_CANISTER_ID=$(dfx canister id context)
echo -e "${GREEN}Context Canister ID: ${CONTEXT_CANISTER_ID}${RESET}"

# Create proxy canister
dfx canister id proxy_contract > /dev/null
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Creating proxy canister...${RESET}"
  dfx canister create proxy_contract
fi
dfx canister call proxy_contract cycles_left > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Uploading WASM for proxy canister...${RESET}"
  dfx canister install proxy_contract --mode=install --wasm ./proxy_contract/res/proxy_contract.wasm
  dfx canister call proxy_contract cycles_left > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: could not reach proxy canister.${RESET}"
    exit 1
  fi
fi

# Fetch proxy canister ID and echo
PROXY_CANISTER_ID=$(dfx canister id proxy_contract)
echo -e "${GREEN}Proxy Canister ID: ${PROXY_CANISTER_ID}${RESET}"

# Create external canister
dfx canister id external_contract > /dev/null
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Creating external canister...${RESET}"
  dfx canister create external_contract
fi
dfx canister call external_contract hello > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "${GREEN}Uploading WASM for external canister...${RESET}"
  dfx canister install external_contract --mode=install --wasm ./external_contract/res/external_contract.wasm
  dfx canister call external_contract hello > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: could not reach external canister.${RESET}"
    exit 1
  fi
fi

# Fetch external canister ID and echo
EXTERNAL_CANISTER_ID=$(dfx canister id external_contract)
echo -e "${GREEN}External Canister ID: ${EXTERNAL_CANISTER_ID}${RESET}"

# Save to .env file
echo -e "${GREEN}Saving canister IDs to .env file...${RESET}"
echo "CONTEXT_CANISTER_ID=${CONTEXT_CANISTER_ID}" > .env
echo "PROXY_CANISTER_ID=${PROXY_CANISTER_ID}" >> .env
echo "EXTERNAL_CANISTER_ID=${EXTERNAL_CANISTER_ID}" >> .env

echo -e "${GREEN}Installation done! Starting node${RESET}"
