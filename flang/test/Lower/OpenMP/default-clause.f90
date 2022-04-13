! This test checks lowering of OpenMP parallel directive
! with `DEFAULT` clause present.

! RUN: bbc -fopenmp -emit-fir %s -o - | \
! RUN:   FileCheck %s --check-prefix=FIRDialect

!FIRDialect: func @_QQmain() {
!FIRDialect: %[[W:.*]] = fir.alloca i32 {bindc_name = "w", uniq_name = "_QFEw"}
!FIRDialect: %[[X:.*]] = fir.alloca i32 {bindc_name = "x", uniq_name = "_QFEx"}
!FIRDialect: %[[Y:.*]] = fir.alloca i32 {bindc_name = "y", uniq_name = "_QFEy"}
!FIRDialect: %[[Z:.*]] = fir.alloca i32 {bindc_name = "z", uniq_name = "_QFEz"}
!FIRDialect: omp.parallel default(private)  {
!FIRDialect: %[[PRIVATE_X:.*]] = fir.alloca i32 {bindc_name = "x", pinned, uniq_name = "_QFEx"}
!FIRDialect: %{{.*}} = fir.load %[[X]] : !fir.ref<i32>
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_X]] : !fir.ref<i32>
!FIRDialect: %[[PRIVATE_Y:.*]] = fir.alloca i32 {bindc_name = "y", pinned, uniq_name = "_QFEy"}
!FIRDialect: %[[PRIVATE_Z:.*]] = fir.alloca i32 {bindc_name = "z", pinned, uniq_name = "_QFEz"}
!FIRDialect: %[[PRIVATE_W:.*]] = fir.alloca i32 {bindc_name = "w", pinned, uniq_name = "_QFEw"}
!FIRDialect: %{{.*}} = arith.constant 2 : i32
!FIRDialect: %{{.*}} = fir.load %[[PRIVATE_Y]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = arith.muli %{{.*}}, %{{.*}} : i32
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_X]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = fir.load %[[PRIVATE_W]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = arith.constant 45 : i32
!FIRDialect: %{{.*}} = arith.addi %{{.*}}, %{{.*}} : i32
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_Z]] : !fir.ref<i32>
!FIRDialect: omp.terminator
!FIRDialect: }
!FIRDialect: omp.parallel default(firstprivate)  {
!FIRDialect: %[[PRIVATE_X:.*]] = fir.alloca i32 {bindc_name = "x", pinned, uniq_name = "_QFEx"}
!FIRDialect: %[[PRIVATE_Y:.*]] = fir.alloca i32 {bindc_name = "y", pinned, uniq_name = "_QFEy"}
!FIRDialect: %{{.*}} = fir.load %[[Y]] : !fir.ref<i32>
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_Y]] : !fir.ref<i32>
!FIRDialect: %[[PRIVATE_Z:.*]] = fir.alloca i32 {bindc_name = "z", pinned, uniq_name = "_QFEz"}
!FIRDialect: %{{.*}} = fir.load %[[Z]] : !fir.ref<i32>
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_Z]] : !fir.ref<i32>
!FIRDialect: %[[PRIVATE_W:.*]] = fir.alloca i32 {bindc_name = "w", pinned, uniq_name = "_QFEw"}
!FIRDialect: %{{.*}} = fir.load %[[W]] : !fir.ref<i32>
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_W]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = arith.constant 2 : i32
!FIRDialect: %{{.*}} = fir.load %[[PRIVATE_Y]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = arith.muli %{{.*}}, %{{.*}} : i32
!FIRDialect: fir.store %{{.*}} to %[[PRIVATE_X]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = fir.load %[[PRIVATE_W]] : !fir.ref<i32>
!FIRDialect: %{{.*}} = arith.constant 45 : i32
!FIRDialect: %{{.*}} = arith.addi %{{.*}}, %{{.*}} : i32
!FIRDialect: fir.store %14 to %[[PRIVATE_Z]] : !fir.ref<i32>
!FIRDialect: omp.terminator
!FIRDialect: }
!FIRDialect: return
!FIRDialect: }

program default_clause_lowering
    integer :: x, y, z, w

    !$omp parallel default(private) firstprivate(x)
        x = y * 2
        z = w + 45
    !$omp end parallel

    !$omp parallel default(firstprivate) private(x)
        x = y * 2
        z = w + 45
    !$omp end parallel
end program default_clause_lowering
