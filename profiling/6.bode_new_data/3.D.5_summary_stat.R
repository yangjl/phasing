### Jinliang Yang
### 1/13/2016
### summary of the final imputation results

library(data.table, lib="~/bin/Rlib/")
############################
fgeno <- fread("largedata/landrace_imputeR_01232016.txt")
fgeno <- as.data.frame(fgeno)

### before geno
bgeno <- fread("largedata/lcache/land_recode.txt")
bgeno <- as.data.frame(bgeno)

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
lmiss <- cbind(lmiss2, lmiss[, -2])

lm <- lmiss[, c(1:5,7,8)]
write.table(lm, "largedata/landrace_imputeR_01232016_info.csv", 
            sep=",", row.names=FALSE, quote=FALSE)
###41% -> 0.03%

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


