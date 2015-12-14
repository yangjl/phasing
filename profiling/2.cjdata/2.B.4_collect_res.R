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
    write.table(out, outfile, sep=",", row.names=TRUE, quote=FALSE)
    return(out)
}    
 
### 
for(i in 1:10){
    test <- snpdf(chri=i, verbose=TRUE, outfile= paste0("largedata/ip/chr", i, "_ip35.csv"))
}

################## cat them into one file:
imp <- data.frame()
for(i in 1:10){
    tem <- read.csv(paste0("largedata/ip/chr", i, "_ip35.csv"))
    imp <- rbind(imp, tem)
}
write.table(imp, "largedata/ip/imputed_parents_id35.csv", sep=",", row.names=TRUE, quote=FALSE)


snpinfo <- read.csv("largedata/ip/snpinfo.csv")
row.names(imp) <- snpinfo$snpid
nms <- names(imp)
nms <- gsub("\\.", ":", nms)
names(imp) <- gsub(".*_PC", "PC", nms)
imp$snpid <- row.names(imp)


imp <- imp[, c(69, 1:68)]
write.table(imp, "largedata/ip/imputed_parents_or.csv", sep=",", row.names=TRUE, quote=FALSE)
