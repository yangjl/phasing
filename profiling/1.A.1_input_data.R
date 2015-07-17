
genotype <- matrix(c(
    0,0,0,0,1,2,2,2,0,0,2,0,0,0,
    2,2,2,2,1,0,0,0,2,2,2,2,2,2,
    2,2,2,2,1,2,2,2,0,0,2,2,2,2,
    2,2,2,2,0,0,0,0,2,2,2,2,2,2,
    0,0,0,0,0,2,2,2,2,2,2,0,0,0
    ), ncol = 14, byrow = TRUE)

plantid <- paste("ID-", 1:5, sep="")
snpid <- paste("SNP-", letters[1:14], sep="")
rownames(genotype) <- plantid
colnames(genotype) <- snpid
genotype[1:5, 1:5]
