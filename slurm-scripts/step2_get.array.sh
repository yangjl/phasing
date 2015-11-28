#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing
#SBATCH -J get_array
#SBATCH -o /home/jolyang/Documents/Github/phasing/slurm-log/log-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing/slurm-log/err-%j.txt

#only argument is mean (of poisson) of number of crossovers
R --no-save < profiling/2.cjdata/2.A.3_get_array.R
#sbatch -p bigmemh --mem 128000 --ntasks=16 slurm-scripts/step2_get.array.sh
#sbatch -p serial slurm-scripts/sim_step1.sh 10 1000