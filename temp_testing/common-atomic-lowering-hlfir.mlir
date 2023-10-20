module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, fir.defaultkind = "a1c4d8i4l4r4", fir.kindmap = "", llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", omp.is_gpu = false, omp.is_target_device = false, omp.version = #omp.version<version = 11>} {
  func.func @_QQmain() attributes {fir.bindc_name = "sample"} {
    %0 = fir.alloca i32 {bindc_name = "a", uniq_name = "_QFEa"}
    %1:2 = hlfir.declare %0 {uniq_name = "_QFEa"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
    %2 = fir.alloca i32 {bindc_name = "b", uniq_name = "_QFEb"}
    %3:2 = hlfir.declare %2 {uniq_name = "_QFEb"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
    %4 = fir.alloca i32 {bindc_name = "x", uniq_name = "_QFEx"}
    %5:2 = hlfir.declare %4 {uniq_name = "_QFEx"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
    %c5 = arith.constant 5 : index
    %6 = fir.alloca !fir.array<5xi32> {bindc_name = "y", uniq_name = "_QFEy"}
    %7 = fir.shape %c5 : (index) -> !fir.shape<1>
    %8:2 = hlfir.declare %6(%7) {uniq_name = "_QFEy"} : (!fir.ref<!fir.array<5xi32>>, !fir.shape<1>) -> (!fir.ref<!fir.array<5xi32>>, !fir.ref<!fir.array<5xi32>>)
    %c2 = arith.constant 2 : index
    %9 = hlfir.designate %8#0 (%c2)  : (!fir.ref<!fir.array<5xi32>>, index) -> !fir.ref<i32>
    %c8_i32 = arith.constant 8 : i32
    %10 = fir.load %5#0 : !fir.ref<i32>
    %11 = arith.addi %c8_i32, %10 : i32
    %12 = hlfir.no_reassoc %11 : i32
    omp.atomic.update %9 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %18 = arith.muli %arg0, %12 : i32
      omp.yield(%18 : i32)
    }
    %c2_0 = arith.constant 2 : index
    %13 = hlfir.designate %8#0 (%c2_0)  : (!fir.ref<!fir.array<5xi32>>, index) -> !fir.ref<i32>
    %c8_i32_1 = arith.constant 8 : i32
    omp.atomic.update %13 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %18 = arith.divui %arg0, %c8_i32_1 : i32
      omp.yield(%18 : i32)
    }
    %c8_i32_2 = arith.constant 8 : i32
    %c4 = arith.constant 4 : index
    %14 = hlfir.designate %8#0 (%c4)  : (!fir.ref<!fir.array<5xi32>>, index) -> !fir.ref<i32>
    %15 = fir.load %14 : !fir.ref<i32>
    %16 = arith.addi %c8_i32_2, %15 : i32
    %17 = hlfir.no_reassoc %16 : i32
    omp.atomic.update %5#1 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %18 = arith.addi %arg0, %17 : i32
      omp.yield(%18 : i32)
    }
    %c8_i32_3 = arith.constant 8 : i32
    omp.atomic.update %5#1 : !fir.ref<i32> {
    ^bb0(%arg0: i32):
      %18 = arith.subi %arg0, %c8_i32_3 : i32
      omp.yield(%18 : i32)
    }
    return
  }
  fir.global @_QQEnvironmentDefaults constant : !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>> {
    %0 = fir.zero_bits !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>>
    fir.has_value %0 : !fir.ref<tuple<i32, !fir.ref<!fir.array<0xtuple<!fir.ref<i8>, !fir.ref<i8>>>>>>
  }
}
