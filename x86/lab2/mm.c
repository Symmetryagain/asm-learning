#include "mm.h"
// #include <bits/pthreadtypes.h>
// #include <bits/types/struct_timeval.h>
#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

#define M 4096
#define N 4096
#define P 4096
#define NUM_THREADS 8 // number of threads
#define min(a, b) ((a) < (b) ? (a) : (b))
/*
 *  A (M*N) B (N*P)
 *  calculate A times B
 */

Matrix createMatrix(int row, int col) {
  Matrix mat;
  mat.rows = row, mat.cols = col;
  mat.data = (double **)malloc(row * sizeof(double *));
  double *block = (double *)malloc(row * col * sizeof(double));
  for (int i = 0; i < row; ++i) {
    mat.data[i] = &block[i * col];
  }
  return mat;
}

void freeMatrix(Matrix mat) {
  free(mat.data[0]);
  free(mat.data);
}

void initMatrix(Matrix mat) {
  for (int i = 0; i < mat.rows; ++i)
    for (int j = 0; j < mat.cols; ++j)
      mat.data[i][j] = (double)rand() / RAND_MAX;
}

void matrixMulSingle(Matrix A, Matrix B, Matrix C) {
  for (int i = 0; i < A.rows; ++i)
    for (int k = 0; k < A.cols; ++k) {
      double tmp = A.data[i][k];
      for (int j = 0; j < B.cols; ++j)
        C.data[i][j] += tmp * B.data[k][j];
    }
}

void *threadWorker(void *Arg) {
  ThreadArg *Targ = (ThreadArg *)Arg;
  int st_row = M / NUM_THREADS * Targ->threadId;
  int ed_row = Targ->threadId == NUM_THREADS - 1 ? M : st_row + M / NUM_THREADS;
  //  printf("%d %d %d\n", Targ->threadId, st_row, ed_row);
  for (int i = st_row; i < ed_row; ++i)
    for (int k = 0; k < Targ->A->cols; ++k) {
      double tmp = Targ->A->data[i][k];
      for (int j = 0; j < Targ->B->cols; ++j)
        Targ->C->data[i][j] += tmp * Targ->B->data[k][j];
    }

  pthread_exit(NULL);
}

void matrixMulParallel(Matrix A, Matrix B, Matrix C) {
  pthread_t threads[NUM_THREADS];
  ThreadArg Args[NUM_THREADS];

  for (int i = 0; i < NUM_THREADS; ++i) { // create threads
    Args[i].threadId = i;
    Args[i].A = &A, Args[i].B = &B, Args[i].C = &C;
    pthread_create(&threads[i], NULL, threadWorker, &Args[i]);
  }

  for (int i = 0; i < NUM_THREADS; ++i)
    pthread_join(threads[i], NULL);
}

double get_time() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (double)tv.tv_sec * 1000 + (double)tv.tv_usec / 1000;
}

void printMatrix(Matrix A) {
  for (int i = 0; i < A.rows; ++i) {
    for (int j = 0; j < A.cols; ++j)
      printf("%.5lf ", A.data[i][j]);
    puts("");
  }
}

int main() {
  Matrix A, B, C_single, C_parallel;
  A = createMatrix(M, N);
  B = createMatrix(N, P);
  C_single = createMatrix(M, P);
  C_parallel = createMatrix(M, P);

  // initialize
  srand(time(0));
  initMatrix(A), initMatrix(B);

  double st_single = get_time();
  matrixMulSingle(A, B, C_single);
  double ed_single = get_time();

  double st_parallel = get_time();
  matrixMulParallel(A, B, C_parallel);
  double ed_parallel = get_time();

  for (int i = 0; i < M; ++i)
    for (int j = 0; j < P; ++j)
      if (fabs(C_single.data[i][j] - C_parallel.data[i][j]) > 1e-6) {
        printf("Verification FAIL at [%d][%d]", i, j);
        exit(1);
      }

  puts("Verification PASS!");

  /*
    puts("A:");
    printMatrix(A);
    puts("B:");
    printMatrix(B);
    puts("C_single:");
    printMatrix(C_single);
    puts("C_parallel:");
    printMatrix(C_parallel);
  */
  freeMatrix(A);
  freeMatrix(B);
  freeMatrix(C_single);
  freeMatrix(C_parallel);

  return 0;
}
