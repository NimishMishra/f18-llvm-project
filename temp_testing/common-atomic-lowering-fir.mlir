module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, fir.defaultkind = "a1c4d8i4l4r4", fir.kindmap = "", llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", omp.is_gpu = false, omp.is_target_device = false, omp.version = #omp.version<version = 11>} {
  func.func @_QQmain() attributes {fir.bindc_name = "sample"} {
    %0 = fir.alloca i32 {bindc_name = "a", uniq_name = "_QFEa"}
    %1 = fir.alloca i32 {bindc_name = "b", uniq_name = "_QFEb"}
    %2 = fir.alloca i32 {bindc_name = "x", uniq_name = "_QFEx"}
    %3 = fir.alloca !fir.array<5xi32> {bindc_name = "y", uniq_name = "_QFEy"}
    %c2_i64 = arith.constant 2 : i64
    %c1_i64 = arith.constant 1 : i64
    %4 = arith.subi %c2_i64, %c1_i64 : i64
    %5 = fir.coordinate_of %3, %4 : (!fir.ref<!fir.array<5xi32>>, i64) -> !fir.ref<i32>
    %c8_i32 = arith.constant 8 : i32
    %6 = fir.load %2 : !fir.ref<i32>
    %7 = arith.addi %c8_i32, %6 : i32
    %8 = fir.no_reassoc %7 : i32
    omp.atomic.update %5 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %16 = arith.muli %arg0, %8 : i32
      omp.yield(%16 : i32)
    }
    %c2_i64_0 = arith.constant 2 : i64
    %c1_i64_1 = arith.constant 1 : i64
    %9 = arith.subi %c2_i64_0, %c1_i64_1 : i64
    %10 = fir.coordinate_of %3, %9 : (!fir.ref<!fir.array<5xi32>>, i64) -> !fir.ref<i32>
    %c8_i32_2 = arith.constant 8 : i32
    omp.atomic.update %10 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %16 = arith.divui %arg0, %c8_i32_2 : i32
      omp.yield(%16 : i32)
    }
    %c8_i32_3 = arith.constant 8 : i32
    %c4_i64 = arith.constant 4 : i64
    %c1_i64_4 = arith.constant 1 : i64
    %11 = arith.subi %c4_i64, %c1_i64_4 : i64
    %12 = fir.coordinate_of %3, %11 : (!fir.ref<!fir.array<5xi32>>, i64) -> !fir.ref<i32>
    %13 = fir.load %12 : !fir.ref<i32>
    %14 = arith.addi %c8_i32_3, %13 : i32
    %15 = fir.no_reassoc %14 : i32
    omp.atomic.update %2 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %16 = arith.addi %arg0, %15 : i32
      omp.yield(%16 : i32)
    }
    %c8_i32_5 = arith.constant 8 : i32
    omp.atomic.update %2 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %16 = arith.subi %arg0, %c8_i32_5 : i32
      omp.yield(%16 : i32)
    }
    return
  }
  fir.global @_QQEnvironmentDefaults constant : !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>> {
    %0 = fir.zero_bits !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>>
    fir.has_value %0 : !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>>
  }
}
