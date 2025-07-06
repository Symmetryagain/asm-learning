#include "matrix.h"
#include <bits/pthreadtypes.h>
#include <pthread.h>
#include <stdatomic.h>

extern int block_size;
void *blockedThreadWorker(void *arg) {
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
        for (int i = i_b; i < i_e; ++i)
          for (int k = k_b; k < k_e; ++k) {
            double val = A->data[i * A->cols + k];
            for (int j = j_b; j < j_e; ++j)
              C->data[i * A->cols + j] += val * B->data[k * B->cols + j];
          }
      }
    }
  }
  pthread_exit(NULL);
}

void c_cache_mul(Matrix *A, Matrix *B, Matrix *C) {
  pthread_t threads[NUM_THREADS];
  ThreadArg Args[NUM_THREADS];
  atomic_int next_row;
  atomic_init(&next_row, 0);

  for (int i = 0; i < NUM_THREADS; ++i) { // create threads
    Args[i].threadId = i;
    Args[i].A = A, Args[i].B = B, Args[i].C = C;
    Args[i].next_row = &next_row;
    pthread_create(&threads[i], NULL, blockedThreadWorker, &Args[i]);
  }

  for (int i = 0; i < NUM_THREADS; ++i)
    pthread_join(threads[i], NULL);
}
