get_pp <- function(path="largedata/pp", pattern="PC_.*.csv", imp68){
    files <- list.files(path, pattern, full.names = TRUE)
    
    pid <- unique(gsub(".*\\/|_chr.*", "", files))
    message(sprintf("###>>> get [ %s ] phased parents", length(pid)))
    
    ppls <- list()
    for(j in 1:length(pid)){
        pp <- data.frame()
        for(i in 1:10){
            tem <- read.csv(paste0(path, "/", pid[j], "_chr",i, ".csv"))
            pp <- rbind(tem, pp)
        }
        
        pp$snpid <- as.character(pp$snpid)
        pp0 <- merge(pp, imp68, by.x="snpid", by.y="row.names", all=TRUE )
        pp0 <- pp0[, c(1:5, which(names(pp0) == pid[j]))]
        
        pp0[pp0[,6]==3, ]$hap1 <- 3
        pp0[pp0[,6]==3, ]$hap2 <- 3
        pp0[pp0[,6]==0, ]$hap1 <- 0
        pp0[pp0[,6]==0, ]$hap2 <- 0
        pp0[pp0[,6]==2, ]$hap1 <- 1
        pp0[pp0[,6]==2, ]$hap2 <- 1
        
        pp0$chr <- as.numeric(as.character(gsub("S|_.*", "", pp0$snpid)))
        pp0$pos <- as.numeric(as.character(gsub("S.*_", "", pp0$snpid)))
        pp0 <- pp0[order(pp0$chr, pp0$pos),]
        
        pp1 <- data.frame()
        for(i in 1:10){
            subchr <- subset(pp0, chr==i)
            tem <- data.frame(a=subchr$idx, b=1:nrow(subchr))
            tem <- tem[!is.na(tem$a),]
            if(sum(tem$a != tem$b) > 0){
                stop("###>>> re-idx error !")
            }
            subchr$idx <- 1:nrow(subchr)
            subchr$chunk[1] <- 1
            for(k in 2:nrow(subchr)){
                if(is.na(subchr$chunk[k])){
                    subchr$chunk[k] <- subchr$chunk[k-1]  
                }
            }
            pp1 <- rbind(pp1, subchr)
        }
        message(sprintf("###>>> finished [ %s ] parents [ %s ]", j, pid[j]))
        ppls[[pid[j]]] <- pp1
        
    }
    return(ppls)
}
