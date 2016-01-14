### Jinliang Yang
### Jan 6th, 2016
### get read depth from VCF file

library(data.table, lib="~/bin/Rlib/")
depth <- fread("largedata/iplantdata/depth.txt", header=TRUE)
depth <- as.data.frame(depth)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

pid <- names(depth)[names(depth) %in% names(geno)]
depth <- depth[, c("ID", pid)]

maskgeno <- function(geno, depth, maxsites=16000,  DP=10){
    
    if(sum(depth$ID != geno$snpid) > 0){
        stop("!!! ID not identical !!!")
    }
    totsites <- 0
    for(i in 2:ncol(depth)){
        pid <- names(depth)[i]
        idx <- which(depth[, i] >= DP)
        if(length(idx) > maxsites){
            idx <- sample(idx, maxsites, replace=FALSE)
            idx <- sort(idx)
        }
        
        totsites <- totsites + length(idx)
        geno[idx, pid] <- 3
        message(sprintf("###>>> masked [ %s ]", i))
    }
    message(sprintf("###>>> TOTAL sites masked [ %s ]", totsites))
    return(geno)
}

newgeno <- maskgeno(geno, depth, maxsites=16000,  DP=10)
###>>> TOTAL sites masked [ 57328637 ]
7328637/(4878*nrow(geno))
###>>> [1] 0.03657269


write.table(newgeno, "largedata/lcache/teo_masked.txt", sep="\t", row.names=FALSE, quote=FALSE)
write.table(depth, "largedata/lcache/teo_geno_depth.txt", sep="\t", row.names=FALSE, quote=FALSE)
