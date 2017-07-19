####################################################################3
#
#       Example:   Reduction
#
#       We often need to know some aspect of a global distributed dataset.
#       For instance, we might wish to compute the sum of the data values, 
#       the minimimum data value, or the maximum data value.  When using MPI,
#       this can be easily accomplished through the reduction method.


def main():
    """
    Python, mpi4py parallel hello world.
    """

    from mpi4py import MPI
    import sys
    import numpy as np

    num_proc  = MPI.COMM_WORLD.Get_size()
    my_rank   = MPI.COMM_WORLD.Get_rank()
    node_name = MPI.Get_processor_name()
    comm = MPI.COMM_WORLD

    if (my_rank == 0):
        sys.stdout.write("  %d MPI Processes are now active.\n" %(num_proc))
        sys.stdout.flush()
    comm.Barrier()


    # Create some data -- simple sine wave
    two_pi = 2.0*np.pi
    nx = 1024
    dx = two_pi/nx
    x = np.zeros(nx,dtype='float64')
    y = np.zeros(nx,dtype='float64')
    kx = two_pi/(1.0+my_rank)  # each process has a different wavenumber
    amp = (1.0+my_rank)        # and a different amplitude
    for i in range(nx):
        x[i] = i*dx
        y[i] = amp*np.sin(x[i]*kx)


    #Evaluate the sum, min, and max locally
    local_sum = np.sum(y)
    local_max = np.max(y)
    local_min = np.min(y)


    #Print the local values
    comm.Barrier()
    for i in range(num_proc):
        if (i == my_rank):
            if (i == 0):
                sys.stdout.write("\n\n")
                sys.stdout.write("            Local Results\n")
            sys.stdout.write(
                "  Rank %d reports (MIN, MAX, SUM): %f, %f, %f.\n"
                % (my_rank, local_min, local_max, local_sum))
            sys.stdout.flush()
        comm.Barrier()

    #Create variables to hold the global sum,min, and max
    global_sum = np.ndarray(1,dtype='float64')
    global_min = np.ndarray(1,dtype='float64')
    global_max = np.ndarray(1,dtype='float64')

    #Peform the reductions
    comm.Allreduce([local_sum, MPI.DOUBLE], [global_sum,MPI.DOUBLE], op=MPI.SUM)
    comm.Allreduce([local_min, MPI.DOUBLE], [global_min,MPI.DOUBLE], op=MPI.MIN)
    comm.Allreduce([local_max, MPI.DOUBLE], [global_max,MPI.DOUBLE], op=MPI.MAX)

    comm.Barrier()
    for i in range(num_proc):
        if (i == my_rank):
            if (i == 0):
                sys.stdout.write("\n\n")
                sys.stdout.write("            Global Results\n")
            sys.stdout.write(
                "  Rank %d reports (MIN, MAX, SUM): %f, %f, %f.\n"
                % (my_rank, global_min, global_max, global_sum))
            sys.stdout.flush()
        comm.Barrier()
    MPI.Finalize()
main()
