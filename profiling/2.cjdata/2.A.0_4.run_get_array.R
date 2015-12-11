### Jinliang Yang
### use impute_parent in CJ data

source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")
setUpslurm(slurmsh="largedata/scripts/step1_getarray.sh",
           codesh='R --no-save < profiling/2.cjdata/2.A.0_3_get_array.R',
           wd=NULL, jobid="get-array", email="yangjl0930@gmail.com")


###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p serial --mem 8000 largedata/scripts/step2_aj_ip.sh
###>>> RUN: sbatch -p bigmemh largedata/scripts/step2_aj_ip.sh
