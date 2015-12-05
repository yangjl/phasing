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
f2 <- list.files(path="largedata/obs", pattern="csv", full.names=TRUE)
f3 <- gsub("csv", "RData", f2)

leftf <- files[!files %in% f3]
o <- load(leftf[JOBID])

tem <- impute_parent(GBS.array=obj, hom.error = 0.02, het.error = 0.8)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)

outfile <- gsub("RData", "csv", leftf[JOBID])
write.table(res, outfile, sep=",", row.names=FALSE, quote=FALSE)