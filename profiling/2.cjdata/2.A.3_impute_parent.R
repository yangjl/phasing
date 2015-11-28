### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)

load(file="~/Documents/Github/imputeR/largedata/teo.RData")
Geno4imputeR <- ob1
ped <- read.table("data/parentage_info.txt", header =TRUE)

ob2 <- create_array(Geno4imputeR, ped, outdir="largedata/",
                    maf_cutoff=0.002, lmiss_cutoff=0.8, imiss_cutoff=0.8, size_cutoff=40)




files <- list.files(path="largedata", pattern="RData", full.names=TRUE)

o <- load(files[1])
tem <- impute_parent(GBS.array=obj, hom.error = 0.02, het.error = 0.8, imiss = 0.5)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)


############
probs <- error_mx(hom.error=0.02, het.error=0.8, imiss=0.5)




# plot #############
pinfo <- read.table("data/parentage_sum.txt", header=TRUE)
par(mfrow=c(1,1))
counts <- pinfo[, c("nselfer", "nox")]
counts[is.na(counts)] <- 0
counts$tot <- counts$nselfer + counts$nox
counts <- counts[order(counts$tot, decreasing=T), ]
counts <- as.matrix(t(counts[,1:2]))
barplot(counts, main="Family Size Distribution", xlab="families", col=c("darkblue","red"), 
        legend = c("selfing", "outcrossing"))
