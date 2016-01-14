### Jinliang Yang
### 1/13/2016
### summary of the final imputation results


library(data.table, lib="~/bin/Rlib/")
fgeno <- fread("largedata/teo_imputeR_01112016.txt")
fgeno <- as.data.frame(fgeno)

### before geno
bgeno <- fread("largedata/lcache/teo_recoded.txt")
bgeno <- as.data.frame(bgeno)

############################
mr <- apply(fgeno[, -1], 2, function(x){
    sum(x==3)/length(x)
})
pmr <- data.frame(pid=names(mr), mr=mr)
write.table(pmr, "cache/teo_imputeR_01112016_pmr.csv", sep=",", row.names=FALSE, quote=FALSE)

mr2 <- apply(bgeno[, -1:-3], 2, function(x){
    sum(x==3)/length(x)
})
pmr2 <- data.frame(pid=names(mr2), mr=mr2)
write.table(pmr2, "cache/teo_raw_pmr.csv", sep=",", row.names=FALSE, quote=FALSE)

#############################
lmiss <- fgeno[, 1:2]
lmiss$maf <- apply(fgeno[, -1], 1, function(x){
    (2*sum(x==2) + sum(x==1)) / (2*length(x))
})
lmiss$mr <- apply(fgeno[, -1], 1, function(x){
    sum(x==3) / length(x)
})

lmiss2 <- bgeno[, 1:3]
lmiss2$maf <- apply(bgeno[, -1:-3], 1, function(x){
    (2*sum(x==2) + sum(x==1)) / (2*length(x))
})
lmiss2$mr <- apply(bgeno[, -1:-3], 1, function(x){
    sum(x==3) / length(x)
})

names(lmiss2)[4:5] <- c("maf0", "mr0")
lmiss <- cbind(lmiss2, lmiss[, -2], by="snpid", sort=FALSE)
write.table(lmiss[,-6], "cache/teo_imputeR_01112016_info.csv", sep=",", row.names=FALSE, quote=FALSE)



#############################
pmr <- read.csv("cache/teo_imputeR_01112016_pmr.csv")

info <- read.csv("cache/teo_imputeR_01112016_info.csv")

pdf("graphs/teo_impute_sum.pdf", width=8, height=6)
par(mfrow=c(2,2))
hist(info$maf0, breaks=30, main="Before Imputation", xlab="MAF", col="#458b74", cex=1.2)
hist(info$maf, breaks=30, main="After Imputation", xlab="MAF", col="#458b74", cex=1.2)
hist(info$mr0, breaks=30, main="Before Imputation", xlab="Missing Rate", col="#458b74", cex=1.2)
hist(info$mr, breaks=30, main="After Imputation", xlab="Missing Rate", col="#458b74", cex=1.2)
dev.off()


