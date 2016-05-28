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

p5 <- c("PC_M05_ID1", "PC_I58_ID2", "PC_N09_ID1", "PC_I58_ID2", "PC_L08_ID1")
goodloci <- read.table("data/good_loci.txt")
subgeno <- subset(geno, snpid %in% goodloci$V1)

### updated geno matrix
imp4 <- read.csv("largedata/ip/imp4.csv")
if(sum(subgeno$snpid != row.names(imp4)) >0) stop("!!! ERROR")
ncol(subgeno[, names(imp4)])
subgeno[, names(imp4)] <- imp4


ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% p5)



###############
write_subgeno(geno=subgeno, ped=myped, ksize=10, outfile="largedata/ik/kid")

