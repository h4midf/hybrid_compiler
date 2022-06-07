#map0 = affine_map<()[s0] -> (s0)>
#map1 = affine_map<(d0)[s0] -> (d0 * s0)>
#map2 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map3 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_gemm(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: f64, %arg4: f64, %arg5: memref<?x1100xf64>, %arg6: memref<?x1200xf64>, %arg7: memref<?x1100xf64>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = arith.index_cast %arg1 : i32 to index
    %1 = arith.index_cast %arg2 : i32 to index
    %2 = arith.index_cast %arg0 : i32 to index
    affine.parallel (%arg8) = (0) to (symbol(%2)) {
      affine.for %arg9 = 0 to %0 {
        %6 = affine.load %arg5[%arg8, %arg9] : memref<?x1100xf64>
        %7 = arith.mulf %6, %arg4 : f64
        affine.store %7, %arg5[%arg8, %arg9] : memref<?x1100xf64>
      }
      %3 = affine.apply #map0()[%1]
      %4 = affine.apply #map0()[%0]
      %5 = affine.apply #map1(%3)[%4]
      affine.for %arg9 = 0 to %5 {
        %6 = affine.apply #map2(%arg9)[%4]
        %7 = affine.apply #map3(%arg9)[%4]
        %8 = affine.load %arg6[%arg8, %7] : memref<?x1200xf64>
        %9 = arith.mulf %arg3, %8 : f64
        %10 = affine.load %arg7[%7, %6] : memref<?x1100xf64>
        %11 = arith.mulf %9, %10 : f64
        %12 = affine.load %arg5[%arg8, %6] : memref<?x1100xf64>
        %13 = arith.addf %12, %11 : f64
        affine.store %13, %arg5[%arg8, %6] : memref<?x1100xf64>
      }
    }
    return
  }
}

