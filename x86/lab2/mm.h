#ifndef MM_H
#define MM_H

typedef struct {
  double **data;
  int rows, cols;
} Matrix;

typedef struct {
  int threadId;
  Matrix *A, *B, *C;
} ThreadArg;

Matrix createMatrix(int row, int col);

void printMatrix(Matrix A);

void freeMatrix(Matrix mat);

void initMatrix(Matrix mat);

void matrixMulSingle(Matrix A, Matrix B, Matrix C);

void *threadWorker(void *arg);

void matrixMulParallel(Matrix A, Matrix B, Matrix C);

double get_time();

#endif
