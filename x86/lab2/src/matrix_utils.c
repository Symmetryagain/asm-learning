#include "matrix.h"

int block_size;

double get_time() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (double)tv.tv_sec * 1000 + (double)tv.tv_usec / 1000;
}

Matrix createMatrix(int row, int col) {
  Matrix mat;
  mat.rows = row, mat.cols = col;
  mat.data = (double *)malloc(row * col * sizeof(double));
  return mat;
}

void initMatrix(Matrix *mat) {
  for (int i = 0; i < mat->rows; ++i)
    for (int j = 0; j < mat->cols; ++j)
      mat->data[i * mat->cols + j] = (double)rand() / RAND_MAX;
}

void freeMatrix(Matrix *mat) {
  free(mat->data);
}

void printMatrix(Matrix *A) {
  for (int i = 0; i < A->rows; ++i) {
    for (int j = 0; j < A->cols; ++j)
      printf("%.4lf ", A->data[i * A->cols + j]);
    puts("");
  }
}

void write_matrix(FILE *f, Matrix *mat) {
  for (int i = 0; i < mat->rows; i++) {
    for (int j = 0; j < mat->cols; j++) {
      fprintf(f, "%.7lf ", mat->data[i * mat->cols + j]);
    }
    fprintf(f, "\n");
  }
}

void read_matrix(FILE *f, Matrix *mat) {
    for (int i = 0; i < mat->rows; i++) {
        for (int j = 0; j < mat->cols; j++) {
            fscanf(f, "%lf", &mat->data[i * mat->cols + j]);
        }
    }
}

int verifyMatrix(Matrix *A, Matrix *B) {
  if (A->rows != B->rows || A->cols != B->cols) {
    printf("Verification FAIL: A(%d rows, %d cols), B(%d rows, %d cols)", A->rows, A->cols, B->rows, B->cols);
    return 0;
  }
  for (int i = 0; i < A->rows; ++i)
    for (int j = 0; j < A->cols; ++j)
      if (fabs(A->data[i * A->cols + j] - B->data[i * B->cols + j]) > 1e-5) {
        printf("Verification FAIL at [%d][%d], A: %.5lf, B: %.5lf\n", i, j, A->data[i * A->cols + j], B->data[i * B->cols + j]);
        return 0;
      }
  puts("Verification PASS!");
  return 1;
}
