.PHONY: submodules setup-buildroot

BR_DIR = $(CURDIR)/buildroot
BR_EXT = $(CURDIR)/buildroot-external

submodules:
	@git submodule init
	@git submodule update

setup-buildroot: submodules
	$(MAKE) -C $(BR_DIR) BR2_EXTERNAL=$(BR_EXT) weatherstation_defconfig
