# iCEBrainstorm

A STM32F412 MCU with a iCE40UP5K FPGA on a compact dev board.

You will need STMCubeMX, VSCode and STMCubeProgrammer to program the STM.

<!-- You can use [apio](https://github.com/FPGAwars/apio) to synthesise a design and upload the firmware to the FPGA using a [online dfu-uploader](https://devanlai.github.io/webdfu/dfu-util/) (easier) -->

You will need to use the [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) to to synthesise your design and upload the bitstream to the FPGA. 

## Basic Structure
The STM32 Microcontroller and the iCE40 FPGA share one PCB and have some connections between them to communicate.
They can be programmed through their respective USB-C Port.
There are some switches to select the "program mode" for both the STM and the FPGA.

The code and bootloader of the SMT are stored inside the SMT IC, but the code and bootloader of the FPGA are stored on an external SPI Flash IC. 

There is also an gyrosensor on board. For more documentation, go look at the KiCAD files.

<!-- ![](/documentation/foto.png) -->

## How to Program:
Both the STM and the FPGA use a "Bootloader" to re-program themselfes. This makes the device visible to your computer and puts it in "program mode".


### STM32
The STM32 relies on its build-in bootloader to program itself via USB.
The bootloader is selected by switching the ```BOOT0``` Switch and ```RESET```-ing the SMT:
- Set the ```BOOT0``` Switch
- press ```RESET STM``` or plug in the cable
- The STM is now in DFU-mode, and can be programmed with STM32CubeProgrammer (or other software)
- In CubeProgrammer: select USB and click connect

![](/documentation/stprog_screenshot_usb.png)
- Click ```Open File``` and select your ```.elf``` file

![](/documentation/stprog_screenshot_openfile.png)
- Click ```Download```

![](/documentation/stprog_screenshot_download.png)
- Reset the ```BOOT0``` Switch.
- press ```RESET STM``` and your code should run.

### ICE40 FPGA

The FPGA relies on the [no2 bootloader](https://github.com/psychogenic/no2bootloader/tree/master), which is stored on the SPI-Flash IC.
The bootloader is selected by switching the ```FBOOT``` switch and ```RESET```-ing the FPGA, and then putting the ```FBOOT``` switch back.
Check if the ```CDONE``` LED at the top of the board is on.

- Set the ```FBOOT``` Switch
- press ```RESET FPGA``` or plug in the cable
- Reset the ```BOOT0``` Switch.
- Check if the ```CDODE``` LED at the top of the board is on.
- The FPGA is now in DFU-mode, and can be programmed with ```dfu-util``` (or other software)

## Clock
The STM and the FPGA are relatively independent from each other, with one slight caveat:
The STM32 is responsible for providing the FPGA with a Clock signal. The no2-bootloader of the FPGA relies on this clock source, and will not work without it. 

This clock can of course be used in your FPGA design as well.

### How to provide the clock 
- In cubeMX, go to ```PC9``` and select ```RCC_MCO_2```

![](/documentation/stcubemx_rcc_mco_2.png)
- Done!

## License

This repository is primarily licensed under the GNU General Public License v3.0.

Exceptions:
- STM32CubeMX-generated files are licensed under STMicroelectronics'
  STM32Cube firmware license (see file headers).
- The NO2 bootloader firmware is licensed under GPL-3.0-or-later
- Some third-party components may be licensed under MIT or CERN OHL v2.
