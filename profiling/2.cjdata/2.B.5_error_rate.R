### Jinliang Yang
### 12/8/2015


library("data.table", lib="~/bin/Rlib")
mx <- fread("largedata/lcache/teo_recoded.txt")
mx <- as.data.frame(mx)

imp <- fread("largedata/ip/imputed_parents.csv", sep=",")
imp <- as.data.frame(imp)

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 30)
pinfo$founder <- as.character(pinfo$founder)

############
out <- imp_checking(imp, mx, ped, depth_cutoff=10)
write.table(out, )

imp_checking <- function(imp, mx, ped, depth_cutoff=10){
    res <- pinfo
    res$miss <- -9
    res$gbs0 <- -9
    res$gbs1 <- -9
    res$gbs2 <- -9
    res$call0 <- -9
    res$call1 <- -9
    res$call2 <- -9
    res$err0 <- -9
    res$err1 <- -9
    res$err2 <- -9
    res$err <- -9
    for(i in 1:nrow(pinfo)){
        focalp <- pinfo$founder[i]
        kids <- subset(ped, parent1 == focalp & parent2 == focalp)$proid
        kidgeno <- mx[, c("snpid", focalp, kids)]
        message(sprintf("###>>> founder [ %s ] has [ %s ] selfed kids, [ %s ] selected!", 
                        focalp, pinfo$nselfer[i], length(kids)))
        
        subgeno <- merge(snpinfo, kidgeno, by="snpid")
        #sum(subgeno$major.x != subgeno$major.y)
        pgeno <- imp[, c("snpid", focalp)]
        names(pgeno)[2] <- "ip"
        subgeno <- merge(pgeno, subgeno, by="snpid")
        
        subgeno$count0 <- apply(subgeno[, 11:ncol(subgeno)], 1, function(x) sum(x==0))
        subgeno$count1 <- apply(subgeno[, 11:ncol(subgeno)], 1, function(x) sum(x==1))
        subgeno$count2 <- apply(subgeno[, 11:ncol(subgeno)], 1, function(x) sum(x==2))
        subgeno$count3 <- apply(subgeno[, 11:ncol(subgeno)], 1, function(x) sum(x==3))
        
        res$miss[i] <- sum(subgeno[,10] == 3)
        res$gbs0[i] <- sum(subgeno[,10] == 0)
        res$gbs1[i] <- sum(subgeno[,10] == 1)
        res$gbs2[i] <- sum(subgeno[,10] == 2)
        res$call0[i] <- sum(subgeno$ip == 0)
        res$call1[i] <- sum(subgeno$ip == 1)
        res$call2[i] <- sum(subgeno$ip == 2)
        
        t1 <- subset(subgeno,  count0 > depth_cutoff & count1 == 0 & count2 == 0)
        res$err0[i] <- sum(t1$ip != 0)/length(t1$ip)

        t2 <- subset(subgeno,  count0 == 0 & count1 == 0 & count2 > depth_cutoff)
        res$err2[i] <- sum(t2$ip != 2)/length(t2$ip)
        
        t3 <- subset(subgeno,  count0 > depth_cutoff & count2 > depth_cutoff)
        res$err1[i] <- sum(t3$ip != 1)/length(t3$ip)
        
        res$err[i] <- (sum(t1$ip != 0) + sum(t2$ip != 2) + sum(t3$ip != 1))/(length(t1$ip) + length(t2$ip) + length(t3$ip))
    }
    return(res)
}




