### Jinliang Yang modified from VSB
### July 30th, 2015
## phasing.R


loading_h5 <- function(){
    library(parallel)
    library(devtools)
    options(mc.cores=NULL)
    load_all("~/bin/tasselr")
    load_all("~/bin/ProgenyArray")
    
    #### load h5file
    teo <- initTasselHDF5(file="largedata/teo.h5", version="5")
    teo <- loadBiallelicGenotypes(teo, verbose = TRUE)
    
    #loading in genotypes from HDF5 file 'teo.h5'... done.
    #binding samples together into matrix... done.
    #filtering biallelic loci... done.
    #encoding genotypes... done.
    #Warning message:
    #    In loadBiallelicGenotypes(teo, verbose = TRUE) :
    #    Removed 357647 loci non-biallelic.
    
    #[1:598043, 1:4875]
    save(list="teo", file="largedata/cj_data.Rdata")
}
    
loading_h5()
######################################################################################

get_info <- function(){
    library(parallel)
    library(devtools)
    options(mc.cores=NULL)
    load_all("~/bin/tasselr")
    load_all("~/bin/ProgenyArray")
    
    ob <- load("largedata/cj_data.Rdata")
    
    pos <- as.data.frame(granges(teo))
    alt <- sapply(teo@alt, function(x) TASSELL_ALLELES[x+1L])
    info <- data.frame(snpid=rownames(geno(teo)), ref=ref(teo), alt=alt)
    info <- merge(info, pos, by.x="snpid", by.y="row.names")
    
    sites <- subset(info, seqnames !=0) 
    sites <- sites[, c("seqnames", "start", "ref", "alt")]
    sites <- sites[order(sites$seqnames, sites$start), ]
    sites <- subset(sites, ref != "-" & alt != "-")
    write.table(sites, "largedata/genotype_calls/gbs_sites_v2.txt", sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE)
    
    ### get genotype matrix
    genos <- geno(teo)
    
    ### calculate missing rates
    imiss <- apply(genos, 2, function(x) return(sum(is.na(x))/598043))
    imiss <- data.frame(imiss)
    
    lmiss <- apply(genos, 1, function(x) return(sum(is.na(x))/4875))
    lmiss <- data.frame(lmiss)
    
    ### calculate maf
    maf <- apply(genos, 1, function(x){
        x <- x[!is.na(x)]
        c0 <- sum(x == 0)
        c1 <- sum(x == 1)
        c2 <- sum(x == 2)
        return(min(c(2*c0 +c1, c1 + 2*c2))/(2*(c0 + c1 + c2)) )
    })
    
    maf <- data.frame(maf)
    
    ## return the results
    info <- merge(info, lmiss, by.x="snpid", by.y="row.names")
    info <- merge(info, maf, by.x="snpid", by.y="row.names")
    write.table(info, "data/teo_info.csv", sep=",", row.names=FALSE, quote=FALSE)
    write.table(imiss, "data/teo_imiss.csv", sep=",", quote=FALSE)
}
#######################
get_info()

