
# Load the R packages: gdsfmt and SNPRelate
library(gdsfmt)
library(SNPRelate)
library("data.table", lib="~/bin/Rlib/")

imp <- fread("largedata/ip/imputed_parents.csv", sep=",")
imp <- as.data.frame(imp)
snpinfo <- read.csv("largedata/ip/snpinfo.csv")

sid <- gsub(":.*", "",  names(imp)[-1])

snpgdsCreateGeno("largedata/lcache/imp_parents.gds", genmat=as.matrix(imp[, -1]),
                 sample.id= sid , snp.id=snpinfo$snpid, 
                 snp.chromosome= snpinfo$chr,
                 snp.position= snpinfo$pos, snp.allele=NULL, snpfirstdim=TRUE)

genofile <- snpgdsOpen("largedata/lcache/imp_parents.gds")


#RV <- snpgdsPCA(genofile)
#plot(RV$eigenvect[,2], RV$eigenvect[,1], xlab="PC 2", ylab="PC 1")


#snp.id <- sample(snpset.id, 1500)  # random 1500 SNPs
ibs <- snpgdsIBS(genofile, num.thread=4)
ibs.hc <- snpgdsHCluster(ibs)
rv <- snpgdsCutTree(ibs.hc)

pdf("graphs/p_cluster_ibs.pdf", height=5, width=15)
plot(rv$dendrogram, leaflab="perpendicular", main="Cluster based on IBS")
dev.off()
# close the file
snpgdsClose(genofile)

