# LEDs driver for PCEngines apu series module Makefile
#
# This file is in the public domain. Permission to use, copy, modify, and
# distribute this software and its documentation for any purpose and without
# fee is hereby granted, without any conditions or restrictions.
# This software is provided “as is” without express or implied warranty.
#
# Christian Herzog (daduke) <daduke@daduke.org>, 2013-12-10, based on
# Adam Cécile (Le_Vert) <gandalf@le-vert.net>, 2008-01-18

KERNEL_VERSION  := `uname -r`
KERNEL_DIR      := /lib/modules/$(KERNEL_VERSION)/build
INSTALL_MOD_DIR := kernel/drivers/leds
PWD             := $(shell pwd)
DESTDIR 	=
PREFIX 		= /usr/local
SBINDIR 	= $(PREFIX)/sbin

obj-m := apuled-button.o
SOURCE = $(subst .o,.c,$(obj-m))
MODULE = $(subst .o,.ko,$(obj-m))

all: $(MODULE)
	gcc -Wformat=0 -o apuled apuled.c

$(MODULE): $(SOURCE)
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules

install: $(MODULE)
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) INSTALL_MOD_DIR=$(INSTALL_MOD_DIR) modules_install
	depmod -a
	install -m 0755 apuled $(SBINDIR)/apuled
	install -m 0755 apubutton $(SBINDIR)/apubutton

uninstall:
	rm -f $(SBINDIR)/apuled
	rm -f $(SBINDIR)/apubutton
	rm -f /lib/modules/`uname -r`/$(INSTALL_MOD_DIR)/$(MODULE)
	depmod -a

distclean: clean

clean:
	rm -f *.o *.ko .*.cmd .*.flags *.mod.c Module.symvers
	rm -rf .tmp_versions
	rm -f apuled modules.order
