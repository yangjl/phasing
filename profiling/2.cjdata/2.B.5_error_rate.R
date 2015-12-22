### Jinliang Yang
### 12/8/2015


library("data.table", lib="~/bin/Rlib")
library("imputeR")
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

ped <- read.table("data/parentage_info.txt", header=TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
pinfo <- pedinfo(ped)


#####
test <- read.csv("largedata/obs/PC_I50_ID2_mrg:250276265_chr10.csv")
pid <- "PC_I50_ID2_mrg:250276265"
myped <- subset(ped, parent1 == parent2 & parent1 == pid)
mygeno <- subset(geno, snpid %in% row.names(test))
err1 <- estimate_error(geno=mygeno, ped=myped, self_cutoff=30, depth_cutoff=10, est_kids = FALSE)

mygeno[, pid] <- test$gmax
err2 <- estimate_error(geno=mygeno, ped=myped, self_cutoff=30, depth_cutoff=10, est_kids = FALSE)



############
out <- imp_checking(imp, mx, ped, depth_cutoff=10)
write.table(out, "cache/imp_err.csv", sep=",", row.names=FALSE, quote=FALSE)


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