# Jinliang Yang
# 11.23/2015
# collect simulation results


collect_sim <- function(ptn="csv$"){
    files <- list.files(path="largedata/sim1/", pattern =ptn, full.names=TRUE)
    out <- data.frame()
    for(i in 1:length(files)){
        res <- read.csv(files[i])
        
        #error rates
        e1 <- nrow(subset(res, gmax != true_parent ))/nrow(res)
        e2 <- nrow(subset(res, gor != true_parent & gor !=3 ))/nrow(res)
        
        tem <- data.frame(file=files[i], err1=e1, err2=e2)
        out <- rbind(out, tem)
    }
    out$size <- gsub(".*res_", "", out$file)
    out$size <- gsub("_.*", "", out$size)
    return(out)
}

### rate 50% self and 50% outcrossed
res5 <- collect_sim(ptn="srate0.5.csv$")
write.table(res5, "cache/simip_10000loci_rate5.csv", sep=",", row.names=FALSE, quote=FALSE)

### rate 0% self and 100% outcrossed
res0 <- collect_sim(ptn="srate0.csv$")
write.table(res0, "cache/simip_10000loci_rate0.csv", sep=",", row.names=FALSE, quote=FALSE)

### rate 100% self and 0% outcrossed
res1 <- collect_sim(ptn="srate1.csv$")
write.table(res1, "cache/simip_10000loci_rate1.csv", sep=",", row.names=FALSE, quote=FALSE)


### plot ###############################################
res5 <- read.csv("cache/simip_10000loci_rate5.csv")
res0 <- read.csv("cache/simip_10000loci_rate0.csv")
res1 <- read.csv("cache/simip_10000loci_rate1.csv")


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





