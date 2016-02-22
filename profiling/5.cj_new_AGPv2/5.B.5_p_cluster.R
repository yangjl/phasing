### Jinliang Yang

# Load the R packages: gdsfmt and SNPRelate
library(gdsfmt)
library(SNPRelate)
library("data.table", lib="~/bin/Rlib/")


snpinfo <- read.csv("cache/snpinfo_self30.csv")

ip24 <- read.csv("largedata/ip/round1_ip24.csv")
ip21 <- read.csv("largedata/ip/round2_ip21.csv")
ip23 <- read.csv("largedata/ip/round3_ip23.csv")

imp <- cbind(ip24, ip21, ip23)
write.table(imp, "cache/imp68.csv", sep=",", row.names=TRUE, quote=FALSE)

sid <- gsub("\\..*", "",  names(imp))
mx <- as.matrix(imp)
snpgdsCreateGeno("largedata/lcache/imp_parents.gds", genmat=mx,
                 sample.id= sid, snp.id=snpinfo$snpid, 
                 snp.chromosome= snpinfo$chr,
                 snp.position= snpinfo$pos, snp.allele=NULL, snpfirstdim=TRUE)


genofile <- snpgdsOpen("largedata/lcache/imp_parents.gds")
#snp.id <- sample(snpset.id, 1500)  # random 1500 SNPs
ibs <- snpgdsIBS(genofile, maf=0.01, missing.rate=0.05, num.thread=4)
ibs.hc <- snpgdsHCluster(ibs)
rv <- snpgdsCutTree(ibs.hc)

pdf("graphs/cluster_ibs_rounds3.pdf", height=5, width=15)
plot(rv$dendrogram, leaflab="perpendicular", main="Cluster based on IBS")
dev.off()
# close the file
snpgdsClose(genofile)

