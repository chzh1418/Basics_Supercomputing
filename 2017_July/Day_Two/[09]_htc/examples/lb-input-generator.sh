#!/bin/bash

for input in data/input_{0..9}.csv
do
    echo >>lb_cmd_file \
      "wc -l ${input} >$(basename ${input})-lines"
done
