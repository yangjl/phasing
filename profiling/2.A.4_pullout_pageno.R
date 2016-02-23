### Jinliang Yang
### 9/23/2015
### purpose: pull out palmar Chico for Anne

ids <- read.csv("data/wgs_teo19_id.csv")

### SNP matrix comparison
library(parallel)
library(devtools)
options(mc.cores=NULL)
load_all("~/bin/tasselr")
load_all("~/bin/ProgenyArray")

ob2 <- load("largedata/cj_data.Rdata")
genos <- geno(teo)

nms <- gsub("_mrg\\:.*", "", colnames(genos))
subgeno <- genos[, which(nms %in% ids$id)]

subgeno <- as.data.frame(subgeno)
names(subgeno) <- gsub("_mrg\\:.*", "", colnames(subgeno))

pos <- as.data.frame(granges(teo))
alt <- sapply(teo@alt, function(x) TASSELL_ALLELES[x+1L])
info <- data.frame(snpid=rownames(geno(teo)), ref=ref(teo), alt=alt)
info <- merge(info, pos, by.x="snpid", by.y="row.names")
info <- info[, 1:5]
names(info) <- c("snpid", "ref", "alt", "chr", "pos")

pageno <- merge(info, subgeno, by.x="snpid", by.y="row.names")
write.table(pageno, "~")

# https://github.com/yangjl/tasselr
# Genotypes are loaded and decoded into the number of alternate alleles they have (0, 1, 2)
tem <- pageno
pageno <- tem

pageno$ref <- as.character(pageno$ref)
pageno$alt <- as.character(pageno$alt)
for(i in 6:ncol(pageno)){
    pageno[, i] <- as.character(pageno[, i])
    pageno[is.na(pageno[, i]), i] <- "NN"
    pageno[pageno[, i] == 0, i] <- paste0(pageno[pageno[, i] == 0, ]$ref, pageno[pageno[, i] == 0, ]$ref)
    pageno[pageno[, i] == 1, i] <- paste0(pageno[pageno[, i] == 1, ]$ref, pageno[pageno[, i] == 1, ]$alt)
    pageno[pageno[, i] == 2, i] <- paste0(pageno[pageno[, i] == 2, ]$alt, pageno[pageno[, i] == 2, ]$alt)
    
    print(i)
}

write.table(pageno, "/group/jrigrp4/Anne/GBS_teo_parents_n19.txt", sep="\t", row.names=FALSE, quote=FALSE)




