

### [BILLO, Calimero X ICP Hackathon Entry](https://calimero.network/)  

<img width="864" alt="Screenshot 2025-02-04 at 00 02 09" src="https://github.com/user-attachments/assets/1b4209e3-728f-4570-899f-b18e0220d470" />

The **SLAD team** decided to look back in the past and use the best future technology to bring the next Play to earn Blockchain technology to the masses.

In Bitcoin's early days, mining was a fun and accessible activity, this was quickly replaced by a too serious Blockrush where chinese pool of miners leave no chance to the others.
But boys wanna have fun !

On the **ICP blockchain**, the launch of **BOB** sparked a wave of memecoins that burn ICP in a deflationary manner, creating an illusion of Proof-of-Work. After BOB's success, numerous fair-distribution projects like **Bone.fun, MSQ Burn, Diggy, and DOD** emerged—focused on token burning without true PoW.  

One of our team members, [Daniil](https://github.com/dantol29), played a key role in bringing **BIL** to life: a fully-fledged **Proof-of-Work blockchain on ICP**, featuring a ledger canister for transactions and a network of miners processing them.

But BIL has lived and trespassed 

### Introducing **BILLO** - BIL-LOcal  
Leveraging the **Calimero Network** and **ICP**, our project revives PoW and old-school mining, adding a **play-to-earn** model.  
Thanks to **Calimero local computing**, **Miners stay off-chain**, before ICP smart contracts verify computations.A **game-based front-end** keeps things fun, engaging, and challenging. Miners have a **chat**  where they can share intelligence information without fear of the data leaving their network, thanks to Calimero.  

BILLO is a **memecoin** with **fair distribution**, **entertaining gameplay**, and **zero initial investment**, since all computation happens locally.  

### About the **Calimero Network**  
The **Calimero Network** is a decentralized framework designed for building **self-sovereign, peer-to-peer applications**. It emphasizes:  
- **Data Ownership**: Users have full control over their data.  
- **Privacy**: Data is stored locally, and transactions are verified client-side.  
- **Decentralization**: Applications and nodes communicate in a **peer-to-peer** manner.  
- **Local Computing**: Reducing reliance on centralized infrastructure.  

### Meet the Team:  
- [Daniil ("the ICP guy")](https://github.com/dantol29)  
- [Leo ("the civil engineer")](https://github.com/lmangall/)  
- [Stefano ("the philosopher")](https://github.com/552020)  
- [Anton ("the tailor")](https://github.com/AntonSplavnik)  

BILLO is here to bring back the joy of mining—powered by the best of past and future technology! 🚀


<img width="866" alt="Screenshot 2025-02-04 at 00 02 21" src="https://github.com/user-attachments/assets/36a70c94-1dcc-4416-a444-a288312ff6a4" />



## Build & Start

### Setup & Build  
Ensure dependencies are installed, then run:

```sh
make setup
```

This checks prerequisites, builds the node application WASM, and sets up the ICP devnet.

### Start Development  
To deploy the mining contract and start development:

```sh
make dev
```

### Clean Up  
Stop services and remove temporary files:

```sh
make clean
```

## Available Commands

- `make check-prerequisites` – Verify required dependencies.  
- `make setup` – Set up the environment and build the project.  
- `make build-node-app-wasm` – Build the node application WebAssembly.  
- `make deploy-mining` – Deploy the mining contract.  
- `make dev` – Start the development environment.  
- `make clean` – Stop services and clean up temporary files.  
- `make help` – Display available commands.


