### Jinliang Yang
### use impute_parent in CJ data




files <- list.files(path="largedata/cjmasked/subgeno", pattern="csv$", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/ik_files.csv", sep=",", row.names=FALSE)
##481

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.D.1_run_impute_kid.R',
             arrayjobs="1-100",
             wd=NULL, jobid="ik1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik1.sh


