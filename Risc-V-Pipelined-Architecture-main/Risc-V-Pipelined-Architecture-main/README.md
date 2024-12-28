# RISC-V Pipelined Processor (Basic 5-Stage)

This project implements a **basic 5-stage pipelined RISC-V processor**. It includes five key stages: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execution (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**. The architecture demonstrates how instruction execution is divided into parallel stages to improve throughput and processor performance.

**Note**: Hazards (data, control, and structural) have not been handled in this implementation. 

## Features
- **5-Stage Pipeline**: Includes the stages IF, ID, EX, MEM, and WB for executing instructions.
- **Parallel Execution**: Increases instruction throughput by executing multiple instructions simultaneously across different pipeline stages.
- **Basic RISC-V Components**: Includes an ALU, registers, memory, and a control unit for instruction processing.

## Requirements
- **SystemVerilog** libraries for design implementation.
- **VSCode** for editing and compiling the code.
- A simulator like **ModelSim** or **Vivado** for testing the design.
- **GTKWave** for waveform visualization (requires **Multisim** to run GTKWave).

## How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/anam309/Risc-V-Pipelined-Architecture.git
   ```
2. Open the project in **VSCode** and ensure you have the necessary SystemVerilog extensions installed.
3. Compile the SystemVerilog files using your preferred simulator (ModelSim/Vivado).
4. Use **GTKWave** to visualize the waveform, but note that **Multisim** is required to run GTKWave.
5. Run the testbench to observe the processor's functionality.
6. Experiment with different RISC-V instructions in the pipelined architecture.

## Educational Purpose
This project serves as an educational tool for understanding the operation of a pipelined processor, showcasing how instruction execution is divided into multiple stages to increase throughput. It provides insight into the functioning of a basic 5-stage pipeline in a RISC-V processor.

## License
This project is **not licensed** yet. Feel free to use it with proper attribution.
