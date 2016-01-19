### Jinliang Yang
### use impute_parent in CJ data


###########
write_subgeno <- function(geno, ped, ksize=10, outfile="out"){
    ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
    tot <- ceiling(nrow(ped)/10)
    #for(i in 1:tot){
    tem <- lapply(1:tot, function(i){
        message(sprintf("###>>> start to write the [ %s/%s ] subset of geno", i, tot))
        if(i != tot){
            kid <- ped$proid[((i-1)*ksize+1):(ksize*i)]
            
        }else{
            kid <- ped$proid[((i-1)*ksize+1):nrow(ped)]
        }
        subgeno <- geno[, c("snpid", kid)]
        
        outfile1 <- paste0(outfile, "_subgeno", i, ".csv")
        write.table(subgeno, outfile1, sep=",", row.names=FALSE, quote=FALSE)
    })
    message(sprintf("###>>> DONE <<< ###"))
}


#### read in masked data
library(data.table, lib="~/bin/Rlib/")
geno <- fread("largedata/lcache/teo_masked.txt")
geno <- as.data.frame(geno)
imp68 <- read.csv("largedata/cjmasked/ip68_masked.csv")
names(imp68) <- gsub("\\.", ":", names(imp68))
if(sum(geno$snpid != row.names(imp68)) >0) stop("!!! ERROR !!!")
geno[, names(imp68)] <- imp68


ped <- read.table("data/parentage_info.txt", header =TRUE)

###############
write_subgeno(geno, ped, ksize=10, outfile="largedata/cjmasked/subgeno/kids")

