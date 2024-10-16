transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/matt/Documents/TN/CSsP/TPs/tp_rom/register_bench.vhd}

vcom -93 -work work {/home/matt/Documents/TN/CSsP/TPs/tp_rom/tb_rb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb_rb

add wave *
view structure
view signals
run 1000 ns
