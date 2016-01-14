### Jinliang Yang
### use impute_parent in CJ data

load(file="~/Documents/Github/imputeR/largedata/teo.RData")


### checking parentage
p1 <- read.table("data/parentage_info.txt", header=TRUE)
p2 <- read.csv("data/Teosinte_2013_2014_Pedigree.csv")
t <- merge(p1, p2, by.x="proid", by.y="Taxa")


pedinfo <- function(pedfile="data/parentage_info.txt", outfile="data/parentage_sum.txt"){
    ped <- read.table(pedfile, header =TRUE)

    ped$parent1 <- as.character(ped$parent1)
    ped$parent2 <- as.character(ped$parent2)
    
    sf <- subset(ped, parent1 == parent2)
    ox <- subset(ped, parent1 != parent2)
    
    pinfo <- data.frame(table(sf$parent1))
    names(pinfo) <- c("founder", "nselfer")
    
    oxinfo <- data.frame(table(c(ox$parent1, ox$parent2)))
    names(oxinfo) <- c("founder", "nox")
    
    pinfo <- merge(pinfo, oxinfo, by="founder", all=TRUE)
   
    pinfo$sid <- gsub("..:.*", "", pinfo$founder)
    pinfo$sid <- gsub("_m", "", pinfo$sid)
    
    pinfo[is.na(pinfo)] <- 0
    pinfo$tot <- pinfo$nselfer + pinfo$nox
    
    message(sprintf("#> total kids/haps [ %s/%s ], parents with kids/total parents [ %s/70 ]",
                    nrow(ped), sum(pinfo$nselfer, na.rm=T)*2 + sum(pinfo$nox), nrow(pinfo)))
    write.table(pinfo, outfile, sep="\t", row.names=FALSE, quote=FALSE)
}

pedinfo(pedfile="data/parentage_info.txt", outfile="data/parentage_sum.txt")
#> total kids/haps [ 4805/9610 ], parents with kids/total parents [ 68/70 ]



# plot #############
pdf("graphs/parentage.pdf", width=6, height=4)
pinfo <- read.table("data/parentage_sum.txt", header=TRUE)
par(mfrow=c(1,1))
counts <- pinfo[, c("nselfer", "nox")]
counts[is.na(counts)] <- 0
counts$tot <- counts$nselfer + counts$nox
counts <- counts[order(counts$tot, decreasing=T), ]
counts <- as.matrix(t(counts[,1:2]))

barplot(counts, main="Family Size Distribution", xlab="families", col=c("darkblue","red"), 
        legend = c("selfed", "outcrossed"))
abline(h=20, lwd=4, lty=4, col="red")
dev.off()


sum(subset(pinfo, tot<20)$tot)
nrow(subset(pinfo, tot<20))
