#!/bin/bash

#SBATCH --job-name htc-exercise2-lb
#SBATCH --ntasks 10
#SBATCH --output htc-exercise2-%j.out
#SBATCH --time 00:02:00

module purge
module load python
module load intel impi
module load loadbalance

(
    for input in data/input_{0..9}.csv
    do
        output="htc-exercise2-${SLURM_JOB_ID}-$(basename ${input%.csv}).out"
        echo "python matrix-multiply.py ${input} >${output}"
    done
) >lb_cmd_file-${SLURM_JOB_ID}

time mpirun lb lb_cmd_file-${SLURM_JOB_ID}
