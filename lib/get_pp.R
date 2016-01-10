get_pp <- function(path="largedata/pp", pattern="PC_.*.csv", chunk_inc=100, imp68){
    files <- list.files(path, pattern, full.names = TRUE)
    
    pid <- unique(gsub(".*\\/|_chr.*", "", files))
    message(sprintf("###>>> get [ %s ] phased parents from [ %s ] files", length(pid), length(files)))
    
    ppls <- list()
    for(j in 1:length(pid)){
        pp <- data.frame()
        for(i in 1:10){
            idx <- grep(paste0(pid[j], "_chr",i, "_"), files)
            for(p in idx){
                tem <- read.csv(files[p])
                chunkid <- as.numeric(as.character(gsub(".*chunk|\\.csv", "", files[p])))
                tem$chunk <- chunk_inc*(chunkid -1)+tem$chunk
                pp <- rbind(pp, tem)
            }
        }
        pp <- pp[order(pp$chunk, pp$idx),]
        
        if(sum(imp68[, pid[j]] == 1) != nrow(pp)){
           stop("!!! unequal number of hetersites !!!") 
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
        for(ci in 1:10){
            subchr <- subset(pp0, chr==ci)
            
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
