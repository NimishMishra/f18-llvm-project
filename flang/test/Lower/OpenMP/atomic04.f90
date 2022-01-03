! This test checks lowering of atomic update construct
! RUN: bbc -fopenmp -emit-fir %s -o - | \
! RUN: FileCheck %s --check-prefix=FIRDialect
! RUN: bbc -fopenmp %s -o - | \
! RUN: tco --disable-llvm --print-ir-after=fir-to-llvm-ir 2>&1 | \
! RUN: FileCheck %s --check-prefix=LLVMIRDialect

!FIRDialect: %0 = fir.alloca i32
!FIRDialect: %1 = fir.alloca i32
!FIRDialect: %[[VAR_A:.*]] = fir.alloca !fir.logical<4> {bindc_name = "a", uniq_name = "_QFEa"}
!FIRDialect: %[[VAR_B:.*]] = fir.alloca !fir.logical<4> {bindc_name = "b", uniq_name = "_QFEb"}
!FIRDialect: %[[VAR_C:.*]] = fir.alloca !fir.logical<4> {bindc_name = "c", uniq_name = "_QFEc"}
!FIRDialect: %[[VAR_X:.*]] = fir.alloca i32 {bindc_name = "x", uniq_name = "_QFEx"}
!FIRDialect: %[[VAR_Y:.*]] = fir.alloca i32 {bindc_name = "y", uniq_name = "_QFEy"}
!FIRDialect: %[[VAR_Z:.*]] = fir.alloca i32 {bindc_name = "z", uniq_name = "_QFEz"}
!FIRDialect: %8 = fir.load %6 : !fir.ref<i32>
!FIRDialect: %c1_i32 = arith.constant 1 : i32
!FIRDialect: %9 = arith.addi %8, %c1_i32 : i32
!FIRDialect: omp.atomic.update %[[VAR_Y]] = %[[VAR_Y]] add %9 memory_order(seq_cst) : !fir.ref<i32>, i32
!FIRDialect: %10 = fir.load %6 : !fir.ref<i32>
!FIRDialect: %c1_i32_0 = arith.constant 1 : i32
!FIRDialect: %11 = arith.subi %10, %c1_i32_0 : i32
!FIRDialect: omp.atomic.update %[[VAR_Y]] = %[[VAR_Y]] sub %11 memory_order(relaxed) : !fir.ref<i32>, i32
!FIRDialect: %12 = fir.load %6 : !fir.ref<i32>
!FIRDialect: omp.atomic.update %[[VAR_Y]] = %[[VAR_Y]] mul %12 memory_order(release) hint(uncontended) : !fir.ref<i32>, i32
!FIRDialect: %13 = fir.load %6 : !fir.ref<i32>
!FIRDialect: %c1_i32_1 = arith.constant 1 : i32
!FIRDialect: %14 = arith.divsi %13, %c1_i32_1 : i32
!FIRDialect: omp.atomic.update %[[VAR_Y]] = %[[VAR_Y]] div %14 : !fir.ref<i32>, i32
!FIRDialect: %15 = fir.load %2 : !fir.ref<!fir.logical<4>>
!FIRDialect: %16 = fir.load %3 : !fir.ref<!fir.logical<4>>
!FIRDialect: %17 = fir.convert %15 : (!fir.logical<4>) -> i1
!FIRDialect: %18 = fir.convert %16 : (!fir.logical<4>) -> i1
!FIRDialect: %19 = arith.andi %17, %18 : i1
!FIRDialect: omp.atomic.update %[[VAR_A]] = %[[VAR_A]] and %19 : !fir.ref<!fir.logical<4>>, i1
!FIRDialect: %20 = fir.load %3 : !fir.ref<!fir.logical<4>>
!FIRDialect: %21 = fir.load %4 : !fir.ref<!fir.logical<4>>
!FIRDialect: %22 = fir.convert %20 : (!fir.logical<4>) -> i1
!FIRDialect: %23 = fir.convert %21 : (!fir.logical<4>) -> i1
!FIRDialect: %24 = arith.ori %22, %23 : i1
!FIRDialect: omp.atomic.update %[[VAR_B]] = %[[VAR_B]] or %24 : !fir.ref<!fir.logical<4>>, i1
!FIRDialect: %25 = fir.load %2 : !fir.ref<!fir.logical<4>>
!FIRDialect: %26 = fir.load %3 : !fir.ref<!fir.logical<4>>
!FIRDialect: %27 = fir.convert %25 : (!fir.logical<4>) -> i1
!FIRDialect: %28 = fir.convert %26 : (!fir.logical<4>) -> i1
!FIRDialect: %29 = arith.cmpi eq, %27, %28 : i1
!FIRDialect: omp.atomic.update %[[VAR_A]] = %[[VAR_A]] eqv %29 hint(contended) : !fir.ref<!fir.logical<4>>, i1
!FIRDialect: %30 = fir.load %4 : !fir.ref<!fir.logical<4>>
!FIRDialect: %31 = fir.load %2 : !fir.ref<!fir.logical<4>>
!FIRDialect: %32 = fir.convert %30 : (!fir.logical<4>) -> i1
!FIRDialect: %33 = fir.convert %31 : (!fir.logical<4>) -> i1
!FIRDialect: %34 = arith.cmpi ne, %32, %33 : i1
!FIRDialect: omp.atomic.update %[[VAR_C]] = %[[VAR_C]] neqv %34 : !fir.ref<!fir.logical<4>>, i1
!FIRDialect: %35 = fir.call @_QPxor(%5, %6) : (!fir.ref<i32>, !fir.ref<i32>) -> f32
!FIRDialect: omp.atomic.update %[[VAR_X]] = %[[VAR_X]] xor %35 hint(nonspeculative) : !fir.ref<i32>, f32
!FIRDialect: %c3_i32 = arith.constant 3 : i32
!FIRDialect: fir.store %c3_i32 to %1 : !fir.ref<i32>
!FIRDialect: %36 = fir.call @_QPrshift(%7, %1) : (!fir.ref<i32>, !fir.ref<i32>) -> f32
!FIRDialect: omp.atomic.update %[[VAR_Z]] = %[[VAR_Z]] shiftr %36 : !fir.ref<i32>, f32
!FIRDialect: %c2_i32 = arith.constant 2 : i32
!FIRDialect: fir.store %c2_i32 to %0 : !fir.ref<i32>
!FIRDialect: %37 = fir.call @_QPlshift(%7, %0) : (!fir.ref<i32>, !fir.ref<i32>) -> i32
!FIRDialect: omp.atomic.update %[[VAR_Z]] = %[[VAR_Z]] shiftl %37 hint(speculative) : !fir.ref<i32>, i32
!FIRDialect: %38 = fir.load %5 : !fir.ref<i32>
!FIRDialect: %39 = fir.load %6 : !fir.ref<i32>
!FIRDialect: %c2_i32_2 = arith.constant 2 : i32
!FIRDialect: %c3_i32_3 = arith.constant 3 : i32
!FIRDialect: %40 = arith.cmpi sgt, %38, %39 : i32
!FIRDialect: %41 = select %40, %38, %39 : i32
!FIRDialect: %42 = arith.cmpi sgt, %41, %c2_i32_2 : i32
!FIRDialect: %43 = select %42, %41, %c2_i32_2 : i32
!FIRDialect: %44 = arith.cmpi sgt, %43, %c3_i32_3 : i32
!FIRDialect: %45 = select %44, %43, %c3_i32_3 : i32
!FIRDialect: omp.atomic.update %[[VAR_X]] = %[[VAR_X]] max %45 : !fir.ref<i32>, i32
!FIRDialect: %46 = fir.load %5 : !fir.ref<i32>
!FIRDialect: %c1_i32_4 = arith.constant 1 : i32
!FIRDialect: %c6_i32 = arith.constant 6 : i32
!FIRDialect: %c7_i32 = arith.constant 7 : i32
!FIRDialect: %47 = arith.cmpi slt, %46, %c1_i32_4 : i32
!FIRDialect: %48 = select %47, %46, %c1_i32_4 : i32
!FIRDialect: %49 = arith.cmpi slt, %48, %c6_i32 : i32
!FIRDialect: %50 = select %49, %48, %c6_i32 : i32
!FIRDialect: %51 = arith.cmpi slt, %50, %c7_i32 : i32
!FIRDialect: %52 = select %51, %50, %c7_i32 : i32
!FIRDialect: omp.atomic.update %[[VAR_Y]] = %[[VAR_Y]] min %52 : !fir.ref<i32>, i32
!FIRDialect: return
!FIRDialect: }

