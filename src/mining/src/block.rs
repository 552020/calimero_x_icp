// block.rs
use crate::transaction::Transaction;
use calimero_sdk::app;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Block {
    pub nonce: u64,
    pub transactions: Vec<Transaction>,
    pub previous_hash: String,
    pub difficulty: u32,
}

#[app::event]
pub enum MyEvent<'a> {
    BlockMined { block_hash: &'a str },
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
        let target_prefix = "0".repeat(self.difficulty as usize);
        while !self.calculate_hash().starts_with(&target_prefix) {
            self.nonce += 1;
        }
        // Emit an event when a block is mined
        app::emit!(MyEvent::BlockMined {
            block_hash: &self.calculate_hash()
        });
    }
}
