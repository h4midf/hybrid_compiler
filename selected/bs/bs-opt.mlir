module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func @bs(%arg0: memref<?xi64>, %arg1: i64, %arg2: memref<?xi64>, %arg3: i32) -> i64 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i64 = arith.constant 1 : i64
    %c2_i64 = arith.constant 2 : i64
    %c0_i64 = arith.constant 0 : i64
    %c-1_i64 = arith.constant -1 : i64
    %true = arith.constant true
    %0 = memref.alloca() : memref<1xi64>
    affine.store %c-1_i64, %0[0] : memref<1xi64>
    %1 = arith.extui %arg3 : i32 to i64
    %2 = arith.index_cast %1 : i64 to index
    affine.for %arg4 = 0 to %2 {
      %4:2 = scf.while (%arg5 = %true, %arg6 = %c0_i64, %arg7 = %arg1) : (i1, i64, i64) -> (i64, i64) {
        %5 = arith.cmpi sle, %arg6, %arg7 : i64
        %6 = arith.andi %5, %arg5 : i1
        scf.condition(%6) %arg6, %arg7 : i64, i64
      } do {
      ^bb0(%arg5: i64, %arg6: i64):
        %5 = arith.subi %arg6, %arg5 : i64
        %6 = arith.divui %5, %c2_i64 : i64
        %7 = arith.addi %arg5, %6 : i64
        %8 = arith.index_cast %7 : i64 to index
        %9 = memref.load %arg0[%8] : memref<?xi64>
        %10 = affine.load %arg2[%arg4] : memref<?xi64>
        %11 = arith.cmpi eq, %9, %10 : i64
        %12 = arith.cmpi ne, %9, %10 : i64
        %13:2 = scf.if %11 -> (i64, i64) {
          %14 = affine.load %0[0] : memref<1xi64>
          %15 = arith.addi %14, %7 : i64
          affine.store %15, %0[0] : memref<1xi64>
          scf.yield %arg5, %arg6 : i64, i64
        } else {
          %14 = memref.load %arg0[%8] : memref<?xi64>
          %15 = affine.load %arg2[%arg4] : memref<?xi64>
          %16 = arith.cmpi slt, %14, %15 : i64
          %17:2 = scf.if %16 -> (i64, i64) {
            %18 = arith.addi %7, %c1_i64 : i64
            scf.yield %18, %arg6 : i64, i64
          } else {
            %18 = arith.addi %7, %c-1_i64 : i64
            scf.yield %arg5, %18 : i64, i64
          }
          scf.yield %17#0, %17#1 : i64, i64
        }
        scf.yield %12, %13#0, %13#1 : i1, i64, i64
      }
    }
    %3 = affine.load %0[0] : memref<1xi64>
    return %3 : i64
  }
}

