# simulaltion 

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

RATE <- as.numeric(as.character(args[1]))
print(RATE)
SIZE <- as.numeric(as.character(args[2]))
print(SIZE)

library(imputeR)

GBS.array <- sim.array(size.array=SIZE, numloci=10000, hom.error = 0.02, het.error = 0.8,
                       rec = 0.25, selfing = RATE, imiss = 0.5, misscode = 3)

inferred_geno_likes <- impute_parent(GBS.array, hom.error=0.02, het.error=0.8)
res <- parentgeno(inferred_geno_likes, oddratio=0.6931472, returnall=TRUE)
res$true_parent <- GBS.array@true_parents[[SIZE]]$hap1 + GBS.array@true_parents[[SIZE]]$hap2

### output results
outfile <- paste0("largedata/sim1/res_", SIZE, "_srate", RATE, ".csv")
write.table(res, outfile, sep=",", row.names=FALSE, quote=FALSE )