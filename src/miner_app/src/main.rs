mod block;
mod miner;
mod transaction;

use block::Block;
use miner::Miner;
use transaction::Transaction;

fn main() {
    let file_path = "data.txt"; // Path to the file containing difficulty and transactions
    let (difficulty, transactions) = miner::read_data_from_file(file_path);

    let previous_hash = "0".repeat(64); // Placeholder for the previous block's hash
    let mut block = Block::new(0, transactions, previous_hash, difficulty);

    block.mine();
    println!("Mined block: {:?}", block);

    if miner::send_block_for_verification(&block) {
        println!("Block verified successfully!");
    } else {
        println!("Block verification failed.");
    }
}
