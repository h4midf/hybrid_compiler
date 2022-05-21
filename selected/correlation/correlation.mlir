module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
}
#map = affine_map<(d0) -> (d0 + 1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_correlation(%arg0: i32, %arg1: i32, %arg2: f64, %arg3: memref<?x1200xf64>, %arg4: memref<?x1200xf64>, %arg5: memref<?xf64>, %arg6: memref<?xf64>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 1.000000e+00 : f64
    %cst_0 = arith.constant 0.000000e+00 : f64
    %cst_1 = arith.constant 1.000000e-01 : f64
    %c1 = arith.constant 1 : index
    %0 = arith.index_cast %arg0 : i32 to index
    %1 = arith.index_cast %arg1 : i32 to index
    affine.for %arg7 = 0 to %0 {
      affine.store %cst_0, %arg5[%arg7] : memref<?xf64>
      affine.for %arg8 = 0 to %1 {
        %7 = affine.load %arg3[%arg8, %arg7] : memref<?x1200xf64>
        %8 = affine.load %arg5[%arg7] : memref<?xf64>
        %9 = arith.addf %8, %7 : f64
        affine.store %9, %arg5[%arg7] : memref<?xf64>
      }
      %5 = affine.load %arg5[%arg7] : memref<?xf64>
      %6 = arith.divf %5, %arg2 : f64
      affine.store %6, %arg5[%arg7] : memref<?xf64>
    }
    affine.for %arg7 = 0 to %0 {
      affine.store %cst_0, %arg6[%arg7] : memref<?xf64>
      affine.for %arg8 = 0 to %1 {
        %10 = affine.load %arg3[%arg8, %arg7] : memref<?x1200xf64>
        %11 = affine.load %arg5[%arg7] : memref<?xf64>
        %12 = arith.subf %10, %11 : f64
        %13 = arith.mulf %12, %12 : f64
        %14 = affine.load %arg6[%arg7] : memref<?xf64>
        %15 = arith.addf %14, %13 : f64
        affine.store %15, %arg6[%arg7] : memref<?xf64>
      }
      %5 = affine.load %arg6[%arg7] : memref<?xf64>
      %6 = arith.divf %5, %arg2 : f64
      %7 = math.sqrt %6 : f64
      %8 = arith.cmpf ule, %7, %cst_1 : f64
      %9 = arith.select %8, %cst, %7 : f64
      affine.store %9, %arg6[%arg7] : memref<?xf64>
    }
    %2 = math.sqrt %arg2 : f64
    affine.for %arg7 = 0 to %1 {
      affine.for %arg8 = 0 to %0 {
        %5 = affine.load %arg5[%arg8] : memref<?xf64>
        %6 = affine.load %arg3[%arg7, %arg8] : memref<?x1200xf64>
        %7 = arith.subf %6, %5 : f64
        affine.store %7, %arg3[%arg7, %arg8] : memref<?x1200xf64>
        %8 = affine.load %arg6[%arg8] : memref<?xf64>
        %9 = arith.mulf %2, %8 : f64
        %10 = arith.divf %7, %9 : f64
        affine.store %10, %arg3[%arg7, %arg8] : memref<?x1200xf64>
      }
    }
    %3 = arith.addi %0, %c-1 : index
    affine.for %arg7 = 0 to %3 {
      affine.store %cst, %arg4[%arg7, %arg7] : memref<?x1200xf64>
      affine.for %arg8 = #map(%arg7) to %0 {
        affine.store %cst_0, %arg4[%arg7, %arg8] : memref<?x1200xf64>
        affine.for %arg9 = 0 to %1 {
          %6 = affine.load %arg3[%arg9, %arg7] : memref<?x1200xf64>
          %7 = affine.load %arg3[%arg9, %arg8] : memref<?x1200xf64>
          %8 = arith.mulf %6, %7 : f64
          %9 = affine.load %arg4[%arg7, %arg8] : memref<?x1200xf64>
          %10 = arith.addf %9, %8 : f64
          affine.store %10, %arg4[%arg7, %arg8] : memref<?x1200xf64>
        }
        %5 = affine.load %arg4[%arg7, %arg8] : memref<?x1200xf64>
        affine.store %5, %arg4[%arg8, %arg7] : memref<?x1200xf64>
      }
    }
    %4 = arith.subi %0, %c1 : index
    affine.store %cst, %arg4[symbol(%4), symbol(%4)] : memref<?x1200xf64>
    return
  }
}
