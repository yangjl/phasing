#!/bin/bash -l
#SBATCH -D /home/jri/projects/phasing_tests
#SBATCH -J phase_test
#SBATCH -o /home/jri/projects/phasing_tests/out/phase_out-%j.txt
#SBATCH -e /home/jri/projects/phasing_tests/error/phase_error-%j.txt
#SBATCH --array=1-150

#only argument is mean (of poisson) of number of crossovers
crossovers=$1
R --no-save "--args $crossovers $SLURM_JOB_ID" < test_code.r 
