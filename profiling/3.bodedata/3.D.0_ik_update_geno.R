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
geno <- fread("largedata/lcache/land_recode.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp53 <- read.csv("largedata/bode/ip53_imputed.csv")
names(imp53) <- gsub("\\.", ":", names(imp53))
names(imp53) <- gsub("^X", "", names(imp53))

if(sum(geno$snpid != row.names(imp53)) > 0) stop("!")
dim(geno[, names(imp53)])
geno[, names(imp53)] <- imp53


ped <- read.table("cache/landrace_parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)

###############
write_subgeno(geno, ped, ksize=10, outfile="largedata/bode/subgeno/kids")

