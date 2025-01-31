// In miner.rs
use crate::block::Block;
use crate::transaction::Transaction;
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::{self, BufReader};
use std::path::Path;
use std::sync::{Arc, Mutex};
use std::thread;

#[derive(Debug, Serialize, Deserialize)]
pub struct BlockchainData {
    pub difficulty: u32,
    pub chain: Vec<Block>,
    pub pending_transactions: Vec<Transaction>,
}

impl BlockchainData {
    /// Reads the blockchain data from a JSON file.
    pub fn from_file<P: AsRef<Path>>(filename: P) -> io::Result<Self> {
        let file = File::open(filename)?;
        let reader = BufReader::new(file);
        let data = serde_json::from_reader(reader)?;
        Ok(data)
    }
}

pub struct Miner {
    pub blocks_mined: u32,
    pub mining: bool,
}

impl Miner {
    pub fn new() -> Self {
        Miner {
            blocks_mined: 0,
            mining: false,
        }
    }

    /// Starts the mining process on a new thread.
    /// Reads the blockchain data from file to get the last block.
    pub fn start_mining_thread(
        miner: Arc<Mutex<Self>>,
        file_path: String,
    ) -> thread::JoinHandle<()> {
        // Clone the file_path into an Arc so that it can be moved into the thread.
        let file_path_arc = Arc::new(file_path);

        thread::spawn({
            let miner = Arc::clone(&miner);
            let file_path_arc = Arc::clone(&file_path_arc);
            move || {
                // Read the blockchain data once to get the last block
                let blockchain_data = match BlockchainData::from_file(&*file_path_arc) {
                    Ok(data) => data,
                    Err(e) => {
                        eprintln!("Error reading blockchain data: {}", e);
                        return;
                    }
                };

                let difficulty = blockchain_data.difficulty;
                let last_block = blockchain_data.chain.last().cloned();

                // Use the last block’s hash if available; otherwise use a default.
                let previous_hash = match last_block {
                    Some(block) => block.calculate_hash(),
                    None => "0".repeat(64),
                };

                {
                    let mut m = miner.lock().unwrap();
                    m.mining = true;
                }

                while {
                    let m = miner.lock().unwrap();
                    m.mining
                } {
                    // In a real blockchain you’d likely update the pending transactions from a mempool.
                    // For our example, we use the pending transactions loaded from the file.
                    let pending_transactions = blockchain_data.pending_transactions.clone();

                    let mut block =
                        Block::new(0, pending_transactions, previous_hash.clone(), difficulty);
                    block.mine();
                    println!("Mined block: {:?}", block);

                    {
                        let mut m = miner.lock().unwrap();
                        m.blocks_mined += 1;
                    }
                }
            }
        })
    }

    /// Stops mining by setting the flag to false.
    pub fn stop_mining(miner: &Arc<Mutex<Self>>) {
        let mut m = miner.lock().unwrap();
        m.mining = false;
    }

    pub fn verify_initial_block(&self, block: &Block) -> bool {
        let hash = block.calculate_hash();
        let target = "0".repeat(block.difficulty as usize);
        hash.starts_with(&target)
    }
}
