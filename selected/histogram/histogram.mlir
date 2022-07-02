module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func.func @histogram(%arg0: memref<?xi32>, %arg1: memref<?xi32>, %arg2: i32, %arg3: i32, %arg4: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c12_i32 = arith.constant 12 : i32
    %0 = arith.index_cast %arg3 : i32 to index
    affine.for %arg5 = 0 to %0 {
      %1 = affine.load %arg1[%arg5] : memref<?xi32>
      %2 = arith.muli %1, %arg2 : i32
      %3 = arith.shrui %2, %c12_i32 : i32
      %4 = arith.addi %arg2, %3 : i32
      %5 = arith.index_cast %4 : i32 to index
      %6 = memref.load %arg0[%5] : memref<?xi32>
      %7 = arith.addi %6, %c1_i32 : i32
      memref.store %7, %arg0[%5] : memref<?xi32>
    }
    return
  }
}
