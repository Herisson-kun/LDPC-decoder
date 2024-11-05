# LDPC Encoder-Decoder over AWGN Channel

Welcome to the **LDPC Encoder-Decoder** project! This implementation provides a low-density parity-check (LDPC) code for error correction over an additive white Gaussian noise (AWGN) channel, simulating a common scenario in digital communication systems.

## Overview

LDPC codes are powerful error-correcting codes widely used in modern telecommunications, known for their high performance and efficiency. They operate by adding redundant data to the transmitted message, enabling the receiver to identify and correct errors caused by channel noise. This project implements both an LDPC encoder and decoder over an AWGN channel to simulate real-world communication.

The decoding is done using the iterative **Sum-Product Algorithm** (belief propagation), which achieves a near-optimal performance, closely approaching the Shannon limit for channels with Gaussian noise.

## Features

- **LDPC Code Construction**: Generates a low-density parity-check matrix (`H`) to specify the code constraints.
- **Encoding**: Encodes the input data using a generator matrix (`G`) derived from the parity-check matrix.
- **Channel Noise Simulation**: Adds AWGN to simulate noise during transmission.
- **Decoding with Sum-Product Algorithm**: Recovers the original data by iteratively updating beliefs in a bipartite graph representation.
- **Error Rate Analysis**: Evaluates bit error rate (BER) at different signal-to-noise ratios (SNRs) to assess performance.

## Project Structure

```plaintext
.
├── src
│   ├── encoder.py         # Implements LDPC encoding
│   ├── decoder.py         # Implements LDPC decoding with Sum-Product algorithm
│   ├── channel.py         # Simulates the AWGN channel
│   ├── parity_matrix.py   # Generates and manages the parity-check matrix H
│   └── utils.py           # Helper functions (e.g., SNR to noise conversion, BER calculation)
├── tests
│   ├── test_encoder.py    # Unit tests for encoder
│   ├── test_decoder.py    # Unit tests for decoder
│   └── test_channel.py    # Unit tests for AWGN channel
├── data                   # Folder for storing performance results (BER, SNR data)
└── README.md              # Project documentation
```

## Requirements

To run this project, you need Python 3.x and the following packages:
- `numpy` (for numerical operations)
- `matplotlib` (for plotting BER vs. SNR results)
- `scipy` (for additional mathematical tools and functions)

Install dependencies via:
```bash
pip install numpy matplotlib scipy
```

## How It Works

1. **Parity-Check Matrix Generation**: The code first creates a sparse parity-check matrix \( H \) of specified dimensions (e.g., 3/4 or 1/2 code rate), which defines the LDPC code. This matrix is used to define the structure of the code.

2. **Encoding**: Given an input message, the encoder generates the codeword by multiplying the message with a generator matrix \( G \), derived from \( H \).

3. **AWGN Channel**: The encoded codeword is sent through an AWGN channel, where Gaussian noise is added to simulate real-world transmission effects.

4. **Decoding (Sum-Product Algorithm)**: At the receiver, the noisy codeword is decoded using belief propagation on the bipartite graph defined by \( H \). This algorithm iteratively updates the likelihood of each bit until either all parity-check constraints are satisfied or a maximum number of iterations is reached.

5. **Performance Analysis**: Bit Error Rate (BER) is computed for different SNR values to visualize the code's effectiveness in error correction over AWGN.

## Usage

1. **Running the Encoder-Decoder**

   To run the full encoder-decoder pipeline with a test message, use the following command in the project directory:
   ```bash
   python src/main.py
   ```

2. **Modifying Parameters**

   Inside `main.py`, you can adjust the following parameters:
   - **Code Length (n)** and **Message Length (k)**: Defines the size and rate of the LDPC code.
   - **SNR Range**: Set a range of SNR values for the AWGN channel to evaluate performance at different noise levels.
   - **Max Iterations**: Set the maximum number of iterations for the Sum-Product algorithm.

3. **Plotting BER vs. SNR**

   After running the pipeline, BER results will be saved to `data/`. You can visualize the BER performance by running:
   ```bash
   python plot_ber.py
   ```
   This will generate a plot showing BER as a function of SNR, allowing you to observe the code's robustness against noise.

## References

- Gallager, R. G. (1962). "Low-Density Parity-Check Codes". *IRE Transactions on Information Theory*.
-  Bernhard M.J. (2005). *LDPC Codes– a brief Tutorial*.
---
