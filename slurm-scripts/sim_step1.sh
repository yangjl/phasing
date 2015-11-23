#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing_tests
#SBATCH -J phase_test
#SBATCH -o /home/jolyang/Documents/Github/phasing_tests/slurm/phase_out-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing_tests/slurm/phase_error-%j.txt
#SBATCH --array=1-150

#only argument is mean (of poisson) of number of crossovers
sizearray=$1
R --no-save "--args $sizearray $SLURM_JOB_ID" < profiling/1.simulation/1.A.1_impute_parent_sim.R
