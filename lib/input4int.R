  

sim_list2df <- function(simlist){
    
    #noind <- 0
    nosnp <- nrow(simlist[[1]][[1]])
    res <- data.frame(snpid=1:nosnp, major=-9, minor=-9)
    for(i in 1:length(simlist)){
        simp <- simlist[[i]][[1]] ### parents
        simk <- simlist[[i]][[2]] ### kids
        
        #noind <- noind + 1 + length(simk)
        
        df <- data.frame(p1=simp$obs)
        names(df)[1] <- paste0("P", i)
        for(j in 1:length(simk)){
            df$kid <- simk[[j]][[2]]$obs
            names(df)[ncol(df)] <- paste0("P", i, "K", j)
        }
        res <- cbind(res, df)
    }
        
    res$major <- apply(res[,-1:-2], 1, function(arow) return(names(which.max(table(t(arow))))) )
    res$major <- as.numeric(as.character(res$major))
    res$minor <- 2 - res$major
    
    return(res)
    ######  
}

### TEST
df <- sim_list2df(simlist)

#    The ENT input file format is as follows:

#    * First line: <number of individuals> <number of snps>    
#    * Additional lines:   
#    <individual id> <sex> <parent 1 id> <parent 2 id> <genotype sequence>   
#    All individual id's must be non-zero, a parent id of 0 represents no 
#    known parent.
input2ent <- function(simlist, missingcode, outfile="largedata/test.txt"){
    dfpa <- sim_list2df(simlist)
    dfpa <- recode4ent(dfpa, missingcode)
    
    ### get pedigree info
    mypa <- dfpa[, -1:-3]
    ped <- data.frame(id=names(mypa), mom=0, dad=0)
    #ped$mom <- gsub("K.", "", ped$id)
    #ped$dad <- ped$mom
    #idx <- grep("P.$", ped$id)
    #ped[idx, c("mom", "dad")] <- 0
    #ped$id <- as.character(ped$id)
    ped$idno <- 1:nrow(ped)
    ### output results
    cat(paste(ncol(mypa), nrow(mypa)),
        sep="\n", file=outfile, append=FALSE)
    for(i in 1:ncol(mypa)){
        cat(ped$idno[i], 
            "M",
            ped$mom[i],
            ped$dad[i],
            "",
            #paste0(mypa[,i]),
            sep=" ", file=outfile, append=TRUE)
        cat(paste0(mypa[,i]),
            "\n",
            sep="", file=outfile, append=TRUE)
    }
}

#    ENT accepts sequences of the form 0/1/2/? where 0/1 denote the 
#    genotypes that are homozygous for the major/minor allele, 
#    2 denotes a heterozygous genotype, and ? denotes an unknown genotype.
recode4ent <- function(df, missingcode){
    
    df0 <- subset(df, major == 0)
    df0[, -1:-3][df0[, -1:-3] == 0] <- "A" ## recode A as major
    df0[, -1:-3][df0[, -1:-3] == 2] <- "B" ## recode B as minor
    df0[, -1:-3][df0[, -1:-3] == 1] <- "H"
    
    df2 <- subset(df, major == 2)
    df2[, -1:-3][df2[, -1:-3] == 2] <- "A"
    df2[, -1:-3][df2[, -1:-3] == 0] <- "B"
    df2[, -1:-3][df2[, -1:-3] == 1] <- "H"
    
    mydf <- rbind(df0, df2)
    mydf <- mydf[order(mydf$snpid),]
    
    ### Recode according to ENT
    mydf[mydf == "A"] <- 0
    mydf[mydf == "B"] <- 1
    mydf[mydf == "H"] <- 2
    mydf[mydf == missingcode] <- "?"
    
    return(mydf)
}

read_ent <- function(file, ped, simlist){
    
    ped$list1 <- gsub("K.*", "", ped$id)
    ped$list1 <- as.numeric(as.character(gsub("P", "", ped$list1)))
    ped$list2 <- as.numeric(as.character(gsub(".*K", "", ped$id)))
    
    
    input <- readLines(con=file)
    err <- 0
    for(i in seq(from=2, to=length(input), by=3)){
        idno <- as.numeric(gsub(" .*", "", input[i]))
        hap1 <- as.numeric(as.character(unlist(strsplit(input[i+1], split="")))) 
        hap2 <- as.numeric(as.character(unlist(strsplit(input[i+1], split=""))))
        if(idno <= nrow(ped)){
            aped <- ped[idno,]
            if(is.na(aped$list2)){
                simlist[[aped$list1]][[1]]$h1 <- hap1
                simlist[[aped$list1]][[1]]$h2 <- hap2
            }else{
                simlist[[aped$list1]][[2]][[aped$list2]][[2]]$h1 <- hap1
                simlist[[aped$list1]][[2]][[aped$list2]][[2]]$h2 <- hap2
                test <- simlist[[aped$list1]][[2]][[aped$list2]][[2]]
                temerr <- sum((test$hap1+test$hap2) != (test$h1+test$h2))
                err <- err + temerr
            }
        }
        
    }
}

sum((test$hap1+test$hap2) != (test$h1+test$h2))
