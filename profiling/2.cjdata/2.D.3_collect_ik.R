### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)

get_ik <- function(path="largedata/ik", pattern="kid_geno"){
    files <- list.files(path, pattern, full.names = TRUE)
    
    kgeno <- read.csv(files[1])
    for(i in 2:length(files)){
        ktem <- read.csv(files[i])
        
        if(sum(kgeno$snpid != ktem$snpid) == 0){
            kgeno <- cbind(kgeno, ktem[, -1])
            message(sprintf("###>>> read the [ %s/%s ] file", i, length(files)))
        }else{
            stop("!!! snpid not match !!!")
        }
    }
    return(kgeno)
}


ikgeno <- get_ik(path="largedata/ik", pattern="kid_geno")


#library(imputeR)
library(data.table, lib="~/bin/Rlib/")

imp68 <- read.csv("cache/imp68.csv")

ipgeno <- merge(imp68, ikgeno, by.x="row.names", by.y="snpid", sort=FALSE)
names(ipgeno)[1] <- "snpid"
names(ipgeno) <- gsub("\\.", ":", names(ipgeno))

write.table(ipgeno, "largedata/teo_imputeR_01112016.txt", sep="\t", row.names=FALSE, quote=FALSE)


ped <- read.table("data/parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)

library(imputeR)
posterr <- estimate_error(geno=ipgeno, ped, self_cutoff=30, depth_cutoff=10, est_kids = TRUE)
perr <- posterr[[1]]
kerr <- posterr[[2]]
kerr$er0 <- kerr$kerr01 + kerr$kerr02
kerr$er1 <- kerr$kerr10 + kerr$kerr12
kerr$er2 <- kerr$kerr20 + kerr$kerr21
kerr$toter <- (kerr$er0*kerr$nmaj + kerr$er1*kerr$nhet + kerr$er2*kerr$nmnr)/(kerr$nmaj + kerr$nhet + kerr$nmnr)

write.table(perr, "cache/post_perr.csv", sep=",", row.names=FALSE, quote=FALSE)
write.table(kerr, "cache/post_kerr.csv", sep=",", row.names=FALSE, quote=FALSE)



########################
kerr <- read.csv("cache/post_kerr.csv")
ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)

out <- merge(kerr, ped, by.x="kid", by.y="proid")
out <- merge(out, pinfo, by.x="parent1", by.y="founder")
out <- merge(out, pinfo, by.x="parent2", by.y="founder")
out$nselfer <- (out$nselfer.x + out$nselfer.y)/2

pdf("graphs/teo_ik_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(out$nselfer, y= log10(out$er2), pch=16, col="green", cex=0.6, type="p",main="Kids (N=1,291) Imputation",
     xlab="Mean Number of selfed kids in Parental families", ylab="Imputing Error (log10)", xlim=c(30,80), ylim=c(-6,2))

points(out$nselfer, y= log10(out$er0), pch=16,cex=0.6, col="red")
points(out$nselfer, y= log10(out$er1), pch=16, cex=0.6,col="blue")
points(x=out$nselfer, y= log10(out$toter), pch=16,cex=0.6, col="black")

abline(h=-2, col="red", lwd=2, lty=2)
legend("topright", col=c("black", "red", "blue", "green"), pch=16,
       legend=c("overall", "major (0)", "het (1)", "minor (2)"))
dev.off()


##################
kerr <- read.csv("cache/post_kerr.csv")


mx2 <- matrix(c(1-mean(kerr$er0), mean(kerr$kerr01), mean(kerr$kerr02),
                mean(kerr$kerr10), 1-mean(kerr$er1), mean(kerr$kerr12),
                mean(kerr$kerr20), mean(kerr$kerr21), 1-mean(kerr$er2)),
              byrow=T,nrow=3,ncol=3)
rownames(mx2) <- c("g0", "g1", "g2")
colnames(mx2) <- c("ob0", "ob1", "ob2")
mx2 <- round(mx2,6)



