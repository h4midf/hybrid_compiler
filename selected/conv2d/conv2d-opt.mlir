#map0 = affine_map<() -> (3)>
#map1 = affine_map<() -> (27)>
#map2 = affine_map<(d0)[s0] -> (d0 * s0)>
#map3 = affine_map<() -> (28)>
#map4 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map5 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
#map6 = affine_map<() -> (45)>
#map7 = affine_map<() -> (40)>
#map8 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map9 = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func @conv2d_f32(%arg0: memref<1x49x42x27xf32>, %arg1: memref<28x3x3x27xf32>, %arg2: memref<28xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() {alignment = 128 : i64} : memref<3x3x27x28xf32>
    affine.parallel (%arg3) = (0) to (3) {
      %3 = affine.apply #map0()
      %4 = affine.apply #map1()
      %5 = affine.apply #map2(%3)[%4]
      %6 = affine.apply #map3()
      %7 = affine.apply #map2(%5)[%6]
      affine.for %arg4 = 0 to %7 {
        %8 = affine.apply #map4(%arg4)[%6]
        %9 = affine.apply #map5(%arg4)[%6]
        %10 = affine.apply #map4(%9)[%4]
        %11 = affine.apply #map5(%9)[%4]
        %12 = affine.load %arg1[%8, %arg3, %11, %10] : memref<28x3x3x27xf32>
        affine.store %12, %0[%arg3, %11, %10, %8] : memref<3x3x27x28xf32>
      }
    }
    
    return
  }
}

