* Convert the solution from exercise 1 ("Slurm job arrays") to use the
  CURC loadbalancer in a single, multi-task job, rather than Slurm job
  arrays.
* Try multiple values for `--ntasks` and observe the execution time
  change.

Each task / input file line should execute a single
`matrix-multiply.py` process.

How might you combine the output from the different tasks into a
single output file?


## Tips

* Use `%j` in `--output` for standard, non-array jobs.
* Use `echo` and `>>` to append lines to an input file.
* Try to avoid building the input file manually; use a Bash loop in
  stead.
* You can build the input file as part of the Slurm job.
* Don't forget to `module load python intel impi loadbalance`.
