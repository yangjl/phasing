### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)
####################################################
res0 <- read.csv("cache/err_masked.csv")

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)
names(pinfo)[4] <- "totkids"

res <- merge(ped, res0, by.x="proid", "pid")

res <- merge(pinfo, res, by.x="founder", by.y="parent1")
names(res)[1] <- "parent1"
res <- merge(pinfo, res, by.x="founder", by.y="parent2")
names(res)[1] <- "parent2"

res$avg <- (res$totkids.x + res$totkids.y)/2
res <- res[order(res$avg),]



res[, 7:ncol(res)][res[, 7:ncol(res)] ==0 ] <- 1e-6

pdf("graphs/teo_masked_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=res$totkids, y= log10(res$toter), type="p", col="black", pch=16, main="Parental Imputing",
     xlab="family size", ylab="Imputing Error (log10)", ylim=c(-6.5, 2))

points(res$totkids, y= log10(res$er0), pch=16, col="red")
points(res$totkids, y= log10(res$er1), pch=16, col="blue")
points(res$totkids, y= log10(res$er2), pch=16, col="green")

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
