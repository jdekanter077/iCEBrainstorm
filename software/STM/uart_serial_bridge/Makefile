compile:
	cmake --build build

init:
	cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-none-eabi.cmake

upload:
	STM32_Programmer_CLI -c port=USB1 -w build/morse_uart_stm.elf
