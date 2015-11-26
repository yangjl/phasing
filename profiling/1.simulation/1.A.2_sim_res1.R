# Jinliang Yang
# 11.23/2015
# collect simulation results


collect_sim <- function(){
    files <- list.files(path="largedata/sim1/", pattern ="csv$", full.names=TRUE)
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

res <- collect_sim()
write.table(res, "cache/sim_res_1000loci.csv", sep=",", row.names=FALSE, quote=FALSE)
write.table(res, "cache/sim_res_10000loci.csv", sep=",", row.names=FALSE, quote=FALSE)


### plot
pdf("graphs/sim1_res.pdf", width=5, height=5)
res <- read.csv("cache/sim_res_1000loci.csv")
res <- res[order(res$size), ]
plot(res$size, res$err1, type="l", col="blue", lwd=3, main="impute_parent Error rate",
     xlab="size.array (50% self and 50% outcross)", ylab="error rate")
lines(res$size, res$err2, col="red", lty=2, lwd=3)
legend("topright", lty=c(1,2), lwd=3, col=c("blue", "red"), legend=c("Maximum Likelihood", "Odd ratio > 0.7"))
dev.off()