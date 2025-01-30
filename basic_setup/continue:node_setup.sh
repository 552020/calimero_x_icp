#!/bin/bash

# Initialize Node 1
NODE1_PEERID=$(merod --node-name node1 init --server-port 2427 --swarm-port 2527 | grep "Generated identity" | sed -E 's/.*PeerId\("(.*)"\)/\1/')
echo "Node 1 PeerId: $NODE1_PEERID"
echo "NODE1_PEERID=$NODE1_PEERID" >> .env

# Initialize Node 2
NODE2_PEERID=$(merod --node-name node2 init --server-port 2428 --swarm-port 2528 | grep "Generated identity" | sed -E 's/.*PeerId\("(.*)"\)/\1/')
echo "Node 2 PeerId: $NODE2_PEERID"
echo "NODE2_PEERID=$NODE2_PEERID" >> .env

# Initialize Node 3
NODE3_PEERID=$(merod --node-name node3 init --server-port 2429 --swarm-port 2529 | grep "Generated identity" | sed -E 's/.*PeerId\("(.*)"\)/\1/')
echo "Node 3 PeerId: $NODE3_PEERID"
echo "NODE3_PEERID=$NODE3_PEERID" >> .env

# Done
echo "All nodes initialized and PeerIds saved in existing.env"
