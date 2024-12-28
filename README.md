# RISC-V 5-Stage Pipelined Processor

Welcome to the RISC-V 5-Stage Pipelined Processor project, a basic implementation of a **5-stage pipeline architecture** designed to improve instruction throughput and enhance processor performance. This project showcases how instructions are executed in parallel across multiple stages, highlighting the efficiency of pipelined processors.

## Features

### Pipeline Stages
1. **Instruction Fetch (IF):** Fetches instructions from memory.
2. **Instruction Decode (ID):** Decodes instructions and fetches operands.
3. **Execution (EX):** Performs arithmetic/logic operations and branch calculations.
4. **Memory Access (MEM):** Handles load and store operations.
5. **Write Back (WB):** Writes results to registers.

### Supported Instruction Types
- **R-Type:** ADD, SUB, AND, OR, XOR, etc.
- **I-Type:** ADDI, SLTI, LW, etc.
- **U-Type:** LUI, AUIPC.
- **B-Type:** BEQ, BNE, BLT, etc.
- **J-Type:** JAL, JALR.

### Load and Store Instructions
- **Load:** LW (Load Word), LH/UH (Load Halfword/Unsigned), LB/UB (Load Byte/Unsigned).
- **Store:** SW (Store Word), SH (Store Halfword), SB (Store Byte).

---

## Requirements
- **SystemVerilog** for design implementation.
- **ModelSim**, **QuestaSim**, or **Vivado** for simulation.
- **GTKWave** for waveform visualization.

---

## How to Use

### Setup
1. Clone the repository:
   ```bash
   git clone https://EbaaHaq/RISC-V-5-Stage-Pipelined-Processor.git
   ```
2. Navigate to the project directory:
   ```bash
   cd risc-v-pipelined-processor
   ```
3. Open the project in **VSCode** and ensure you have the necessary SystemVerilog extensions installed.
4. Run the testbench to observe the processor's functionality.

### Compilation & Simulation
1. Compile the SystemVerilog files:
   ```bash
   vlog *.sv
   ```
2. Simulate the design:
   ```bash
   vsim -c tb_processor -voptargs=+acc -do "run -all"
   ```
3. Visualize the waveform in GTKWave:
   ```bash
   gtkwave processor.vcd
   ```
4. Experiment with different RISC-V instructions in the pipelined architecture.

---

## Educational Purpose
This project serves as a learning tool for understanding pipelined processors, illustrating the division of instruction execution into stages for better throughput. It provides insights into the core concepts of RISC-V pipeline architecture.

---

## License
This project is **not licensed** yet. Feel free to use it with proper attribution.
