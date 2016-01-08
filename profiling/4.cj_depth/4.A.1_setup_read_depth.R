### Jinliang Yang
### Jan 6th, 2016
### get read depth from VCF file

source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")
code1 <- paste0("module load gcc jdk/1.8 tassel/5", "\n",
               "run_pipeline.pl -Xmx64g -h5 largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.h5", 
               " -export largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.vcf -exportType VCF")
setUpslurm(slurmsh="largedata/scripts/h5_vcf.sh", codesh=code1, jobid="h5_vcf", email="yangjl0930@gmail.com")

### run getVCF
code2 <- paste0("getvcf -i largedata/iplantdata/ZeaGBSv27raw_RareAllelesC2TeoCumul_20160105.vcf ",
                "-n largedata/lcache/teo_flt_maf01m8.txt -o largedata/iplantdata/depth.txt")
setUpslurm(slurmsh="largedata/scripts/run_getDH.sh", codesh=code2, jobid="DH", email="yangjl0930@gmail.com")



library(data.table, lib="~/bin/Rlib/")
depth <- fread("largedata/iplantdata/depth.txt", header=TRUE)
depth <- as.data.frame(depth)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

sum(names(depth) %in% names(geno))


#tem <- apply(depth[, -1:-9], 2, function(x) sum(x >=7))

tem <- apply(depth[, -1:-9], 2, function(x) sum(x >=10))
dp <- data.frame(plantid=names(tem), sites=tem)
dp <- subset(dp, plantid %in% names(geno))
dp$rate <- dp$sites/nrow(depth)
write.table(dp, "cache/teo_depth_info.csv", sep=",", row.names=FALSE, quote=FALSE)

dp <- read.csv("cache/teo_depth_info.csv")


