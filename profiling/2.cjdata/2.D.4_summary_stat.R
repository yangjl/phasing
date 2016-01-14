### Jinliang Yang
### 1/13/2016
### summary of the final imputation results


library(data.table, lib="~/bin/Rlib/")
fgeno <- fread("largedata/teo_imputeR_01112016.txt")
fgeno <- as.data.frame(fgeno)

############################
mr <- apply(fgeno[, -1], 2, function(x){
    sum(x==3)/length(x)
})
pmr <- data.frame(pid=names(mr), mr=mr)
write.table(pmr, "cache/teo_imputeR_01112016_pmr.csv", sep=",", row.names=FALSE, quote=FALSE)


#############################
lmiss <- fgeno[, 1:2]
lmiss$maf <- apply(fgeno[, -1], 1, function(x){
    (2*sum(x==2) + sum(x==1)) / (2*length(x))
})
lmiss$mr <- apply(fgeno[, -1], 1, function(x){
    sum(x==3) / length(x)
})

write.table(lmiss, "cache/teo_imputeR_01112016_lmiss.csv", sep=",", row.names=FALSE, quote=FALSE)
