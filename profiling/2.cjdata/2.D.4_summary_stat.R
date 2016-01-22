### Jinliang Yang
### 1/13/2016
### summary of the final imputation results


library(data.table, lib="~/bin/Rlib/")

fs <- list.files(path="largedata/cjmasked/FILLIN/", pattern="txt$", full.names=TRUE)
for(i in 1:length(fs)){
    fgeno <- fread(fs[i])
    fgeno <- as.data.frame(fgeno)
    
    #############################
    if(i == 1){
        lmiss <- fgeno[, 1:2]
        lmiss$mr <- apply(fgeno[, -1], 1, function(x){
            sum(x==3) / length(x)
        })
    }else{
        lmiss$mr <- apply(fgeno[, -1], 1, function(x){
            sum(x==3) / length(x)
        })
    }
    names(lmiss)[ncol(lmiss)] <- paste0("mr", i)
    print(i)
}

write.table(lmiss[,-2], "cache/teo_fillin_info.csv", sep=",", row.names=FALSE, quote=FALSE)



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


