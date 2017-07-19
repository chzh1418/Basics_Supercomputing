#include <stdio.h>
#include <omp.h>

int main(int argc, char** argv) {
    int thread_id;
    int num_threads;

    printf("  Hello world from the only processor here so far!\n");

    //Remember that everything out here is run in serial mode...

    #pragma omp parallel private( num_threads, thread_id)
    {
        // Note the use of the "private" clause above.  Each thread receives 
        // its own copy of every variable inside the parenthesis. 
        // Why does this matter?  Try removing thread_id from the list above 
        // and see what happens.


        thread_id = omp_get_thread_num();

        // In addition to the thread ID, we can find the total number 
        // of threads active at any given time.  We store this in num_threads.  
        // Typically, this is the value of the shell environment variable $OMP_NUM_THREADS,
        // though users can control the number of threads active via OMP pragmas and functions. 
        num_threads = omp_get_num_threads();
        if (num_threads > 1)
        {
            //We might have regions of the code that we only execute if more than one thread is active.
            if (thread_id == 0)
            {
            //Sometimes we might like for only a single thread to report certain information.
            //This avoids redundant output.
                printf("  %d threads are now active.\n", num_threads);
            }
            printf("  Hello world from thread %d.\n",thread_id);
        }

    }
}

