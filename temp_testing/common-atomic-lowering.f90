program sample

integer :: x
integer, dimension(5) :: y
integer :: a, b

!$omp atomic update
  y(2) =  (8 + x) * y(2)
!$omp end atomic

!$omp atomic update
  y(2) =  y(2) / 8
!$omp end atomic

!$omp atomic update
  x =  (8 + y(4)) + x
!$omp end atomic

!$omp atomic update
  x =  8 - x
!$omp end atomic

end program sample
