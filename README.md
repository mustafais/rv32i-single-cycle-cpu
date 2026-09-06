# RV32I Single-Cycle RISC-V CPU

A 32-bit single-cycle RISC-V processor implemented in SystemVerilog with separate instruction and data memories.

The project was built to explore CPU architecture, RTL design, functional verification, and the ASIC physical-design flow. The processor currently implements 31 RV32I base instructions, covering integer arithmetic and logic, immediate operations, conditional branches, jumps, upper-immediate operations, and word-level memory access with LW and SW.

The RTL has also been taken through the OpenLane RTL-to-GDS flow using the SKY130 PDK. Physical-design optimization is still ongoing, with a current goal of achieving timing closure at 100 MHz.

## Architecture

* 32-bit RISC-V processor implementing a 31-instruction RV32I subset
* Single-cycle datapath
* Harvard-style instruction/data memory organization
* 32 × 32-bit register file
* Dedicated branch and jump control
* SystemVerilog RTL

## Implemented Functionality

The current processor supports major RV32I instruction categories, including:

* Register-register arithmetic and logic
* Immediate arithmetic and logic
* Word load and store (LW, SW)
* Conditional branches
* `JAL`
* `JALR`
* Upper-immediate instructions
* Shift operations
* Signed and unsigned comparisons

## Verification

The processor has been tested using custom SystemVerilog testbenches and RISC-V programs.

Testing has included:

* Arithmetic and logical operations
* Register writes
* Immediate generation
* Branch behavior
* Jump behavior
* Load/store behavior
* Program-counter updates
* Multi-instruction execution

Custom programs such as Fibonacci, factorial, and bubble sort have been used as functional workloads.

The design has not yet undergone exhaustive formal verification or full official RISC-V compliance testing.

## Physical Design

The RTL has been taken through the OpenLane ASIC flow using the SKY130 PDK, including:

* Synthesis
* Floorplanning
* Placement
* Clock tree synthesis
* Routing
* Static timing analysis
* GDS generation

Tools used include Yosys, OpenROAD, KLayout, and OpenLane.

## Current Status

The RTL processor is functional for the currently implemented instruction set, and the OpenLane flow has successfully reached GDS generation.

The physical design is still being optimized.

Current physical-design goal:

**100 MHz target frequency (10 ns clock period)**

The design does **not yet meet timing at 100 MHz**, and setup-timing violations remain across some process corners.

Current work includes:

* Refining SDC constraints
* Analyzing critical timing paths
* Improving synthesis and physical-design settings
* Reducing timing violations
* Expanding verification coverage

## Known Limitations

* 100 MHz timing closure has not yet been achieved
* The processor currently implements 31 RV32I base instructions rather than the full base ISA
* Byte and halfword memory operations are not implemented
* ECALL and EBREAK are not implemented
* Full RV32I compliance testing has not yet been completed
* Formal verification has not yet been performed
* RV32M multiply/divide instructions are not implemented
* The design is single-cycle and does not include pipelining
* No cache hierarchy or virtual-memory system is implemented

## Future Work

Possible future improvements include:

* Achieving timing closure at 100 MHz
* Adding remaining RV32I base instructions
* More comprehensive automated verification
* SystemVerilog Assertions
* Cocotb or UVM-based verification
* Official RISC-V architectural testing
* Five-stage pipelining
* Forwarding and hazard detection
* RV32M support
* Cache implementation
