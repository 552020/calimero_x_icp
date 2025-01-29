#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${GREEN}Compiling context, proxy and external canister...${RESET}"

bash context/build.sh
bash proxy_contract/build.sh
bash external_contract/build.sh

lsof -i :4943 > /dev/null
if [ $? -ne 0 ] ; then
  echo -e "${GREEN}Starting local devnet...${RESET}"
  dfx start --clean --background
fi

# Create proxy canister
dfx canister id proxy_contract > /dev/null
if [ $? -ne 0 ] ; then
  echo -e "${GREEN}Creating proxy canister...${RESET}"
  dfx canister create proxy_contract
fi

dfx canister call proxy_contract cycles_left > /dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo -e "${GREEN}Uploading WASM for proxy canister...${RESET}"
  dfx canister install proxy_contract --mode=install --wasm ./proxy_contract/res/proxy_contract.wasm

  dfx canister call proxy_contract cycles_left > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        echo -e "${RED}ERROR: could not reach proxy canister.${RESET}"
        exit 1
    fi
fi

# Create external canister
dfx canister id external_contract > /dev/null
if [ $? -ne 0 ] ; then
  echo -e "${GREEN}Creating external canister...${RESET}"
  dfx canister create external_contract
fi

dfx canister call external_contract hello > /dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo -e "${GREEN}Uploading WASM for external canister...${RESET}"
  dfx canister install external_contract --mode=install --wasm ./external_contract/res/external_contract.wasm

  dfx canister call external_contract hello > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        echo -e "${RED}ERROR: could not reach external canister.${RESET}"
        exit 1
    fi
fi

echo -e "${GREEN}Installation done! Starting node${RESET}"

# TODO: start the node and install the context

# merod --node-name node1 init --server-port 2430 --swarm-port 2530
# merod --node-name node2 init --server-port 2431 --swarm-port 2531
# merod --node-name node1 run
# application install file ./context/res/context.wasm
