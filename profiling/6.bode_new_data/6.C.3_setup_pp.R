### Jinliang Yang
### use impute_parent in CJ data

# pp round 1
files <- list.files(path="largedata/bode/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/bode_pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_bode_pp1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="1-130",
             wd=NULL, jobid="bode_pp1", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p med largedata/scripts/run_bode_pp1.sh

# pp round 2
files <- list.files(path="largedata/bode/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/bode_pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/runbode_pp21.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="1-150",
             wd=NULL, jobid="pp21", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p med largedata/scripts/runbode_pp21.sh

# pp round 3
files <- list.files(path="largedata/bode/obs3", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/bode_pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/runbode_pp31.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="1-160",
             wd=NULL, jobid="pp31", email="yangjl0930@gmail.com")
system("sbatch -p med largedata/scripts/runbode_pp31.sh")
###>>> RUN: sbatch -p serial largedata/scripts/runbode_pp31.sh


# pp round 4
files <- list.files(path="largedata/bode/obs4", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
#506
#1109
df$file <- as.character(df$file)
csvs <- list.files(path="largedata/bode/obs4", pattern=".csv", full.names=TRUE)
myf <- gsub("csv", "RData", csvs)
myf <- df$file[!df$file %in% myf]
df <- data.frame(id=1:length(myf), file=myf)
write.table(df, "largedata/bode_pp_files.csv", sep=",", row.names=FALSE)


#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/runbode_pp41.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="1-250",
             wd=NULL, jobid="pp41", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm largedata/scripts/runbode_pp41.sh

set_arrayjob(shid="largedata/scripts/runbode_pp42.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="251-506",
             wd=NULL, jobid="pp42", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/runbode_pp42.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/runbode_pp43.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/6.bode_new_data/6.C.2_run_phase_parent.R',
             arrayjobs="1-24",
             wd=NULL, jobid="pp43", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p serial largedata/scripts/runbode_pp43.sh
