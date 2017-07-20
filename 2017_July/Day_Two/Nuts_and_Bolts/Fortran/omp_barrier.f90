PROGRAM MAIN
    USE OMP_LIB   
    IMPLICIT NONE
    INTEGER     :: thread_id, num_threads, i
    CHARACTER*8 :: thread_string


    Write(6,*)"  Hello from the only process here so far!"

    !$OMP PARALLEL private(i,thread_id, thread_string, num_threads)


    thread_id = omp_get_thread_num()
    num_threads = omp_get_num_threads()
    If (num_threads .gt. 1) Then

        If (thread_id .eq. 0) Then
            Write(thread_string,'(i8)')num_threads
            Write(6,*)"  "//trim(adjustl(thread_string))//" threads are now active."
        Endif

        ! The new feature here is the use of "BARRIER," useful
        ! for synchronizing thread activity.  Execution of the parallel 
        ! region pauses at the barrier and resumes once all threads have
        ! reached the barrier.

        !$OMP BARRIER
        Write(thread_string,'(i8)')thread_id

        ! Consider the loop below.  Where can we place another barrier to ensure
        ! that the threads print their 'hello' in ascending order based on thread ID? 
        Do i = 0, num_threads-1
            If (thread_id .eq. i) Then
                Write(6,*)"  Hello from thread "//trim(adjustl(thread_string))//"."
            Endif
        Enddo

    Endif

    !$OMP END PARALLEL

END PROGRAM MAIN
