mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ifndef FIRMWARE_PATH
FIRMWARE_PATH := $(current_dir)/firmware
endif

ifndef BUILD_PATH
BUILD_PATH := $(FIRMWARE_PATH)/build
endif

ifndef PYCOM_IDF_PATH
PYCOM_IDF_PATH := $(FIRMWARE_PATH)/pycom-esp-idf
endif

ifndef PYCOM_PATH
PYCOM_PATH := $(FIRMWARE_PATH)/pycom-micropython-sigfox
endif

ifndef BOARD
BOARD := GPY
endif

export IDF_PATH = $(PYCOM_IDF_PATH)

BRANCH := $(subst $e /,-,$(shell git rev-parse --abbrev-ref HEAD))
HASH := $(shell git rev-parse --short HEAD)
TIMESTAMP := $(shell date '+%y.%m.%d-%H.%M.%S')

.PHONY: all
all: clean
	-@cp --parents lib/**/*.py $(PYCOM_PATH)/esp32/frozen/Custom
	-@cp --parents lib/*.py $(PYCOM_PATH)/esp32/frozen/Custom
	@cp main.py $(PYCOM_PATH)/esp32/frozen/Base/_main.py
	@cp boot.py $(PYCOM_PATH)/esp32/frozen/Base/_boot.py
	@cd $(PYCOM_PATH)/esp32 && \
		make BOARD=$(BOARD) clean && \
		make BOARD=$(BOARD) && \
		make BOARD=$(BOARD) release
	@cd $(current_dir)
	@mkdir -p $(BUILD_PATH)
	@cp -r $(PYCOM_PATH)/esp32/build/*.tar.gz $(BUILD_PATH)/$(BOARD)_$(TIMESTAMP)_$(BRANCH)_$(HASH).tar.gz

.PHONY: clean
clean:
	@$(shell which rm) -rf \
	$(PYCOM_PATH)/esp32/build/* \
	$(PYCOM_PATH)/esp32/frozen/pycache \
	$(PYCOM_PATH)/esp32/frozen/Custom/lib \
	$(PYCOM_PATH)/esp32/frozen/Base/_main.py \
	$(PYCOM_PATH)/esp32/frozen/Base/_boot.py

.PHONY: mpy-build
mpy-build:
	@cd $(PYCOM_PATH)/mpy-cross && make clean && make
