use crate::transaction::Transaction;
use sha2::{Digest, Sha256};

#[derive(Debug)]
pub struct Block {
    nonce: u64,
    transactions: Vec<Transaction>,
    previous_hash: String,
    difficulty: u32,
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

        // Include transaction details explicitly in the hash calculation
        let transactions_data = self
            .transactions
            .iter()
            .map(|tx| {
                format!(
                    "sender: {}, recipient: {}, amount: {}",
                    tx.sender, tx.recipient, tx.amount
                )
            })
            .collect::<Vec<String>>()
            .join(", ");

        hasher.update(format!(
            "nonce: {}, transactions: [{}], previous_hash: {}, difficulty: {}",
            self.nonce, transactions_data, self.previous_hash, self.difficulty
        ));

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
