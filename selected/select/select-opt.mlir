module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func @select(%arg0: i32, %arg1: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = memref.alloca() : memref<1000xi32>
    %1 = memref.alloca() : memref<1xi32>
    affine.store %c0_i32, %1[0] : memref<1xi32>
    %2 = arith.index_cast %arg0 : i32 to index
    affine.for %arg2 = 1 to %2 {
      %4 = affine.load %0[%arg2] : memref<1000xi32>
      %5 = arith.remsi %4, %c2_i32 : i32
      %6 = arith.cmpi eq, %5, %c2_i32 : i32
      %7 = arith.extsi %6 : i1 to i32
      %8 = arith.cmpi eq, %7, %c0_i32 : i32
      scf.if %8 {
        %9 = affine.load %1[0] : memref<1xi32>
        %10 = arith.addi %9, %c1_i32 : i32
        affine.store %10, %1[0] : memref<1xi32>
      }
    }
    %3 = affine.load %1[0] : memref<1xi32>
    return %3 : i32
  }
}

