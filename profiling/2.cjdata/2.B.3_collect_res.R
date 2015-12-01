### Jinliang Yang
### updated Dec 1st, 2015


for(i in 1:10){
    files <- list.files(path="largedata/obs", pattern= paste0("chr", i, ".csv"), full.names=TRUE)
    
    
    out <- read.csv(files[1])
    
    for(j in 2:length(files)){
        tem <- read.csv(files[j])
        print(table(tem[,5]))
        out <- cbind(out, tem[, 5])
        names(out)[ncol(out)] <- gsub(".*/|_chr.*", "", files[j])
    }
    
}



for(i in 1:length(files)){
    
}

o <- load(files[JOBID])


data.frame(id=, chr=, )
