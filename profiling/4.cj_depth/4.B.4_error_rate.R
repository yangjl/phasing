### Jinliang Yang
### 1/8/2016
### collect error rate with masked data

library("data.table", lib="~/bin/Rlib")

#### read in all the required data
depth <- fread("largedata/iplantdata/depth.txt", header=TRUE)
depth <- as.data.frame(depth)

geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

msk <- fread("largedata/lcache/teo_masked.txt")
msk <- as.data.frame(msk)

ip68 <- read.csv("largedata/cjmasked/ip68_masked.csv")
names(ip68) <- gsub("\\.", ":", names(ip68))


################################


check_ip_error <- function(submsk, subgeno, dp, imp=ip68, DP=10){
    
    if(sum(submsk$snpid != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    if(sum(subgeno$snpid != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    if(sum(dp$ID != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    
    out <- data.frame()
    for(i in 2:ncol(dp)){
        pid <- names(dp)[i]
        idx1 <- which(dp[, pid] >= DP)
        idx2 <- which(msk[, pid] == 3 )
        ### find the idx for masked sites
        idx <- idx1[idx1 %in% idx2]
        
        geno1 <- imp[idx, pid]
        geno2 <- subgeno[idx, pid]
        
        d <- data.frame(g1=imp[idx, pid], g2=subgeno[idx, pid])
        d <- subset(d, g1 != 3)
        
        er01 <- nrow(subset(d, g2 ==0 & g1 == 1))
        er02 <- nrow(subset(d, g2 ==0 & g1 == 2))
        er10 <- nrow(subset(d, g2 ==1 & g1 == 0))
        er12 <- nrow(subset(d, g2 ==1 & g1 == 2))
        er20 <- nrow(subset(d, g2 ==2 & g1 == 0))
        er21 <- nrow(subset(d, g2 ==2 & g1 == 1))
        
        res <- data.frame(pid=pid, tot=nrow(d), miss=sum(imp[idx, pid]==3), 
                          toter= (er01+er02+er10+er12+er20+er21)/nrow(d),
                          er01=er01/sum(d$g2==0), er02=er02/sum(d$g2==0), 
                          er10=er10/sum(d$g2==1), er12=er12/sum(d$g2==1), 
                          er20=er20/sum(d$g2==2), er21=er21/sum(d$g2==2)
                          )
        out <- rbind(out, res)
    }
    out$er0 <- out$er01 + out$er02
    out$er1 <- out$er10 + out$er12
    out$er2 <- out$er20 + out$er21
    
    return(out)
}

submsk=msk[, c("snpid", names(ip68))]
subgeno=geno[, c("snpid", names(ip68))]
dp=depth[, c("ID", names(ip68))]

res <- check_ip_error(submsk, subgeno, dp, imp=ip68, DP=10)

write.table(res, "cache/err_masked.csv", sep=",", row.names=FALSE, quote=FALSE)

####################################################
res <- read.csv("cache/err_masked.csv")

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)
res <- merge(pinfo, res, by.x="founder", "pid")
names(res)[4] <- "totkids"


res[, 7:ncol(res)][res[, 7:ncol(res)] ==0 ] <- 1e-6

pdf("graphs/teo_masked_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=res$totkids, y= log10(res$er2), type="p", col="green", cex=0.6, pch=16, main="Parental Imputing",
     xlab="family size", ylab="Imputing Error (log10)", ylim=c(-6.5, 2))

points(res$totkids, y= log10(res$er0), pch=16, cex=0.6,  col="red")
#points(res$totkids, y= log10(res$er1), pch=16, col="blue")
points(res$totkids, y= log10(res$er1), pch=16, col="blue")
points(x=res$totkids, y= log10(out$toter), pch=16, cex=0.6, col="black")

abline(h=-1, col="black", lwd=2, lty=2)
abline(h=-2, col="red", lwd=2, lty=2)
legend("topright", col=c("black", "red", "blue", "green"), pch=16,
       legend=c("overall", "major (0)", "het (1)", "minor (2)"))
dev.off()

##############################################
res <- read.csv("cache/err_masked.csv")

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)
res <- merge(pinfo, res, by.x="founder", "pid")
names(res)[4] <- "totkids"


mx1 <- matrix(c(1-mean(res$er0), mean(res$er01), mean(res$er02),
                mean(res$er10), 1-mean(res$er1), mean(res$er12),
                mean(res$er20), mean(res$er21), 1-mean(res$er2)),
              byrow=T,nrow=3,ncol=3)
rownames(mx1) <- c("g0", "g1", "g2")
colnames(mx1) <- c("ob0", "ob1", "ob2")
mx1 <- round(mx1,4)

res <- subset(res, totkids > 20)
mx1 <- matrix(c(1-mean(res$er0), mean(res$er01), mean(res$er02),
                mean(res$er10), 1-mean(res$er1), mean(res$er12),
                mean(res$er20), mean(res$er21), 1-mean(res$er2)),
              byrow=T,nrow=3,ncol=3)
rownames(mx1) <- c("g0", "g1", "g2")
colnames(mx1) <- c("ob0", "ob1", "ob2")
mx1 <- round(mx1,4)