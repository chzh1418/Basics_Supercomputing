###############################################################################
#
#       Exercise:  Message passing
#       
#       Modify this code so that each rank 
#       i) receives a message from the rank above it
#      ii) sends a message to the rank below it.
#       Execution completes when the highest rank receives from process 0


def main():
    """
    Python, mpi4py parallel hello world.
    """

    from mpi4py import MPI
    import sys

    num_proc  = MPI.COMM_WORLD.Get_size()
    my_rank   = MPI.COMM_WORLD.Get_rank()
    node_name = MPI.Get_processor_name()
    comm = MPI.COMM_WORLD

    if (my_rank == 0):
        sys.stdout.write("  %d MPI Processes are now active.\n" %(num_proc))
    comm.Barrier()

    token = my_rank

    if (my_rank < (num_proc-1)):
        my_source = my_rank+1
        my_tag = my_rank+1
        token = comm.recv(source=my_source, tag=my_tag)

    if (my_rank > 0):
        my_dest = my_rank-1
        my_tag = my_rank
        comm.send(token, dest=my_dest, tag=my_tag)

    if (my_rank == (num_proc-1)):
        my_source = 0
        my_tag = 0
        token = comm.recv(source=my_source, tag=my_tag)       
        sys.stdout.write(
            "  Token pass complete!\n")
    if(my_rank == 0):
        my_dest = num_proc-1
        my_tag = my_rank
        comm.send(token, dest=my_dest, tag=my_tag)
    MPI.Finalize()
main()

