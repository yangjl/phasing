### JRI: http://rpubs.com/rossibarra/self_impute

SimSelfer <- function(size.array=20, het.error=0.7, hom.error=0.002, numloci=1000, recombination=TRUE){
    
    ### Simulate and Test
    # make mom
    sfs <- getsfs()
    p=sample(sfs,numloci) #get freqs for all loci
    a1=ran.hap(numloci,p) #make haplotypes
    a2=ran.hap(numloci,p)
    
    true_mom=list(a1,a2) #phased 
    obs_mom=add_error(a1+a2,hom.error,het.error) #convert to diploid genotype
    
    simp <- data.frame(hap1=a1, hap2=a2, geno=a1+a2, obs=obs_mom)
    ## tot 142/1000
    ## nrow(subset(simp, (hap1 != hap2)  & (hap1 + hap2 != geno)))/nrow(subset(simp, hap1 != hap2))
    # 0.70
    ## nrow(subset(simp, (hap1 == hap2)  & (hap1 + hap2 != geno)))/nrow(subset(simp, hap1 == hap2))
    # 0.00125
    
    # make selfed progeny array
    progeny <- vector("list",size.array)
    progeny <- lapply(1:size.array, function(a) kid(true_mom,true_mom, het.error, hom.error, recombination))
    #progeny <- replicate(size.array, kid(true_mom,true_mom, het.error, hom.error, recombination=TRUE))
    return(list(simp, progeny))
    
}

### Create random haplotype
ran.hap=function(numloci,p){sapply(1:numloci,function(x) rbinom(1,1,p[x]))}

### setup the neutral SFS
getsfs <- function(){
    x=1:99/100 #0.01 bins of freq.
    freq=1/x
    sfs=as.numeric(); 
    for(i in 1:99){sfs=c(sfs,rep(x[i],100*freq[i]))}
    return(sfs)
}
### Add error to diploid
add_error<-function(diploid,hom.error,het.error){
    hets_with_error=sample(which(diploid==1),round(het.error*length(which(diploid==1))))
    hom0_with_error=sample(which(diploid==0),round(hom.error*length(which(diploid==0))))
    hom2_with_error=sample(which(diploid==2),round(hom.error*length(which(diploid==2))))
    diploid=replace(diploid,hets_with_error,sample(c(0,2),length(hets_with_error),replace=T)  )
    ### error rate from (hom => het) == (hom1 => hom2)
    diploid=replace(diploid,hom0_with_error,sample(c(1,2),length(hom0_with_error),replace=T)  )
    diploid=replace(diploid,hom2_with_error,sample(c(1,0),length(hom2_with_error),replace=T)  )
    return(diploid)
}

### Make a kid #Returns list of true [[1]] and observed [[2]] kid
kid <- function(mom,dad, het.error, hom.error, recombination){
    
    h <- rbinom(4,1,.5)+1 #mon hap1; dad hap1; mom hap2; dad hap2
    if(recombination){
        len <- length(mom[[1]])
        idx <- sample(1:len, 2) # mon rec; dad rec
        k1= c(mom[[h[1]]][1:idx[1]], mom[[h[3]]][(idx[1]+1):len])
        k2= c(dad[[h[2]]][1:idx[2]], dad[[h[4]]][(idx[2]+1):len])
        true_kid <- k1+k2
         
    }else{
        idx <- c(0, 0)
        k1=mom[[h[1]]]
        k2=dad[[h[2]]]
        true_kid=k1+k2
    }
    obs_kid <- add_error(true_kid,hom.error,het.error)
    info <- data.frame(momh1=h[1], dadh1=h[2], momh2=h[3], dadh2=h[4], momrec=idx[1], dadrec=idx[2])
    simk <- data.frame(hap1=k1, hap2=k2, obs= obs_kid )
    return(list(info, simk))
}





### Return HW probs
hw_probs<-function(x){ return(c(x^2,2*x*(1-x),(1-x)^2))}

### infer mom's genotype
# inferred_mom=1 -> 00, 2->01, 3->11
infer_mom<-function(obs_mom,locus,progeny,p){
    mom_probs=as.numeric()
    for(inferred_mom in 1:3){
        #P(G'|G)
        pgg=gen_error_mat[inferred_mom,obs_mom[locus]+1] #+1 because obs_mom is 0,1, or 2
        #P(G)
        pg=hw_probs(p[locus])[inferred_mom]
        #P(kids|G) sum of logs instead of product
        pkg=sum(sapply(1:length(progeny), function(z) 
            log(sum(probs[[inferred_mom]][,progeny[[z]][[2]][locus]+1]))))
        mom_probs[inferred_mom]=pkg+log(pgg)+log(pg)
    }
    return(which(mom_probs==max(mom_probs))-1)
}

#infer_mom(obs_mom,a,progeny,p)