### Jinliang Yang
### Nov 1st, 2015

CHRI <- 10



##############
library("imputeR")
files <- list.files(path="largedata/obs", pattern=paste0("_chr", CHRI, ".RData"), full.names=TRUE)

ipdat <- read.csv(paste0("largedata/ip/chr", CHRI, "_ip50.csv"))
nms <- gsub("p.*_PC", "PC", names(ipdat))
nms <- gsub("\\.", ":", nms)
names(ipdat) <- nms

o <- load(files[1])


GBS.array <- update_gbs_parents(GBS.array=obj, ipdat)
# get probability matrices
probs <- error_mx(hom.error=0.02, het.error=0.8, imiss=0.5)
# phasing   
phase <- phase_parent(GBS.array, win_length=10, join_length=10, verbose=TRUE)

# compute error rate
out <- phase_error_rate(GBS.array, phase)


