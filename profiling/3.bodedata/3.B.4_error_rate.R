### Jinliang Yang
### 12/31/2015


library("data.table", lib="~/bin/Rlib")
library("imputeR")

### read genotype. snpinfo and pedigree data
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)

ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)

#### update geno matrix
ip13 <- read.csv("largedata/bode/ip/round1_ip13.csv", sep=",", header=TRUE)
names(ip13) <- gsub("\\.", ":", names(ip13))
names(ip13) <- gsub("^X", "", names(ip13))
#geno <- subset(geno, snpid %in% row.names(ip13))
geno[, names(ip13)] <- ip13

ip15 <- read.csv("largedata/bode/ip/round2_ip15.csv")
names(ip15) <- gsub("\\.", ":", names(ip15))
names(ip15) <- gsub("^X", "", names(ip15))
#geno <- subset(geno, snpid %in% row.names(ip13))
geno[, names(ip15)] <- ip15

ip16 <- read.csv("largedata/bode/ip/round3_ip16.csv")
names(ip16) <- gsub("\\.", ":", names(ip16))
names(ip16) <- gsub("^X", "", names(ip16))
#geno <- subset(geno, snpid %in% row.names(ip13))
geno[, names(ip16)] <- ip16


##### round1 self > 40
err <- estimate_error(geno, ped, self_cutoff=30, 
                      depth_cutoff=10, est_kids = FALSE)
write.table(err, "cache/bode_postip_err.csv", sep=",", row.names=FALSE, quote=FALSE)


err11 <- read.csv("cache/round1_ip24_err1.csv")
err12 <- read.csv("cache/round1_ip24_err2.csv")



####################################################
out <- read.csv("cache/imp_err.csv")


pdf("graphs/teo_ip_err.pdf", width=5, height=5)
par(mfrow=c(1,1))
plot(x=out$nselfer, y= log10(out$err), type="p", col="black", pch=16, main="Parental Imputing",
     xlab="family size", ylab="Imputing Error (log10)", xlim=c(20,100), ylim=c(-6,2))

points(out$nselfer, y= log10(out$err0), pch=16, col="red")
points(out$nselfer, y= log10(out$err1), pch=16, col="blue")
points(out$nselfer, y= log10(out$err2), pch=16, col="green")

abline(h=-1, col="red", lwd=2, lty=2)
legend("topright", col=c("black", "red", "blue", "green"), pch=16,
       legend=c("overall", "major (0)", "het (1)", "minor (2)"))
dev.off()


cor(imp$PC_I58_ID1_1, imp$PC_I58_ID2_mrg)