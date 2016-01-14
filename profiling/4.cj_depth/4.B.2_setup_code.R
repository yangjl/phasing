### Jinliang Yang
### use impute_parent in CJ data

files <- list.files(path="largedata/cjmasked/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.B.1_run_impute_parent.R',
             arrayjobs="1-240",
             wd=NULL, jobid="ip_r1", email="yangjl0930@gmail.com")

###>>> RUN: sbatch -p bigmemm largedata/scripts/step3_aj_ip.sh

files <- list.files(path="largedata/cjmasked/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.B.1_run_impute_parent.R',
             arrayjobs="1-210",
             wd=NULL, jobid="ip_r2", email="yangjl0930@gmail.com")

###>>> RUN: sbatch -p bigmemh largedata/scripts/ip2.sh

files <- list.files(path="largedata/cjmasked/obs3", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.B.1_run_impute_parent.R',
             arrayjobs="1-230",
             wd=NULL, jobid="ip_r3", email="yangjl0930@gmail.com")

###>>> RUN: sbatch -p serial largedata/scripts/ip3.sh

