### Jinliang Yang
### use impute_parent in CJ data


files <- list.files(path="largedata/bode/obs1", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/bode_obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.B.1_code_impute_parent.R',
             arrayjobs="1-130",
             wd=NULL, jobid="bdip_r1", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p serial largedata/scripts/ip1.sh

files <- list.files(path="largedata/bode/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)

write.table(df, "largedata/bode_obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/3.bodedata/3.B.1_code_impute_parent.R',
             arrayjobs="1-150",
             wd=NULL, jobid="ip_round2", email="yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/scripts/ip2.sh

files <- list.files(path="largedata/obs3", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.B.1_code_impute_parent.R',
             arrayjobs="1-230",
             wd=NULL, jobid="ip_round3", email="yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/ip3.sh


