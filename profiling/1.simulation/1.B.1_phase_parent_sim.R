### Jinliang Yang
### Dec. 1st, 2015

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

SIZE <- as.numeric(as.character(args[1]))

library(imputeR)

# to make the random events repeatable
set.seed(1234579)
# simulate a GBS.array object
GBS.array <- sim.array(size.array=SIZE, numloci=100, hom.error = 0.02, het.error = 0.8,
                       rec = 0.25, selfing = 0.5, imiss = 0.5, misscode = 3)
# get perfect parent genotype
GBS.array <- get_true_GBS(GBS.array, phased.parents = TRUE)
# get probability matrices
probs <- error_mx2(hom.error=0.02, het.error=0.8)
# phasing   
phase <- phase_parent(GBS.array, win_length=10, join_length=10, self_cutoff = 100, verbose=TRUE)

# compute error rate
out <- phase_error_rate(GBS.array, phase)

outfile <- paste0("largedata/sim2/size", SIZE, "_oc_10kloci.csv")
write.table(out, outfile, sep=",", row.names=FALSE, quote=FALSE)



