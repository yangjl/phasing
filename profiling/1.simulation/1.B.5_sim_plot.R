### Jinliang Yang
### 12/7/2015
### plot simulation results

### plot ###############################################
res1 <- read.csv("cache/pp_self_10000loci.csv")
res1$size <- as.numeric(as.character(gsub("size", "", res1$type)))
res1 <- res1[order(res1$size), ]
lo1 <- loess(res1$rate~res1$size)


lo0 <- loess(res0$rate~res0$size)


pdf("graphs/sim_pp.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=0, y=0, type="n",  main="Parental Phasing",
     xlab="family size", ylab="Phasing Error Rate", xlim=c(1,100), ylim=c(0,1))
lines(predict(lo1), col="blue", lwd=3, lty=1)
lines(predict(lo5), col="red", lwd=3, lty=2)
lines(predict(lo0), col="green", lwd=3, lty=4)
abline(h=0.1, lty=2, lwd=2)
abline(v=40, lwd=2)
legend("topright", col=c("red", "blue", "green"), lty=c(1,2,4), lwd=3,
       legend=c("self kids", "50% self + 50% oc", "outcross kids"))
dev.off()

###################################
par(mfrow=c(3,1))

plot(res5$size, res5$rate, type="l", col="blue", lwd=3, main="50% Selfed and 50% Outcrossed (non-Phased Parents)",
     xlab="family size", ylab="Phasing Error Rate", ylim=c(0,1))
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)


plot(res0$size, res0$rate, type="l", col="blue", lwd=3, main="100% Outcrossed Kids (Phased Parents)",
     xlab="family size", ylab="Phasing Error Rate", ylim=c(0,1))
abline(h=0.1, lty=4, lwd=2, col="red")
abline(v=30)

