### Jinliang Yang
### 12/29/2015


library("data.table", lib="~/bin/Rlib")

info <- fread("largedata/lcache/landrace.info")
info <- as.data.frame(info)

info$count <- nchar(info$alleles)
table(info$count)
#    1      2      3      5      7      9     11 
#241521    208 583994  21396 108186    381      3 

## in-variant sites
sum(info$MAF == 0) #241729
sum(info$count == 1) #241521
sum(is.na(info$alleles)) #208
head(subset(info, count !=1 & MAF ==0))
tail(subset(info, count !=1 & MAF ==0))

## multiple sites
sum(info$MAF == 1) #129966
sum(info$count > 3) #129966


flt <- subset(info, MAF > 0 & MAF < 1)
#[1] 583994     16

flt <- subset(info, MAF > 0 & MAF < 1 & missing < 0.1)

flt <- subset(info, MAF > 0.005 & MAF < 1 & missing < 0.2 & chrom != 0)
flt <- subset(info, MAF > 0.005 & MAF < 1 & missing < 0.1 & chrom != 0)
dim(flt) #310885     16
write.table(flt[, c(1:4,12:16)], "largedata/lcache/landrace_flt_maf01m8.txt", quote=FALSE, sep="\t", row.names=FALSE)





