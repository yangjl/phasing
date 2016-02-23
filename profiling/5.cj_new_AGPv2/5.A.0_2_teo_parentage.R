
loading_h5 <- function(){
    library(parallel)
    library(devtools)
    options(mc.cores=NULL)
    load_all("~/bin/tasselr")
    load_all("~/bin/ProgenyArray")
    
    #### load h5file
    teo <- initTasselHDF5(file="largedata/teo_updated/ZeaGBSv27raw_RareAllelesC2TeoCurated_20160215_AGPv2.h5", version="5")
    teo <- loadBiallelicGenotypes(teo, verbose = TRUE)
    
    #loading in genotypes from HDF5 file 'teo.h5'... done.
    #binding samples together into matrix... done.
    #filtering biallelic loci... done.
    #encoding genotypes... done.
    #Warning message:
    #    In loadBiallelicGenotypes(teo, verbose = TRUE) :
    #    Removed 357647 loci non-biallelic.
    
    #[1:598043, 1:4875]
    save(list="teo", file="largedata/teo_updated/TeoCurated_20160215_AGPv2.Rdata")
}

loading_h5()

## load in parent
parents <- read.delim("largedata/parent_taxa.txt", header=TRUE, stringsAsFactors=FALSE)
progeny <- read.delim("largedata/progeny_merged.txt", header=TRUE, stringsAsFactors=FALSE)
progeny$shorthand <- gsub("_.*", "", progeny$shorthand)

# all IDs found?
stopifnot(all(progeny$mother %in% parents$shorthand))


# all parent and progeny IDs in genotypes?
sample_names <- colnames(geno(teo))
stopifnot(all(parents$shorthand %in% sample_names))
stopifnot(all(progeny$shorthand %in% sample_names))

p <- subset(progeny, shorthand %in% sample_names)


newid <- read.delim("largedata/teo_updated/GBSv27C2TeoCumul20160105_cleanUp.txt", header=TRUE)


# stricter:
#length(setdiff(c(parents$taxa, progeny$taxa), sample_names))
#length(setdiff(sample_names, c(parents$taxa, progeny$taxa)))

## Load into ProgenyArray object

# mothers is given as an index to which column in parent genotype. Note that
# this is in the same order as the genotype columns (below) are ordered.
mothers <- match(progeny$mother, parents$shorthand)

pa <- ProgenyArray(geno(teo)[, progeny$taxa],
                   geno(teo)[, parents$taxa],
                   mothers,
                   loci=teo@ranges)

#201511 loci are fixed

## Infer parentage
# calculate allele frequencies
pa <- calcFreqs(pa)

# infer parents
pa <- inferParents(pa, ehet=0.6, ehom=0.1, verbose=TRUE)
#inferring parents for 4805 progeny
#4804/4805 progeny completed
#Warning message:
#    In inferParents(pa, ehet = 0.6, ehom = 0.1, verbose = TRUE) :
#    found 45 mothers that are inconsistent

save(pa, file= "largedata/cj_parentage.RData")
