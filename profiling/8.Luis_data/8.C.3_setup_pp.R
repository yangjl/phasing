### Jinliang Yang
### use impute_parent in CJ data

# pp round 1
files <- list.files(path="largedata/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/pp_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_pp.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/8.Luis_data/8.C.2_run_phase_parent.R',
             arrayjobs="1-40",
             wd=NULL, jobid="pp40", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/scripts/run_pp.sh

