#!/bin/bash
#SBATCH --nodes=1				# Number of requested nodes
#SBATCH --time=0:01:00				# Max walltime
#SBATCH --qos=crestone				# Specify crestone QOS
#SBATCH --partition=crc-serial			# Specify crestone nodes
#SBATCH --output=sleep_%j.out			# Rename standard output file
#SBATCH --job-name=sleep			# Job submission name
#SBATCH --mail-type=end				# Email you when the job ends 
###SBATCH --mail-user=<user>@colorado.edu	# Email address to send to	
#SBATCH --reservation=basics17                  # Reservation (only valid during workshop)


# Written by:   Shelley Knuth
# Date:         15 July 2016
# Updated:      3 May 2017
# Purpose:      To demonstrate how to run a batch job on RC resources


# purge all existing modules
module purge

whoami
sleep 30
hostname
