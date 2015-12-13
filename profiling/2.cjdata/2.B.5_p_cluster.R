
# Load the R packages: gdsfmt and SNPRelate
library(gdsfmt)
library(SNPRelate)
library("data.table", lib="~/bin/Rlib/")

imp <- fread("largedata/ip/imputed_parents_or.csv", sep=",")
imp <- as.data.frame(imp)
snpinfo <- read.csv("largedata/ip/snpinfo.csv")

sid <- gsub(":.*", "",  names(imp)[-1])
mx <- as.matrix(imp[, -1])
snpgdsCreateGeno("largedata/lcache/imp_parents.gds", genmat=mx,
                 sample.id= sid, snp.id=snpinfo$snpid, 
                 snp.chromosome= snpinfo$chr,
                 snp.position= snpinfo$pos, snp.allele=NULL, snpfirstdim=TRUE)

genofile <- snpgdsOpen("largedata/lcache/imp_parents.gds")

ibd <- snpgdsIBDMoM(genofile, sample.id=sid, maf=0.1, missing.rate=0.05, num.thread=2)
ibd.coeff <- snpgdsIBDSelection(ibd)

#snp.id <- sample(snpset.id, 1500)  # random 1500 SNPs
ibs <- snpgdsIBS(genofile, MAF =0.1, missing.rate=0.05, num.thread=4)
ibs.hc <- snpgdsHCluster(ibs)
rv <- snpgdsCutTree(ibs.hc)

pdf("graphs/por_cluster_ibs3.pdf", height=5, width=15)
plot(rv$dendrogram, leaflab="perpendicular", main="Cluster based on IBS")
dev.off()
# close the file
snpgdsClose(genofile)

###########
snpgdsGDS2BED(genofile, bed.fn="largedata/lcache/plink_snp")



d = read.table("~/Desktop/plink.genome", header=T)
par(pch=16)
with(d,plot(Z0,Z1, xlim=c(0,1), ylim=c(0,1), type="n"))

with(subset(d,RT=="OT") , points(Z0,Z1,col=3))

#################
snp <- fread("largedata/lcache/teo_recoded.txt")
snp <- as.data.frame(snp)

p <- read.csv("largedata/ip/imputed_parents.csv", nrows=5)
nmp <- gsub("\\.", ":", names(p))
praw <- snp[, nmp]

write.table(praw, "parents_raw.csv", sep=",", row.names=FALSE, quote=FALSE)

snpinfo <- read.csv("largedata/ip/snpinfo.csv")

sid <- gsub(":.*", "",  names(praw)[-1])
mx <- as.matrix(praw[, -1])
snpgdsCreateGeno("largedata/lcache/raw_parents.gds", genmat=mx,
                 sample.id= sid, snp.id=snpinfo$snpid, 
                 snp.chromosome= snpinfo$chr,
                 snp.position= snpinfo$pos, snp.allele=NULL, snpfirstdim=TRUE)

genofile <- snpgdsOpen("largedata/lcache/raw_parents.gds")

ibd <- snpgdsIBDMoM(genofile, sample.id=sid, maf=0.05, missing.rate=0.05, num.thread=2)
ibd.coeff <- snpgdsIBDSelection(ibd)

#snp.id <- sample(snpset.id, 1500)  # random 1500 SNPs
ibs <- snpgdsIBS(genofile, num.thread=4)
ibs.hc <- snpgdsHCluster(ibs)
rv <- snpgdsCutTree(ibs.hc)

pdf("graphs/praw_cluster_ibs.pdf", height=5, width=15)
plot(rv$dendrogram, leaflab="perpendicular", main="Cluster based on IBS")
dev.off()