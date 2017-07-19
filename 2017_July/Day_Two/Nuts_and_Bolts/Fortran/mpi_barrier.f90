PROGRAM MAIN
	Implicit None
    include "mpif.h"
	Character*8 :: rank_string, nproc_string
    Character(MPI_MAX_PROCESSOR_NAME) :: node_name
    Integer :: i, ierr, num_proc, my_rank, name_len

    Call MPI_INIT( ierr )
    Call MPI_Comm_size(MPI_COMM_WORLD, num_proc,ierr)
    Call MPI_Comm_rank(MPI_COMM_WORLD, my_rank,ierr)
    Call MPI_Get_processor_name(node_name, name_len,ierr)


    Write(rank_string,'(i8)')my_rank
    Write(nproc_string,'(i8)')num_proc

    If (my_rank .eq. 0) Then
        Write(6,*)"  "//trim(adjustl(nproc_string))//" MPI Pprocesses are now active."
    Endif
    ! As with OpenMP, MPI has a barrier function useful
    ! for synchronizing thread activity.  Execution of the parallel 
    ! region pauses at the barrier and resumes once all threads have
    ! reached the barrier.
    Call MPI_BARRIER(MPI_COMM_WORLD,ierr)

    ! Consider the loop below.  Where can we place another call to mpi_barrier to ensure
    ! that the MPI tasks print their 'hello' in ascending order based on rank? 
    Do i = 0, num_proc
        If (my_rank .eq. i) Then
            Write(6,*)"  Hello from node "//trim(node_name)//" rank "// &
                & trim(adjustl(rank_string))//" out of "//trim(adjustl(nproc_string))//" processors." 
        Endif
        Call MPI_BARRIER(MPI_COMM_WORLD,ierr)
    Enddo
    Call MPI_Finalize(ierr)
END PROGRAM MAIN










