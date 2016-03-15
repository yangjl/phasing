### Jinliang Yang
### use impute_parent in CJ data

# pp round 1
files <- list.files(path="largedata/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/5.cj_new_AGPv2/5.C.2_run_phase_parent.R',
             arrayjobs="1-210",
             wd=NULL, jobid="pp210", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p med largedata/scripts/run_pp.sh

# pp round 2
files <- list.files(path="largedata/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
#f2 <- list.files(path="largedata/obs2", pattern="csv", full.names=TRUE)
#f2 <- gsub("csv", "RData", f2)
#df <- subset(df, !(file %in% f2))
write.table(df, "largedata/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/5.cj_new_AGPv2/5.C.2_run_phase_parent.R',
             arrayjobs="1-230",
             wd=NULL, jobid="pp2_230", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p med largedata/scripts/run_pp2.sh

# pp round 3
files <- list.files(path="largedata/obs3", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/5.cj_new_AGPv2/5.C.2_run_phase_parent.R',
             arrayjobs="1-230",
             wd=NULL, jobid="pp3_230", email="yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/scripts/run_pp3.sh
