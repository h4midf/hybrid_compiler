module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_floyd_warshall(%arg0: i32, %arg1: memref<?x2800xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = arith.index_cast %arg0 : i32 to index
    affine.for %arg2 = 0 to %0 {
      affine.for %arg3 = 0 to %0 {
        affine.for %arg4 = 0 to %0 {
          %1 = affine.load %arg1[%arg3, %arg4] : memref<?x2800xi32>
          %2 = affine.load %arg1[%arg3, %arg2] : memref<?x2800xi32>
          %3 = affine.load %arg1[%arg2, %arg4] : memref<?x2800xi32>
          %4 = arith.addi %2, %3 : i32
          %5 = arith.cmpi slt, %1, %4 : i32
          %6 = arith.select %5, %1, %4 : i32
          affine.store %6, %arg1[%arg3, %arg4] : memref<?x2800xi32>
        }
      }
    }
    return
  }
}
