! RUN: %python %S/../test_errors.py %s %flang_fc1 -fopenmp
! Semantics checks on user defined operators on atomic update statement

module overload_asterisk
    implicit none
    private
    public operator (*)

    interface operator(*)
        module procedure logical_and
    end interface

contains
    pure logical function logical_and(log1, log2)
        logical, intent(in) :: log1, log2

        logical_and = (log1 .and. log2)
    end function
end module

module new_operator
    implicit none
    private
    public operator(.MYOPERATOR.)

    interface operator(.MYOPERATOR.)
       module procedure myprocedure
    end interface
contains
    pure integer function myprocedure(param1, param2)
        integer, intent(in) :: param1, param2
        myprocedure = param1 + param2
    end function
end module

program sample
    use omp_lib
    use overload_asterisk
    use new_operator
    implicit none

    logical  :: T = .true., F = .false.
    integer :: x, y 
     
    !$omp atomic update
        x = x * y
   

    !$omp atomic
    !ERROR: User defined operator not allowed in OpenMP ATOMIC (UPDATE) statement
        x = x .MYOPERATOR. y
end program
