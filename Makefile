CC=ghdl
WORKDIR=.
LFLAGS=--workdir=$(WORKDIR)
TF=1000ns
RFLAGS=--stop-time=$(TF)
WAVIEW=gtkwave
VHD_FILES!=ls *.vhd
unit=main
WFLAGS=> /dev/null 2>&1 &

.PHONY: clean all sim re %.rm
.PRECIOUS: %.o %.ghd

all: $(VHD_FILES:.vhd=.ghd)

re: clean all

%.ghw: %.ghd
	$(CC) -r $* $(RFLAGS) --wave=$@

%.o: %.vhd
	@rm -rfv *$*.o
	$(CC) -a $(LFLAGS) $<

%.ghd: %.o
	$(CC) -e $(LFLAGS) -o $* $*
	touch $@

sim: $(unit).ghw.rm $(unit).ghw
	@echo "Opening waveform" $<
	@$(WAVIEW) $(unit).ghw $(WFLAGS)

%.rm:
	@rm -rfv $*

clean:
	@rm -rfv *.o *.ghw *.cf *.ghd
	@ls | grep -v "\." | grep -v "Makefile" | grep -v "docs" | xargs rm -rfv
