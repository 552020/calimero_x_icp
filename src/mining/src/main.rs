mod block;
mod miner;
mod transaction;

use block::Block;
use miner::{BlockchainData, Miner};
use std::sync::{Arc, Mutex};

fn main() {
    let file_path = "src/blockchain.json".to_string(); // Use the JSON file with blockchain data

    // Create a new Miner instance wrapped in Arc and Mutex
    let miner = Arc::new(Mutex::new(Miner::new()));

    // Start mining in a separate thread
    let miner_thread = Miner::start_mining_thread(Arc::clone(&miner), file_path.clone());

    // Stop mining
    Miner::stop_mining(&miner);

    // Wait for the miner thread to finish
    miner_thread.join().unwrap();

    // Get the number of blocks mined
    let blocks_mined = miner.lock().unwrap().blocks_mined;
    println!("Total blocks mined: {}", blocks_mined);

    // Example of verifying a block (you can replace this with actual block data)
    let blockchain_data = match BlockchainData::from_file(&file_path) {
        Ok(data) => data,
        Err(e) => {
            eprintln!("Error reading blockchain data: {}", e);
            return;
        }
    };
    let difficulty = blockchain_data.difficulty;
    let previous_hash = blockchain_data
        .chain
        .last()
        .map(|b| b.calculate_hash())
        .unwrap_or_else(|| "0".repeat(64));
    let block = Block::new(
        0,
        blockchain_data.pending_transactions,
        previous_hash,
        difficulty,
    );
    if miner.lock().unwrap().verify_initial_block(&block) {
        println!("Initial block verified successfully!");
    } else {
        println!("Initial block verification failed.");
    }
}
