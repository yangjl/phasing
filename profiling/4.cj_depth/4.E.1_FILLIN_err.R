### Jinliang Yang
### use impute_parent in CJ data

#####################################################################
check_ik_error <- function(submsk, subgeno, dp, ikgeno, DP=10){
    
    if(sum(submsk$snpid != ikgeno$snpid) > 0) stop("!!! ID not identical !!!")
    if(sum(subgeno$snpid != ikgeno$snpid) > 0) stop("!!! ID not identical !!!")
    if(sum(dp$ID != ikgeno$snpid) > 0) stop("!!! ID not identical !!!")
    
    out <- data.frame()
    for(i in 2:ncol(dp)){
        pid <- names(dp)[i]
        idx1 <- which(dp[, pid] >= DP)
        idx2 <- which(submsk[, pid] == 3 )
        ### find the idx for masked sites
        idx <- idx1[idx1 %in% idx2]
        
        if(length(idx) > 0){
            geno1 <- ikgeno[idx, pid]
            geno2 <- subgeno[idx, pid]
            
            d <- data.frame(g1=ikgeno[idx, pid], g2=subgeno[idx, pid])
            d <- subset(d, g1 != 3)
            
            er01 <- nrow(subset(d, g2 ==0 & g1 == 1))
            er02 <- nrow(subset(d, g2 ==0 & g1 == 2))
            er10 <- nrow(subset(d, g2 ==1 & g1 == 0))
            er12 <- nrow(subset(d, g2 ==1 & g1 == 2))
            er20 <- nrow(subset(d, g2 ==2 & g1 == 0))
            er21 <- nrow(subset(d, g2 ==2 & g1 == 1))
            
            res <- data.frame(pid=pid, tot=nrow(d), miss=sum(ikgeno[idx, pid]==3), 
                              toter= (er01+er02+er10+er12+er20+er21)/nrow(d),
                              er01=er01/sum(d$g2==0), er02=er02/sum(d$g2==0), 
                              er10=er10/sum(d$g2==1), er12=er12/sum(d$g2==1), 
                              er20=er20/sum(d$g2==2), er21=er21/sum(d$g2==2)
            )
            out <- rbind(out, res)
        }
    }
    out$er0 <- out$er01 + out$er02
    out$er1 <- out$er10 + out$er12
    out$er2 <- out$er20 + out$er21
    return(out)
}

################################
library(data.table, lib="~/bin/Rlib/")
#### read in all the required data

depth <- fread("largedata/iplantdata/teo_depth.txt", header=TRUE)
depth <- as.data.frame(depth)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

msk <- fread("largedata/lcache/teo_masked.txt")
msk <- as.data.frame(msk)

#### for all the FILLIN files
fs <- list.files(path="largedata/cjmasked/FILLIN/", pattern="txt$", full.names=TRUE)
for(i in 2:length(fs)){
    print(i)
    ikgeno <- fread(fs[i])
    ikgeno <- as.data.frame(ikgeno)
    
    ikgeno2 <- merge(geno[,1:2], ikgeno, by="snpid", sort = FALSE)
    ikgeno <- ikgeno2[, -2]
    
    
    ###########
    submsk <- msk[, names(ikgeno)]
    subgeno <- geno[, names(ikgeno)]
    
    ids <- names(depth)[names(depth) %in% names(ikgeno)]
    dp <- depth[, c("ID", ids)]
    
    res <- check_ik_error(submsk, subgeno, dp, ikgeno, DP=10)
    res[is.na(res)] <- 0
    write.table(res, paste0("cache/fillin_err_file", i, ".csv"), sep=",", row.names=FALSE, quote=FALSE)
}
