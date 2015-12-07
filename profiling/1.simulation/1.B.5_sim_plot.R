### Jinliang Yang
### 12/7/2015
### plot simulation results

### plot ###############################################
res1 <- read.csv("cache/pp_self_10000loci.csv")
res1$type <- as.numeric(as.character(gsub("size", "", res1$type)))

res5 <- read.csv("cache/simip_10000loci_rate5.csv")
res0 <- read.csv("cache/simip_10000loci_rate0.csv")



res1 <- res1[order(res1$type), ]
plot(res1$type, res1$rate, type="p", col="blue", lwd=3, main="phase_parent Error rate",
     xlab="family size (0% self and 100% outcross)", ylab="error rate")
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)

plot(res1$type, res1$chunk, type="p", col="blue", lwd=3, main="phase_parent Error rate",
     xlab="family size (0% self and 100% outcross)", ylab="error rate")


legend("topright", lty=c(1,2), lwd=3, col=c("blue", "red"), legend=c("Maximum Likelihood", "Odd ratio > 0.7"))



######
pdf("graphs/sim1_impute_parent.pdf", width=15, height=5)
par(mfrow=c(1,3))
res5 <- res5[order(res5$size), ]
plot(res5$size, res5$err1, type="l", col="blue", lwd=3, main="impute_parent Error rate",
     xlab="family (50% self and 50% outcross)", ylab="error rate", ylim=c(0, 0.7))
lines(res5$size, res5$err2, col="red", lty=2, lwd=3)
abline(h=0.1, lty=4, lwd=2, col="red")
legend("topright", lty=c(1,2), lwd=3, col=c("blue", "red"), legend=c("Maximum Likelihood", "Odd ratio > 0.7"))

res0 <- res0[order(res0$size), ]
plot(res0$size, res0$err1, type="l", col="blue", lwd=3, main="impute_parent Error rate",
     xlab="family size (0% self and 100% outcross)", ylab="error rate", ylim=c(0, 0.7))
lines(res0$size, res0$err2, col="red", lty=2, lwd=3)
abline(h=0.1, lty=4, lwd=2, col="red")
legend("topright", lty=c(1,2), lwd=3, col=c("blue", "red"), legend=c("Maximum Likelihood", "Odd ratio > 0.7"))

res1 <- res1[order(res1$size), ]
plot(res1$size, res1$err1, type="l", col="blue", lwd=3, main="impute_parent Error rate",
     xlab="family size (0% self and 100% outcross)", ylab="error rate", ylim=c(0, 0.7))
lines(res1$size, res1$err2, col="red", lty=2, lwd=3)
abline(h=0.1, lty=4, lwd=2, col="red")
legend("topright", lty=c(1,2), lwd=3, col=c("blue", "red"), legend=c("Maximum Likelihood", "Odd ratio > 0.7"))


dev.off()
