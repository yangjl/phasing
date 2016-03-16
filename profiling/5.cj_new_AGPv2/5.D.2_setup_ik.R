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
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.D.1_run_impute_kid.R',
             arrayjobs="1-250",
             wd=NULL, jobid="ik1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_ik1.sh


