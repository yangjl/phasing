### Jinliang Yang
### use impute_parent in CJ data


ped <- read.table("data/parentage_info.txt", header =TRUE)
jbs <- 1:481
df <- data.frame(id=jbs, start=10*(jbs-1)+1, end=10*(jbs) )
df$end[nrow(df)] <- nrow(ped)
write.table(df, "largedata/ik_files.csv", sep=",", row.names=FALSE)

files <- list.files(path="largedata/cjmasked/obs1", pattern="RData", full.names=TRUE)

files <- list.files(path="largedata/cjmasked/subgeno", pattern="csv$", full.names=TRUE)
df <- data.frame(id=1:length(files), file=files)
write.table(df, "largedata/cjmasked/ik_files.csv", sep=",", row.names=FALSE)

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="1-100",
             wd=NULL, jobid="ik1", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik1.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="140-200",
             wd=NULL, jobid="ik2", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik2.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="201-300",
             wd=NULL, jobid="ik3", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemh --mem 16000 --ntasks=2 largedata/scripts/run_ik3.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik4.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="301-400",
             wd=NULL, jobid="ik4", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik4.sh

source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
set_arrayjob(shid="largedata/scripts/run_ik5.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID}" < profiling/2.cjdata/2.D.1_run_impute_kid.R',
             arrayjobs="401-479",
             wd=NULL, jobid="ik5", email="yangjl0930@gmail.com")
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik5.sh

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm --mem 16000 --ntasks=2 largedata/scripts/run_ik1.sh
