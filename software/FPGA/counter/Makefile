# this does the same as synthesize-and-flash 
upload:
	apio upload

# List all FPGAs and give an error when ther is none
list:
	dfu-util -l
	@if [ -z "$(DFU_ID)" ]; then \
		echo "Error: iCEBrainstorm DFU not found"; \
		exit 1; \
	fi

# Synthesize the bitstream
synthesize:
	apio build -v

# Vibe coded: List all DFU Devices, filter the iCE40 one, and retrieve its numer
DFU_ID := $(shell \
	dfu-util -l | \
	grep 'name="iCE40 bitstream"' | \
	sed -n 's/.*\[\(.*\)\].*/\1/p' \
)

# path to the bitstream to be flashed.
FLASH_FILE := _build/default/hardware.bin

# actual command to find the FPGA and programm it.
# DOES NOT WORK if mutiple FPGAs are plugged in!
flash-dfu:
	@if [ -z "$(DFU_ID)" ]; then \
		echo "Error: iCEBrainstorm DFU not found"; \
		exit 1; \
	fi
	dfu-util -d $(DFU_ID) -a 0 -D $(FLASH_FILE) # This command uploads the bitstream

# Synthesize and flash
synthesize-and-flash-dfu: synthesize flash-dfu
	
# Clean
clean:
	apio clean

