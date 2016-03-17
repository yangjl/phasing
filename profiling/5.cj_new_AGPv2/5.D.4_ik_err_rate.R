### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

####################################################
ipgeno <- fread("largedata/teo_imputeR_03162016.txt")
ipgeno <- as.data.frame(ipgeno)

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
ped <- ped[-4741,]

posterr <-  estimate_error(geno=ipgeno, ped, self_cutoff=30, depth_cutoff=10, check_kid_err = TRUE)
perr <- posterr[[1]]
kerr <- posterr[[2]]
kerr$er0 <- kerr$kerr01 + kerr$kerr02
kerr$er1 <- kerr$kerr10 + kerr$kerr12
kerr$er2 <- kerr$kerr20 + kerr$kerr21
kerr$toter <- (kerr$er0*kerr$nmaj + kerr$er1*kerr$nhet + kerr$er2*kerr$nmnr)/(kerr$nmaj + kerr$nhet + kerr$nmnr)

write.table(perr, "cache/teo_post_perr.csv", sep=",", row.names=FALSE, quote=FALSE)
write.table(kerr, "cache/teo_post_kerr.csv", sep=",", row.names=FALSE, quote=FALSE)


####################################################

res0 <- read.csv("cache/teo_post_kerr.csv")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)
names(pinfo)[4] <- "totkids"

res <- merge(ped, res0, by.x="proid", "kid")

res <- merge(pinfo, res, by.x="founder", by.y="parent1")
names(res)[1] <- "parent1"
res <- merge(pinfo, res, by.x="founder", by.y="parent2")
names(res)[1] <- "parent2"

res$avg <- (res$totkids.x + res$totkids.y)/2
res <- res[order(res$avg),]



res[, 7:ncol(res)][res[, 7:ncol(res)] ==0 ] <- 1e-4

pdf("graphs/teo_masked_kid_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=res$avg, y= log10(res$er2), type="p", col="green", pch=16, cex=0.6, main="Kids (N=4,762)",
     xlab="Avg parental family size", ylab="Imputing Error (log10)", ylim=c(-4.5, 2))

points(res$avg, y= log10(res$er0), pch=16, cex=0.6, col="red")
points(res$avg, y= log10(res$er1), pch=16, cex=0.6, col="blue")
points(res$avg, y= log10(res$toter), pch=16, cex=0.6, col="black")
#points(res$totkids, y= log10(res$er1), pch=16, col="blue")

abline(h=-1, col="black", lwd=2, lty=2)
abline(h=-2, col="red", lwd=2, lty=2)
legend("topright", col=c("black", "red", "blue", "green"), pch=16,
       legend=c("overall", "major (0)", "het (1)", "minor (2)"))
dev.off()

##############################################
ker <- read.csv("cache/teo_post_kerr.csv")

mx2 <- matrix(c(1-mean(ker$kerr01, na.rm=T)-mean(ker$kerr02, na.rm=T), mean(ker$kerr01, na.rm=T), mean(ker$kerr02, na.rm=T),
                mean(ker$kerr10, na.rm=T), 1-mean(ker$kerr10, na.rm=T)-mean(ker$kerr12, na.rm=T), mean(ker$kerr12, na.rm=T),
                mean(ker$kerr20, na.rm=T), mean(ker$kerr21, na.rm=T), 1-mean(ker$kerr20, na.rm=T)-mean(ker$kerr21, na.rm=T)),
              byrow=T,nrow=3,ncol=3)
rownames(mx2) <- c("g0", "g1", "g2")
colnames(mx2) <- c("ob0", "ob1", "ob2")
mx2 <- round(mx2, 4)
