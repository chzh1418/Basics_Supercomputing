/*
 *  Copyright (C) 2015  Timothy Brown
 *
 *  Modified by Nick Featherstone 2017
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <err.h>
#include <mpi.h>

int
main(int argc, char **argv)
{
	int ierr   = 0;			/* Error status                     */
	int rank   = 0;			/* MPI rank                         */
	int nprocs = 0;			/* MPI number of processors         */
	int rtag   = 10;		/* MPI tag for the ring             */
	int i      = 0;			/* Indexer                          */
	int N      = 0;			/* Array size                       */
	int left   = 0;			/* Left neighbour rank              */
	int right  = 0;			/* Right neighbour rank             */
	int offset = 0;			/* Offset into data array           */
	int *data  = NULL;		/* Data array                       */
	int total  = 0;			/* Total of the data array          */
    MPI_Request reqs[2];    /* Array of interrupt requests used for send and receive */
    MPI_Status mstat[2];   /* Status array used for MPI Wait-All /*

	/* Initialize MPI */
	ierr = MPI_Init(NULL, NULL);

	/* Find out our rank and total number of processors */
	ierr = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

	/*  Only the root rank reads the command line arguments */
	if (rank == 0) {
        N = 10000;
		if (N <= 0) {
			warnx("Will not run with negative array size.");
			MPI_Abort(MPI_COMM_WORLD, ierr);
		}
		printf("Running on %d processors.\nWith %d elements.\n", nprocs,
		       N * nprocs);
	}

	/* Broadcast the data array size */
	ierr = MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);

	/* Allocate the data array */
	data = malloc(N * nprocs * sizeof(int));

	if (!data) {
		warnx("Unable to allocate: %lu", N * nprocs * sizeof(int));
		MPI_Abort(MPI_COMM_WORLD, ierr);
	}

	/* Initialize the data array to contain my rank number */
	for (i = 0; i < N * nprocs; ++i) {
		data[i] = rank;
	}

	/* Figure out my neighbours */
	left  = rank + 1;
	right = rank - 1;

	/* Create periodic boundry conditions */
	if (left > nprocs -1) left  = 0;
	if (right < 0)        right = nprocs - 1;

	/* Send/Receive for all processors */
	offset = 0;
	for (i = 0; i < nprocs -1; ++i) {

	    ierr = MPI_Isend(&(data[offset]), N, MPI_INT, left,
			    rtag, MPI_COMM_WORLD, &reqs[0]);
	    offset += N;
	    ierr = MPI_Irecv(&(data[offset]), N, MPI_INT, right,
			    rtag, MPI_COMM_WORLD, &reqs[1]);
        ierr = MPI_Waitall(2, reqs, mstat);
	}

	/* Sum our data array */
	for (i = 0; i < N * nprocs; ++i) {
		total += data[i];
	}

	printf("[%02d] Total is: %d\n", rank, total);

	/* Free the data array */
	if (data) {
		free(data);
		data = NULL;
	}

	/* Finalize MPI and exit */
	ierr = MPI_Finalize();

	return(EXIT_SUCCESS);
}
