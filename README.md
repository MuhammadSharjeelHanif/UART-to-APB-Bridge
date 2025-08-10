# UART to APB Bridge (SystemVerilog + UVM)

This project implements a **UART to APB bridge** that decodes 8-bit UART transactions into APB protocol operations and sends appropriate responses back over UART. It includes both RTL and UVM-based verification.

---

## 🧠 Project Overview

- **Objective:** To enable communication between a UART master and an APB-based peripheral by designing a hardware bridge in SystemVerilog.
- **Protocol:** UART input is parsed and decoded to generate corresponding APB read/write transactions.
- **Response:** The APB response (ACK or read data) is sent back over UART.

---

## ⚙️ Features

- **UART RX/TX**
  - 8-bit data, 1 start bit, 1 stop bit
  - Baud rate divisor calculation based on 100 MHz clock

- **UART Packet Format**
  - 8-bit UART Transaction: `[7:3] data`, `[2:1] address`, `[0] R/W bit`
  - `R/W = 1` ⇒ Write, `R/W = 0` ⇒ Read

- **APB Master Interface**
  - Generates `PADDR`, `PWDATA`, `PWRITE`, `PSEL`, `PENABLE` based on UART packet
  - Waits for `PREADY` and reads `PRDATA` for read operations

- **UVM Verification Environment**
  - Includes UART monitor, APB monitor, scoreboard, driver, and sequencer
  - Supports directed and randomized sequences
  - Verified with 10,000+ UART packets

---



