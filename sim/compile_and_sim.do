# =========================================================
# compile_and_sim.do  –  one-click compile + simulate
#
# ModelSim transcript:
#   cd {C:/path/to/simple_proc}
#   do compile_and_sim.do
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
vcom -93 -explicit -work work testbench.vhd

echo "Compilation complete."
vsim -novopt work.testbench

# ---- Wave window ----
add wave -divider "CLOCK / RESET / CYCLE"
add wave /testbench/clk
add wave /testbench/rst
add wave -radix unsigned /testbench/cycle_num

add wave -divider "PC  (word-addressed, +1 each cycle)"
add wave -radix unsigned /testbench/obs_pc

add wave -divider "PIPELINE  (opcode in each stage)"
add wave -label "IF  stage opcode" /testbench/obs_op_if
add wave -label "ID  stage opcode" /testbench/obs_op_id
add wave -label "EAR stage opcode" /testbench/obs_op_ear
add wave -label "FO  stage opcode" /testbench/obs_op_fo
add wave -label "EX  stage opcode" /testbench/obs_op_ex

add wave -divider "MUX 4-to-1  (next PC value)"
add wave -radix unsigned /testbench/obs_mux4_out

add wave -divider "MUX I  (effective address source)"
add wave -radix unsigned /testbench/obs_muxi_out

add wave -divider "MUX 2-to-1  (into Address Register)"
add wave -radix unsigned /testbench/obs_mux2_out

add wave -divider "AR  (Address Register)"
add wave -radix unsigned /testbench/obs_ar

add wave -divider "MUX A  (ALU bus A / operand 1)"
add wave -radix hex /testbench/obs_muxa_out

add wave -divider "MUX B  (ALU bus B / operand 2)"
add wave -radix hex /testbench/obs_muxb_out

add wave -divider "ALU result"
add wave -radix hex /testbench/obs_alu_result

add wave -divider "Data memory output"
add wave -radix hex /testbench/obs_mem_out

add wave -divider "PSW flags"
add wave /testbench/obs_psw_z
add wave /testbench/obs_psw_s
add wave /testbench/obs_psw_v
add wave /testbench/obs_psw_c
add wave /testbench/obs_branch_taken

add wave -divider "Write-back"
add wave               /testbench/obs_rf_wr_en
add wave -radix unsigned /testbench/obs_rf_wr_addr
add wave -radix hex      /testbench/obs_rf_wr_data

add wave -divider "Register file"
add wave -radix hex /testbench/obs_r1
add wave -radix hex /testbench/obs_r2
add wave -radix hex /testbench/obs_r3
add wave -radix hex /testbench/obs_r4
add wave -radix hex /testbench/obs_r5

run 2100 ns
wave zoom full
