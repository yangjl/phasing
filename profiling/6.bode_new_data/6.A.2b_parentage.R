### Jinliang Yang modified from VSB
### July 30th, 2015
## phasing.R

#bode_parentage.Rdata copied from /home/vince251/data/bode_data
get_parents(obfile="largedata/lcache/bode_parentage.Rdata",
            outfile="cache/landrace_parentage_info.txt")

get_parents <- function(obfile="largedata/lcache/bode_parentage.Rdata",
                        outfile="cache/landrace_parentage_info.txt"){
    ob <- load(obfile)
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
    
    partab <- partab[, c("proid", "parent1_names", "parent2_names", "progeny", 
                         "parent_1", "parent_2", "qq_uu", "nloci")]
    names(partab)[2:3] <- c("parent1", "parent2")
    write.table(partab, outfile, sep="\t", row.names=FALSE, quote=FALSE)
    
}


