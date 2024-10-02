onerror {exit -code 1}
vlib work
vcom -work work tp_rom.vho
vcom -work work Waveform1.vwf.vht
vsim -novopt -c -t 1ps -L cyclonev -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.single_port_rom_async_vhd_vec_tst
vcd file -direction tp_rom.msim.vcd
vcd add -internal single_port_rom_async_vhd_vec_tst/*
vcd add -internal single_port_rom_async_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
