! RUN: %flang_fc1 -emit-fir -finit-integer=20 -o - %s | FileCheck %s

subroutine initialized_integer
!CHECK: %[[load:.*]] = fir.address_of(@_QFinitialized_integerEx) : !fir.ref<i32>
!CHECK: %[[x_decl:.*]] = fir.declare %[[load]] {uniq_name = "_QFinitialized_integerEx"} : (!fir.ref<i32>) -> !fir.ref<i32>
  integer :: x = 10
end subroutine

subroutine uninitialized_integer
!CHECK: %[[const:.*]] = arith.constant 20 : i32
!CHECK: %[[y_alloca:.*]] = fir.alloca i32 {bindc_name = "y", uniq_name = "_QFuninitialized_integerEy"}
!CHECK: %[[y_decl:.*]] = fir.declare %[[y_alloca]] {uniq_name = "_QFuninitialized_integerEy"} : (!fir.ref<i32>) -> !fir.ref<i32>
!CHECK: fir.store %[[const]] to %[[y_decl]] : !fir.ref<i32>
  integer :: y
end subroutine

!CHECK: fir.global internal @_QFinitialized_integerEx : i32 {
!CHECK: %[[const:.*]] = arith.constant 10 : i32
!CHECK: fir.has_value %[[const]] : i32
!CHECK: }
