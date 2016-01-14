### Jinliang Yang
### use impute_parent in CJ data

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

#### read in masked data
geno <- fread("largedata/lcache/teo_masked.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp68 <- read.csv("largedata/cjmasked/ip68_masked.csv")
names(imp68) <- gsub("\\.", ":", names(imp68))
if(sum(geno$snpid != row.names(imp68)) >0) stop("!!! ERROR !!!")
geno[, names(imp68)] <- imp68

#################################################
## First round of imputation, with family > 40 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
ped <- read.table("data/parentage_info.txt", header =TRUE)
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 40)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% pinfo$founder)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

create_array(geno, ped=myped, pargeno, pp=NULL, pinfo=pinfo,
             outdir="largedata/cjmasked/obs1", bychr=TRUE, bychunk=1000)

