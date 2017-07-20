Submit `bash-multiple-background-tasks.sh` as a Slurm job array. Each
array task should execute a single `matrix-multiply.py` process, and
write to a separate output file.


## Tips

* You may need to `module load python` to get access to Python "numpy"
  for use in `matrix-multiply.py`.
* Use `sbatch` to submit a Slurm job (and run `man sbatch` for help on
  the options available).
* You may prefer to update `bash-multiple-tasks.sh` with embedded
  `#SBATCH` directives.
* Request `--ntasks 1` since we'll only be running one task per array
  index.
* Specify a 1-minute per-index time limit using the `--time`
  parameter.
* Specify an `--output` file that uses `%A` and `%a` to make each task
  write to a separate file.
* Use the `--reservation` `basics17`.
