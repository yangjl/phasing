### Jinliang Yang
### 12/8/2015


library("data.table", lib="~/bin/Rlib")
library("imputeR")

ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)

##### round1 self > 40, depth>10
imp67 <- read.csv("largedata/ip/imp67.csv")

if(sum(geno$snpid != row.names(imp67)) >0) stop("!!! ERROR")
ncol(geno[, names(imp67)])
geno[, names(imp67)] <- imp67


####################################################
pinfo <- pedinfo(ped)
iperr <- estimate_error(geno, ped, self_cutoff=30, depth_cutoff=10, check_kid_err=FALSE)
iperr <- merge(pinfo, iperr, by.x="founder", by.y="fam")
write.table(iperr, "cache/post_iper35.csv", sep=",", row.names=FALSE, quote=FALSE)


####################################################
out <- read.csv("cache/post_iper35.csv")
out[, 5:13][out[, 5:13] ==0 ] <- 1e-6

pdf("graphs/teo_ip_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=1, y= 1, type="n", col="black", pch=16, main="Parents (N=35) Imputation",
     xlab="Number of selfed kids", ylab="Imputing Error (log10)", xlim=c(20,100), ylim=c(-6,2))

points(out$nselfer, y= log10(out$er0), pch=16, col="red")
points(out$nselfer, y= log10(out$er1), pch=16, col="blue")
points(out$nselfer, y= log10(out$er2), pch=16, col="green")

abline(h=-2, col="red", lwd=2, lty=2)
legend("topright", col=c( "red", "blue", "green"), pch=16,
       legend=c("major (0)", "het (1)", "minor (2)"))
dev.off()

####################################################
out <- read.csv("cache/post_iper35.csv")
per <- out
mx1 <- matrix(c(1-mean(per$er0), mean(per$er01), mean(per$er02),
                mean(per$er10), 1-mean(per$er1), mean(per$er12),
                mean(per$er20), mean(per$er21), 1-mean(per$er2)),
              byrow=T,nrow=3,ncol=3)
rownames(mx1) <- c("g0", "g1", "g2")
colnames(mx1) <- c("ob0", "ob1", "ob2")
mx1 <- round(mx1,4)

