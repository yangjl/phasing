### Jinliang Yang
### phase parents

library(imputeR)
library(data.table, lib="~/bin/Rlib/")

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
#################################################
## First round of imputation, with family > 40 selfed kids
#mygeno <- mendelian_check(geno, ped, self_cutoff=30, depth_cutoff=10)
pinfo <- pedinfo(ped)
pinfo <- subset(pinfo, nselfer > 40)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)
myped <- subset(ped, parent1 == parent2 & parent1 %in% pinfo$founder)
pargeno <- data.frame(parentid= as.character(unique(c(ped$parent1, ped$parent2))), true_p=0)

#pargeno <- subset(pargeno, pargeno[,2] >0)
create_array(geno, ped=myped, pargeno, pp=NULL, pinfo=pinfo,
             outdir="largedata/bode/obs1", bychr=TRUE, bychunk=NULL)


