### Jinliang Yang
### run impute_parent using CJ's data

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

JOBID <- as.numeric(as.character(args[1]))
print(JOBID)
###########
library(imputeR)

df <- read.csv("largedata/obs_files.csv")
df$file <- as.character(df$file)
o <- load(df$file[JOBID])

perr <- read.csv("cache/teo_parents_errmx.csv")
kerr <- read.csv("cache/teo_kids_errmx.csv")
    
tem <- impute_parent(GBS.array=obj, perr, kerr)

res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)

outfile <- gsub("RData", "csv", df$file[JOBID])
write.table(res, outfile, sep=",", row.names=TRUE, quote=FALSE)


