### Jinliang Yang

# Load the R packages: gdsfmt and SNPRelate
library(gdsfmt)
library(SNPRelate)
library("data.table", lib="~/bin/Rlib/")

imp67 <- read.csv("largedata/ip/imp67.csv")

sid <- names(imp67)
snpid <- row.names(imp67)
mx <- as.matrix(imp67)
snpgdsCreateGeno("largedata/lcache/imp_parents.gds", genmat=mx,
                 sample.id= sid, snp.id= snpid, 
                 snp.chromosome= gsub("S|_.*", "", snpid),
                 snp.position= gsub(".*_", "", snpid), snp.allele=NULL, snpfirstdim=TRUE)


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

