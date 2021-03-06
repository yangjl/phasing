### Jinliang Yang
### use impute_parent in CJ data


files <- list.files(path="largedata/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/8.Luis_data/8.B.1_code_impute_parent.R',
             arrayjobs="1-40",
             wd=NULL, jobid="ip", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p med largedata/scripts/ip1.sh


