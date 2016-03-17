### Jinliang Yang
### use impute_parent in CJ data

#library(imputeR)

get_ik <- function(path="largedata/ik", pattern="kid_geno"){
    files <- list.files(path, pattern, full.names = TRUE)
    message(sprintf("### found [ %s ] files!", length(files)))
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

##############
ikgeno <- get_ik(path="largedata/ik", pattern="kid_geno")

#library(imputeR)
library(data.table, lib="~/bin/Rlib/")
imp67 <- read.csv("largedata/ip/imp67.csv")

#if(sum(ikgeno$snpid != row.names(imp67)) > 0) stop("!")

ipgeno <- merge(imp67, ikgeno, by.x="row.names", by.y="snpid", sort=FALSE)
names(ipgeno)[1] <- "snpid"


write.table(ipgeno, "largedata/teo_imputeR_03162016.txt", sep="\t",
            row.names=FALSE, quote=FALSE)

