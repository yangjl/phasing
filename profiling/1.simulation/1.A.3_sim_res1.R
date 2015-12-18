# Jinliang Yang
# 11.23/2015
# collect simulation results


### rate 50% self and 50% outcrossed
res1 <- read.csv("cache/simip_out1.csv")
res2 <- read.csv("cache/simip_out2.csv")
res3 <- read.csv("cache/simip_out3.csv")
res41 <- read.csv("cache/simip_out4.csv")
res42 <- read.csv("cache/simip_out4_2.csv")
res4 <- rbind(res41, res42)

res5 <- read.csv("cache/simip_out5.csv")

### plot ###############################################
lo1 <- loess(res1$error/1000~res1$size)
lo2 <- loess(res2$error/1000~res2$size)
lo3 <- loess(res3$error/1000~res3$size)
lo4 <- loess(res4$error/1000~res4$size)
lo5 <- loess(res5$error/1000~res5$size)


pdf("graphs/sim_ip.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=0, y=0, type="n",  main="Parental Imputing",
     xlab="family size", ylab="Imputing Error Rate", xlim=c(1, 100), ylim=c(0,0.3))
lines(predict(lo1), col="red", lwd=3, lty=1)
lines(predict(lo2), col="blue", lwd=3, lty=2)
lines(predict(lo3), col="green", lwd=3, lty=3)
lines(predict(lo4), col="black", lwd=3, lty=4)
lines(predict(lo5), col="yellow", lwd=3, lty=5)
abline(h=0.05, lty=2, lwd=2)
#abline(v=10, lwd=2)
abline(v=20, lwd=2)
legend("topright", col=c("red", "blue", "green", "black", "yellow"), lty=c(1,2,3,4,5), lwd=3,
       legend=c("all self", "half self + half oc (unknown)", "half self + half oc (known)",
                "all oc (unknown)", "all oc (known"))
dev.off()






#############
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





