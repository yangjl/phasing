# Self imputation
# Use self progeny to impute, but not phase, mom. Base on old [mctwos code](https://rpubs.com/rossibarra/mctwos), 
# so uses haplotypes even though here we ignore phasing.

## Functions

############################################################################
# Create random haplotype
ran.hap=function(numloci,p){sapply(1:numloci,function(x) rbinom(1,1,p[x]))}
############################################################################

# Copy mom to kids with recombination
copy.mom=function(mom,co_mean){ 
  co=rpois(1,co_mean) #crossovers
  numloci=length(mom[[1]])
  rec=c(1,sort(round(runif(co,2,numloci-1))),numloci+1) #position   
  chrom=rbinom(1,1,.5)+1
  kpiece=as.numeric()
  for(r in 1:(length(rec)-1)){
    kpiece=c(kpiece,mom[[chrom]][rec[r]:(rec[r+1]-1)]) #copy 1->rec from mom
    chrom=ifelse(chrom==1,2,1)  
  }     
  return(kpiece)
}
############################################################################


############################################################################
#Add error to diploid
#Error model assumes errors have equal likelihood of being called either alternative genotype.
add_error<-function(diploid,hom.error,het.error){
    hets_with_error=sample(which(diploid==1),round(het.error*length(which(diploid==1))))
    hom0_with_error=sample(which(diploid==0),round(hom.error*length(which(diploid==0))))
    hom2_with_error=sample(which(diploid==2),round(hom.error*length(which(diploid==2))))
    diploid=replace(diploid,hets_with_error,sample(c(0,2),length(hets_with_error),replace=T)  )
    diploid=replace(diploid,hom0_with_error,sample(c(1,2),length(hom0_with_error),replace=T)  )
    diploid=replace(diploid,hom2_with_error,sample(c(1,0),length(hom2_with_error),replace=T)  )
    return(diploid)
}
############################################################################

############################################################################
# Make a kid
#Returns list of true [[1]] and observed [[2]] kid
kid=function(mom,dad,het.error,hom.error,rec=1.5){
    if(rec==0){
      k1=mom[[rbinom(1,1,.5)+1]]
      k2=dad[[rbinom(1,1,.5)+1]]
    } else{
      k1=copy.mom(mom,rec)
      k2=copy.mom(dad,rec)
    }
    true_kid=k1+k2
    obs_kid=add_error(true_kid,hom.error,het.error)
    return(list(true_kid,obs_kid))
}
############################################################################

############################################################################
# Return HW probs
hw_probs<-function(x){ return(c(x^2,2*x*(1-x),(1-x)^2))}
############################################################################

############################################################################
# Setup all possible haplotypes for window of X heterozgous sites
#This needs to be fixed to remove redundancy. E.g. 010 is the same as 101 and 1010 is same as 0101.
#I don't think should bias things in the meantime, just be slow.
setup_haps<-function(win_length){
  haps=list(0,1); 
  for(i in 2:win_length){ 
    haps=c(haps,haps); 
    for(j in 1:(length(haps)/2)){  haps[[j]][(length(haps[[j]]))+1]=0 };   
    for(k in (length(haps)/2+1):length(haps)){  haps[[k]][(length(haps[[k]]))+1]=1 };   
  }
  nohaps=as.numeric();
  newhaps=list();
  for(i in 1:(length(haps)-1)){
    for(j in (i+1):length(haps)){
      if(sum((1-unlist(haps[j]))==unlist(haps[i]))==win_length){ nohaps[length(nohaps)+1]=i }
    }
  }
  for(i in 1:length(haps)){ if(!(i %in% nohaps)){newhaps[[length(newhaps)+1]]=haps[[i]]}}
  return(newhaps)
}
############################################################################


############################################################################
# Find most likely phase of kid at a window, return that probability
#give this mom haplotype and a kid's diploid genotype over the window and returns maximum prob
# Mendel is taken care of in the probs[[]] matrix already 
which_phase<-function(haplotype,kidwin){
  three_genotypes=list()
  haplotype=unlist(haplotype)
  three_genotypes[[1]]=haplotype+haplotype
  three_genotypes[[2]]=haplotype+(1-haplotype)
  three_genotypes[[3]]=(1-haplotype)+(1-haplotype)
  geno_probs=as.numeric() #prob of each of three genotypes
  for(geno in 1:3){
    #log(probs[[2]][three_genotypes,kidwin] is the log prob. of kid's obs geno 
    #given the current phased geno and given mom is het. (which is why probs[[2]])
    geno_probs[geno]=sum( sapply(1:length(haplotype), function(zz) log( probs[[2]][three_genotypes[[geno]][zz]+1,kidwin[zz]+1])))
  }
  if(length(which(geno_probs==max(geno_probs)))!=1){browser()}
  return(max(geno_probs))
}
############################################################################


