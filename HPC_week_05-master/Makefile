BUILD_DIR = ./build

$(shell mkdir -p $(BUILD_DIR))

KERNELS = ./kernels/gemm_asm_asimd_16_6_1.s
OBJ_FILES = $(patsubst kernels/%.s, $(BUILD_DIR)/%.o, $(KERNELS))

driver: $(OBJ_FILES) driver.cpp
	aarch64-linux-android33-clang++ -g -pedantic -Wall -Wextra -Werror -O3 -fopenmp $^ -o $(BUILD_DIR)/gemm_asm_asimd_16_6_1