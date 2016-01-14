### Jinliang Yang
### use impute_parent in CJ data

#mysq | grep "jolyang" | grep "serial"



files <- list.files(path="largedata/cjmasked/subgeno", pattern="csv$", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/ik_files.csv", sep=",", row.names=FALSE)
##481

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.D.1_run_impute_kid.R',
             arrayjobs="1-481",
             wd=NULL, jobid="ik1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial --mem 16000 --ntasks=2 largedata/scripts/run_ik1.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.D.1_run_impute_kid.R',
             arrayjobs="301-481",
             wd=NULL, jobid="ik2", email="yangjl0930@gmail.com")
###>>> RUN: sca


pool <- c(1, 6, 8, 11, 21, 31, 41, 51, 61, 16, 26, 36, 46, 56, 66, 18, 28, 38, 48, 58, 68, 34)
sample(pool, 6)
#[1] 66 26 34 41 18 61
