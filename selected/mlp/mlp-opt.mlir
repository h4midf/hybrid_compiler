module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func @mlp(%arg0: memref<?xi32>, %arg1: memref<?xmemref<?xi32>>, %arg2: memref<?xi32>, %arg3: i32, %arg4: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %arg4 : i32 to index
    %1 = arith.index_cast %arg3 : i32 to index
    %2 = llvm.mlir.undef : i32
    %3 = memref.alloca() : memref<1xi32>
    affine.store %2, %3[0] : memref<1xi32>
    affine.for %arg5 = 0 to 10 {
      affine.parallel (%arg6) = (0) to (symbol(%1)) {
        affine.store %c0_i32, %arg0[%arg6] : memref<?xi32>
      }
      affine.parallel (%arg6) = (0) to (symbol(%1)) {
        affine.for %arg7 = 0 to %0 {
          %8 = affine.load %arg1[%arg5] : memref<?xmemref<?xi32>>
          %9 = affine.load %8[%arg7 + %arg6 * symbol(%0)] : memref<?xi32>
          %10 = affine.load %arg2[%arg7] : memref<?xi32>
          %11 = arith.muli %9, %10 : i32
          %12 = affine.load %arg0[%arg6] : memref<?xi32>
          %13 = arith.addi %12, %11 : i32
          affine.store %13, %arg0[%arg6] : memref<?xi32>
        }
        %4 = affine.load %arg0[%arg6] : memref<?xi32>
        %5 = arith.cmpi sgt, %c0_i32, %4 : i32
        %6 = arith.extsi %5 : i1 to i32
        %7 = arith.muli %6, %4 : i32
        affine.store %7, %arg0[%arg6] : memref<?xi32>
      }
      affine.parallel (%arg6) = (0) to (symbol(%0)) {
        %4 = affine.load %arg0[%arg6] : memref<?xi32>
        affine.store %4, %arg2[%arg6] : memref<?xi32>
      }
    }
    affine.store %c0_i32, %3[0] : memref<1xi32>
    affine.for %arg5 = 0 to %0 {
      %4 = affine.load %arg2[%arg5] : memref<?xi32>
      %5 = affine.load %3[0] : memref<1xi32>
      %6 = arith.addi %5, %4 : i32
      affine.store %6, %3[0] : memref<1xi32>
    }
    return
  }
}

