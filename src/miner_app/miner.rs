use crate::transaction::Transaction;
use sha2::{Digest, Sha256};

#[derive(Debug)]
pub struct Block {
    nonce: u64,
    transactions: Vec<Transaction>,
    previous_hash: String,
    difficulty: u32, //Should the difficulty be in the block ?
}

impl Block {
    pub fn new(
        nonce: u64,
        transactions: Vec<Transaction>,
        previous_hash: String,
        difficulty: u32,
    ) -> Self {
        Block {
            nonce,
            transactions,
            previous_hash,
            difficulty,
        }
    }

    pub fn calculate_hash(&self) -> String {
        let mut hasher = Sha256::new();
        hasher.update(format!("{:?}", self));
        let result = hasher.finalize();
        hex::encode(result)
    }

    pub fn mine(&mut self) {
        while self
            .calculate_hash()
            .chars()
            .take(self.difficulty as usize)
            .collect::<String>()
            != "0".repeat(self.difficulty as usize)
        {
            self.nonce += 1;
        }
    }
}
