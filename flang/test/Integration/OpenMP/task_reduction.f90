!===----------------------------------------------------------------------===!
! This directory can be used to add Integration tests involving multiple
! stages of the compiler (for eg. from Fortran to LLVM IR). It should not
! contain executable tests. We should only add tests here sparingly and only
! if there is no other way to test. Repeat this message in each test that is
! added to this directory and sub-directories.
!===----------------------------------------------------------------------===!

!RUN: %flang_fc1 -emit-llvm -fopenmp -fopenmp-version=50 %s -o - | FileCheck %s
!RUN: %flang_fc1 -emit-llvm -fopenmp -fopenmp-version=50 -mmlir --force-byref-reduction %s -o - | FileCheck --check-prefix=CHECK-REF %s

!===-------------- Pass by value ----------------------
!CHECK: define ptr @red_init(ptr noalias %0, ptr noalias %1) #2 {
!CHECK: entry:
!CHECK: store i32 0, ptr %0, align 4
!CHECK: ret ptr %0
!CHECK: }

!CHECK: define ptr @red_comb(ptr %0, ptr %1) #2 {
!CHECK: entry:
!CHECK: %2 = load i32, ptr %0, align 4
!CHECK: %3 = load i32, ptr %1, align 4
!CHECK: %4 = add i32 %2, %3
!CHECK: store i32 %4, ptr %0, align 4
!CHECK: ret ptr %0
!CHECK: }

!===-------------- Pass by reference ----------------------
!CHECK-REF: define void @red_init(ptr noalias %0, ptr noalias %1) #2 {
!CHECK-REF: entry:
!CHECK-REF: %2 = alloca ptr, align 8
!CHECK-REF: %3 = alloca ptr, align 8
!CHECK-REF: store ptr %0, ptr %2, align 8
!CHECK-REF: store ptr %1, ptr %3, align 8
!CHECK-REF: %4 = load ptr, ptr %2, align 8
!CHECK-REF: store i32 0, ptr %4, align 4
!CHECK-REF: ret void
!CHECK-REF: }

!CHECK-REF: define void @red_comb(ptr %0, ptr %1) #2 {
!CHECK-REF: entry:
!CHECK-REF: %2 = alloca ptr, align 8
!CHECK-REF: %3 = alloca ptr, align 8
!CHECK-REF: store ptr %0, ptr %2, align 8
!CHECK-REF: store ptr %1, ptr %3, align 8
!CHECK-REF: %4 = load ptr, ptr %2, align 8
!CHECK-REF: %5 = load ptr, ptr %3, align 8
!CHECK-REF: %6 = load i32, ptr %4, align 4
!CHECK-REF: %7 = load i32, ptr %5, align 4
!CHECK-REF: %8 = add i32 %6, %7
!CHECK-REF: store i32 %8, ptr %4, align 4
!CHECK-REF: ret void
!CHECK-REF: }
subroutine test_task_reduction()
 integer :: x

 !$omp taskgroup task_reduction(+:x)
   !$omp task
     x = x + 1
   !$omp end task
 !$omp end taskgroup
end subroutine
