### Jinliang Yang
### use impute_parent in CJ data


files <- list.files(path="largedata/obs", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.B.1_code_impute_parent.R',
             arrayjobs="1-240",
             wd=NULL, jobid="ip_round1", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/step3_aj_ip.sh

files <- list.files(path="largedata/obs2", pattern="RData", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)

f2 <- list.files(path="largedata/obs2", pattern="csv$", full.names=TRUE)
f2 <- gsub("RData", "csv", f2)
df <- subset(df, !(file%in% f2))

write.table(df, "largedata/obs_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/ip3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.B.1_code_impute_parent.R',
             arrayjobs="1-110",
             wd=NULL, jobid="ip_round2", email="yangjl0930@gmail.com")
###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/scripts/ip2.sh


