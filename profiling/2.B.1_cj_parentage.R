### Jinliang Yang modified from Kate Crosby
# You'll need this amount of memory to open the parentage.Rdata file
# srun -p bigmemh --mem 64000 --pty R

get_parents <- function(){
    ob <- load("largedata/cj_parentage.RData")
    # parents/kids index
    pid <- colnames(pa@parents_geno)
    parents <- data.frame(pid=pid, idx=1:length(pid))
    
    progeny.names <- colnames(pa@progeny_geno)
    progeny <- data.frame(proid=progeny.names, idx=1:length(progeny.names))
    
    # index file
    partab <- data.frame(pa@parents)
    
    # Merge
    partab <- merge(partab, progeny, by.x="progeny", by.y="idx")
    partab <- merge(partab, parents, by.x="parent_1", by.y="idx")
    names(partab)[ncol(partab)] <- "parent1_names"
    
    partab <- merge(partab, parents, by.x="parent_2", by.y="idx")
    names(partab)[ncol(partab)] <- "parent2_names"
    
    partab <- partab[, c("proid", "parent1_names", "parent2_names", "progeny", "parent_1", "parent_2", "qq_uu", "which_mother", "nloci")]
    names(partab)[2:3] <- c("parent1", "parent2")
    write.table(partab, "data/parentage_info.txt", sep="\t", row.names=FALSE, quote=FALSE)
    
}

##########################################################################################################################################
#library(plyr)

getped <- function(){
    ped <- read.table("data/parentage_info.txt", header =TRUE)
    wgs <- read.csv("data/wgs_teo19_id.csv")
    #ped <- partab
    
    ped$parent1 <- as.character(ped$parent1)
    ped$parent2 <- as.character(ped$parent2)
    
    selfer <- subset(ped, parent1 == parent2)
    ox <- subset(ped, parent1 != parent2)
    
    pinfo <- data.frame(table(selfer$parent1))
    names(pinfo) <- c("founder", "nselfer")
    
    oxinfo <- data.frame(table(c(ox$parent1, ox$parent2)))
    names(oxinfo) <- c("founder", "nox")
    
    pinfo <- merge(pinfo, oxinfo, by="founder", all=TRUE)
    pinfo$sid <- gsub("_1.*", "", pinfo$founder)
    pinfo$sid <- gsub("_mrg.*", "", pinfo$sid)
    
    pinfo <- merge(pinfo, wgs, by.x="sid", by.y="id", all=TRUE)
    
    sub <- subset(pinfo, !is.na(WGS))
    write.table(pinfo, "data/parentage_sum.txt", sep="\t", row.names=FALSE, quote=FALSE)
    
}





