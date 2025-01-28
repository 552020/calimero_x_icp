use crate::block::Block;
use crate::transaction::Transaction;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

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

pub fn send_block_for_verification(block: &Block) -> bool {
    // Simulate sending the block for verification and receiving a response
    println!("Sending block for verification: {:?}", block);
    // Here you would implement the actual verification logic
    true // Simulating a successful verification
}
