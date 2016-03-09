### Jinliang Yang
### Feb 23th, 2016


library("data.table", lib="~/bin/Rlib")

info <- fread("largedata/teo_updated/teo_raw_biallelic.hmp.info")
info <- as.data.frame(info)

info$count <- nchar(info$alleles)
table(info$count)
#3     5     7 
#88230  6482    32

flt2 <- subset(info, MAF > 0.005 & MAF < 1 & missing < 0.2 & chrom != 0)
dim(flt2) #88179    16
write.table(flt2[, c(1:4,12:16)], "largedata/teo_updated/TeoCurated_20160308_AGPv2_flt_maf005m2.txt", 
            quote=FALSE, sep="\t", row.names=FALSE)

########### plot a figure
pdf("graphs/Teocurated_maf005m2.pdf", width=10, height=5)
par(mfrow=c(1,2))
hist(flt2$MAF, main="MAF", xlab="MAF")
range(flt2$MAF) #0.005 0.500
hist(flt2$missing, main="Missing", xlab="missing rate")
range(flt2$missing) #[1] 0.00000 0.19996
dev.off()
##############

code3 <- paste0("snpconvert -a largedata/teo_updated/teo_raw_biallelic.hmp.txt", 
                " -i largedata/teo_updated/TeoCurated_20160308_AGPv2_flt_maf005m2.txt -s 12",
                " -o largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
library(maizeR)
set_farm_job(slurmsh = "largedata/scripts/run_snpconvert.sh",
             shcode = code3, wd = NULL, jobid = "snpconvert",
             email="yangjl0930@gmail.com")








################################
sum(info$MAF == 0) #252221
sum(info$count == 1) #[1]251012
sum(is.na(info$alleles)) #1209
head(subset(info, count !=1 & MAF ==0))
tail(subset(info, count !=1 & MAF ==0))

sum(info$MAF == 1) #[1] 105734
sum(info$count > 3) #105734


flt <- subset(info, MAF > 0 & MAF < 1)
#[1] 597735     16

dim(subset(flt, MAF < 0.01)) #196240
dim(subset(flt, missing > 0.8)) #97691 

flt2 <- subset(info, MAF > 0.01 & MAF < 1 & missing < 0.8 & chrom != 0)
dim(flt2) #322213     16
write.table(flt2[, c(1:4,12:16)], "largedata/teo_updated/TeoCurated_20160215_AGPv2_flt_maf01m8.txt", quote=FALSE, sep="\t", row.names=FALSE)

flt3 <- subset(info,  MAF > 0.001 &MAF < 1 & missing < 0.8 & chrom != 0)
#359560     16
write.table(flt3[, c(1:4,12:16)], "largedata/teo_updated/TeoCurated_20160215_AGPv2_flt_maf001m8.txt", quote=FALSE, sep="\t", row.names=FALSE)

######################################

code3 <- paste0("snpconvert -a largedata/teo_updated/TeoCurated_20160215_AGPv2.hmp.txt", 
                " -i largedata/teo_updated/TeoCurated_20160215_AGPv2_flt_maf001m8.txt -s 12",
                " -o largedata/teo_updated/TeoCurated_20160215_AGPv2_recoded.txt")

source("~/Documents/Github/zmSNPtools/Rcodes/setUpslurm.R")
setUpslurm(slurmsh="largedata/scripts/run_snpconvert.sh", codesh=code3, 
           jobid="snpconvert", email="yangjl0930@gmail.com")

