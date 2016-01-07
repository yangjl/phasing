### Jinliang Yang
### Jan 6th, 2016
### get read depth from VCF file

source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")

code1 <- paste0("module load gcc jdk/1.8 tassel/5", "\n",
               "run_pipeline.pl -Xmx64g -h5 largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.h5", 
               " -export largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.vcf -exportType VCF")
setUpslurm(slurmsh="largedata/scripts/h5_vcf.sh", codesh=code1, jobid="h5_vcf", email="yangjl0930@gmail.com")


code2 <- paste0("getvcf -i largedata/iplantdata/ZeaGBSv27raw_RareAllelesC2TeoCumul_20160105.vcf ",
                "-n largedata/lcache/teo_flt_maf01m8.txt -o largedata/iplantdata/depth.txt")
setUpslurm(slurmsh="largedata/scripts/run_getDH.sh", codesh=code2, jobid="DH", email="yangjl0930@gmail.com")



library(data.table, lib="~/bin/Rlib/")
out <- read.table("largedata/iplantdata/out3.txt", header=TRUE)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

nm <- gsub("\\.", ":", names(out)) 
sum(nm %in% names(geno))
