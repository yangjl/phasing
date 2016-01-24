### Jinliang Yang
### use impute_parent in CJ data

#mysq | grep "jolyang" | grep "serial"

files <- list.files(path="largedata/bode/subgeno", pattern="csv$", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/bode/ik_files.csv", sep=",", row.names=FALSE)
##491

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.D.1_run_impute_kid.R',
             arrayjobs="1-250",
             wd=NULL, jobid="ik1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_ik1.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
set_arrayjob(shid="largedata/scripts/run_ik2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.D.1_run_impute_kid.R',
             arrayjobs="251-491",
             wd=NULL, jobid="ik2", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_ik2.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik83.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.D.1_run_impute_kid.R',
             arrayjobs="83",
             wd=NULL, jobid="ik83", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_ik2.sh
