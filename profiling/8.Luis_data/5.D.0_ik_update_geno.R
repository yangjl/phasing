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
library(imputeR)

### read genotype. snpinfo and pedigree data
ped <- read.csv("data/Parentage_for_imputeR.csv")
names(ped) <- c("proid", "parent1", "parent2")
geno <- fread("largedata/teo_updated/teo_raw_biallelic_recoded_20160303_AGPv2.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp67 <- read.csv("largedata/ip/imp67.csv")
if(sum(geno$snpid != row.names(imp67)) >0) stop("!!! ERROR")
ncol(geno[, names(imp67)])
geno[, names(imp67)] <- imp67


###############
write_subgeno(geno, ped, ksize=10, outfile="largedata/ik/")

