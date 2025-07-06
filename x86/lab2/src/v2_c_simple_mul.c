#include "matrix.h"

void c_simple_mul(Matrix *A, Matrix *B, Matrix *C) {
  for (int i = 0; i < A->rows; ++i)
    for (int k = 0; k < A->cols; ++k) {
      double tmp = A->data[i * A->cols + k];
      for (int j = 0; j < B->cols; ++j)
        C->data[i * C->cols + j] += tmp * B->data[k * B->cols + j];
    }
}

