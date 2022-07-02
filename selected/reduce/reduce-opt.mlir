module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func @reduce(%arg0: memref<?xi32>, %arg1: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %0 = memref.alloca() : memref<1xi32>
    affine.store %c0_i32, %0[0] : memref<1xi32>
    %1 = arith.index_cast %arg1 : i32 to index
    affine.for %arg2 = 0 to %1 {
      %3 = affine.load %arg0[%arg2] : memref<?xi32>
      %4 = affine.load %0[0] : memref<1xi32>
      %5 = arith.addi %4, %3 : i32
      affine.store %5, %0[0] : memref<1xi32>
    }
    %2 = affine.load %0[0] : memref<1xi32>
    return %2 : i32
  }
}

