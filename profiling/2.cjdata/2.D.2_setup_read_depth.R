
source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")
setUpslurm(slurmsh="largedata/scripts/h5_vcf.sh", codesh="sh profiling/2.cjdata/2.D.1_read_depth.sh", jobid="h5_vcf", email="yangjl0930@gmail.com")
