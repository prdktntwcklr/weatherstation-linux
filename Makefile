.PHONY: submodules setup-buildroot build-app

BR_DIR = $(CURDIR)/buildroot
BR_EXT = $(CURDIR)/buildroot-external
SHELL := /bin/bash

submodules:
	@echo "Fetching Git submodules..."
	@git submodule init
	@git submodule update

setup-buildroot: submodules
	@echo "Configuring Buildroot with external tree..."
	$(MAKE) -C $(BR_DIR) BR2_EXTERNAL=$(BR_EXT) weatherstation_defconfig

build-app: setup-buildroot
	@echo "Starting build. Logging to $(CURDIR)/build.log"
	set -o pipefail; $(MAKE) -C $(BR_DIR) -j16 2>&1 | tee $(CURDIR)/build.log