############################################################################
# Get mom's phase
phase_mom<-function(mom,progeny,win_length){
  hetsites=which(estimated_mom==1)
  mom_haps<-setup_haps(win_length) # gets all possible haplotypes for X hets 
  mom_phase1=as.numeric() 
  mom_phase2=as.numeric() 
  win_hap=as.numeric()
  old_hap=as.numeric() 
  for(winstart in 1:(length(hetsites)-(win_length-1))){
    #print(paste(winstart,"...")) 
    momwin=hetsites[winstart:(winstart+win_length-1)]
    if(winstart==1){ #arbitrarily assign win_hap to one chromosome initially
      win_hap=infer_dip(momwin,progeny,mom_haps)
      mom_phase1=win_hap
      mom_phase2=1-win_hap
    } else{
      win_hap=infer_dip(momwin,progeny,mom_haps,mom_phase1)
      same=sum(mom_phase1[winstart:(winstart+(length(win_hap)-2))]==win_hap[1:length(win_hap)-1])
      if(same==0){ #totally opposite phase of last window
        mom_phase2[length(mom_phase2)+1]=win_hap[length(win_hap)]
        mom_phase1[length(mom_phase1)+1]=1-win_hap[length(win_hap)]
      } else if(same==(win_length-1) ){ #same phase as last window
        mom_phase1[length(mom_phase1)+1]=win_hap[length(win_hap)]
        mom_phase2[length(mom_phase2)+1]=1-win_hap[length(win_hap)]
      } else{ #PHASE ERROR!
      browser()
      }
    }
  }
  return(mom_phase1)
}
############################################################################



############################################################################
# Same as above, output kid's phase.
# give this mom haplotype and a kid's diploid genotype over the window and returns maximum prob
# Mendel is takenh care of in the probs[[]] matrix already 
which_phase_kid<-function(haplotype,kidwin){
  three_genotypes=list()
  haplotype=unlist(haplotype)
  three_genotypes[[1]]=haplotype+haplotype
  three_genotypes[[2]]=haplotype+(1-haplotype)
  three_genotypes[[3]]=(1-haplotype)+(1-haplotype)
  geno_probs=as.numeric() #prob of each of three genotypes
  for(geno in 1:3){
    #log(probs[[2]][three_genotypes,kidwin] is the log prob. of kid's obs geno 
    #given the current phased geno and given mom is het. (which is why probs[[2]])
    geno_probs[geno]=sum( sapply(1:length(haplotype), function(zz) log( probs[[2]][three_genotypes[[geno]][zz]+1,kidwin[zz]+1])))
  }
  if(length(which(geno_probs==max(geno_probs)))!=1){browser()}
  return(three_genotypes[[which(geno_probs==max(geno_probs))]])
}
############################################################################


############################################################################
# Infer which phase is mom in a window
infer_dip<-function(momwin,progeny,haps,momphase1){  #momwin is list of heterozygous sites, progeny list of kids genotypes, haps list of possible haps,momphase1 is current phased mom for use in splitting ties
  phase_probs=as.numeric()
  for(my_hap in 1:(length(haps))){ #iterate over possible haplotypes <- this is slower because setup_haps makes too many haps
    #get max. prob for each kid, sum over kids
    phase_probs[my_hap]=sum( sapply(1:length(progeny), function(z) which_phase(haps[my_hap],progeny[[z]][[2]][momwin] )))
  }
 #if multiple haps tie, check each against current phase and return one with smallest distance
 if(length(which(phase_probs==max(phase_probs)))>1){
    same_phases=which(phase_probs==max(phase_probs))
    tie_score=as.numeric()
    long=length(momwin)
    for( i in 1:length(same_phases)){    
      tie_hap=haps[[same_phases[i]]]
      same1=sum(momphase1[(length(momphase1)-long+2):length(momphase1)]==tie_hap[1:length(tie_hap)-1])
      same2=sum(momphase1[(length(momphase1)-long+2):length(momphase1)]==(1-tie_hap[1:length(tie_hap)-1]))
      tie_score[i]=max(same1,same2)
    }
    if(length(which(tie_score==max(tie_score)))!=1){browser()}
    return(haps[[same_phases[which(tie_score==max(tie_score))]]])
  } else {
    return(haps[[which(phase_probs==max(phase_probs))]])
  }
}
############################################################################


############################################################################
# Infer mom's genotype
#We have obs. mom and obs. (selfed) kids.  We want to know $P(G|\theta)$, and $P(G|\theta) \propto P(\theta|G) \times (G)$, where $\theta$ is observed data.  This consists of observed genotypes ($G'$) of both mom and kids. So:
#$P(G|\theta)\propto \left( \prod\limits_{i=1}^{k}{P(G'_k|G)} \right) \times P(G'_{mom}|G) \times P(G)$
#This function is to impute mom's genotype from a progeny array of k kids at a single locus.
# inferred_mom=1 -> 00, 2->01, 3->11
infer_mom<-function(obs_mom,locus,progeny,p){
  mom_probs=as.numeric()
  for(inferred_mom in 1:3){
    #P(G'|G)
    pgg=gen_error_mat[inferred_mom,obs_mom[locus]+1] #+1 because obs_mom is 0,1, or 2
    #P(G)
    pg=hw_probs(p[locus])[inferred_mom]
    #P(kids|G) sum of logs instead of product
    pkg=sum(sapply(1:length(progeny), function(z) log(sum(probs[[inferred_mom]][,progeny[[z]][[2]][locus]+1]))))
    mom_probs[inferred_mom]=pkg+log(pgg)+log(pg)
  }
  return(which(mom_probs==max(mom_probs))-1)
}
############################################################################






