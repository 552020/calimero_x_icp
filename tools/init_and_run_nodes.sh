#!/bin/bash

# Define node names and their respective ports
nodes=("node1" "node2" "node3")
server_ports=(2427 2428 2429)
swarm_ports=(2527 2528 2529)

# Base directory for Calimero nodes
base_dir="$HOME/.calimero"

# Function to check if tmux is installed
check_tmux() {
    if ! command -v tmux >/dev/null 2>&1; then
        echo "tmux is not installed. Would you like to:"
        echo "1) Exit and install tmux manually (recommended)"
        echo "2) Continue without tmux (will open separate terminal windows)"
        read -p "Enter your choice (1 or 2): " choice
        case $choice in
            1)
                echo "Please install tmux and try again:"
                echo "  - On MacOS: brew install tmux"
                echo "  - On Ubuntu/Debian: sudo apt-get install tmux"
                echo "  - On other systems: use your package manager to install tmux"
                exit 1
                ;;
            2)
                echo "Proceeding without tmux..."
                export USE_TMUX=0
                return
                ;;
            *)
                echo "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi
    export USE_TMUX=1
}

# Function to check ports
check_ports() {
  for port in "${server_ports[@]}" "${swarm_ports[@]}"; do
    if lsof -i:"$port" &>/dev/null; then
      echo "Port $port is in use."
      read -p "Kill the process using port $port? (y/n): " choice
      if [[ $choice == "y" || $choice == "Y" ]]; then
        lsof -ti:"$port" | xargs kill -9
        echo "Process on port $port killed."
      else
        echo "Port $port is still in use. Exiting."
        exit 1
      fi
    else
      echo "Port $port is free."
    fi
  done
}

# Function to check if node directories exist
check_node_dirs() {
    for node in "${nodes[@]}"; do
        node_dir="$base_dir/$node"
        if [ -d "$node_dir" ]; then
            echo "Directory for $node already exists at $node_dir."
            read -p "Do you want to reinitialize $node? (y/n): " choice
            if [[ $choice == "y" || $choice == "Y" ]]; then
                echo "Removing and reinitializing $node..."
                rm -rf "$node_dir"
                initialize_node "$node"
            else
                echo "Skipping initialization of $node."
                continue
            fi
        else
            echo "No existing directory found for $node. Proceeding with initialization."
            initialize_node "$node"
        fi
    done
}

# Function to initialize a node
initialize_node() {
    node=$1
    index=$(echo "${nodes[@]}" | tr ' ' '\n' | grep -n "^$node$" | cut -d: -f1)
    server_port=${server_ports[$((index - 1))]}
    swarm_port=${swarm_ports[$((index - 1))]}

    echo "Initializing $node on server port $server_port and swarm port $swarm_port."
    mkdir -p "$base_dir/$node"  # Ensure the directory exists
    
    if [ "$USE_TMUX" -eq 1 ]; then
        tmux send-keys -t my_session "merod --node-name $node init --server-port $server_port --swarm-port $swarm_port" C-m
    else
        # For non-tmux, just run the init command directly
        merod --node-name $node init --server-port $server_port --swarm-port $swarm_port
    fi
}

# Function to run nodes
run_nodes() {
    if [ "$USE_TMUX" -eq 1 ]; then
        # Tmux version
        for node in "${nodes[@]}"; do
            node_dir="$base_dir/$node"
            if [ ! -d "$node_dir" ]; then
                echo "Error: Directory for $node does not exist at $node_dir. Please initialize the node first."
                exit 1
            fi

            echo "Starting $node in a new tmux window..."
            tmux new-window -t my_session -n "$node"
            tmux send-keys -t my_session:"$node" "merod --node-name $node run" C-m
        done
        
        # Attach to the session
        tmux attach -t my_session
    else
        # Non-tmux version - open new terminal windows
        for node in "${nodes[@]}"; do
            node_dir="$base_dir/$node"
            if [ ! -d "$node_dir" ]; then
                echo "Error: Directory for $node does not exist at $node_dir. Please initialize the node first."
                exit 1
            fi

            echo "Starting $node in a new terminal window..."
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                osascript -e "tell app \"Terminal\" to do script \"merod --node-name $node run\""
            else
                # Linux (assuming x-terminal-emulator is available)
                x-terminal-emulator -e "merod --node-name $node run" &
            fi
        done
        
        echo "Nodes started in separate terminal windows."
        echo "Please keep these windows open to maintain node operation."
    fi
}

# Main script execution
check_tmux
check_ports
check_node_dirs

if [ "$USE_TMUX" -eq 1 ]; then
    # Start tmux session only if using tmux
    tmux new-session -d -s my_session
fi

run_nodes
