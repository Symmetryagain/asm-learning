CC = gcc
SRC_DIR = src
OBJ_DIR = build
HEAD_DIR = include
BASE_CFLAGS = -Wall -Wextra -I $(HEAD_DIR)

O2_FILES = main.c matrix_utils.c v0_py_numpy_mul.c v1_py_simple_mul.c v2_c_simple_mul.c v3_c_parallel_mul.c v4_c_cache_mul.c
MARCH_FILES = v4_c_cache_mul.c v5_c_SIMD_mul.c v6_c_multi_optimized_mul.c
O3_FILES = v5_c_SIMD_mul.c v6_c_multi_optimized_mul.c
AVX512_FILES = v6_c_multi_optimized_mul.c

SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TARGET = Project.out

all: $(TARGET)

$(TARGET): $(OBJ_FILES)
	@echo "Linking target: $^..."
	$(CC) $^ -o $@ -lm

$(foreach file,$(O2_FILES),\
	$(eval $(OBJ_DIR)/$(file:.c=.o): EXTRA_CFLAGS += -O2))

$(foreach file,$(MARCH_FILES),\
	$(eval $(OBJ_DIR)/$(file:.c=.o): EXTRA_CFLAGS += -march=native))

$(foreach file,$(O3_FILES),\
	$(eval $(OBJ_DIR)/$(file:.c=.o): EXTRA_CFLAGS += -O3 -mfma))

$(foreach file,$(AVX512_FILES),\
	$(eval $(OBJ_DIR)/$(file:.c=.o): EXTRA_CFLAGS += -mavx512f -mavx512dq))

$(OBJ_DIR)/%.o: EXTRA_CFLAGS =
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) -c $< -o $@ $(BASE_CFLAGS) $(EXTRA_CFLAGS)

clean:
	rm -rf $(OBJ_DIR) $(TARGET)

rebuild: clean all

.PHONY: all clean rebuild
