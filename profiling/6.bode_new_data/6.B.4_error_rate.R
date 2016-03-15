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
ip53 <- read.csv("largedata/bode/ip53_imputed.csv", sep=",", header=TRUE)
names(ip53) <- gsub("\\.", ":", names(ip53))
names(ip53) <- gsub("^X", "", names(ip53))
if(sum(geno$snpid != row.names(ip53)) > 0) stop("!!! ERRROR !!!")
dim(geno[, names(ip53)])
geno[, names(ip53)] <- ip53

##### round1 self > 40
err <- estimate_error(geno, ped, self_cutoff=30, depth_cutoff=10, check_kid_err = TRUE)
write.table(err, "cache/bode_postip_err.csv", sep=",", row.names=FALSE, quote=FALSE)



####################################################
out <- read.csv("cache/bode_postip_err.csv")

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


