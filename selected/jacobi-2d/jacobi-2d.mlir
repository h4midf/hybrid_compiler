#map = affine_map<()[s0] -> (s0 - 1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_jacobi_2d(%arg0: i32, %arg1: i32, %arg2: memref<?x1300xf64>, %arg3: memref<?x1300xf64>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.000000e-01 : f64
    %0 = arith.index_cast %arg1 : i32 to index
    %1 = arith.index_cast %arg0 : i32 to index
    affine.for %arg4 = 0 to %1 {
      affine.for %arg5 = 1 to #map()[%0] {
        affine.for %arg6 = 1 to #map()[%0] {
          %2 = affine.load %arg2[%arg5, %arg6] : memref<?x1300xf64>
          %3 = affine.load %arg2[%arg5, %arg6 - 1] : memref<?x1300xf64>
          %4 = arith.addf %2, %3 : f64
          %5 = affine.load %arg2[%arg5, %arg6 + 1] : memref<?x1300xf64>
          %6 = arith.addf %4, %5 : f64
          %7 = affine.load %arg2[%arg5 + 1, %arg6] : memref<?x1300xf64>
          %8 = arith.addf %6, %7 : f64
          %9 = affine.load %arg2[%arg5 - 1, %arg6] : memref<?x1300xf64>
          %10 = arith.addf %8, %9 : f64
          %11 = arith.mulf %10, %cst : f64
          affine.store %11, %arg3[%arg5, %arg6] : memref<?x1300xf64>
        }
      }
      affine.for %arg5 = 1 to #map()[%0] {
        affine.for %arg6 = 1 to #map()[%0] {
          %2 = affine.load %arg3[%arg5, %arg6] : memref<?x1300xf64>
          %3 = affine.load %arg3[%arg5, %arg6 - 1] : memref<?x1300xf64>
          %4 = arith.addf %2, %3 : f64
          %5 = affine.load %arg3[%arg5, %arg6 + 1] : memref<?x1300xf64>
          %6 = arith.addf %4, %5 : f64
          %7 = affine.load %arg3[%arg5 + 1, %arg6] : memref<?x1300xf64>
          %8 = arith.addf %6, %7 : f64
          %9 = affine.load %arg3[%arg5 - 1, %arg6] : memref<?x1300xf64>
          %10 = arith.addf %8, %9 : f64
          %11 = arith.mulf %10, %cst : f64
          affine.store %11, %arg2[%arg5, %arg6] : memref<?x1300xf64>
        }
      }
    }
    return
  }
}
