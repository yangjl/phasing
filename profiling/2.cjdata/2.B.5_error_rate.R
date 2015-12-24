### Jinliang Yang
### 12/8/2015


library("data.table", lib="~/bin/Rlib")
library("imputeR")
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)


##### round1 self > 40
ip24 <- read.csv("largedata/ip/round1_ip24.csv")
names(ip24) <- gsub("\\.", ":", names(ip24))
myped <- subset(ped, parent1 == parent2 & parent1 %in% names(ip24))
#mygeno <- subset(geno, snpid %in% row.names(test))
err1 <- estimate_error(geno, ped=myped, self_cutoff=30, depth_cutoff=10, est_kids = FALSE)
write.table(err1, "cache/round1_ip24_err1.csv", sep=",", row.names=FALSE, quote=FALSE)

mygeno <- subset(geno, snpid %in% row.names(ip24))
mygeno[, names(ip24)] <- ip24
err2 <- estimate_error(geno=mygeno, ped=myped, self_cutoff=30, depth_cutoff=10, est_kids = FALSE)
write.table(err2, "cache/round1_ip24_err2.csv", sep=",", row.names=FALSE, quote=FALSE)


##### round1 self > 20
ip21 <- read.csv("largedata/ip/round2_ip21.csv")
names(ip21) <- gsub("\\.", ":", names(ip21))

ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
subped <- subset(ped, parent1 == parent2 & parent1 %in% names(ip21))


#mygeno <- subset(geno, snpid %in% row.names(test))
err1 <- estimate_error(geno, ped=subped, self_cutoff=20, depth_cutoff=7, est_kids = FALSE)
write.table(err1, "cache/round2_ip21_err1.csv", sep=",", row.names=FALSE, quote=FALSE)

mygeno <- subset(geno, snpid %in% row.names(ip21))
mygeno[, names(ip21)] <- ip21
err2 <- estimate_error(geno=mygeno, ped=subped, self_cutoff=20, depth_cutoff=7, est_kids = FALSE)
write.table(err2, "cache/round2_ip21_err2.csv", sep=",", row.names=FALSE, quote=FALSE)


err21 <- read.csv("cache/round2_ip21_err1.csv")
err22 <- read.csv("cache/round2_ip21_err2.csv")

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