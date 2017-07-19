###############################################################################
#
#       Exercise:  Deadlock
#       
#       In this example, each rank 
#       i) receives a message from the rank below it
#      ii) sends a message to the rank above it.
#     iii) Rank 0 sends to rank N-1, and rank N-1 receives from rank 0
#       Execution completes when process 0 receives from the highest rank.
#       Note the modified logic for rank 0 and the maximum rank
#     iv)  Each process stores its collected tokens in a list and prints the list contents at the end
#
#     Exercise:  break the deadlock that causes this program to hang.
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

    stoken = my_rank*2
    rtoken = 0
    tokens = []

    right = my_rank -1
    left  = my_rank+1
    
    if (left > num_proc-1):
        left = 0
    if (right < 0):
        right =num_proc-1
    for i in range(num_proc):
        if (my_rank%2 == 0):
            my_source = left
            my_tag = left
            rtoken = comm.recv(source=my_source, tag=my_tag) 
            tokens.append(rtoken)

            my_dest = right
            my_tag = my_rank
            comm.send(stoken, dest=my_dest, tag=my_tag)
            stoken=rtoken
        else:
            my_dest = right
            my_tag = my_rank
            comm.send(stoken, dest=my_dest, tag=my_tag)
            stoken=rtoken

            my_source = left
            my_tag = left
            rtoken = comm.recv(source=my_source, tag=my_tag) 
            tokens.append(rtoken)
            stoken = rtoken
    rstr=str(my_rank)
    print 'Rank '+rstr+' has finished.  Tokens are:', tokens


    MPI.Finalize()
main()

