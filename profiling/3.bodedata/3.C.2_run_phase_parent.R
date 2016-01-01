### Jinliang Yang
### Nov 1st, 2015

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

JOBID <- as.numeric(as.character(args[1]))
print(JOBID)

##############
library("imputeR")
df <- read.csv("largedata/bode_pp_files.csv")
df$file <- as.character(df$file)

o <- load(df$file[JOBID])
#perr <- read.csv("cache/teo_parents_errmx.csv")
kerr <- read.csv("cache/land_kids_errmx.csv")

probs <- error_probs(mx=kerr, merr=1)

# phasing   
phase <- phase_parent(GBS.array=obj, win_length=10, join_length=0, verbose=TRUE, OR=log(3))

# compute error rate
#outfile <- gsub("/obs/", "/pp/", df$file[JOBID])
outfile <- gsub("RData", "csv", df$file[JOBID])
write.table(phase, outfile, sep=",", row.names=FALSE, quote=FALSE)

