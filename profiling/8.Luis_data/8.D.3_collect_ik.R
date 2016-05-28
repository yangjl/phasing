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
ikgeno <- get_ik(path="largedata/ik", pattern="kid_subgeno")

write.table(ikgeno, "largedata/teo_kid121_05282016.txt", sep="\t",
            row.names=FALSE, quote=FALSE)

