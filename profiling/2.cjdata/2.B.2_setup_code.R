### Jinliang Yang
### use impute_parent in CJ data

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")

# run array job of impute_parents
set_arrayjob(shid="slurm-scripts/step3_aj_ip.sh",
             shcode="R --no-save '--args $SLURM_ARRAY_TASK_ID' < profiling/2.cjdata/2.B.1_code_impute_parent.R",
             arrayjobs="1-10",
             wd=NULL, jobid="imputeR", email="yangjl0930@gmail.com")