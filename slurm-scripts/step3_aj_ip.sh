#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing
#SBATCH -o /home/jolyang/Documents/Github/phasing/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing/slurm-log/err-%j.txt
#SBATCH -J imputeR
#SBATCH --array=1-45
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.B.3_code2_impute_parent.R
