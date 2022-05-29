! This test checks lowering of atomic update construct
! RUN: bbc -fopenmp -emit-fir %s -o - | \
! RUN: FileCheck %s

program OmpAtomicUpdate
    use omp_lib
    integer :: x, y, z
    integer, pointer :: a, b
    integer, target :: c, d
    a=>c
    b=>d

!CHECK: %[[VAR_X:.*]] = fir.alloca i32 {bindc_name = "x", uniq_name = "_QFEx"} 
!CHECK: %[[VAR_Y:.*]] = fir.alloca i32 {bindc_name = "y", uniq_name = "_QFEy"}
!CHECK: %[[VAR_Z:.*]] = fir.alloca i32 {bindc_name = "z", uniq_name = "_QFEz"}
!CHECK: omp.atomic.update %1 : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: {{.*}} = arith.constant 1 : i32
!CHECK: %[[RESULT:.*]] = arith.addi %[[ARG]], {{.*}} : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
!CHECK: omp.atomic.update %[[VAR_Z]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: %{{.*}} = fir.load %[[VAR_X]] : !fir.ref<i32>
!CHECK: %[[RESULT:.*]] = arith.muli {{.*}}, %[[ARG]] : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
    !$omp atomic 
        y = y + 1
    !$omp atomic update
        z = x * z 

!CHECK: omp.atomic.update   memory_order(relaxed) hint(uncontended) %[[VAR_X]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: %{{.*}} = arith.constant 1 : i32
!CHECK: %[[RESULT:.*]] = arith.subi %[[ARG]], {{.*}} : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK:}
!CHECK: omp.atomic.update   memory_order(relaxed) %[[VAR_Y]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: {{.*}} = fir.load %[[VAR_X]] : !fir.ref<i32>
!CHECK: {{.*}} = fir.load %[[VAR_Z]] : !fir.ref<i32>
!CHECK: {{.*}} = arith.cmpi sgt, {{.*}}, %[[ARG]] : i32
!CHECK: {{.*}} = arith.select {{.*}}, {{.*}}, %[[ARG]] : i32
!CHECK: {{.*}} = arith.cmpi sgt, {{.*}}, {{.*}} : i32
!CHECK: %[[RESULT:.*]] = arith.select {{.*}}, {{.*}}, {{.*}} : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
!CHECK: omp.atomic.update   memory_order(relaxed) hint(contended) %[[VAR_Z]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: {{.*}} = fir.load %[[VAR_X]] : !fir.ref<i32>
!CHECK: %[[RESULT:.*]] = arith.addi %[[ARG]], {{.*}} : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
    !$omp atomic relaxed update hint(omp_sync_hint_uncontended)
        x = x - 1
    !$omp atomic update relaxed 
        y = max(x, y, z)
    !$omp atomic relaxed hint(omp_sync_hint_contended)
        z = z + x

!CHECK: omp.atomic.update   memory_order(release) hint(contended) %[[VAR_Z]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: {{.*}} = arith.constant 10 : i32
!CHECK: %[[RESULT:.*]] = arith.muli {{.*}}, %[[ARG]] : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
!CHECK: omp.atomic.update   memory_order(release) hint(speculative) %[[VAR_X]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: %{{.*}} = fir.load %[[VAR_Z]] : !fir.ref<i32>
!CHECK: %[[RESULT:.*]] = arith.divsi %[[ARG]], {{.*}} : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
    !$omp atomic release update hint(omp_lock_hint_contended)
        z = z * 10
    !$omp atomic hint(omp_lock_hint_speculative) update release
        x = x / z

!CHECK: omp.atomic.update   memory_order(seq_cst) hint(nonspeculative) %[[VAR_Y]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: %{{.*}} = arith.constant 10 : i32
!CHECK: %[[RESULT:.*]] = arith.addi {{.*}}, %[[ARG]] : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
!CHECK: omp.atomic.update   memory_order(seq_cst) %[[VAR_Z]] : !fir.ref<i32> {
!CHECK: ^bb0(%[[ARG:.*]]: i32):
!CHECK: %{{.*}} = fir.load %[[VAR_Y]] : !fir.ref<i32>
!CHECK: %[[RESULT:.*]] = arith.addi {{.*}}, %[[ARG]] : i32
!CHECK: omp.yield(%[[RESULT]] : i32)
!CHECK: }
!CHECK: return
!CHECK: }
    !$omp atomic hint(omp_sync_hint_nonspeculative) seq_cst
        y = 10 + y
    !$omp atomic seq_cst update
        z = y + z

!Pointers
    !$omp atomic update
        a = a + b 
end program OmpAtomicUpdate
