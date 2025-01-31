mod block;
mod miner;
mod transaction;

use block::Block;
use miner::{read_data_from_file, Miner};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    let file_path = "data.txt".to_string(); // Path to the file containing difficulty and transactions

    // Create a new Miner instance wrapped in Arc and Mutex
    let miner = Arc::new(Mutex::new(Miner::new()));

    // Start mining in a separate thread
    let miner_thread = Miner::start_mining_thread(Arc::clone(&miner), file_path.clone());

    // Let the miner run for 10 seconds
    thread::sleep(Duration::from_secs(10));

    // Stop mining
    Miner::stop_mining(&miner);

    // Wait for the miner thread to finish
    miner_thread.join().unwrap();

    // Get the number of blocks mined
    let blocks_mined = miner.lock().unwrap().blocks_mined;
    println!("Total blocks mined: {}", blocks_mined);

    // Example of verifying a block (you can replace this with actual block data)
    let previous_hash = "0".repeat(64);
    let (difficulty, transactions) = read_data_from_file(&file_path);
    let block = Block::new(0, transactions, previous_hash, difficulty);
    if miner.lock().unwrap().verify_initial_block(&block) {
        println!("Initial block verified successfully!");
    } else {
        println!("Initial block verification failed.");
    }
}
