module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_atax(%arg0: i32, %arg1: i32, %arg2: memref<?x2100xf64>, %arg3: memref<?xf64>, %arg4: memref<?xf64>, %arg5: memref<?xf64>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f64
    %0 = arith.index_cast %arg1 : i32 to index
    affine.parallel (%arg6) = (0) to (symbol(%0)) {
      affine.store %cst, %arg4[%arg6] : memref<?xf64>
    }
    %1 = arith.index_cast %arg0 : i32 to index
    affine.for %arg6 = 0 to %1 {
      affine.store %cst, %arg5[%arg6] : memref<?xf64>
      affine.for %arg7 = 0 to %0 {
        %2 = affine.load %arg5[%arg6] : memref<?xf64>
        %3 = affine.load %arg2[%arg6, %arg7] : memref<?x2100xf64>
        %4 = affine.load %arg3[%arg7] : memref<?xf64>
        %5 = arith.mulf %3, %4 : f64
        %6 = arith.addf %2, %5 : f64
        affine.store %6, %arg5[%arg6] : memref<?xf64>
      }
      affine.parallel (%arg7) = (0) to (symbol(%0)) {
        %2 = affine.load %arg4[%arg7] : memref<?xf64>
        %3 = affine.load %arg2[%arg6, %arg7] : memref<?x2100xf64>
        %4 = affine.load %arg5[%arg6] : memref<?xf64>
        %5 = arith.mulf %3, %4 : f64
        %6 = arith.addf %2, %5 : f64
        affine.store %6, %arg4[%arg7] : memref<?xf64>
      }
    }
    return
  }
}

