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
            ru <- sum(out$hap1.x == out[,4+idx])
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
res1 <- collect_sim2(path="largedata/sim2/", pattern="csv$")
res1$type <- gsub(".*//|_10kloci.csv", "", res1$file)
idx <- grep("_oc", res1$type)
res1 <- res1[-idx,]
write.table(res1, "cache/pp_self_10000loci.csv", sep=",", row.names=FALSE, quote=FALSE)

### rate 50% self and 50% outcrossed
res5 <- collect_sim2(path="largedata/sim2/", pattern="oc_10kloci.csv$")
write.table(res5, "cache/pp_10kloci_rate5.csv", sep=",", row.names=FALSE, quote=FALSE)

### rate 0% self and 100% outcrossed and phased
res0 <- collect_sim2(path="largedata/sim2/", pattern="ocphased_10kloci.csv$")
write.table(res0, "cache/simip_10000loci_ocphased_rate0.csv", sep=",", row.names=FALSE, quote=FALSE)








