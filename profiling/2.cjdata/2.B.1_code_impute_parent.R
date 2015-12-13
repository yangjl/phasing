### Jinliang Yang
### run impute_parent using CJ's data

##get command line args
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

JOBID <- as.numeric(as.character(args[1]))
print(JOBID)
###########
library(imputeR)

files <- list.files(path="largedata/obs", pattern="RData", full.names=TRUE)
o <- load(files[JOBID])

tem <- impute_parent(GBS.array=obj, major.error=0.03, het.error=0.8, minor.error=0.2)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)

outfile <- gsub("RData", "csv", files[JOBID])
write.table(res, outfile, sep=",", row.names=TRUE, quote=FALSE)


