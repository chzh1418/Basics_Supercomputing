##################################################################
#
#       Example:  Reduction
#       
#       This example demonstrates reduction usage in MPI.
#       Each process performs a partial integral.  Results are
#       summed across processes to produce an estimate of Pi.
def f(a):
    return 4.0/(1.0 + a*a)

def main():
    """
    Parallel Hello World
    """

    from mpi4py import MPI  #importing MPI initializes the MPI library (similar to MPI_Init)
    import sys

    # The program is now running parallel
    num_proc  = MPI.COMM_WORLD.Get_size() # The number of processes
    my_rank   = MPI.COMM_WORLD.Get_rank() # The rank of this process (ranges from 0 to num_proc-1)
    node_name = MPI.Get_processor_name()  # The name of the node
    comm = MPI.COMM_WORLD
    
    pi25dt = 3.141592653589793238462643
    if (my_rank == 0):
        sys.stdout.write(
        "  %d MPI processes are now active.\n"
        % (num_proc))

        sys.stdout.flush()

    sys.stdout.write(
        "  Hello from node %s, rank %d out of %d processes.\n"
        % (node_name, my_rank, num_proc))
    sys.stdout.flush()

    comm.Barrier()

    if (my_rank == 0):
        nstr = input('Enter number of intervals: ')
        n = int(nstr)
    else:
        n = None

    n = comm.bcast(n, root=0)


    h = 1.0/n
    mysum = 0.0
    for i in range(my_rank+1,n+1,num_proc):
        x = h*( float(i) - 0.5 )
        mysum += f(x)
    global_sum=comm.allreduce(mysum)
    pi = h*global_sum
    pi_err = abs(pi-pi25dt)
    if (my_rank == 0):
        sys.stdout.write(
            "  pi is approximately %f, Error is %f.\n"
            % (pi, pi_err))
        sys.stdout.flush()
    # Once we're finished, we call Finalize
    # No further calls to MPI can be made once MPI_Finalize is invoked.
    MPI.Finalize()
main()

