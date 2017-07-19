##################################################################
#
#       Exercise:  Synchronization
#       
#       Place an additional call to barrier into the code below so that
#       processes print their ID's to the screen in ascending order.
def main():

    from mpi4py import MPI
    import sys

    num_proc  = MPI.COMM_WORLD.Get_size()
    my_rank   = MPI.COMM_WORLD.Get_rank()
    node_name = MPI.Get_processor_name()
    comm = MPI.COMM_WORLD

    if (my_rank == 0):
        sys.stdout.write("  %d MPI Processes are now active.\n" %(num_proc))

    # As with OpenMP, MPI has a barrier function useful
    # for synchronizing thread activity.  Execution of the parallel 
    # region pauses at the barrier and resumes once all threads have
    # reached the barrier.
    comm.Barrier()

    # Consider the loop below.  Where can we place another call to barrier to ensure
    # that the MPI tasks print their 'hello' in ascending order based on rank? 
    for i in range(num_proc):
        if (i == my_rank):
            sys.stdout.write(
                "  Hello from node %s, rank %d out of %d processes.\n"
                % (node_name, my_rank, num_proc))

    MPI.Finalize()
main()

