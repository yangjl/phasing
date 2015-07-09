## phasing.R

library(parallel)
library(devtools)
options(mc.cores=NULL)

#load_all("/home/vince251/src/tasselr")
load_all("~/Projects/tasselr")
load_all("~/Projects/ProgenyArray")

# cache files
tassel_file <- "cj_data.Rdata"
parentage_file <- "parentage.Rdata"
phasing_file <- "phasing.Rdata"

## load in genotype data -- don't load if the parentage data (next step) exists
if (!file.exists(tassel_file)) {
  message("loading GBS data from HDF5 file...   ", appendLF=FALSE)
  h5file <- "./teo.h5"
  teo <- initTasselHDF5(h5file, version="5")
  teo <- loadBiallelicGenotypes(teo)
  save(teo, file=tassel_file)
  message("done.")
} else {
  message("loading in cached GBS data...   ", appendLF=FALSE)
  load(file=tassel_file)
  message("done.")
}

# load sequence lengths from chromosome
sl <- read.table("refgen2-lengths.txt", col.names=c("chrom", "length"),
                 stringsAsFactors = FALSE)
sl <- setNames(sl$length, sl$chrom)
chrs <- ifelse(names(sl) == "UNKNOWN", "0", names(sl))
names(sl) <- chrs
seqlengths(teo@ranges) <- sl[names(seqlengths(teo@ranges))]

## load in parent
parents <- read.delim("parent_taxa.txt", header=TRUE, stringsAsFactors=FALSE)
progeny <- read.delim("progeny_merged.txt", header=TRUE, stringsAsFactors=FALSE)

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

if (!file.exists(parentage_file)) {
  # make ProgenyArray object
  message("making ProgenyArray object...  ", appendLF=FALSE)
  pa <- ProgenyArray(geno(teo)[, progeny$taxa],
                     geno(teo)[, parents$taxa],
                     mothers,
                     loci=teo@ranges)
  message("done.")
  ## Infer parentage
  # calculate allele frequencies
  pa <- calcFreqs(pa)

  # infer parents
  message("inferring parentage...  ", appendLF=FALSE)
  pa <- inferParents(pa, ehet=0.6, ehom=0.1, verbose=TRUE)
  message("done.")
  message("saving parentage...  ", appendLF=FALSE)
  save(pa, file=parentage_file)
  message("done.")
} else {
  load(parentage_file)
}

## Phasing
window_size <- 6L

if (!file.exists(phasing_file)) {
  message("added ref/alt alleles...  ", appendLF=FALSE)
  pa@ref <- ref(teo)
  pa@alt <- alt(teo)
  message("done.")
  message("phasing data...  ", appendLF=FALSE)
  gmtiles <- geneticTiles(pa, "NAM_AGPv2_filtered_gm_4col.txt", window_size)
  pa <- phaseParents(pa, gmtiles)
  message("done.")
  message("saving phased data...  ", appendLF=FALSE)
  save(pa, file=phasing_file)
  message("done.")
} else {
  load(phasing_file)
}

message("writing phased results...  ", appendLF=FALSE)
phased_data_file <- "phases_alleles.txt.gz"
tmp <- phases(pa, include_ll=TRUE)
for (i in seq_along(pa@tiles@tiles)) {
  file <- gzfile(sprintf("cj_phasing_%d.gz", i))
  out <- cbind(tmp$pos[[i]], tile=tmp$tiles[[i]], round(tmp$ll[[i]], 6), tmp$pars[[i]], tmp$prog[[i]])
  write.table(out, file=file, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
}
message("done.")