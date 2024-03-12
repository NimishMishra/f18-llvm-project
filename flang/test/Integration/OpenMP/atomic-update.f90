!===----------------------------------------------------------------------===!
! This directory can be used to add Integration tests involving multiple
! stages of the compiler (for eg. from Fortran to LLVM IR). It should not
! contain executable tests. We should only add tests here sparingly and only
! if there is no other way to test. Repeat this message in each test that is
! added to this directory and sub-directories.
!===----------------------------------------------------------------------===!

!RUN: %flang_fc1 -emit-llvm -fopenmp %s -o - | FileCheck %s


!CHECK: omp.par.entry:
!CHECK: %[[GEP:.*]] = getelementptr { ptr }, ptr {{.*}}, i32 0, i32 0
!CHECK: %[[LOADGEP:.*]] = load ptr, ptr %[[GEP]], align 8
!CHECK: %[[TID_ADDR_LOCAL:.*]] = alloca i32, align 4
!CHECK: %[[VAL_1:.*]] = load i32, ptr {{.*}}, align 4
!CHECK: store i32 %[[VAL_1]], ptr %[[TID_ADDR_LOCAL]], align 4
!CHECK: %[[TID:.*]] = load i32, ptr %[[TID_ADDR_LOCAL]], align 4
!CHECK: br label %omp.par.region

!CHECK: omp.par.region:
!CHECK: br label %omp.par.region1

!CHECK: omp.par.region1:
!CHECK: %omp_global_thread_num2 = call i32 @__kmpc_global_thread_num(ptr @1)
!CHECK: void @__kmpc_critical(ptr @1, i32 %omp_global_thread_num2, ptr @.gomp_critical_user_.var)
!CHECK: %[[VAL_2:.*]] = load { float, float }, ptr %[[LOADGEP]], align 4
!CHECK: %[[VAL_3:.*]] = extractvalue { float, float } %[[VAL_2]], 0
!CHECK: %[[VAL_4:.*]] = extractvalue { float, float } %[[VAL_2]], 1
!CHECK: %[[VAL_5:.*]] = fadd contract float %[[VAL_3]], 1.000000e+00
!CHECK: %[[VAL_6:.*]] = fadd contract float %[[VAL_4]], 1.000000e+00
!CHECK: %[[VAL_7:.*]] = insertvalue { float, float } undef, float %[[VAL_5]], 0
!CHECK: %[[VAL_8:.*]] = insertvalue { float, float } %[[VAL_7]], float %[[VAL_6]], 1
!CHECK: store { float, float } %[[VAL_8]], ptr %[[LOADGEP]], align 4
!CHECK: call void @__kmpc_end_critical(ptr @1, i32 %omp_global_thread_num2, ptr @.gomp_critical_user_.var)
subroutine complex_type
   complex*8 ia

   !$omp parallel
     !$omp atomic
       ia = ia + (1, 1)
   !$omp end parallel
end subroutine



subroutine pointer_type
   implicit none
   integer, pointer :: x
   integer, target :: y
   real, target :: z
   x => y

!CHECK: %omp_global_thread_num = call i32 @__kmpc_global_thread_num(ptr @1)
!CHECK: call void @__kmpc_critical(ptr @1, i32 %omp_global_thread_num, ptr @.gomp_critical_user_.var)
!CHECK: %[[VAL_13:.*]] = load i32, {{.*}}, align 4
!CHECK: %[[VAL_14:.*]] = sitofp i32 %[[VAL_13]] to float
!CHECK: %[[VAL_15:.*]] = fadd contract float %[[VAL_14]], {{.*}}
!CHECK: %[[VAL_16:.*]] = fptosi float %[[VAL_15]] to i32
!CHECK: store i32 %[[VAL_16]], ptr {{.*}}, align 4
!CHECK: call void @__kmpc_end_critical(ptr @1, i32 %omp_global_thread_num, ptr @.gomp_critical_user_.var)
   !$omp atomic update
      x = x + z
end subroutine
