### Jinliang Yang
### use impute_parent in CJ data

# pp round 1
files <- list.files(path="largedata/cjmasked/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
#1189
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1-500",
             wd=NULL, jobid="pp1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmeml largedata/scripts/run_pp1.sh

set_arrayjob(shid="largedata/scripts/run_pp2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="501-1000",
             wd=NULL, jobid="pp2", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_pp2.sh

set_arrayjob(shid="largedata/scripts/run_pp3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1001-1189",
             wd=NULL, jobid="pp3", email="yangjl0930@gmail.com")

###>>> RUN: sbatch -p serial largedata/scripts/run_pp3.sh

# pp round 2
files <- list.files(path="largedata/cjmasked/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
#[1] 1340    2
write.table(df, "largedata/cjmasked/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp21.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1-500",
             wd=NULL, jobid="pp21", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_pp21.sh

set_arrayjob(shid="largedata/scripts/run_pp21.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="21",
             wd=NULL, jobid="pp21", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemh largedata/scripts/run_pp21.sh

set_arrayjob(shid="largedata/scripts/run_pp23.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1001-1340",
             wd=NULL, jobid="pp23", email="yangjl0930@gmail.com")

###>>> RUN: sbatch -p bigmemm largedata/scripts/run_pp23.sh



# pp round 3
files <- list.files(path="largedata/cjmasked/obs3", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/pp_files.csv", sep=",", row.names=FALSE)

file1 <- list.files(path="largedata/cjmasked/obs3", pattern="PC_.*.csv", full.names=TRUE)
file1 <- gsub("csv", "RData", file1)
file2 <- list.files(path="largedata/cjmasked/obs3", pattern="PC_.*.RData", full.names=TRUE)
file <- file2[!(file2 %in% file1)]
df <- data.frame(id=1:length(file), file=file)
write.table(df, "largedata/cjmasked/pp_files.csv", sep=",", row.names=FALSE)

#850
#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp31.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1-300",
             wd=NULL, jobid="pp31", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_pp31.sh

set_arrayjob(shid="largedata/scripts/run_pp32.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="301-600",
             wd=NULL, jobid="pp32", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/run_pp32.sh

set_arrayjob(shid="largedata/scripts/run_pp33.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="601-850",
             wd=NULL, jobid="pp33", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_pp33.sh

set_arrayjob(shid="largedata/scripts/run_pp36.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="1-20",
             wd=NULL, jobid="pp36", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_pp34.sh
set_arrayjob(shid="largedata/scripts/run_pp37.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/4.cj_depth/4.C.2_run_phase_parent.R',
             arrayjobs="21-53",
             wd=NULL, jobid="pp37", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_pp34.sh