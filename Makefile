CC=ghdl
WORKDIR=.
LFLAGS=--workdir=$(WORKDIR)
TF=1000ns
RFLAGS=--stop-time=$(TF)
WAVIEW=gtkwave
VHD_FILES!=ls *.vhd
unit=main
WFLAGS=> /dev/null 2>&1 &

.PHONY: clean all sim remake

all: $(VHD_FILES:.vhd=.ghd)

remake: clean all

%.ghw: %.ghd
	$(CC) -r $* $(RFLAGS) --wave=$@

%.o: %.vhd
	$(CC) -a $(LFLAGS) $<

%.ghd: %.o
	$(CC) -e $(LFLAGS) -o $* $*
	touch $@

sim: $(unit).ghw
	@echo "Opening waveform" $<
	@$(WAVIEW) $(unit).ghw $(WFLAGS)

clean:
	@rm -rfv *.o *.ghw *.cf *.ghd
	@ls | grep -v "\." | grep -v "Makefile" | xargs rm -rfv
