### Jinliang Yang
### use impute_parent in CJ data

#mysq | grep "jolyang" | grep "serial"

files <- list.files(path="largedata/ik", pattern="csv$", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/teo_ik_files.csv", sep=",", row.names=FALSE)
##491

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/5.cj_new_AGPv2/5.D.1_run_impute_kid.R',
             arrayjobs="1-475",
             wd=NULL, jobid="ik", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p med largedata/scripts/run_ik1.sh

#416
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/5.cj_new_AGPv2/5.D.1_run_impute_kid.R',
             arrayjobs="416",
             wd=NULL, jobid="ik", email="yangjl0930@gmail.com")