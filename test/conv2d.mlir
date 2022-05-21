#map0 = affine_map<() -> (27)>
#map1 = affine_map<() -> (28)>
#map2 = affine_map<(d0)[s0] -> (d0 * s0)>
#map3 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map4 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
#map5 = affine_map<() -> (40)>
#map6 = affine_map<() -> (3)>
#map7 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map8 = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func @conv2d_f32(%arg0: memref<1x49x42x27xf32>, %arg1: memref<28x3x3x27xf32>, %arg2: memref<28xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() {alignment = 128 : i64} : memref<3x3x27x28xf32>
    affine.parallel (%arg3) = (0) to (3) {
      affine.parallel (%arg4) = (0) to (3) {
        %3 = affine.apply #map0()
        %4 = affine.apply #map1()
        %5 = affine.apply #map2(%3)[%4]
        affine.for %arg5 = 0 to %5 {
          %6 = affine.apply #map3(%arg5)[%4]
          %7 = affine.apply #map4(%arg5)[%4]
          %8 = affine.load %arg1[%6, %arg3, %arg4, %7] : memref<28x3x3x27xf32>
          affine.store %8, %0[%arg3, %arg4, %7, %6] : memref<3x3x27x28xf32>
        }
      }
    }
    %1 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    %2 = memref.alloc() {alignment = 128 : i64} : memref<1x45x40x28xf32>
    affine.parallel (%arg3) = (0) to (1) {
      affine.parallel (%arg4) = (0) to (45) {
        %3 = affine.apply #map5()
        %4 = affine.apply #map1()
        %5 = affine.apply #map2(%3)[%4]
        affine.for %arg5 = 0 to %5 {
          %6 = affine.apply #map3(%arg5)[%4]
          %7 = affine.apply #map4(%arg5)[%4]
          affine.store %cst, %1[%arg3, %arg4, %7, %6] : memref<1x45x40x28xf32>
        }
      }
    }
    memref.copy %1, %2 : memref<1x45x40x28xf32> to memref<1x45x40x28xf32>
    affine.parallel (%arg3) = (0) to (1) {
      affine.parallel (%arg4) = (0) to (45) {
        %3 = affine.apply #map5()
        %4 = affine.apply #map1()
        %5 = affine.apply #map2(%3)[%4]
        %6 = affine.apply #map6()
        %7 = affine.apply #map2(%5)[%6]
        %8 = affine.apply #map6()
        %9 = affine.apply #map2(%7)[%8]
        %10 = affine.apply #map0()
        %11 = affine.apply #map2(%9)[%10]
        affine.for %arg5 = 0 to %11 {
          %12 = affine.apply #map3(%arg5)[%10]
          %13 = affine.apply #map4(%arg5)[%10]
          %14 = affine.apply #map3(%13)[%8]
          %15 = affine.apply #map4(%13)[%8]
          %16 = affine.apply #map3(%15)[%6]
          %17 = affine.apply #map4(%15)[%6]
          %18 = affine.apply #map3(%17)[%4]
          %19 = affine.apply #map4(%17)[%4]
          %20 = affine.apply #map7(%arg4, %16)
          %21 = affine.apply #map8(%19, %14)
          %22 = affine.load %arg0[%arg3, %20, %21, %12] : memref<1x49x42x27xf32>
          %23 = affine.load %0[%16, %14, %12, %18] : memref<3x3x27x28xf32>
          %24 = affine.load %2[%arg3, %arg4, %19, %18] : memref<1x45x40x28xf32>
          %25 = arith.mulf %22, %23 : f32
          %26 = arith.addf %24, %25 : f32
          affine.store %26, %2[%arg3, %arg4, %19, %18] : memref<1x45x40x28xf32>
        }
      }
    }
    return
  }
}
