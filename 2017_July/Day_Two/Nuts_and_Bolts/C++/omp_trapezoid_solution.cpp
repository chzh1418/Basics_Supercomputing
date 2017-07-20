#include <stdio.h>
#include <omp.h>
double myfunc(double x) {
    return x*x*x;
}

double trapezoid_int(double a, double b, int ntrap) {
    // Integrates f(x) from a to b
    double integral;
    double h;
    double val;
    double x;
    int i;
    h = (b-a)/(ntrap-1); // step size

    val = myfunc(a);
    integral = 0.5*val;
    val = myfunc(b);
    integral = integral+0.5*val;  // add the endpoints



    #pragma omp parallel for private(i,x) shared(h,ntrap) reduction(+:integral)
    for (i=1; i<ntrap-1; ++i)
    {
        x = a+i*h;
        integral = integral+myfunc(x);
    }
    
    integral = integral*h;
    return integral;
}



int main(int argc, char** argv) {
    // Print a hello world message from the main thread.
    double myval;
    double xone;
    double xtwo;
    double answer;
    int ntrap;
    int ntests;
    int nthread;

    ntests = 2;
    ntrap = 10000000;
    //ntests = 1000; //uncomment this line once your code is working correctly


    xone = 1.0;
    xtwo = 2.0;

    // The small parallel region below is used to check on how many
    // threads we specified with OMP_NUM_THREADS
    #pragma omp parallel
    {
        nthread = omp_get_num_threads();
    }
    printf("  Calculating the integral of f(x) = x^3 from %f to %f\n",xone,xtwo);
    printf("  %d times, using %d trapezoids and %d threads.\n", ntests, ntrap, nthread);
    for (int i=0; i<ntests; ++i)
    {
        answer = trapezoid_int(xone,xtwo,ntrap);
    }


    
    printf("  The integral is %f.\n", answer);

}

