#!/bin/bash
#SBATCH --nodes=1				# Number of requested nodes
#SBATCH --time=0:01:00				# Max walltime
#SBATCH --qos=crestone				# Specify crestone QOS
#SBATCH --partition=crc-serial			# Specify crestone nodes
#SBATCH --output=R_code_%j.out			# Output file name
#SBATCH --reservation=basics17			# Reservation (only valid during workshop)

# purge all existing modules
module purge

# Load the R module
module load R/3.3.0

# Run R Script
Rscript R_program.R
