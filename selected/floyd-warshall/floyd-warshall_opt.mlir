#map0 = affine_map<()[s0] -> (s0)>
#map1 = affine_map<(d0)[s0] -> (d0 * s0)>
#map2 = affine_map<(d0)[s0] -> (d0 mod s0)>
#map3 = affine_map<(d0)[s0] -> (d0 floordiv s0)>
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func @kernel_floyd_warshall(%arg0: i32, %arg1: memref<?x2800xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = arith.index_cast %arg0 : i32 to index
    %1 = affine.apply #map0()[%0]
    %2 = affine.apply #map0()[%0]
    %3 = affine.apply #map1(%1)[%2]
    %4 = affine.apply #map0()[%0]
    %5 = affine.apply #map1(%3)[%4]
    affine.for %arg2 = 0 to %5 {
      %6 = affine.apply #map2(%arg2)[%4]
      %7 = affine.apply #map3(%arg2)[%4]
      %8 = affine.apply #map2(%7)[%2]
      %9 = affine.apply #map3(%7)[%2]
      %10 = affine.load %arg1[%8, %6] : memref<?x2800xi32>
      %11 = affine.load %arg1[%8, %9] : memref<?x2800xi32>
      %12 = affine.load %arg1[%9, %6] : memref<?x2800xi32>
      %13 = arith.addi %11, %12 : i32
      %14 = arith.cmpi slt, %10, %13 : i32
      %15 = arith.select %14, %10, %13 : i32
      affine.store %15, %arg1[%8, %6] : memref<?x2800xi32>
    }
    return
  }
}

