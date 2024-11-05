# RISC-V implementation in VHDL
This project is part of the course "*Conception de systèmes sur puce*" at [TELECOM Nancy](https://telecomnancy.univ-lorraine.fr/).
It aims to implement a 32 bits RISC-V processor in VHDL.

## Run Simulations
I provide a Makefile to compile the project and run simulations.
By default, it uses [GHDL](https://ghdl.github.io/ghdl/) for compilation and simulation and [GTKWave](https://gtkwave.sourceforge.net/) for waveform visualization.
You can change the tools with `$(CC)` and `$(WAVIEW)` variables.
```sh
make entity_name.ghd # Analyze and Elaborate the entity_name
make entity_name.ghw # Run the simulation and generate the waveform
make unit=entity_name sim # Run the simulation and show the waveform
make cpu # Make everything for the CPU
```

## Author
- [Matthias Cabillot](mailto:matthias.cabillot@telecomnancy.net)
