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

submsk=msk[, c("snpid", names(ip68))]
subgeno=geno[, c("snpid", names(ip68))]
dp=depth[, c("ID", names(ip68))]

check_ip_error <- function(submsk, subgeno, dp, imp=ip68, DP=10){
    
    if(sum(submsk$snpid != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    if(sum(subgeno$snpid != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    if(sum(dp$ID != row.names(imp)) > 0) stop("!!! ID not identical !!!")
    
    out <- data.frame()
    for(i in 2:ncol(dp)){
        pid <- names(dp)[i]
        idx1 <- which(dp[, pid] >= DP)
        idx2 <- which(msk[, pid] == 3 )
        
        idx <- idx1[idx1 %in% idx2]
        
        geno1 <- imp[idx, pid]
        geno2 <- geno[idx, pid]
        
        d <- data.frame(g1=imp[idx, pid], g2=geno[idx, pid])
        d <- subset(d, g1 != 3)
        
        er01 <- nrow(subset(d, g2 ==0 & g1 == 1))
        er02 <- nrow(subset(d, g2 ==0 & g1 == 2))
        er10 <- nrow(subset(d, g2 ==1 & g1 == 0))
        er12 <- nrow(subset(d, g2 ==1 & g1 == 2))
        er20 <- nrow(subset(d, g2 ==2 & g1 == 0))
        er21 <- nrow(subset(d, g2 ==2 & g1 == 1))
        
        res <- data.frame(pid=pid, tot=nrow(d), miss=sum(imp[idx, pid]==3), 
                          toter=er01+er02+er10+er12+er20+er21,
                          er01=er01, er02=er02, er10=er10, er12=er12, er20=er20, er21=er21,
                          tot0=sum(d$g2==0), tot1=sum(d$g2==1), tot2=sum(d$g2==2))
        out <- rbind(out, res)
    }
    return(out)
}

submsk=msk[, c("snpid", names(ip68))]
subgeno=geno[, c("snpid", names(ip68))]
dp=depth[, c("ID", names(ip68))]

res <- check_ip_error(submsk, subgeno, dp, imp=ip68, DP=10)

write.table(res, "cache/err_masked.csv", sep=",", row.names=FALSE, quote=FALSE)


mx1 <- matrix(c(1, mean(res$er01/res$tot0), mean(res$er02/res$tot0),
                mean(res$er10/res$tot1), 1, mean(res$er12/res$tot1),
                mean(res$er20/res$tot2), mean(res$er21/res$tot2), 1),
              byrow=T,nrow=3,ncol=3)
mx1 <- matrix(1, byrow=T, nrow=3, ncol=3)
rownames(mx1) <- c("g0", "g1", "g2")
colnames(mx1) <- c("ob0", "ob1", "ob2")


####################################################
res <- read.csv("cache/err_masked.csv")
pinfo <- read.csv("cache/pinfo.csv")
names(pinfo)[4] <- "totkids"
out <- merge(pinfo, res, by.x="founder", by.y="pid")
out <- out[order(out$totkids),]

out$ter <- log10(out$toter/out$tot)
out$err0 <- log10(out$er0/out$tot0)
out$err1 <- log10(out$er1/out$tot1)
out$err2 <- log10(out$er2/out$tot2)
out[is.infinite(out$err1), ]$err1 <- -3
out[is.infinite(out$err2), ]$err2 <- -3

pdf("graphs/teo_masked_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=out$totkids, y= out$ter, type="p", col="black", pch=16, main="Parental Imputing",
     xlab="family size", ylab="Imputing Error (log10)", ylim=c(-4, 2))

points(out$totkids, y= out$err0, pch=16, col="red")
points(out$totkids, y= out$err1, pch=16, col="blue")
points(out$totkids, y= out$err2, pch=16, col="green")

abline(h=-1, col="red", lwd=2, lty=2)
legend("topright", col=c("black", "red", "blue", "green"), pch=16,
       legend=c("overall", "major (0)", "het (1)", "minor (2)"))
dev.off()


cor(imp$PC_I58_ID1_1, imp$PC_I58_ID2_mrg)