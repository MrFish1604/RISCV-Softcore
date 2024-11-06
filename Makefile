CC=ghdl
WORKDIR=.
LFLAGS=--workdir=$(WORKDIR) --std=08
TF=1000ns
RFLAGS=--stop-time=$(TF) --stop-delta=50000
WAVIEW=gtkwave
VHD_FILES!=ls *.vhd
unit=main
WFLAGS=> /dev/null 2>&1 &

.SUFFIXES: # Erase implicit rules
.PHONY: clean all sim re %.rm
.PRECIOUS: %.o %.ghd

all: $(VHD_FILES:.vhd=.ghd)

re: clean all

cpu: imem.txt program_counter.ghd program_counter_auto.ghd single_port_rom_async.ghd register_bench.ghd ALU.ghd controleur.ghd imem.ghd imm_ext.ghd mux21.ghd lm.ghd cpu.ghd
	@rm -rfv tb_cpu.ghd

imem.o: imem.txt

%.ghw: %.ghd
	$(CC) -r $* $(RFLAGS) --wave=$@

%.o: %.vhd
	@rm -rfv *$*.o
	$(CC) -a $(LFLAGS) $<

%.ghd: %.o
	$(CC) -e $(LFLAGS) -o $* $*
	touch $@
	@rm -rfv cpu.ghd
	@rm -rfv tb_$@

sim: $(unit).ghw.rm $(unit).ghw
	@echo "Opening waveform" $<
	@$(WAVIEW) $(unit).ghw $(WFLAGS)

%.rm:
	@rm -rfv $*

clean:
	@rm -rfv *.o *.ghw *.cf *.ghd
	@ls | grep -v "\." | grep -v "Makefile" | grep -v "*.md" | grep -v "LICENSE" | grep -v "prgms" | grep -v "docs" | xargs rm -rfv
