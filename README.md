Jane Street posted this [challenge](https://blog.janestreet.com/protocol-emulator-asic-competition/) recently and this is my attempt at the challenge. I will be updating the repo as I go along learning and implementing into my design.

![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)


# FlexPIO: Open-Source Protocol Emulator ASIC

FlexPIO is a compact, programmable soft-core protocol emulator designed for Tiny Tapeout on the **IHP 130nm CMOS5L** process. It acts as a lightweight programmable state machine capable of bit-banging complex serial protocols (like UART, SPI, I2C, or custom interfaces) with cycle-accurate precision.

## Key Features
* **Custom ISA:** Designed for minimal area and high-speed execution (`SET`, `WAIT`, `IN`, `JMP`).
* **8 Bidirectional GPIOs (`gio[7:0]`):** Direct multi-pin bitmask control and input reading.
* **Instruction Memory:** 128-word 16-bit instruction store.
* **Scratch Registers:** 8 general-purpose registers (`R0`–`R7`) for state management.
* **Tiny Tapeout Integration:** Fully constrained for a 6x4 tile layout on the IHP 130nm process.

---

## Instruction Set Architecture (ISA)

FlexPIO uses fixed 16-bit instruction words divided by 3-bit opcodes:

| Opcode | Mnemonic | Description | Bit Format |
| :---: | :--- | :--- | :--- |
| `000` | `SET` | Set/clear masked pins | `[15:13]=000`, `[12]=val`, `[11:4]=mask`, `[3:0]=0` |
| `001` | `WAIT` | Pause execution for N cycles | `[15:13]=001`, `[12:10]=0`, `[9:0]=cycle_count` |
| `010` | `IN`   | Sample input pins into a register | *(Configured in MVP expansion)* |
| `011` | `JMP`  | Unconditional or conditional branch | *(Configured in MVP expansion)* |

---

## Simulation & Verification

FlexPIO uses **Cocotb** and **Icarus Verilog** for automated testbenches and waveform generation.

### Running Tests
1. Navigate to the test directory:
    ```bash
    cd test
    ```

2. Run the simulation suite:
    ```bash
    make
    ```

3. Inspect the generated FST waveform `(test/tb.fst)` using GTKWave or Surfer.