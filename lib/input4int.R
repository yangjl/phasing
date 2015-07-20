  
#    ENT accepts sequences of the form 0/1/2/? where 0/1 denote the 
#    genotypes that are homozygous for the major/minor allele, 
#    2 denotes a heterozygous genotype, and ? denotes an unknown genotype.

#    The ENT input file format is as follows:
    
#    * First line: <number of individuals> <number of snps>    
#    * Additional lines:   
#    <individual id> <sex> <parent 1 id> <parent 2 id> <genotype sequence>   
#    All individual id's must be non-zero, a parent id of 0 represents no 
#    known parent.
input4ent <- function(simlist){
    
    noind <- 0
    
    for(i in 1:length(simlist)){
        simp <- simlist[[i]][[1]] ### parents
        simk <- simlist[[i]][[2]] ### kids
        
        noind <- noind + 1 + length(simk)
        
        df <- data.frame(p1=simp$obs)
        names(df)[1] <- paste0("P", i)
        for(j in 1:length(simk)){
            df$kid <- simk[[j]][[2]]$obs
            names(df)[ncol(df)] <- paste0("P", i, "K", j)
        }
    }
        
    
    
    
    ######  
}




