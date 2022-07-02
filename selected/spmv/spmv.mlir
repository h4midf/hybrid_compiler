module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func.func @spmv(%arg0: memref<?x200xi32>, %arg1: memref<?xi32>, %arg2: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = llvm.mlir.undef : i32
    %1 = memref.alloca() : memref<1xi32>
    affine.store %0, %1[0] : memref<1xi32>
    %2 = memref.alloca() : memref<100x200x2xi32>
    affine.for %arg3 = 0 to 100 {
      affine.store %c0_i32, %1[0] : memref<1xi32>
      affine.for %arg4 = 0 to 200 {
        %3 = arith.index_cast %arg4 : index to i32
        %4 = affine.load %1[0] : memref<1xi32>
        %5 = arith.index_cast %4 : i32 to index
        memref.store %3, %2[%arg3, %5, %c0] : memref<100x200x2xi32>
        %6 = affine.load %arg0[%arg3, %arg4] : memref<?x200xi32>
        memref.store %6, %2[%arg3, %5, %c1] : memref<100x200x2xi32>
        %7 = affine.load %arg0[%arg3, %arg4] : memref<?x200xi32>
        %8 = arith.cmpi ne, %7, %c0_i32 : i32
        %9 = arith.extsi %8 : i1 to i32
        %10 = arith.addi %4, %9 : i32
        affine.store %10, %1[0] : memref<1xi32>
      }
    }
    affine.for %arg3 = 0 to 100 {
      affine.for %arg4 = 0 to 200 {
        %3 = affine.load %2[%arg3, %arg4, 0] : memref<100x200x2xi32>
        %4 = affine.load %2[%arg3, %arg4, 1] : memref<100x200x2xi32>
        %5 = arith.index_cast %3 : i32 to index
        %6 = memref.load %arg1[%5] : memref<?xi32>
        %7 = arith.muli %4, %6 : i32
        %8 = affine.load %arg2[%arg3] : memref<?xi32>
        %9 = arith.addi %8, %7 : i32
        affine.store %9, %arg2[%arg3] : memref<?xi32>
      }
    }
    return
  }
}
