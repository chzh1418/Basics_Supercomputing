#include <stdio.h>
#include <omp.h>

int main(int argc, char** argv) {

    printf("  Hello world from the only processor here so far!\n");

    #pragma omp parallel
    {
        int thread_id;
        int num_threads;

        thread_id = omp_get_thread_num();
        num_threads = omp_get_num_threads();
        if (num_threads > 1)
        {
            if (thread_id == 0)
            {
                printf("  %d threads are now active.\n", num_threads);
            }

            // The new feature here is the use of "BARRIER," useful
            // for synchronizing thread activity.  Execution of the parallel 
            // region pauses at the barrier and resumes once all threads have
            // reached the barrier.

            #pragma omp barrier

            // Consider the loop below.  Where can we place another barrier to ensure
            // that the threads print their 'hello' in ascending order based on thread ID? 
            for (int i=0; i<num_threads; ++i)
            {
                if (thread_id == i)
                {
                    printf("  Hello world from thread %d.\n",thread_id);
                }
            }

        }

    }
}

