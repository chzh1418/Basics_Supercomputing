
! SOLUTION:  Ring-communication without deadlock
PROGRAM iring

  USE mpi

  IMPLICIT NONE

  INTEGER, PARAMETER :: dp = KIND(1.0d0)

  INTEGER, PARAMETER     :: N = 10000
  INTEGER, PARAMETER     :: RINGTAG = 10
  INTEGER                :: ierr
  INTEGER                :: cnt
  INTEGER                :: nprocs
  INTEGER                :: id
  INTEGER                :: j
  INTEGER                :: left
  INTEGER                :: right
  REAL(dp), ALLOCATABLE  :: x(:)

  CALL MPI_Init(ierr)
  CALL MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, id, ierr)
  IF (id == 0) THEN
     PRINT *, "Running on ", nprocs, "MPI processes!"
  END IF
  ALLOCATE(x(N*nprocs))
  x(:) = id
  left = id + 1
  right = id - 1
  IF (left > nprocs - 1) THEN
     left = 0
  END IF
  IF (right < 0) THEN
     right = nprocs-1
  END IF
  cnt = 1
  DO j = 1, nprocs - 1
     IF (MOD(id,2) .eq. 0) THEN
        ! Even ranks post a receive first, followed by a send
         CALL MPI_Recv(x(cnt+N), N, MPI_DOUBLE_PRECISION, &
              & right, ringtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
         CALL MPI_Send(x(cnt), N, MPI_DOUBLE_PRECISION, &
              &  left, ringtag, MPI_COMM_WORLD, ierr)
     ELSE
        ! Odd ranks post a send first, followed by a receive to prevent deadlock
         CALL MPI_Send(x(cnt), N, MPI_DOUBLE_PRECISION, &
              &  left, ringtag, MPI_COMM_WORLD, ierr)
         CALL MPI_Recv(x(cnt+N), N, MPI_DOUBLE_PRECISION, &
              & right, ringtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
     ENDIF
     cnt = cnt + N
  END DO

  PRINT *, '[', id, ']', ' My answer is', SUM(x)

  DEALLOCATE(x)
  CALL MPI_finalize(ierr)

END PROGRAM iring

