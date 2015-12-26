### Jinliang Yang
### Dec. 1st, 2015

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
SIZE <- as.numeric(as.character(args[1]))
RATE <- as.numeric(as.character(args[2]))

library(imputeR)

# to make the random events repeatable
set.seed(1234579)
# simulate a GBS.array object
GBS.array <- sim.array(size.array=SIZE, numloci=1000, hom.error = 0.02, het.error = 0.8,
                       rec = 0.25, selfing = RATE, imiss = 0.5, misscode = 3)
# get perfect parent genotype
GBS.array <- get_true_GBS(GBS.array, phased.parents = TRUE)
# get probability matrices
probs <- error_mx2(major.error=0.02, het.error=0.8, minor.error=0.02)
# phasing   
phase <- phase_parent(GBS.array, win_length=10, join_length=10, verbose=TRUE, OR=log(3))

# compute error rate
out <- phase_error_rate(GBS.array, phase)

outfile <- paste0("largedata/sim2/size", SIZE, "_rate", RATE, "_1k.csv")
write.table(out, outfile, sep=",", row.names=FALSE, quote=FALSE)



