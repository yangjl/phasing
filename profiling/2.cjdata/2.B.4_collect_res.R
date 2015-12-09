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

############ checking the 2=0 issue:
chr <- read.csv("largedata/obs/p10_PC_L56_ID1_1:250276233_chr4.csv")
o <- load("largedata/obs/p10_PC_L56_ID1_1:250276233_chr4.RData")

obj@pedigree <- subset(obj@pedigree, p1==p2)
ped <- obj@pedigree
obj@gbs_kids <- obj@gbs_kids[ped$kid]

tem <- impute_parent(GBS.array=obj, hom.error = 0.02, het.error = 0.8)
res <- parentgeno(tem, oddratio=0.69, returnall=TRUE)


parent <- obj@gbs_parents[[1]]
res <- data.frame(parent=parent, kid=obj@gbs_kids[[1]])
for(i in 2:length(obj@gbs_kids)){
    tem <- data.frame(parent=parent, kid=obj@gbs_kids[[i]])
    res <- cbind(res, tem[,2])
}


