program main
 
  integer(1) :: x(10)
  integer :: idx(10)
  integer :: i, n 
  !$omp atomic update 
    x(i) = x(i) + n  
  !$omp end atomic
  
end program main
