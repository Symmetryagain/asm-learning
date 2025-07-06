#include "matrix.h"
#include <immintrin.h>

extern int block_size;
void *simdThreadWorker(void *arg) {
  ThreadArg *targ = (ThreadArg *)arg;
  Matrix *A = targ->A;
  Matrix *B = targ->B;
  Matrix *C = targ->C;
  atomic_int *next_row = targ->next_row;
  
  int i_b;
  while ((i_b = atomic_fetch_add(next_row, block_size)) < A->rows) {
    int i_e = min(i_b + block_size, A->rows);
    for (int j_b = 0; j_b < B->cols; j_b += block_size) {
      int j_e = min(j_b + block_size, B->cols);
      for (int k_b = 0; k_b < A->cols; k_b += block_size) {
        int k_e = min(k_b + block_size, A->cols);
        for (int i = i_b; i < i_e; ++i) {
          const double *restrict rowA = A->data + i * A->cols;
          double *restrict rowC = C->data + i * C->cols;
          for (int k = k_b; k < k_e; ++k) {
            const double val = rowA[k];
            const double *restrict rowB = B->data + k * B->cols;
            int j = j_b;
            __m256d val_vec = _mm256_set1_pd(rowA[k]);
            for (; j <= j_e - 4; j += 4) {
              __m256d b_vec = _mm256_loadu_pd(rowB + j);
              __m256d c_vec = _mm256_loadu_pd(rowC + j);
              c_vec = _mm256_fmadd_pd(val_vec, b_vec, c_vec);
              _mm256_storeu_pd(rowC + j, c_vec);
            }
            for (; j < j_e; ++j)
              rowC[j] += val * rowB[j];
          }
        }
      }
    }
  }
  pthread_exit(NULL);
}

void c_SIMD_mul(Matrix *A, Matrix *B, Matrix *C) {
  pthread_t threads[NUM_THREADS];
  ThreadArg Args[NUM_THREADS];
  atomic_int next_row;
  atomic_init(&next_row, 0);

  for (int i = 0; i < NUM_THREADS; ++i) { // create threads
    Args[i].threadId = i;
    Args[i].A = A, Args[i].B = B, Args[i].C = C;
    Args[i].next_row = &next_row;
    pthread_create(&threads[i], NULL, simdThreadWorker, &Args[i]);
  }

  for (int i = 0; i < NUM_THREADS; ++i)
    pthread_join(threads[i], NULL);
}
