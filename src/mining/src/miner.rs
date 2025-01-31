// In miner.rs
use crate::block::Block;
use crate::transaction::Transaction;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

pub struct Miner {
    pub blocks_mined: u32,
    mining: bool,
}

impl Miner {
    pub fn new() -> Self {
        Miner {
            blocks_mined: 0,
            mining: false,
        }
    }

    /// Starts the mining process on a new thread.
    /// This function consumes an Arc<Mutex<Miner>> so that the mining thread owns it.
    pub fn start_mining_thread(
        miner: Arc<Mutex<Self>>,
        file_path: String,
    ) -> thread::JoinHandle<()> {
        // Clone the file_path into an Arc so that it can be moved into the thread.
        let file_path = Arc::new(file_path);

        thread::spawn({
            // Clone the Arc to be moved into the closure.
            let miner = Arc::clone(&miner);
            let file_path = Arc::clone(&file_path);
            move || {
                {
                    // Set mining to true
                    let mut m = miner.lock().unwrap();
                    m.mining = true;
                }
                while {
                    let m = miner.lock().unwrap();
                    m.mining
                } {
                    // Use the free function instead of a method on self to avoid lifetime issues.
                    let (difficulty, transactions) = read_data_from_file(&file_path);
                    let previous_hash = "0".repeat(64);
                    let mut block = Block::new(0, transactions, previous_hash, difficulty);
                    block.mine();
                    println!("Mined block: {:?}", block);

                    {
                        let mut m = miner.lock().unwrap();
                        m.blocks_mined += 1;
                    }
                    thread::sleep(Duration::from_secs(1));
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
        let difficulty_str = "0".repeat(block.difficulty as usize);
        hash.starts_with(&difficulty_str)
    }
}

// Free function version remains the same.
pub fn read_data_from_file(file_path: &str) -> (u32, Vec<Transaction>) {
    let mut difficulty = 0;
    let mut transactions = Vec::new();

    if let Ok(lines) = read_lines(file_path) {
        for (i, line) in lines.enumerate() {
            if let Ok(data) = line {
                if i == 0 {
                    difficulty = data.parse().unwrap_or(0);
                } else {
                    let parts: Vec<&str> = data.split(',').collect();
                    if parts.len() == 3 {
                        transactions.push(Transaction {
                            sender: parts[0].to_string(),
                            recipient: parts[1].to_string(),
                            amount: parts[2].parse().unwrap_or(0),
                        });
                    }
                }
            }
        }
    }

    (difficulty, transactions)
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
