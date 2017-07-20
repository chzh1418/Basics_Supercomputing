#!/bin/bash
#SBATCH --array 0-9
#SBATCH --output slurm-array-%A.%a.out

echo "Master job id: ${SLURM_ARRAY_JOB_ID}"
echo "Array index: ${SLURM_ARRAY_TASK_ID}"
