// RUN: mlir-clang %s %stdinclude -S | FileCheck %s
// RUN: clang %s -O3 %stdinclude %polyverify -o %s.exec1 && %s.exec1 &> %s.out1
// RUN: mlir-clang %s %polyverify %stdinclude -O3 -o %s.execm && %s.execm &> %s.out2
// RUN: rm -f %s.exec1 %s.execm
// RUN: diff %s.out1 %s.out2
// RUN: rm -f %s.out1 %s.out2
// RUN: mlir-clang %s %polyexec %stdinclude -O3 -o %s.execm && %s.execm > %s.mlir.time; cat %s.mlir.time | FileCheck %s --check-prefix EXEC
// RUN: clang %s -O3 %polyexec %stdinclude -o %s.exec2 && %s.exec2 > %s.clang.time; cat %s.clang.time | FileCheck %s --check-prefix EXEC
// RUN: rm -f %s.exec2 %s.execm
// RUN: mlir-clang -raise-scf-to-affine %s %stdinclude -S | FileCheck %s

// RUN: clang %s -O3 %stdinclude %polyverify -o %s.exec1 && %s.exec1 &> %s.out1
// RUN: mlir-clang %s %polyverify %stdinclude -detect-reduction -O3 -o %s.execm && %s.execm &> %s.out2
// RUN: rm -f %s.exec1 %s.execm
// RUN: diff %s.out1 %s.out2
// RUN: rm -f %s.out1 %s.out2

/**
 * This version is stamped on May 10, 2016
 *
 * Contact:
 *   Louis-Noel Pouchet <pouchet.ohio-state.edu>
 *   Tomofumi Yuki <tomofumi.yuki.fr>
 *
 * Web address: http://polybench.sourceforge.net
 */
/* 2mm.c: this file is part of PolyBench/C */







#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <assert.h>
#include <stdint.h>

static int32_t *A;
static int32_t *B;
static int32_t *C;
static int32_t *C2; 

#define A_SIZE 1000
#define B_SIZE 1000
#define C_SIZE 1000


/**
* @brief compute output in the host
*/
void vecadd(int A[A_SIZE], int B[B_SIZE], int C[C_SIZE]) {
    #pragma scop    
    for (int i = 0; i < A_SIZE; i++) {
        C[i] = A[i] + B[i];
    }
    #pragma endscop
}

/**
* @brief Main of the Host Application.
*/
int main(int argc, char **argv) {
    int *A;
    int *B;
    int *C;

    vecadd(A,B,C);

    return 0;
 }
