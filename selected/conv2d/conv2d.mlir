#map0 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map1 = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func @conv2d_f32(%arg0: memref<1x49x42x27xf32>, %arg1: memref<28x3x3x27xf32>, %arg2: memref<28xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() {alignment = 128 : i64} : memref<3x3x27x28xf32>
    affine.for %arg3 = 0 to 3 {
      affine.for %arg4 = 0 to 3 {
        affine.for %arg5 = 0 to 27 {
          affine.for %arg6 = 0 to 28 {
            %3 = affine.load %arg1[%arg6, %arg3, %arg4, %arg5] : memref<28x3x3x27xf32>
            affine.store %3, %0[%arg3, %arg4, %arg5, %arg6] : memref<3x3x27x28xf32>
          }
        }
      }
    }
    %1 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    %2 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 45 {
        affine.for %arg5 = 0 to 40 {
          affine.for %arg6 = 0 to 28 {
            affine.store %cst, %1[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
          }
        }
      }
    }
    memref.copy %1, %2 : memref<1x45x40x28xf32> to memref<1x45x40x28xf32>
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 45 {
        affine.for %arg5 = 0 to 40 {
          affine.for %arg6 = 0 to 28 {
            affine.for %arg7 = 0 to 3 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 27 {
                  %3 = affine.apply #map0(%arg4, %arg7)
                  %4 = affine.apply #map1(%arg5, %arg8)
                  %5 = affine.load %arg0[%arg3, %3, %4, %arg9] : memref<1x49x42x27xf32>
                  %6 = affine.load %0[%arg7, %arg8, %arg9, %arg6] : memref<3x3x27x28xf32>
                  %7 = affine.load %2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
                  %8 = arith.mulf %5, %6 : f32
                  %9 = arith.addf %7, %8 : f32
                  affine.store %9, %2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
}

