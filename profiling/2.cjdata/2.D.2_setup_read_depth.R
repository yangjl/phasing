
source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")

codes <- paste0("module load gcc jdk/1.8 tassel/5", "\n",
               "run_pipeline.pl -Xmx64g -h5 largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.h5", 
               " -export largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.vcf -exportType VCF")

setUpslurm(slurmsh="largedata/scripts/h5_vcf.sh", codesh=codes, jobid="h5_vcf", email="yangjl0930@gmail.com")
