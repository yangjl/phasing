### Jinliang Yang
### 12/8/2015

imp <- data.frame()
for(i in 1:10){
    tem <- read.csv(paste0("largedata/ip/chr", i, "_ip50.csv"))
    imp <- rbind(imp, tem)
}
imp <- read.csv()


snpinfo <- data.frame()
for(i in 1:10){
    ob <- load(paste0("largedata/obs/p67_PC_N14_ID1_1:250276247_chr", i, ".RData"))
}



