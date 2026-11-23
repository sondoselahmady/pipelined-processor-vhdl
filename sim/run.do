# =========================================================
# run.do
# Automated Compilation and Simulation Script
# =========================================================

vlib work
vmap work work

vcom -93 -explicit -work work pc.vhd
vcom -93 -explicit -work work instruction_memory.vhd
vcom -93 -explicit -work work data_memory.vhd
vcom -93 -explicit -work work register_file.vhd
vcom -93 -explicit -work work alu.vhd
vcom -93 -explicit -work work psw.vhd
vcom -93 -explicit -work work control_unit.vhd
vcom -93 -explicit -work work mux_2to1.vhd
vcom -93 -explicit -work work mux_4to1.vhd
vcom -93 -explicit -work work mux_16to1.vhd
vcom -93 -explicit -work work decoder_3to8.vhd
vcom -93 -explicit -work work if_id.vhd
vcom -93 -explicit -work work id_ear.vhd
vcom -93 -explicit -work work ear_fo.vhd
vcom -93 -explicit -work work fo_ex.vhd
vcom -93 -explicit -work work ex_mem_wb.vhd
vcom -93 -explicit -work work processor.vhd
vcom -93 -explicit -work work top_level.vhd
vcom -93 -explicit -work work testbench.vhd

echo "Compilation complete. Launching Testbench..."
vsim -novopt work.testbench

# Clean Wave Layout
add wave -divider "=== CLOCK / RESET ==="
add wave /testbench/clk
add wave /testbench/rst
add wave -radix unsigned /testbench/cycle_num

add wave -divider "=== PROGRAM COUNTER ==="
add wave -radix unsigned /testbench/obs_pc

add wave -divider "=== PIPELINE STAGE OPCODES ==="
add wave -label "IF  (fetch)"       /testbench/obs_op_if
add wave -label "ID  (decode)"      /testbench/obs_op_id
add wave -label "EAR (eff. addr)"   /testbench/obs_op_ear
add wave -label "FO  (fetch opnd)"  /testbench/obs_op_fo
add wave -label "EX  (execute)"     /testbench/obs_op_ex

add wave -divider "=== ALU & MEMORY ==="
add wave -radix hex -label "ALU Bus A" /testbench/obs_muxa_out
add wave -radix hex -label "ALU Bus B" /testbench/obs_muxb_out
add wave -radix hex -label "ALU Result" /testbench/obs_alu_result
add wave -radix hex -label "Data Mem Output" /testbench/obs_mem_out

add wave -divider "=== PSW FLAGS ==="
add wave /testbench/obs_psw_z
add wave /testbench/obs_psw_s
add wave /testbench/obs_branch_taken

add wave -divider "=== REGISTER FILE ==="
add wave -radix hex /testbench/obs_r1
add wave -radix hex /testbench/obs_r2
add wave -radix hex /testbench/obs_r3
add wave -radix hex /testbench/obs_r4
add wave -radix hex /testbench/obs_r5
add wave -radix hex /testbench/obs_r6
add wave -radix hex /testbench/obs_r7

# Run until the clock stops (sim_done = true)
run -all
wave zoom full