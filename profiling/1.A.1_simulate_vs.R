### Jinliang Yang

source("lib/haplotype-simulation.R")


sim <- simSibFamily(10, 100,
                    rates=c(selfing=0.5, halfsib=0.2, fullsib=0.3),
                    nfullsib_fathers=2, mom_inbred=FALSE,
                    father_F=0.1, ehet=0.8, ehom=0.1,
                    na_rate=0.5) 

# Error: could not find function "sampleSiteFreqs"


