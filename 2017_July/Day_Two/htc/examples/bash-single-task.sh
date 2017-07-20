#!/bin/bash

module purge
module load python

time python matrix-multiply.py data/input_0.csv
