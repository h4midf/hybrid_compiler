module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func.func @scan_ssa(%arg0: memref<?xi32>, %arg1: memref<?xi32>, %arg2: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = affine.load %arg1[0] : memref<?xi32>
    affine.store %0, %arg0[0] : memref<?xi32>
    %1 = arith.index_cast %arg2 : i32 to index
    affine.for %arg3 = 1 to %1 {
      %2 = affine.load %arg0[%arg3 - 1] : memref<?xi32>
      %3 = affine.load %arg1[%arg3] : memref<?xi32>
      %4 = arith.addi %2, %3 : i32
      affine.store %4, %arg0[%arg3] : memref<?xi32>
    }
    return
  }
}
