.PHONY: submodules setup-buildroot build-app

BR_DIR = $(CURDIR)/buildroot
BR_EXT = $(CURDIR)/buildroot-external
BR_OUT = $(CURDIR)/output
BR_LOG = $(BR_OUT)/build.log
SHELL := /bin/bash

submodules:
	@if [ ! -f "$(BR_DIR)/Makefile" ]; then \
		echo "Error: Buildroot submodule not found. Run 'git submodule update --init --recursive' on your host."; \
		exit 1; \
	fi

setup-buildroot: submodules
	@echo "Configuring Buildroot with external tree..."
	@mkdir -p $(BR_OUT)
	$(MAKE) -C $(BR_DIR) BR2_EXTERNAL=$(BR_EXT) O=$(BR_OUT) weatherstation_defconfig

build-app: setup-buildroot
	@echo "Starting build. Logging to $(BR_LOG)"
	set -o pipefail; $(MAKE) -C $(BR_DIR) O=$(BR_OUT) -j16 2>&1 | tee $(BR_LOG)
