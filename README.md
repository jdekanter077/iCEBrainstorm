# iCEBrainstorm

A STM32F412 MCU with a iCE40UP5K FPGA on a compact dev board.

You will need STMCubeMX, VSCode and STMCubeProgrammer to program the STM.

<!-- You can use [apio](https://github.com/FPGAwars/apio) to synthesise a design and upload the firmware to the FPGA using a [online dfu-uploader](https://devanlai.github.io/webdfu/dfu-util/) (easier) -->

<!-- You will need to use the [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) to to synthesise your design and upload the bitstream to the FPGA.  -->
You can use apio to synthesize and upload your hdl on the FPGA. Refer to [apio support](#apio-support) on how to configure apio to support the iCEBrainstorm board.

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
- Check if the ```CDONE``` LED at the top of the board is on.
- The FPGA is now in DFU-mode, and can be programmed with 
```apio upload``` or using ```dfu-util```

<!-- - run ```dfu-util -l``` to list all dfu devices. -->
<!-- example output: 
```Found DFU: [1d50:6146] ver=0006, devnum=12, cfg=1, intf=0, path="", alt=1, name="RISC-V firmware", serial="e464bc68932e5839"
Found DFU: [1d50:6146] ver=0006, devnum=12, cfg=1, intf=0, path="", alt=0, name="iCE40 bitstream", serial="e464bc68932e5839"
``` -->
<!-- - run ```dfu-util -d 1d50:6146 -a 0 -D hardware.bin``` to flash your bitstream on the FPGA. Maybe You have to replace the ```1d50:6146```-number with what you see on your terminal. -->
- run ```apio devices usb``` to list all dfu devices.
- run ```apio upload``` to synthesize and upload the verilog code.

-  To edit your HDL code, take a look at the examples in [software/FPGA](./software/FPGA)

### APIO Support
[apio](https://github.com/FPGAwars/apio) is a open-source FPGA Toolchain, which will help us synthesize HDL code.
Make sure you have a recent version of apio installed! You can uninstall and install again to update.
- Install apio using ```pip install apio```
- edit ```~/.apio/packages/definitions/boards.jsonc``` and add this snippet:
```
  // https://github.com/jdekanter077/iCEBrainstorm
  "iCEBrainstorm": {
    "legacy-name": "iCEBrainstorm",
    "description": "iCEBrainstorm by jdk",
    "fpga-id": "ice40up5k-sg48",
    "programmer": {
      "id": "dfu"
    },
    "usb": {
      "vid": "1d50",
      "pid": "6146"
    }
  },
```

This will add apio support for the iCEBrainstorm board.
-  to create a new project, run ```apio create -b iCEBrainstorm```
-  edit your HDL code, take a look at the examples in [software/FPGA](./software/FPGA)

### Bootloader
The Bootloader is preinstalled by Joël and should not have to be touched.
Check out [bootloader/README.md](./software/FPGA/bootloader/README.md) for more information.

## Clock
The STM and the FPGA are relatively independent from each other, with one slight caveat:
The STM32 is responsible for providing the FPGA with a Clock signal. The no2-bootloader of the FPGA relies on this clock source, and will not work without it. 

This clock can of course be used in your FPGA design as well.

### How to provide the clock 
- In cubeMX, go to ```PC9``` and select ```RCC_MCO_2```

![](/documentation/stcubemx_rcc_mco_2.png)
- Generate Code, open the folder in STMCubeIDE or VSCode, compile, and upload using STMCubeProgrammer.
- Done!

## FPGA Pinout Description:
These informations should be in every ```main.pcf``` file.

| Description | FPGA Pin | Usage |
| --- | ---- | ---- |
| clk_i | 20  | 16 MHz Clock, provided by the STM32 | 
| btn_0 | 31 | left button | 
| btn_1 | 32 | right button | 
| in_0 | 34 | Input Switch and/or GPIO | 
| in_1 | 35 | Input Switch and/or GPIO | 
| in_2 | 36 | Input Switch and/or GPIO | 
| in_3 | 37 | Input Switch and/or GPIO | 
| out_0 | 25  | LED | 
| out_1 | 26  | LED | 
| out_2 | 27  | LED | 
| out_3 | 28  | LED | 
| io_0 | 47  | GPIO | 
| io_1 | 42  | GPIO | 
| io_2 | 38  | GPIO | 
| io_3 | 23  | GPIO | 
| rgb_0 | 39 | RGB LED and/or GPIO | 
| rgb_1 | 40 | RGB LED and/or GPIO | 
| rgb_2 | 41 | RGB LED and/or GPIO | 
| uart_tx | 2  | uart output (STM RX <- FPGA TX) | 
| uart_rx | 3  | uart input (STM TX -> FPGA RX) | 
| scl | 19 | I2C Clock | 
| sda | 18 | I2C Data | 

# Author
Joël de Kanter

# License

This repository is primarily licensed under the GNU General Public License v3.0.

Exceptions:
- STM32CubeMX-generated files are licensed under STMicroelectronics'
  STM32Cube firmware license (see file headers).
- The NO2 bootloader firmware is licensed under GPL-3.0-or-later
- Some third-party components may be licensed under MIT or CERN OHL v2.
