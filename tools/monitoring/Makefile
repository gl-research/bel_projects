# PREFIX  controls where programs and libraries get installed
# Note: during compile (all), PREFIX must be set to the final installation path
# Example usage:
#   make PREFIX=/usr all
PREFIX      ?= /usr/local
STAGING     ?=
EB          ?= ../../ip_cores/etherbone-core/api
WRPC        ?= ../../ip_cores/wrpc-sw
TARGETS     := eb-mon

EXTRA_FLAGS ?=
CFLAGS      ?= $(EXTRA_FLAGS) -Wall -O2 -I $(EB) -I $(WRPC)/include -I $(WRPC)/pp_printf 
LIBS        ?= -L $(EB)/.libs -Wl,-rpath,$(PREFIX)/lib -letherbone -lm

# special for eb-mon
WBDIR    = ..
WBFLAG   = -DNOWB_SIMULATE
WBFLAG  += -I$(WBDIR) 

all: $(TARGETS)

eb-mon: eb-mon.c
	$(CC) $(CFLAGS) $(WBFLAG) $(WBDIR)/wb_api.c $(WRPC)/dev/w1.c $(WRPC)/dev/w1-temp.c $(WRPC)/dev/w1-eeprom.c $(WRPC)/tools/eb-w1.c -o eb-mon eb-mon.c $(LIBS)

clean:
	rm -f *.o eb-mon

install:
	mkdir -p $(STAGING)$(PREFIX)/bin
	cp $(TARGETS) $(STAGING)$(PREFIX)/bin

.PHONY: all clean
