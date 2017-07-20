!**********************************************************************
!   compute pi by integrating f(x) = 4/(1 + x**2)     
!   OpenMP-assisted calculation of Pi
!
!  Variables:
!
!    pi  the calculated result
!    n   number of points of integration.  
!    x           midpoint of each rectangle's interval
!    f           function to integrate
!    sum,pi      area of rectangles
!    tmp         temporary scratch space for global summation
!    i           do loop index
!****************************************************************************
PROGRAM pi_omp

  USE OMP_LIB

  INTEGER, parameter :: dp = kind(1.0d0)
  REAL(dp)::  PI25DT = 3.141592653589793238462643d0

  REAL(dp) ::  pi, h, sum, x, f, a
  INTEGER :: n, i, rc
  !                                 function to integrate
  f(a) = 4.d0 / (1.d0 + a*a)


  sizetype   = 1
  sumtype    = 2


     WRITE(6,98)
98   FORMAT('Enter the number of intervals:')
     READ(5,99) n
99   FORMAT(i10)



  !                                 calculate the interval size
  h = 1.0d0/n

  sum  = 0.0d0
  !$OMP PARALLEL DO PRIVATE(i,x) SHARED(n) REDUCTION(+:sum)
  DO i = 1, n
     x = h * (DBLE(i) - 0.5d0)
     sum = sum + f(x)
  ENDDO
  !$OMP END PARALLEL DO
  pi = h * sum





     WRITE(6, 97) pi, ABS(pi - PI25DT)
97   FORMAT('  pi is approximately: ', F18.16, &
          '  Error is: ', F18.16)




END PROGRAM pi_omp




