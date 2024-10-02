transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/matt/Documents/TN/CSsP/TPs/tp_rom/single_port_rom_async.vhd}

vcom -93 -work work {/home/matt/Documents/TN/CSsP/TPs/tp_rom/tb_mem.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb_mem

add wave *
view structure
view signals
run 300 ns
