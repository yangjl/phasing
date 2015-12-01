#!/bin/bash -l
#SBATCH -D /Users/yangjl/Documents/Github/phasing
#SBATCH -o /Users/yangjl/Documents/Github/phasing/slurm-log/testout-%j.txt
#SBATCH -e /Users/yangjl/Documents/Github/phasing/slurm-log/err-%j.txt
#SBATCH -J imputeR
#SBATCH --array=1-10
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

R --no-save '--args $SLURM_ARRAY_TASK_ID' < profiling/2.cjdata/2.B.1_code_impute_parent.R
