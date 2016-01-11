### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)

get_ik <- function(path="largedata/ik", pattern="kid_geno"){
    files <- list.files(path, pattern, full.names = TRUE)
    
    kgeno <- read.csv(files[1])
    for(i in 2:length(files)){
        ktem <- read.csv(files[i])
        
        if(sum(kgeno$snpid != ktem$snpid) == 0){
            kgeno <- cbind(kgeno, ktem[, -1])
            message(sprintf("###>>> read the [ %s/%s ] file", i, length(files)))
        }else{
            stop("!!! snpid not match !!!")
        }
    }
    return(kgeno)
}


ikgeno <- get_ik(path="largedata/ik", pattern="kid_geno")


#library(imputeR)
library(data.table, lib="~/bin/Rlib/")

imp68 <- read.csv("cache/imp68.csv")

ipgeno <- merge(imp68, ikgeno, by.x="row.names", by.y="snpid", sort=FALSE)
names(ipgeno)[1] <- "snpid"
names(ipgeno) <- gsub("\\.", ":", names(ipgeno))




ped <- read.table("data/parentage_info.txt", header =TRUE)
ped[, 1:3] <- apply(ped[, 1:3], 2, as.character)

library(imputeR)
posterr <- estimate_error(geno=ipgeno, ped, self_cutoff=30, depth_cutoff=10, est_kids = TRUE)

write.table(err1, "cache/round1_ip24_err1.csv", sep=",", row.names=FALSE, quote=FALSE)






library(data.table, lib="~/bin/Rlib/")

ped <- read.table("data/parentage_info.txt", header =TRUE)
geno <- fread("largedata/lcache/teo_recoded.txt")
geno <- as.data.frame(geno)

### updated geno matrix
imp68 <- read.csv("cache/imp68.csv")
names(imp68) <- gsub("\\.", ":", names(imp68))
geno <- subset(geno, snpid %in% row.names(imp68))
geno[, names(imp68)] <- imp68

source("lib/get_pp.R")
ppr3 <- get_pp(path="largedata/obs3", pattern="PC_.*.csv", imp68)



save(file="largedata/lcache/R3_pp23.RData", list="ppr3")

ob1 <- load("largedata/lcache/R1_pp24.RData")
ob2 <- load("largedata/lcache/R2_pp21.RData")
pp68 <- c(pp24, ppr2, ppr3)
save(file="largedata/lcache/teo_pp68.RData", list="pp68")







