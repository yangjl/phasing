### Jinliang Yang
### updated Dec 1st, 2015

col_snpdf <- function(chri=1, verbose=TRUE, outfile="largedata/ip/chr1_ip50.csv"){
    files <- list.files(path=filepath, pattern= paste0("chr", chri, ".csv"), full.names=TRUE)
    if(verbose) message(sprintf("###>>> collect chr [ %s ] for [ %s ] parents ", chri, length(files)))
    
    out <- read.csv(files[1])[,1:5]
    names(out)[ncol(out)] <- gsub(".*/|_chr.*", "", files[1])
    
    for(j in 2:length(files)){
        tem <- read.csv(files[j])
        #if(verbose) print(table(tem[,5]))
        out <- cbind(out, tem[, 5])
        names(out)[ncol(out)] <- gsub(".*/|_chr.*", "", files[j])
    }
    out <- out[, -1:-4]
    if(verbose) message(sprintf("###>>> Merged [ %s ] Loci for [ %s ] parents ", nrow(out), ncol(out)))
    if(verbose) message(sprintf("###>>> Output file to [ %s ]", outfile))
    write.table(out, outfile, sep=",", row.names=TRUE, quote=FALSE)
    return(out)
}    
 
### 
for(i in 1:10){
    test <- col_snpdf(chri=i, verbose=TRUE, filepath="largedata/obs2", outfile= paste0("largedata/ip/chr", i, "_ip24.csv"))
}

################## cat them into one file:
imp <- data.frame()
for(i in 1:10){
    tem <- read.csv(paste0("largedata/ip/chr", i, "_ip68.csv"))
    imp <- rbind(imp, tem)
}
write.table(imp, "largedata/ip/imputed_parents_id68.csv", sep=",", row.names=TRUE, quote=FALSE)

