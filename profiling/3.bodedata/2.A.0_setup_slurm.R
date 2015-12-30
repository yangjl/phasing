
source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")

code2 <- "getsnpinfo -i largedata/lcache/landrace.hmp.txt -s 12 -o largedata/lcache/landrace.info"
setUpslurm(slurmsh="largedata/scripts/run_getinfo.sh", codesh=code2, jobid="getinfo", email="yangjl0930@gmail.com")

