###############################################################################
#
#       Example:  Message passing
#       
#       Ranks 0 and num_proc -1 exchange the value of the stoken variable
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

    stoken = 3*my_rank+1
    roken =-1
    if (my_rank == num_proc-1):
        my_dest = 0
        my_tag = my_rank
        comm.send(stoken, dest=my_dest, tag=my_tag)

        my_source = 0
        my_tag = 0
        rtoken = comm.recv(source=my_source, tag=my_tag)
        sys.stdout.write(
            " Rank %d has received the token %d from rank %d.\n"%(my_rank,rtoken,my_source))

    if (my_rank == 0):


        my_source = num_proc-1
        my_tag = num_proc-1
        rtoken = comm.recv(source=my_source, tag=my_tag)       
        sys.stdout.write(
            " Rank %d has received the token %d from rank %d.\n"%(my_rank,rtoken,my_source))

        my_dest = num_proc-1
        my_tag = my_rank
        comm.send(stoken, dest=my_dest, tag=my_tag)


    MPI.Finalize()
main()

