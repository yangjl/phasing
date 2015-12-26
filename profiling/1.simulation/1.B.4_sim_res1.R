# Jinliang Yang
# 11.23/2015
# collect simulation results


collect_sim2 <- function(path="largedata/sim2/", pattern="csv$"){
    files <- list.files(path, pattern, full.names=TRUE)
    outfile <- data.frame()
    for(i in 1:length(files)){
        res <- read.csv(files[i])
        res <- res[order(res$idx),]
        #error rates
        totru <- 0
        chunks <- unique(res$chunk)
        chunks <- chunks[chunks > 0 ]
        for(ci in chunks){
            out <- subset(res, chunk == ci)
            idx <- which.max(c(sum(out$hap1.x == out$hap1.y), sum(out$hap1.x == out$hap2.y)))
            ru <- sum(out$hap1.x == out[, 5+idx])
            totru <- totru + ru
        }

        tem <- data.frame(file=files[i], het=nrow(res), err =nrow(res)-totru, chunk= length(chunks))
        tem$rate <- tem$err/tem$het
        outfile <- rbind(outfile, tem)
    }
    outfile <- outfile[order(outfile$file),]
    return(outfile)
}

### rate 100% self and 0% outcrossed
res <- collect_sim2(path="largedata/sim2/", pattern="csv$")
res$type <- gsub(".*//|_1k.csv", "", res$file)

res$size <- as.numeric(as.character(gsub("size|_.*", "", res$type)))
res$type <- gsub(".*_", "", res$type)
write.table(res1, "cache/pp_sim_1k.csv", sep=",", row.names=FALSE, quote=FALSE)



res1 <- subset(res, type=="rate1")
res1 <- res1[order(res1$size),]
lo1 <- loess(res1$rate~res1$size)

res0 <- subset(res, type=="rate0")
res0 <- res0[order(res0$size),]
lo0 <- loess(res0$rate~res0$size)

res5 <- subset(res, type=="rate0.5")
res5 <- res5[order(res5$size),]
lo5 <- loess(res5$rate~res5$size)




