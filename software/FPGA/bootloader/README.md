# BOOTLOADER

The FPGA relies on the no2bootloader to make itself flashable over USB.

This process was inspired by a [youtube video](https://www.youtube.com/watch?v=gGN0g9jgsUc)

## How to build the bootloader
### Installing depencies
Don't even try building when until these are installed and can be called from your terminal!
- install the [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- install a [embedded riscv compiler (xpack)](https://xpack-dev-tools.github.io/riscv-none-elf-gcc-xpack/)
- for the riscv-compiler, you'll need [xpm](https://xpack.github.io/xpm/)
- and for that, you'll need [npn](https://docs.npmjs.com/cli/v11/configuring-npm/install)

### make sure to set the $PATH
example:
```
export PATH=$PATH:/Users/oompje_joost/fpga-toolchain/bin:/Users/oompje_joost/oss-cad-suite/bin
export PATH=$HOME/Library/xPacks/@xpack-dev-tools/riscv-none-elf-gcc/15.2.0-1.1/.content/bin:$PATH
export PATH=$PATH:/usr/local/Cellar/flashrom/1.6.0/sbin/
```
consider setting them permanently by adding this to the end of your ```.bashrc``` file.

### Compiling
go to ```no2bootloader/ice40-stub/```

run ```make PRE_CLEAN=1 bootloader-clean``` to cleanup the old files.

run ```make BOARD=icebrainstorm CROSS=riscv-none-elf- bootloader``` to build the bootloader.

If everything works, a ```bootloader.bin``` file should be generated in ```ice40-stub/build-tmp```. This needs to be moved ino the flash.

## Flashing the bootloader to the FPGA

If the no2bootloader is (still) in the spi-flash, than switch the ```FBOOT``` button 4 times. The Bootloader should show up in ```dfu-util -l```. There should be 4 options/listed devices istead of the usual two.

### Preparing the Board
Electrically disconnect the spi-flash from the FPGA by desoldering + cutting the connections of the SPI lines. Make sure (with a mutimeter) that the connections are indeed not conducting.

### Preparing the Programmer
Connect a second device (I used a raspberry pi pico) to act as SPI Programmer. Compile and flash the code on the pico.

[Pico code](https://github.com/stacksmashing/pico-serprog#readme)

### Flashing
- install ```flashrom```
- make sure to add it to your ```$PATH```

because the binairy file is not exactly as big as the SPI flash, flashrom will complain..

- Add a ```layout.txt``` file to tell flashrom what it needs to flash.

Content of layout.txt: ```00000000:00061ACF bootloader```
replace the hex number with the size of ```hardware.bin``` (in hexadecimal) minus one.

run ```flashrom -p serprog:dev=/dev/tty.usbmodem1301:115200,spispeed=12M --layout layout.txt --include bootloader:bootloader.bin -w``` 
the usb device may differ a bit. 


# Author
Joël de Kanter