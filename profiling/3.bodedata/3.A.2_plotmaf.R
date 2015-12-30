### Jinliang Yang
### 12/29/2015


library("data.table", lib="~/bin/Rlib")

info <- fread("largedata/lcache/landrace.info")
info <- as.data.frame(info)

info$count <- nchar(info$alleles)
table(info$count)
#1      2      3      5      7      9 
#250508   1214 598043 105559    362      4

sum(info$MAF == 0) #251722
sum(info$count == 1) #[1] 250508
sum(is.na(info$alleles)) #1214
head(subset(info, count !=1 & MAF ==0))
tail(subset(info, count !=1 & MAF ==0))

sum(info$MAF == 1) #[1] 105925
sum(info$count > 3) #105925


flt <- subset(info, MAF > 0 & MAF < 1)
#[1] 598043     16
dim(subset(flt, MAF < 0.01))
dim(subset(flt, MAF < 0.01))
dim(subset(flt, missing > 0.8))

flt <- subset(info, MAF > 0.01 & MAF < 1 & missing < 0.8 & chrom != 0)
dim(flt)
write.table(flt[, c(1:4,12:16)], "largedata/lcache/teo_flt_maf01m8.txt", quote=FALSE, sep="\t", row.names=FALSE)





