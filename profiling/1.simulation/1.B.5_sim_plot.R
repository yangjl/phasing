### Jinliang Yang
### 12/7/2015
### plot simulation results

### plot ###############################################
res1 <- read.csv("cache/pp_self_10000loci.csv")
res1$type <- as.numeric(as.character(gsub("size", "", res1$type)))
res1 <- res1[order(res1$type), ]


res5 <- read.csv("cache/pp_10kloci_rate5.csv")
res5$size <- gsub(".*//|_oc_10k.*", "", res5$file)
res5$size <- as.numeric(as.character(gsub("size", "", res5$size)))
res5 <- res5[order(res5$size),]


res0 <- read.csv("cache/simip_10000loci_ocphased_rate0.csv")
res0$size <- gsub(".*//|_ocphased.*", "", res0$file)
res0$size <- as.numeric(as.character(gsub("size", "", res0$size)))
res0 <- res0[order(res0$size),]



par(mfrow=c(1,3))
plot(res1$type, res1$rate, type="l", col="blue", lwd=3, main="100% Selfed Kids",
     xlab="family size", ylab="Phasing Error Rate", ylim=c(0,1))
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)

plot(res5$size, res5$rate, type="l", col="blue", lwd=3, main="50% Selfed and 50% Outcrossed (non-Phased Parents)",
     xlab="family size", ylab="Phasing Error Rate", ylim=c(0,1))
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)


plot(res0$size, res0$rate, type="l", col="blue", lwd=3, main="100% Outcrossed Kids (Phased Parents)",
     xlab="family size", ylab="Phasing Error Rate", ylim=c(0,1))
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)

