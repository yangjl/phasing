# simulaltion 

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

SIZE <- args[1]
JOB <- args[2]

library(imputeR)
GBS.array <- sim.array(size.array=SIZE, numloci=1000, hom.error = 0.02, het.error = 0.8,
                       rec = 0.25, selfing = 0.5, imiss = 0.5, misscode = 3)


inferred_geno_likes <- impute_parent(GBS.array, hom.error=0.02, het.error=0.8, imiss=0.5, p = GBS.array@freq)
res <- parentgeno(inferred_geno_likes, oddratio=0.6931472, returnall=TRUE)
res$true_parent <- GBS.array@true_parents[[SIZE]]$hap1 + GBS.array@true_parents[[SIZE]]$hap2

outfile <- paste0("largedata/sim1/res_", SIZE, "_", JOB, ".csv")
write.table(res, outfile, sep=",", row.names=FALSE, quote=FALSE )