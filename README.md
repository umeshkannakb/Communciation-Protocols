# Communication Protocols â€” RTL Implementations in Verilog

A growing collection of hardware communication protocol implementations in Verilog HDL. Each protocol is self-contained with RTL design, testbench, and documentation.

> **Note:** The original repo name has a typo (`Communciation`). Rename it to `Communication-Protocols` via GitHub Settings â†’ Repository name.

---

## Protocols Implemented

| Protocol | Status | Description |
|----------|--------|-------------|
| UART | âœ… Complete | Universal Asynchronous Receiver-Transmitter |
| I2C | ðŸ”² Planned | Inter-Integrated Circuit (2-wire serial) |
| SPI | ðŸ”² Planned | Serial Peripheral Interface (4-wire full-duplex) |
| APB | ðŸ”² Planned | AMBA Peripheral Bus (ARM bus protocol) |

---

## Repository Structure

```
Communication-Protocols/
â”œâ”€â”€ README.md
â”œâ”€â”€ .gitignore
â”œâ”€â”€ UART/
â”‚   â”œâ”€â”€ README.md           â† UART-specific documentation
â”‚   â”œâ”€â”€ uart.v              â† Top-level UART module
â”‚   â”œâ”€â”€ uart_tx.v           â† Transmitter FSM
â”‚   â”œâ”€â”€ uart_rx.v           â† Receiver FSM
â”‚   â”œâ”€â”€ baud_gen.v          â† Baud rate clock generator
â”‚   â”œâ”€â”€ uart_tb.v           â† Full UART testbench
â”‚   â”œâ”€â”€ uart_tx_tb.v        â† Transmitter testbench
â”‚   â””â”€â”€ uart_rx_tb.v        â† Receiver testbench
â”œâ”€â”€ I2C/                    â† (Planned)
â”‚   â””â”€â”€ README.md
â””â”€â”€ SPI/                    â† (Planned)
    â””â”€â”€ README.md
```

---

## UART â€” Universal Asynchronous Receiver-Transmitter

### Overview

UART is a serial communication protocol that transmits data **asynchronously** â€” no shared clock between devices. Each data frame consists of a **start bit**, **8 data bits**, an optional **parity bit**, and a **stop bit**.

### Frame Format

```
Idle  Start  D0  D1  D2  D3  D4  D5  D6  D7  Stop
 1  |  0  |  x   x   x   x   x   x   x   x  |  1
```

### Module Hierarchy

```
uart.v (top)
â”œâ”€â”€ uart_tx.v     â”€â”€ Transmitter (parallel-in, serial-out)
â”œâ”€â”€ uart_rx.v     â”€â”€ Receiver (serial-in, parallel-out)
â””â”€â”€ baud_gen.v    â”€â”€ Clock divider for baud rate generation
```

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CLK_FREQ` | 50,000,000 | System clock in Hz |
| `BAUD_RATE` | 115200 | Baud rate (bits/second) |
| `DATA_BITS` | 8 | Data bits per frame |
| `STOP_BITS` | 1 | Stop bits |

### Port Description â€” `uart_tx`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | System clock |
| `rst_n` | input | 1 | Active-low reset |
| `tx_start` | input | 1 | Start transmission pulse |
| `tx_data` | input | 8 | Parallel data to send |
| `tx_serial` | output | 1 | Serial output line |
| `tx_done` | output | 1 | Transmission complete pulse |

### Port Description â€” `uart_rx`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | System clock |
| `rst_n` | input | 1 | Active-low reset |
| `rx_serial` | input | 1 | Serial input line |
| `rx_data` | output | 8 | Received parallel data |
| `rx_done` | output | 1 | Reception complete pulse |

### Baud Rate Calculation

```
Baud divisor = CLK_FREQ / BAUD_RATE
             = 50,000,000 / 115,200 â‰ˆ 434 clock cycles per bit
```

### How to Simulate

```bash
# Using Icarus Verilog
iverilog -o uart_sim UART/uart_tx.v UART/uart_rx.v UART/baud_gen.v UART/uart_tb.v
vvp uart_sim

# Or open in Vivado â†’ Run Behavioral Simulation
```

---

## What to Add Next

- [ ] Add UART README with waveform screenshot inside `UART/` folder
- [ ] Add I2C implementation (master + slave)
- [ ] Add SPI implementation (master + slave)
- [ ] Set GitHub topics: `verilog` `uart` `i2c` `spi` `fpga` `digital-design` `communication-protocols`
- [ ] Add simulation waveform screenshots for each protocol

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| Xilinx Vivado / Icarus Verilog | Simulation |
| GTKWave | Waveform viewing |

---

## License

MIT License
