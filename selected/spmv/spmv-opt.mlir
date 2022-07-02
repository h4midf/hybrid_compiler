#map0 = affine_map<() -> (100)>
#map1 = affine_map<() -> (200)>
#map2 = affine_map<(d0)[s0] -> (d0 * s0)>
#map3 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map4 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-macosx11.0.0"} {
  func @spmv(%arg0: memref<?x200xi32>, %arg1: memref<?xi32>, %arg2: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
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
        %6 = arith.index_cast %arg4 : index to i32
        %7 = affine.load %1[0] : memref<1xi32>
        %8 = arith.index_cast %7 : i32 to index
        memref.store %6, %2[%arg3, %8, %c0] : memref<100x200x2xi32>
        %9 = affine.load %arg0[%arg3, %arg4] : memref<?x200xi32>
        memref.store %9, %2[%arg3, %8, %c1] : memref<100x200x2xi32>
        %10 = affine.load %arg0[%arg3, %arg4] : memref<?x200xi32>
        %11 = arith.cmpi ne, %10, %c0_i32 : i32
        %12 = arith.extsi %11 : i1 to i32
        %13 = arith.addi %7, %12 : i32
        affine.store %13, %1[0] : memref<1xi32>
      }
    }
    %3 = affine.apply #map0()
    %4 = affine.apply #map1()
    %5 = affine.apply #map2(%3)[%4]
    affine.for %arg3 = 0 to %5 {
      %6 = affine.apply #map3(%arg3)[%4]
      %7 = affine.apply #map4(%arg3)[%4]
      %8 = affine.load %2[%7, %6, 0] : memref<100x200x2xi32>
      %9 = affine.load %2[%7, %6, 1] : memref<100x200x2xi32>
      %10 = arith.index_cast %8 : i32 to index
      %11 = memref.load %arg1[%10] : memref<?xi32>
      %12 = arith.muli %9, %11 : i32
      %13 = affine.load %arg2[%7] : memref<?xi32>
      %14 = arith.addi %13, %12 : i32
      affine.store %14, %arg2[%7] : memref<?xi32>
    }
    return
  }
}

