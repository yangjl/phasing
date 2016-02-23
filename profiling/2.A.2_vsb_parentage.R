### Jinliang Yang modified from VSB
### July 30th, 2015
## phasing.R

library(parallel)
library(devtools)
options(mc.cores=NULL)
load_all("~/bin/tasselr")
load_all("~/bin/ProgenyArray")

ob <- load("largedata/cj_data.Rdata")
# load sequence lengths from chromosome
sl <- read.table("largedata/refgen2-lengths.txt", col.names=c("chrom", "length"),
                 stringsAsFactors = FALSE)
sl <- setNames(sl$length, sl$chrom)
chrs <- ifelse(names(sl) == "UNKNOWN", "0", names(sl))
names(sl) <- chrs
seqlengths(teo@ranges) <- sl[names(seqlengths(teo@ranges))]

## load in parent
parents <- read.delim("largedata/parent_taxa.txt", header=TRUE, stringsAsFactors=FALSE)
progeny <- read.delim("largedata/progeny_merged.txt", header=TRUE, stringsAsFactors=FALSE)

# all IDs found?
stopifnot(all(progeny$mother %in% parents$shorthand))


# all parent and progeny IDs in genotypes?
sample_names <- colnames(geno(teo))
stopifnot(all(parents$taxa %in% sample_names))
stopifnot(all(progeny$taxa %in% sample_names))

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

#ProgenyArray object: 598043 loci, 70 parents, 4805 progeny
#number of chromosomes: 11
#object size: 11640.408 Mb
#number of progeny: 4805
#number of parents: 70
#proportion missing:
#    progeny: 0.503
#parents:  0.393
#number of complete parental loci: 9202

###########################################################################

map <- as.data.frame(pa@ranges)

geno1 <- pa@parents_geno
geno1[is.na(geno1)] <- 3
geno1 <- t(geno1)

genodf <- data.frame(fid=1:70, iid=row.names(geno1), pid=0, mid=0, as.data.frame(geno1))



