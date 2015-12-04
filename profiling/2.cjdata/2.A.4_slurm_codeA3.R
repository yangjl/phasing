### Jinliang Yang
### use impute_parent in CJ data


source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")
setUpslurm(slurmsh="largedata/scripts/step2_get_array.sh",
           shcode='R --no-save < profiling/2.cjdata/2.A.3_get_array.R',
           wd=NULL, jobid="get-array", email="yangjl0930@gmail.com")
