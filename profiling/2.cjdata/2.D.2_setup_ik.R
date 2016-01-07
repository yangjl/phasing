### Jinliang Yang
### use impute_parent in CJ data

# pp round 1
ped <- read.table("data/parentage_info.txt", header =TRUE)
jbs <- 1:481
df <- data.frame(id=jbs, start=10*(jbs-1)+1, end=10*(jbs) )
df$end[nrow(df)] <- nrow(ped)
write.table(df, "largedata/ik_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="480-481",
             wd=NULL, jobid="ik481", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/run_pp.sh


