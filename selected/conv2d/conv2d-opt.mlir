#map0 = affine_map<() -> (3)>
#map1 = affine_map<(d0)[s0] -> (d0 * s0)>
#map2 = affine_map<() -> (27)>
#map3 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map4 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
#map5 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map6 = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func @conv2d_f32(%arg0: memref<1x49x42x27xf32>, %arg1: memref<28x3x3x27xf32>, %arg2: memref<28xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() {alignment = 128 : i64} : memref<3x3x27x28xf32>
    affine.parallel (%arg3) = (0) to (3) {
      affine.parallel (%arg4) = (0) to (3) {
        affine.parallel (%arg5) = (0) to (27) {
          affine.parallel (%arg6) = (0) to (28) {
            %3 = affine.load %arg1[%arg6, %arg3, %arg4, %arg5] : memref<28x3x3x27xf32>
            affine.store %3, %0[%arg3, %arg4, %arg5, %arg6] : memref<3x3x27x28xf32>
          }
        }
      }
    }
    %1 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    %2 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    affine.parallel (%arg3) = (0) to (1) {
      affine.parallel (%arg4) = (0) to (45) {
        affine.parallel (%arg5) = (0) to (40) {
          affine.parallel (%arg6) = (0) to (28) {
            affine.store %cst, %1[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
          }
        }
      }
    }
    memref.copy %1, %2 : memref<1x45x40x28xf32> to memref<1x45x40x28xf32>
    affine.parallel (%arg3) = (0) to (1) {
      affine.parallel (%arg4) = (0) to (45) {
        affine.parallel (%arg5) = (0) to (40) {
          affine.parallel (%arg6) = (0) to (28) {
            %3 = affine.apply #map0()
            %4 = affine.apply #map0()
            %5 = affine.apply #map1(%3)[%4]
            %6 = affine.apply #map2()
            %7 = affine.apply #map1(%5)[%6]
            affine.for %arg7 = 0 to %7 {
              %8 = affine.apply #map3(%arg7)[%6]
              %9 = affine.apply #map4(%arg7)[%6]
              %10 = affine.apply #map3(%9)[%4]
              %11 = affine.apply #map4(%9)[%4]
              %12 = affine.apply #map5(%arg4, %11)
              %13 = affine.apply #map6(%arg5, %10)
              %14 = affine.load %arg0[%arg3, %12, %13, %8] : memref<1x49x42x27xf32>
              %15 = affine.load %0[%11, %10, %8, %arg6] : memref<3x3x27x28xf32>
              %16 = affine.load %2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
              %17 = arith.mulf %14, %15 : f32
              %18 = arith.addf %16, %17 : f32
              affine.store %18, %2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xf32>
            }
          }
        }
      }
    }
    return
  }
}

