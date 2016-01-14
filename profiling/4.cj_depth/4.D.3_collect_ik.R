### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)

get_ik <- function(path="largedata/ik", pattern="kid_geno"){
    files <- list.files(path, pattern, full.names = TRUE)
    message(sprintf("### found [ %s ] files!", length(files)))
    kgeno <- read.csv(files[1])
    for(i in 2:length(files)){
        ktem <- read.csv(files[i])
        
        if(sum(kgeno$snpid != ktem$snpid) == 0){
            kgeno <- cbind(kgeno, ktem[, -1])
            message(sprintf("###>>> read the [ %s/%s ] file", i, length(files)))
        }else{
            stop("!!! snpid not match !!!")
        }
    }
    return(kgeno)
}

##############
ikgeno <- get_ik(path="largedata/cjmasked/ik", pattern="kid_geno")
write.table(ikgeno, "largedata/cjmasked/ikgeno_all.csv", sep=",", row.names=FALSE, quote=FALSE)

names(ikgeno) <- gsub("\\.", ":", names(ikgeno))


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
depth <- fread("largedata/iplantdata/depth.txt", header=TRUE)
depth <- as.data.frame(depth)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

msk <- fread("largedata/lcache/teo_masked.txt")
msk <- as.data.frame(msk)

ikgeno2 <- merge(geno[,1:2], ikgeno, by="snpid", sort = FALSE)
ikgeno <- ikgeno2[, -1]

submsk=msk[, c("snpid", names(ikgeno))]
subgeno=geno[, c("snpid", names(ikgeno))]

ids <- names(depth)[names(depth) %in% names(ikgeno)]
dp=depth[, c("ID", ids)]

res <- check_ik_error(submsk, subgeno, dp, ikgeno, DP=10)
res[is.na(res)] <- 0
write.table(res, "cache/err_masked.csv", sep=",", row.names=FALSE, quote=FALSE)

