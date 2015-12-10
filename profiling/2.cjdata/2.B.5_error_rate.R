### Jinliang Yang
### 12/8/2015

imp <- data.frame()
for(i in 1:10){
    tem <- read.csv(paste0("largedata/ip/chr", i, "_ip50.csv"))
    imp <- rbind(imp, tem)
}
imp <- read.csv()


snpinfo <- read.csv("largedata/obs/snpinfo.csv")
snpinfo <- cbind(snpinfo, imp)

ped <- read.table("data/parentage_info.txt", header=TRUE)

ob <- load(file="~/Documents/Github/imputeR/largedata/teo.RData")
Geno4imputeR <- ob1
geno <- Geno4imputeR@genomx



focalp <- gsub(".*_PC", "PC", names(imp))
focalp <- gsub("\\.", ":", focalp)
subped <- subset(ped, parent1 ==  focalp[1] & parent2 == focalp[1])

geno <- as.data.frame(geno)
mysnp <- merge(snpinfo[, c(1:8, 9)], geno[, subped$proid], by.x="snpid", by.y="row.names")


mysnp$count0 <- apply(mysnp[, 10:ncol(mysnp)], 1, function(x) sum(x==0))
mysnp$count1 <- apply(mysnp[, 10:ncol(mysnp)], 1, function(x) sum(x==1))
mysnp$count2 <- apply(mysnp[, 10:ncol(mysnp)], 1, function(x) sum(x==2))
mysnp$count3 <- apply(mysnp[, 10:ncol(mysnp)], 1, function(x) sum(x==3))

table(subset(mysnp, count1==0 & count2==0 & count3 <30)[, 9])

table(subset(mysnp, count0==0 & count1==0 & count3 <30)[, 9])

