### Jinliang Yang
### 12/16/2015
### simulation of impute_parent

library(imputeR)
sim_ip <- function(numloci=1000, selfrate=1, outfile=NULL){
    
    
    perr <- t(gen_error_mat(major.error=0.01, het.error=0.6, minor.error=0.01))
    kerr <- perr
    
    out <- data.frame()
    for(SIZE in 1:100){
        GBS.array <- sim.array(size.array=SIZE, numloci, hom.error = 0.01, het.error = 0.6, selfing=selfrate,
                               rec = 0.25, imiss = 0.5, misscode = 3)
        #GBS.array <- true_other_parents(GBS.array)
        GBS.array@pedigree$true_p <- truep
        
        inferred_geno_likes <- impute_parent(GBS.array, perr, kerr)
        res <- parentgeno(inferred_geno_likes, oddratio=0.6931472, returnall=TRUE)
        res$true_parent <- GBS.array@true_parents[[SIZE+1]]$hap1 + GBS.array@true_parents[[SIZE+1]]$hap2
        
        tem <- data.frame(size=SIZE, error=sum(res$gmax != res$true_parent)) 
        out <- rbind(out, tem)
    }
    if(!is.null(outfile)){
        write.table(out, outfile, sep=",", row.names=FALSE, quote=FALSE)
    }
    return(out)
}

### completely selfed kids
set.seed(1234)
tem1 <- data.frame()
for(k in 1:5){
    out1 <- sim_ip(numloci=1000, selfrate=1, outfile="cache/simip_out1.csv")
    out1$rand <- k
    tem1 <- rbind(tem1, out1)
}
write.table(tem1, "cache/simip_out1.csv", sep=",", row.names=FALSE, quote=FALSE)

### half selfed kids and half oc (parents unknow)
set.seed(1234)
tem2 <- data.frame()
for(k in 1:5){
    out2 <- sim_ip(numloci=1000, selfrate=0.5, outfile="cache/simip_out2.csv")
    out2$rand <- k
    tem2 <- rbind(tem2, out2)
}
write.table(tem2, "cache/simip_out2.csv", sep=",", row.names=FALSE, quote=FALSE)


### complete oc (unknow parents)
set.seed(12345)
tem3 <- data.frame()
for(k in 1:5){
    
    out3 <- sim_ip(numloci=100, selfrate=0, outfile="cache/simip_out3.csv")
    out3$rand <- k
    tem3 <- rbind(tem3, out3)
}
write.table(tem3, "cache/simip_out3.csv", sep=",", row.names=FALSE, quote=FALSE)


