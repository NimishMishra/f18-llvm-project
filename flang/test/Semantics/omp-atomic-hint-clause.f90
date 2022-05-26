program sample
    use omp_lib
    integer :: x, y
    !$omp atomic hint(1) write
        y = 2
    !$omp atomic read hint(2)
        y = x
    ! one test case for wrong value of hint: on the left, right, and on normal atomic update
    !$omp atomic hint(3)
        y = y + 10
    !$omp atomic read hint(5)
        y = x
    !$omp atomic hint(7) write
        y = 10 + x
    ! one test case for non-constant hint
    !$omp atomic update hint(x)
        y = y * 1
end program
