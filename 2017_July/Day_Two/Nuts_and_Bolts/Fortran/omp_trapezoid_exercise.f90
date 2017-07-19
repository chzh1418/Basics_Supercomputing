PROGRAM MAIN
    USE OMP_LIB   
    IMPLICIT NONE
    REAL*8  :: myal, xone,xtwo, answer
    INTEGER :: i, ntrap, ntests, nthread
    CHARACTER*8 :: thread_string
    

    ntests = 2
    ntests = 1000  !Uncomment this line once your code is working correctly.
    ntrap = 1000000

    xone = 1.0
    xtwo = 2.0

    ! The small parallel region below is used to check on how many
    ! threads we specified with OMP_NUM_THREADS

    !$OMP PARALLEL 
    nthread = omp_get_num_threads()
    !$OMP END PARALLEL

    Write(thread_string,'(i8)')nthread
    Write(6,*)"  Calculating the integral of f(x) = x^3 from 1.0 to 2.0."
    Write(6,*)"  10,000 times, using 1,000,000 trapezoids and " &
        & //trim(adjustl(thread_string))//" threads."

    Do i = 1, ntests
        answer = trapezoid_int(xone,xtwo,ntrap);
    Enddo
    Write(6,*)"  The integral is: ", answer

Contains

Function myfunc(x) result(xcubed)
    Real*8, Intent(In) :: x
    Real*8 :: xcubed
    xcubed = x*x*x
End Function myfunc

Function trapezoid_int(a,b,ntrap) result(integral)
    !Integrates f(x) from a to b
    Real*8, Intent(In)  :: a, b
    Integer, Intent(In) :: ntrap
    Real*8 :: integral, h, val, x
    Integer :: i

    h = (b-a)/(ntrap-1) ! step size

    val = myfunc(a)
    integral = 0.5*val
    val = myfunc(b)
    integral = integral+0.5*val  ! add the endpoints


    ! Uncomment the OMP directives below to enable OpenMP parallelism for this loop
    ! Consider which variables should be private, shared, and reduced.
    ! Fill in the ()'s accordingly
    !!$OMP PARALLEL DO private() shared() reduction(+:)
    DO i = 1, ntrap-2
        x = a+i*h
        integral = integral+myfunc(x)
    Enddo
    !!$OMP END PARALLEL DO

    integral = integral*h
End Function trapezoid_int
END PROGRAM MAIN

