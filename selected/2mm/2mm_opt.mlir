module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_2mm(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: f64, %arg5: f64, %arg6: memref<?x900xf64>, %arg7: memref<?x1100xf64>, %arg8: memref<?x900xf64>, %arg9: memref<?x1200xf64>, %arg10: memref<?x1200xf64>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f64
    %0 = arith.index_cast %arg2 : i32 to index
    %1 = arith.index_cast %arg1 : i32 to index
    %2 = arith.index_cast %arg3 : i32 to index
    %3 = arith.index_cast %arg0 : i32 to index
    affine.parallel (%arg11) = (0) to (symbol(%3)) {
      affine.parallel (%arg12) = (0) to (symbol(%1)) {
        affine.store %cst, %arg6[%arg11, %arg12] : memref<?x900xf64>
        affine.for %arg13 = 0 to %0 {
          %4 = affine.load %arg7[%arg11, %arg13] : memref<?x1100xf64>
          %5 = arith.mulf %arg4, %4 : f64
          %6 = affine.load %arg8[%arg13, %arg12] : memref<?x900xf64>
          %7 = arith.mulf %5, %6 : f64
          %8 = affine.load %arg6[%arg11, %arg12] : memref<?x900xf64>
          %9 = arith.addf %8, %7 : f64
          affine.store %9, %arg6[%arg11, %arg12] : memref<?x900xf64>
        }
      }
    }
    affine.parallel (%arg11) = (0) to (symbol(%3)) {
      affine.parallel (%arg12) = (0) to (symbol(%2)) {
        %4 = affine.load %arg10[%arg11, %arg12] : memref<?x1200xf64>
        %5 = arith.mulf %4, %arg5 : f64
        affine.store %5, %arg10[%arg11, %arg12] : memref<?x1200xf64>
        affine.for %arg13 = 0 to %1 {
          %6 = affine.load %arg6[%arg11, %arg13] : memref<?x900xf64>
          %7 = affine.load %arg9[%arg13, %arg12] : memref<?x1200xf64>
          %8 = arith.mulf %6, %7 : f64
          %9 = affine.load %arg10[%arg11, %arg12] : memref<?x1200xf64>
          %10 = arith.addf %9, %8 : f64
          affine.store %10, %arg10[%arg11, %arg12] : memref<?x1200xf64>
        }
      }
    }
    return
  }
}

