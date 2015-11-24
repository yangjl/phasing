#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing
#SBATCH -J sim1
#SBATCH -o /home/jolyang/Documents/Github/phasing/slurm-log/log-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing/slurm-log/err-%j.txt
#SBATCH --array=1-10

#only argument is mean (of poisson) of number of crossovers
sizearray=$1
R --no-save "--args $sizearray $SLURM_JOB_ID" < profiling/1.simulation/1.A.1_impute_parent_sim.R
