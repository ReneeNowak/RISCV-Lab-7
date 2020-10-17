#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

// terms = N / stride + N % stride;
// for (int i = 0; i < N; i + stride) {
//   sum = sum + v0[i] * v1[i];
// }

// Stride = 1 terms = 9 / 1 = 9 sum = v0[0] * v1[0] + v0[1] * v1[1] +
//                                    v0[2] * v1[2]....v0[8] *
//                                        v0[8]

//                                        Stride = 2,
//            terms = 9 / 2 + 1 = 5 sum = v0[0] + v1[0] + v0[2] * v1[2] +
//                                        v0[4] * v1[4] + v0[6] * v1[6] +
//                                        v0[8] * v1[8]

//                                            Stride = 3,
//            terms = 9 / 3 = 3 sum =
//                        v0[0] * v1[0] + v0[3] * v1[3] + v0[6] * v1[6] %

// C only permits one return value while in an assembly you can return
// multiple values through registers. This pointer contortion (array and
// size) is to mimic the use of multiple registers to return values in a
// RISC V assembly
int32_t *array, *size;

void read_vector(char *filename) {
  FILE *fp;
  fp = fopen(filename, "rb");
  size = (int32_t *)malloc(sizeof(int));
  fread(size, sizeof(int), 1, fp);
  array = (int32_t *)malloc((*size) * sizeof(int));
  fread(array, sizeof(int32_t), *size, fp);
  printf("%s\n", filename);
  for (int i = 0; i < *size; i++) {
    printf("%d,", array[i]);
  }
  printf("\n");
  return;
}

int main(int argc, char **argv) {
  if (argc < 3) {
    printf("main.s <M0_PATH> <M1_PATH>");
    exit(1);
  }
  int *m0_array, *m0_size, *m1_array, *m1_size;
  int m0_stride = 1, m1_stride = 1;

  read_vector(argv[1]);
  m0_array = array;
  m0_size = size;

  read_vector(argv[2]);
  m1_array = array;
  m1_size = size;

  assert(*m0_size == *m1_size);

  int terms = *m0_size / m0_stride + *m0_size % m0_stride;
  // Stride =
  int sum = 0;
  for (size_t i = 0; i < terms; i++) {
    sum += m0_array[i] * m1_array[i];
    /* code */
  }
  printf("Sum %d", sum);
}

//