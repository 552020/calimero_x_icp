use borsh::{BorshDeserialize, BorshSerialize};
use std::sync::Mutex;
use lazy_static::lazy_static;

// Define a struct for computation requests
#[derive(BorshSerialize, BorshDeserialize, Clone)]
pub struct Payload {
    pub num1: i32,
    pub num2: i32,
    pub operation: String,
}

// Define static storage for input and output values
lazy_static! {
    static ref STORAGE: Mutex<Option<Payload>> = Mutex::new(None);
    static ref RESULT: Mutex<Option<i32>> = Mutex::new(None);
}

/// Initialization function (required for Calimero)
#[no_mangle]
pub extern "C" fn init() {
    println!("Application initialized!");
}

/// Function to handle computation requests
#[no_mangle]
pub extern "C" fn handle_message() {
    let payload_option = STORAGE.lock().unwrap().clone();

    if let Some(payload) = payload_option {
        let result = match payload.operation.as_str() {
            "add" => payload.num1 + payload.num2,
            "subtract" => payload.num1 - payload.num2,
            "multiply" => payload.num1 * payload.num2,
            "divide" => {
                if payload.num2 != 0 {
                    payload.num1 / payload.num2
                } else {
                    0 // Handle division by zero
                }
            }
            _ => 0, // Default for unsupported operations
        };

        *RESULT.lock().unwrap() = Some(result);
        println!("Computed result: {}", result);
    } else {
        println!("No payload found in storage.");
    }
}

/// Function to manually set a payload (to mimic `storage::write`)
#[no_mangle]
pub extern "C" fn set_payload(num1: i32, num2: i32, operation_ptr: *const u8, operation_len: usize) {
    let operation = unsafe {
        let slice = std::slice::from_raw_parts(operation_ptr, operation_len);
        String::from_utf8(slice.to_vec()).expect("Invalid UTF-8 string")
    };

    let payload = Payload { num1, num2, operation };
    *STORAGE.lock().unwrap() = Some(payload);
    println!("Payload set successfully.");
}

/// Function to retrieve the computed result
#[no_mangle]
pub extern "C" fn get_result() -> i32 {
    RESULT.lock().unwrap().unwrap_or(0)
}
