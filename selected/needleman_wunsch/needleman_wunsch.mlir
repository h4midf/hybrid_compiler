#map0 = affine_map<()[s0] -> (s0 + 1)>
#map1 = affine_map<(d0) -> (d0)>
#map2 = affine_map<(d0) -> (d0 - 1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func.func @needleman_wunsch(%arg0: memref<?xi32>, %arg1: memref<?xi32>, %arg2: memref<?xi32>, %arg3: i32, %arg4: i32, %arg5: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1_i32 = arith.constant -1 : i32
    %c16_i32 = arith.constant 16 : i32
    %0 = arith.index_cast %arg4 : i32 to index
    %1 = memref.alloca() : memref<256xi32>
    %2 = memref.alloca() : memref<289xi32>
    %3 = memref.alloca() : memref<256xi32>
    %4 = memref.alloca() : memref<289xi32>
    %5 = arith.addi %arg4, %c-1_i32 : i32
    %6 = arith.divsi %5, %c16_i32 : i32
    %7 = arith.index_cast %6 : i32 to index
    affine.for %arg6 = 1 to #map0()[%7] {
      affine.for %arg7 = 0 to #map1(%arg6) {
        affine.for %arg8 = 0 to 16 {
          affine.for %arg9 = 0 to 16 {
            %8 = affine.load %arg2[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 - 15) * symbol(%0) + 1] : memref<?xi32>
            affine.store %8, %3[%arg9 + %arg8 * 16] : memref<256xi32>
          }
        }
        affine.for %arg8 = 0 to 17 {
          affine.for %arg9 = 0 to 17 {
            %8 = affine.load %arg0[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 - 16) * symbol(%0)] : memref<?xi32>
            affine.store %8, %4[%arg9 + %arg8 * 17] : memref<289xi32>
          }
        }
        affine.for %arg8 = 1 to 17 {
          affine.for %arg9 = 1 to 17 {
            %8 = affine.load %4[%arg9 + %arg8 * 17 - 18] : memref<289xi32>
            %9 = affine.load %3[%arg9 + %arg8 * 16 - 17] : memref<256xi32>
            %10 = arith.addi %8, %9 : i32
            %11 = affine.load %4[%arg9 + %arg8 * 17 - 1] : memref<289xi32>
            %12 = arith.subi %11, %arg5 : i32
            %13 = affine.load %4[%arg9 + %arg8 * 17 - 17] : memref<289xi32>
            %14 = arith.subi %13, %arg5 : i32
            %15 = arith.cmpi sgt, %10, %12 : i32
            %16 = arith.cmpi sgt, %12, %14 : i32
            %17 = arith.select %15, %10, %12 : i32
            %18 = arith.select %16, %12, %14 : i32
            %19 = arith.cmpi sgt, %17, %18 : i32
            %20 = arith.select %19, %17, %18 : i32
            affine.store %20, %4[%arg9 + %arg8 * 17] : memref<289xi32>
          }
        }
        affine.for %arg8 = 0 to 16 {
          affine.for %arg9 = 0 to 16 {
            %8 = affine.load %4[%arg9 + %arg8 * 17 + 18] : memref<289xi32>
            affine.store %8, %arg0[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 - 15) * symbol(%0) + 1] : memref<?xi32>
          }
        }
      }
    }
    affine.for %arg6 = 2 to #map0()[%7] {
      affine.for %arg7 = #map2(%arg6) to %7 {
        affine.for %arg8 = 0 to 16 {
          affine.for %arg9 = 0 to 16 {
            %8 = affine.load %arg2[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 + symbol(%7) * 16 - 31) * symbol(%0) + 1] : memref<?xi32>
            affine.store %8, %1[%arg9 + %arg8 * 16] : memref<256xi32>
          }
        }
        affine.for %arg8 = 0 to 17 {
          affine.for %arg9 = 0 to 17 {
            %8 = affine.load %arg0[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 + symbol(%7) * 16 - 32) * symbol(%0)] : memref<?xi32>
            affine.store %8, %2[%arg9 + %arg8 * 17] : memref<289xi32>
          }
        }
        affine.for %arg8 = 1 to 17 {
          affine.for %arg9 = 1 to 17 {
            %8 = affine.load %2[%arg9 + %arg8 * 17 - 18] : memref<289xi32>
            %9 = affine.load %1[%arg9 + %arg8 * 16 - 17] : memref<256xi32>
            %10 = arith.addi %8, %9 : i32
            %11 = affine.load %2[%arg9 + %arg8 * 17 - 1] : memref<289xi32>
            %12 = arith.subi %11, %arg5 : i32
            %13 = affine.load %2[%arg9 + %arg8 * 17 - 17] : memref<289xi32>
            %14 = arith.subi %13, %arg5 : i32
            %15 = arith.cmpi sgt, %10, %12 : i32
            %16 = arith.cmpi sgt, %12, %14 : i32
            %17 = arith.select %15, %10, %12 : i32
            %18 = arith.select %16, %12, %14 : i32
            %19 = arith.cmpi sgt, %17, %18 : i32
            %20 = arith.select %19, %17, %18 : i32
            affine.store %20, %2[%arg9 + %arg8 * 17] : memref<289xi32>
          }
        }
        affine.for %arg8 = 0 to 16 {
          affine.for %arg9 = 0 to 16 {
            %8 = affine.load %2[%arg9 + %arg8 * 17 + 18] : memref<289xi32>
            affine.store %8, %arg0[%arg9 + %arg7 * 16 + (%arg7 * -16 + %arg8 + %arg6 * 16 + symbol(%7) * 16 - 31) * symbol(%0) + 1] : memref<?xi32>
          }
        }
      }
    }
    return
  }
}
