### Jinliang Yang
### 12/29/2015

source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")

code2 <- "getsnpinfo -i largedata/lcache/landrace.hmp.txt -s 12 -o largedata/lcache/landrace.info"
setUpslurm(slurmsh="largedata/scripts/run_getinfo.sh", codesh=code2, 
           jobid="getinfo", email="yangjl0930@gmail.com")


code3 <- paste0("snpconvert -a largedata/lcache/landrace.hmp.txt", 
                " -i largedata/lcache/landrace_flt_maf01m8.txt -s 12",
                " -o largedata/lcache/land_recode.txt")

setUpslurm(slurmsh="largedata/scripts/run_snpconvert.sh", codesh=code3, 
           jobid="snpconvert", email="yangjl0930@gmail.com")

