### Jinliang Yang modified from VSB
### July 30th, 2015
## phasing.R

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