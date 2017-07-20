PROGRAM MAIN
    USE OMP_LIB   
    IMPLICIT NONE
    INTEGER     :: thread_id, num_threads
    CHARACTER*8 :: thread_string


    Write(6,*)"  Hello from the only process here so far!"

    !Remember that everything out here is run in serial mode...

    !$OMP PARALLEL private( thread_string, num_threads, thread_id)

    ! Note the use of the "private" clause above.  Each thread receives 
    ! its own copy of every variable inside the parenthesis. 
    ! Why does this matter?  Try removing thread_id from the list above 
    ! and see what happens.

    thread_id = omp_get_thread_num()

    ! In addition to the thread ID, we can find the total number 
    ! of threads active at any given time.  We store this in num_threads.  
    ! Typically, this is the value of the shell environment variable $OMP_NUM_THREADS,
    ! though users can control the number of threads active via OMP pragmas and functions. 

    num_threads = omp_get_num_threads()
    If (num_threads .gt. 1) Then
        !We might have regions of the code that we only execute if more than one thread is running.

        If (thread_id .eq. 0) Then
            !Sometimes we might like for only a single thread to report certain information.
            !This avoids redundant output.
            Write(thread_string,'(i8)')num_threads
            Write(6,*)"  "//trim(adjustl(thread_string))//" threads are now active."
        Endif

        Write(thread_string,'(i8)')thread_id
        Write(6,*)"  Hello from thread "//trim(adjustl(thread_string))//"."

    Endif

    !$OMP END PARALLEL

END PROGRAM MAIN
