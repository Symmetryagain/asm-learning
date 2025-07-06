#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

void py_numpy_mul(Matrix *A, Matrix *B, Matrix *C) {
  char input_path[] = "py/files/in.txt";
  char output_path[] = "py/files/out.txt";

  FILE *input_file = fopen(input_path, "w");
  if (!input_file) {
    perror("fopen error");
    exit(EXIT_FAILURE);
  }

  fprintf(input_file, "%d %d %d\n", A->rows, A->cols, B->cols);
  write_matrix(input_file, A);
  write_matrix(input_file, B);
  fclose(input_file);
  
  char py_command[] = "python3 py/np_matrix_mul.py";
  if (system(py_command)) {
    printf("error executing py script\n");
    return;
  }

  FILE *output_file = fopen(output_path, "r");
  if (!input_file) {
    perror("fopen error");
    exit(EXIT_FAILURE);
  }

  read_matrix(output_file, C);
  fclose(output_file);
}
