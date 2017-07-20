#!/bin/bash


module purge
module load intel impi
module load loadbalance

mpirun lb lb_cmd_file
