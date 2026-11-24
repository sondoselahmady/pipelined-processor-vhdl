# Pipelined Processor (VHDL / ModelSim)

VHDL implementation and ModelSim simulation of a pipelined processor, including datapath and control modules, pipeline stage registers, memory initialization files, a testbench, and a block diagram.

## Key Files
- **Processor & Datapath:** `processor.vhd`, `top_level.vhd`, `alu.vhd`, `control_unit.vhd`, `register_file.vhd`, `pc.vhd`, `psw.vhd`, `decoder_3to8.vhd`, `mux_2to1.vhd`, `mux_4to1.vhd`, `mux_16to1.vhd`
- **Pipeline Stages:** `if_id.vhd`, `id_ear.vhd`, `ear_fo.vhd`, `fo_ex.vhd`, `ex_mem_wb.vhd`
- **Memory & Simulation:** `instruction_memory.vhd`, `data_memory.vhd`, `imem.txt`, `dmem.txt`, `testbench.vhd`, `compile_and_sim.do`, `run.do`
- **Architecture Diagram:** `Block Diagram.drawio`

## Running in ModelSim
Open the project directory in ModelSim and run the simulation script (`compile_and_sim.do` or `run.do`) with `testbench.vhd`.

## What I Learned

- How pipelining actually works past the textbook diagrams: stage registers, data flow between stages, and why hazards happen
- Writing testbenches and driving simulations in ModelSim with .do scripts
- Breaking a large digital design into small, testable modules