!LLVMIRDialect: llvm.func @_QQmain() {
!LLVMIRDialect: %0 = llvm.mlir.constant(1 : i32) : i32
!LLVMIRDialect: %1 = llvm.mlir.constant(3 : i32) : i32
!LLVMIRDialect: %2 = llvm.mlir.constant(2 : i32) : i32
!LLVMIRDialect: %3 = llvm.mlir.constant(6 : i32) : i32
!LLVMIRDialect: %4 = llvm.mlir.constant(7 : i32) : i32
!LLVMIRDialect: %5 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %6 = llvm.alloca %5 x i32 {in_type = i32, operand_segment_sizes = dense<0> : vector<2xi32>} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %7 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %8 = llvm.alloca %7 x i32 {in_type = i32, operand_segment_sizes = dense<0> : vector<2xi32>} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %9 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_A:.*]] = llvm.alloca %9 x i32 {bindc_name = "a", in_type = !fir.logical<4>, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEa"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %11 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_B:.*]] = llvm.alloca %11 x i32 {bindc_name = "b", in_type = !fir.logical<4>, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEb"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %13 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_C:.*]] = llvm.alloca %13 x i32 {bindc_name = "c", in_type = !fir.logical<4>, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEc"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %15 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_X:.*]] = llvm.alloca %15 x i32 {bindc_name = "x", in_type = i32, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEx"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %17 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_Y:.*]] = llvm.alloca %17 x i32 {bindc_name = "y", in_type = i32, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEy"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %19 = llvm.mlir.constant(1 : i64) : i64
!LLVMIRDialect: %[[LLVM_VAR_Z:.*]] = llvm.alloca %19 x i32 {bindc_name = "z", in_type = i32, operand_segment_sizes = dense<0> : vector<2xi32>, uniq_name = "_QFEz"} : (i64) -> !llvm.ptr<i32>
!LLVMIRDialect: %21 = llvm.load %18 : !llvm.ptr<i32>
!LLVMIRDialect: %22 = llvm.add %21, %0  : i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Y]] = %[[LLVM_VAR_Y]] add %22 memory_order(seq_cst) : !llvm.ptr<i32>, i32
!LLVMIRDialect: %23 = llvm.sub %21, %0  : i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Y]] = %[[LLVM_VAR_Y]] sub %23 memory_order(relaxed) : !llvm.ptr<i32>, i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Y]] = %[[LLVM_VAR_Y]] mul %21 memory_order(release) hint(uncontended) : !llvm.ptr<i32>, i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Y]] = %[[LLVM_VAR_Y]] div %21 : !llvm.ptr<i32>, i32
!LLVMIRDialect: %24 = llvm.load %10 : !llvm.ptr<i32>
!LLVMIRDialect: %25 = llvm.load %12 : !llvm.ptr<i32>
!LLVMIRDialect: %26 = llvm.trunc %24 : i32 to i1
!LLVMIRDialect: %27 = llvm.trunc %25 : i32 to i1
!LLVMIRDialect: %28 = llvm.and %26, %27  : i1
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_A]] = %[[LLVM_VAR_A]] and %28 : !llvm.ptr<i32>, i1
!LLVMIRDialect: %29 = llvm.load %14 : !llvm.ptr<i32>
!LLVMIRDialect: %30 = llvm.trunc %29 : i32 to i1
!LLVMIRDialect: %31 = llvm.or %27, %30  : i1
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_B]] = %[[LLVM_VAR_B]] or %31 : !llvm.ptr<i32>, i1
!LLVMIRDialect: %32 = llvm.icmp "eq" %26, %27 : i1
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_A]] = %[[LLVM_VAR_A]] eqv %32 hint(contended) : !llvm.ptr<i32>, i1
!LLVMIRDialect: %33 = llvm.icmp "ne" %30, %26 : i1
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_C]] = %[[LLVM_VAR_C]] neqv %33 : !llvm.ptr<i32>, i1
!LLVMIRDialect: %34 = llvm.call @_QPxor(%16, %18) : (!llvm.ptr<i32>, !llvm.ptr<i32>) -> f32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_X]] = %[[LLVM_VAR_X]] xor %34 hint(nonspeculative) : !llvm.ptr<i32>, f32
!LLVMIRDialect: llvm.store %1, %8 : !llvm.ptr<i32>
!LLVMIRDialect: %35 = llvm.call @_QPrshift(%20, %8) : (!llvm.ptr<i32>, !llvm.ptr<i32>) -> f32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Z]] = %[[LLVM_VAR_Z]] shiftr %35 : !llvm.ptr<i32>, f32
!LLVMIRDialect: llvm.store %2, %6 : !llvm.ptr<i32>
!LLVMIRDialect: %36 = llvm.call @_QPlshift(%20, %6) : (!llvm.ptr<i32>, !llvm.ptr<i32>) -> i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_Z]] = %[[LLVM_VAR_Z]] shiftl %36 hint(speculative) : !llvm.ptr<i32>, i32
!LLVMIRDialect: %37 = llvm.load %16 : !llvm.ptr<i32>
!LLVMIRDialect: %38 = llvm.load %18 : !llvm.ptr<i32>
!LLVMIRDialect: %39 = llvm.icmp "sgt" %37, %38 : i32
!LLVMIRDialect: %40 = llvm.select %39, %37, %38 : i1, i32
!LLVMIRDialect: %41 = llvm.icmp "sgt" %40, %2 : i32
!LLVMIRDialect: %42 = llvm.select %41, %40, %2 : i1, i32
!LLVMIRDialect: %43 = llvm.icmp "sgt" %42, %1 : i32
!LLVMIRDialect: %44 = llvm.select %43, %42, %1 : i1, i32
!LLVMIRDialect: omp.atomic.update %[[LLVM_VAR_X]] = %[[LLVM_VAR_X]] max %44 : !llvm.ptr<i32>, i32
!LLVMIRDialect: %45 = llvm.icmp "slt" %37, %0 : i32
!LLVMIRDialect: %46 = llvm.select %45, %37, %0 : i1, i32
!LLVMIRDialect: %47 = llvm.icmp "slt" %46, %3 : i32
!LLVMIRDialect: %48 = llvm.select %47, %46, %3 : i1, i32
!LLVMIRDialect: %49 = llvm.icmp "slt" %48, %4 : i32
!LLVMIRDialect: %50 = llvm.select %49, %48, %4 : i1, i32
!LLVMIRDialect: %[[LLVM_VAR_Y]] = %[[LLVM_VAR_Y]] min %50 : !llvm.ptr<i32>, i32
!LLVMIRDialect: llvm.return
!LLVMIRDialect: }


program OmpAtomic
    use omp_lib
    integer :: x, y, z 
    logical :: a, b, c
    !$omp atomic seq_cst 
        y = y + 1
    !$omp atomic relaxed
        y = y - 1
    !$omp atomic release hint(omp_sync_hint_uncontended)
        y = y * 1
    !$omp atomic
        y = y / 1
    !$omp atomic hint(omp_sync_hint_none)
        a = a .AND. b
    !$omp atomic
        b = b .OR. c
    !$omp atomic hint(omp_sync_hint_contended)
        a = a .EQV. b
    !$omp atomic
        c = c .NEQV. a
    !$omp atomic hint(omp_sync_hint_nonspeculative)
        x = xor(x, y)
    !$omp atomic
        z = rshift(z, 3)
    !$omp atomic hint(omp_sync_hint_speculative)
        z = lshift(z, 2)
    !$omp atomic
        x = max(x, y, 2, 3)
    !$omp atomic
        y = min(x, 1, 6, 7)
end program OmpAtomic
