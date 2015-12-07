### Jinliang Yang
### Nov 1st, 2015


update_tb <- function(self_cutoff=0){
    
    out <- data.frame()
    for(chri in 1:10){
        files <- list.files(path="largedata/obs", pattern=paste0("_chr", chri, ".RData"), full.names=TRUE)
        pinfo <- read.table("data/parentage_sum.txt", header=TRUE)
        
        df <- data.frame(files=files, founder=0)
        df$founder <- gsub(".*_PC_", "PC_", df$files)
        df$founder <- gsub("_chr.*", "", df$founder)
        
        df <- merge(df, pinfo,  by="founder")
        df$chr <- chri
        
        #df <- subset(df, nselfer > self_cutoff)
        out <- rbind(out, df)
    }
    return(subset(out, nselfer > self_cutoff))
}

res <- update_tb(self_cutoff=40)
write.table(res, "largedata/pp/parent_40kids.csv", sep=",", row.names=FALSE, quote=FALSE)
