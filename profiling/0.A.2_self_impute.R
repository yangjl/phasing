### JRI: http://rpubs.com/rossibarra/self_impute

### Create random haplotype
ran.hap=function(numloci,p){sapply(1:numloci,function(x) rbinom(1,1,p[x]))}

### Add error to diploid
add_error<-function(diploid,hom.error,het.error){
    hets_with_error=sample(which(diploid==1),round(het.error*length(which(diploid==1))))
    hom0_with_error=sample(which(diploid==0),round(hom.error*length(which(diploid==0))))
    hom2_with_error=sample(which(diploid==2),round(hom.error*length(which(diploid==2))))
    diploid=replace(diploid,hets_with_error,sample(c(0,2),length(hets_with_error),replace=T)  )
    diploid=replace(diploid,hom0_with_error,sample(c(1,2),length(hom0_with_error),replace=T)  )
    diploid=replace(diploid,hom2_with_error,sample(c(1,0),length(hom2_with_error),replace=T)  )
    return(diploid)
}

### Make a kid #Returns list of true [[1]] and observed [[2]] kid
kid=function(mom,dad,het.error,hom.error){
    k1=mom[[rbinom(1,1,.5)+1]]
    k2=dad[[rbinom(1,1,.5)+1]]
    true_kid=k1+k2
    obs_kid=add_error(true_kid,hom.error,het.error)
    return(list(true_kid,obs_kid))
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