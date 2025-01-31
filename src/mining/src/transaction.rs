// transaction.rs
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Transaction {
    pub sender: String,
    pub recipient: String,
    pub amount: u32,
}
