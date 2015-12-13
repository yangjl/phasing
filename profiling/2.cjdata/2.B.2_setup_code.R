### Jinliang Yang
### use impute_parent in CJ data

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")

# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.B.1_code_impute_parent.R',
             arrayjobs="1-379",
             wd=NULL, jobid="ip1-379", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/step3_aj_ip.sh