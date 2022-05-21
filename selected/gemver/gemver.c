// TODO: mlir-clang %s %stdinclude | FileCheck %s
// RUN: clang %s -O3 %stdinclude %polyverify -o %s.exec1 && %s.exec1 &> %s.out1
// RUN: mlir-clang %s %polyverify %stdinclude -O3 -o %s.execm && %s.execm &> %s.out2
// RUN: rm -f %s.exec1 %s.execm
// RUN: diff %s.out1 %s.out2
// RUN: rm -f %s.out1 %s.out2
// RUN: mlir-clang %s %polyexec %stdinclude -O3 -o %s.execm && %s.execm > %s.mlir.time; cat %s.mlir.time | FileCheck %s --check-prefix EXEC
// RUN: clang %s -O3 %polyexec %stdinclude -o %s.exec2 && %s.exec2 > %s.clang.time; cat %s.clang.time | FileCheck %s --check-prefix EXEC
// RUN: rm -f %s.exec2 %s.execm

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
/* gemver.c: this file is part of PolyBench/C */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "gemver.h"



void kernel_gemver(int n,
		   DATA_TYPE alpha,
		   DATA_TYPE beta,
		   DATA_TYPE POLYBENCH_2D(A,N,N,n,n),
		   DATA_TYPE POLYBENCH_1D(u1,N,n),
		   DATA_TYPE POLYBENCH_1D(v1,N,n),
		   DATA_TYPE POLYBENCH_1D(u2,N,n),
		   DATA_TYPE POLYBENCH_1D(v2,N,n),
		   DATA_TYPE POLYBENCH_1D(w,N,n),
		   DATA_TYPE POLYBENCH_1D(x,N,n),
		   DATA_TYPE POLYBENCH_1D(y,N,n),
		   DATA_TYPE POLYBENCH_1D(z,N,n))
{
  int i, j;

#pragma scop

  for (i = 0; i < _PB_N; i++)
    for (j = 0; j < _PB_N; j++)
      A[i][j] = A[i][j] + u1[i] * v1[j] + u2[i] * v2[j];

  for (i = 0; i < _PB_N; i++)
    for (j = 0; j < _PB_N; j++)
      x[i] = x[i] + beta * A[j][i] * y[j];

  for (i = 0; i < _PB_N; i++)
    x[i] = x[i] + z[i];

  for (i = 0; i < _PB_N; i++)
    for (j = 0; j < _PB_N; j++)
      w[i] = w[i] +  alpha * A[i][j] * x[j];

#pragma endscop
}


// CHECK:   func @kernel_gemver(%arg0: i32, %arg1: f64, %arg2: f64, %arg3: memref<2000x2000xf64>, %arg4: memref<2000xf64>, %arg5: memref<2000xf64>, %arg6: memref<2000xf64>, %arg7: memref<2000xf64>, %arg8: memref<2000xf64>, %arg9: memref<2000xf64>, %arg10: memref<2000xf64>, %arg11: memref<2000xf64>) {
// CHECK-NEXT:  %0 = index_cast %arg0 : i32 to index
// CHECK-NEXT:  affine.for %arg12 = 0 to %0 {
// CHECK-NEXT:    %1 = affine.load %arg4[%arg12] : memref<2000xf64>
// CHECK-NEXT:    %2 = affine.load %arg6[%arg12] : memref<2000xf64>
// CHECK-NEXT:    affine.for %arg13 = 0 to %0 {
// CHECK-NEXT:      %3 = affine.load %arg3[%arg12, %arg13] : memref<2000x2000xf64>
// CHECK-NEXT:      %4 = affine.load %arg5[%arg13] : memref<2000xf64>
// CHECK-NEXT:      %5 = mulf %1, %4 : f64
// CHECK-NEXT:      %6 = addf %3, %5 : f64
// CHECK-NEXT:      %7 = affine.load %arg7[%arg13] : memref<2000xf64>
// CHECK-NEXT:      %8 = mulf %2, %7 : f64
// CHECK-NEXT:      %9 = addf %6, %8 : f64
// CHECK-NEXT:      affine.store %9, %arg3[%arg12, %arg13] : memref<2000x2000xf64>
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NEXT:  affine.for %arg12 = 0 to %0 {
// CHECK-NEXT:    %1 = affine.load %arg9[%arg12] : memref<2000xf64>
// CHECK-NEXT:    affine.for %arg13 = 0 to %0 {
// CHECK-NEXT:      %2 = affine.load %arg3[%arg13, %arg12] : memref<2000x2000xf64>
// CHECK-NEXT:      %3 = mulf %arg2, %2 : f64
// CHECK-NEXT:      %4 = affine.load %arg10[%arg13] : memref<2000xf64>
// CHECK-NEXT:      %5 = mulf %3, %4 : f64
// CHECK-NEXT:      %6 = addf %1, %5 : f64
// CHECK-NEXT:      affine.store %6, %arg9[%arg12] : memref<2000xf64>
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NEXT:  affine.for %arg12 = 0 to %0 {
// CHECK-NEXT:    %1 = affine.load %arg9[%arg12] : memref<2000xf64>
// CHECK-NEXT:    %2 = affine.load %arg11[%arg12] : memref<2000xf64>
// CHECK-NEXT:    %3 = addf %1, %2 : f64
// CHECK-NEXT:    affine.store %3, %arg9[%arg12] : memref<2000xf64>
// CHECK-NEXT:  }
// CHECK-NEXT:  affine.for %arg12 = 0 to %0 {
// CHECK-NEXT:    %1 = affine.load %arg8[%arg12] : memref<2000xf64>
// CHECK-NEXT:    affine.for %arg13 = 0 to %0 {
// CHECK-NEXT:      %2 = affine.load %arg3[%arg12, %arg13] : memref<2000x2000xf64>
// CHECK-NEXT:      %3 = mulf %arg1, %2 : f64
// CHECK-NEXT:      %4 = affine.load %arg9[%arg13] : memref<2000xf64>
// CHECK-NEXT:      %5 = mulf %3, %4 : f64
// CHECK-NEXT:      %6 = addf %1, %5 : f64
// CHECK-NEXT:      affine.store %6, %arg8[%arg12] : memref<2000xf64>
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NEXT:  return
// CHECK-NEXT: }

// EXEC: {{[0-9]\.[0-9]+}}
