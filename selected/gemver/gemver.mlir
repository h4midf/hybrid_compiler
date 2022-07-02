module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func.func @gemver(%arg0: memref<?xmemref<?xf64>>, %arg1: memref<?xf64>, %arg2: memref<?xmemref<?xf64>>) attributes {llvm.linkage = #llvm.linkage<external>} {
    affine.for %arg3 = 0 to 1000 {
      affine.for %arg4 = 0 to 500 {
        %0 = affine.load %arg2[0] : memref<?xmemref<?xf64>>
        %1 = affine.load %0[%arg3] : memref<?xf64>
        %2 = affine.load %arg0[%arg3] : memref<?xmemref<?xf64>>
        %3 = affine.load %2[%arg4] : memref<?xf64>
        %4 = affine.load %arg1[%arg4] : memref<?xf64>
        %5 = arith.mulf %3, %4 : f64
        %6 = arith.addf %1, %5 : f64
        affine.store %6, %0[%arg3] : memref<?xf64>
      }
    }
    return
  }
}
