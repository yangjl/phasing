### Jinliang Yang
### updated Dec 1st, 2015

snpdf <- function(chri=1, verbose=TRUE, outfile="largedata/ip/chr1_ip50.csv"){
    files <- list.files(path="largedata/obs", pattern= paste0("chr", chri, ".csv"), full.names=TRUE)
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
    write.table(out, outfile, sep=",", row.names=FALSE, quote=FALSE)
    return(out)
}    
 
### 
for(i in 1:10){
    test <- snpdf(chri=i, verbose=TRUE, outfile= paste0("largedata/ip/chr", i, "_ip50.csv"))
}

