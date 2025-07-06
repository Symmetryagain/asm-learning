#ifndef _MATRIX_H
#define _MATRIX_H

#include <math.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>


#define M 4096
#define N 4096
#define P 4096
#define NUM_THREADS 8 // number of threads
#define min(a, b) ((a) < (b) ? (a) : (b))

double get_time();

typedef struct {
  double *data;
  int rows, cols;
} Matrix;

Matrix createMatrix(int row, int col);

void initMatrix(Matrix *mat);

void freeMatrix(Matrix *mat);

void printMatrix(Matrix *A);

void write_matrix(FILE *f, Matrix *mat);

void read_matrix(FILE *f, Matrix *mat);

int verifyMatrix(Matrix *A, Matrix *B);

void py_numpy_mul(Matrix *A, Matrix *B, Matrix *C);

void py_simple_mul(Matrix *A, Matrix *B, Matrix *C);

void c_simple_mul(Matrix *A, Matrix *B, Matrix *C);

void c_parallel_mul(Matrix *A, Matrix *B, Matrix *C);

void c_cache_mul(Matrix *A, Matrix *B, Matrix *C);

void c_SIMD_mul(Matrix *A, Matrix *B, Matrix *C);

void c_multi_optimized_mul(Matrix *A, Matrix *B, Matrix *C);

typedef struct {
  Matrix *A, *B, *C;
  atomic_int *next_row;
  int threadId;
} ThreadArg;

#endif
