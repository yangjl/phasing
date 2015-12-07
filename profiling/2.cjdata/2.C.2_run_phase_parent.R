### Jinliang Yang
### Nov 1st, 2015

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

JOBID <- as.numeric(as.character(args[1]))
print(JOBID)

##############
library("imputeR")
df <- read.csv("largedata/pp/parent_40kids.csv")

ipdat <- read.csv(paste0("largedata/ip/chr", df$chr[JOBID], "_ip50.csv"))
nms <- gsub("p.*_PC", "PC", names(ipdat))
nms <- gsub("\\.", ":", nms)
names(ipdat) <- nms

myfile <- as.character(df$files[JOBID])
print(myfile)
o <- load(myfile)

GBS.array <- update_gbs_parents(GBS.array=obj, ipdat)
# get probability matrices
probs <- error_mx2(hom.error=0.02, het.error=0.8)
# phasing   
phase <- phase_parent(GBS.array, win_length=10, join_length=10, self_cutoff = 40, verbose=TRUE)

# compute error rate
outfile <- gsub("/obs/", "/pp/", myfile)
outfile <- gsub("RData", "csv", outfile)
write.table(phase, outfile, sep=",", row.names=FALSE, quote=FALSE)

