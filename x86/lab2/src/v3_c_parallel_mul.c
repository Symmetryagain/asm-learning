#include "matrix.h"

void *threadWorker(void *Arg) {
  ThreadArg *Targ = (ThreadArg *)Arg;
  int st_row = M / NUM_THREADS * Targ->threadId;
  int ed_row = Targ->threadId == NUM_THREADS - 1 ? M : st_row + M / NUM_THREADS;
  Matrix *A = Targ->A;
  Matrix *B = Targ->B;
  Matrix *C = Targ->C;
  //  printf("%d %d %d\n", Targ->threadId, st_row, ed_row);
  for (int i = st_row; i < ed_row; ++i)
    for (int k = 0; k < A->cols; ++k) {
      double tmp = A->data[i * A->cols + k];
      for (int j = 0; j < B->cols; ++j)
        C->data[i * C->cols + j] += tmp * B->data[k * B->cols + j];
    }

  pthread_exit(NULL);
}

void c_parallel_mul(Matrix *A, Matrix *B, Matrix *C) {
  pthread_t threads[NUM_THREADS];
  ThreadArg Args[NUM_THREADS];

  for (int i = 0; i < NUM_THREADS; ++i) { // create threads
    Args[i].threadId = i;
    Args[i].A = A, Args[i].B = B, Args[i].C = C;
    pthread_create(&threads[i], NULL, threadWorker, &Args[i]);
  }

  for (int i = 0; i < NUM_THREADS; ++i)
    pthread_join(threads[i], NULL);
}


