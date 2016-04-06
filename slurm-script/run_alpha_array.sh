#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing
#SBATCH -o /home/jolyang/Documents/Github/phasing/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing/slurm-log/err-%j.txt
#SBATCH -J alpha
#SBATCH --array=1
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

sh slurm-script/run_alpha_$SLURM_ARRAY_TASK_ID.sh
