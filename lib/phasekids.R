# Self imputation
# Use self progeny to impute, but not phase, mom. Base on old [mctwos code](https://rpubs.com/rossibarra/mctwos), so uses haplotypes even though here we ignore phasing.

## Functions
############################################################################
# Return HW probs
hw_probs<-function(x){ return(c(x^2,2*x*(1-x),(1-x)^2))}
############################################################################
# row 1 is true_gen 00, row2 is true_gen 01, row 3 is true_gen 11
# cols are obs. genotype (00,01,11)
gen_error_mat <- matrix(c(1-hom.error,hom.error/2,hom.error/2,het.error/2,
                          1-het.error,het.error/2,hom.error/2,hom.error/2,1-hom.error),
                        byrow=T,nrow=3,ncol=3)

probs<-vector("list",3)
probs[[1]]<-gen_error_mat*matrix(c(1, 0, 0), nrow = 3,byrow=F,ncol=3)
probs[[2]]<-gen_error_mat*matrix(c(1/4, 1/2, 1/4), nrow = 3,byrow=F,ncol=3)
probs[[3]]<-gen_error_mat*matrix(c(0, 0, 1), nrow = 3,byrow=F,ncol=3)

gen_error_mat <- cbind(gen_error_mat, 1)
probs[[1]] <- cbind(probs[[1]], 1)
probs[[2]] <- cbind(probs[[2]], 1)
probs[[3]] <- cbind(probs[[3]], 1)

############################################################################
# Infer mom's genotype
# We have obs. mom and obs. (selfed) kids.  We want to know $P(G|\theta)$, and $P(G|\theta) \propto P(\theta|G) \times P(G)$, 
# where $\theta$ is observed data.  This consists of observed genotypes ($G'$) of both mom and kids. So:
# $P(G|\theta)\propto \left( \prod\limits_{i=1}^{k}{P(G'_k|G)} \right) \times P(G'_{mom}|G) \times P(G)$
# This function is to impute mom's genotype from a progeny array of k kids at a single locus.
# inferred_mom=1 -> 00, 2->01, 3->11
infer_mom<-function(obs_mom,locus,progeny,p){
    ### locus:
    ### p: p=sample(sfs,numloci) #freqs of all loci sampled from sfs
    mom_probs=as.numeric()
    for(inferred_mom in 1:3){
        #P(G'|G)
        pgg=gen_error_mat[inferred_mom,obs_mom[locus]+1] #+1 because obs_mom is 0,1, or 2
        #P(G)
        pg=hw_probs(p[locus])[inferred_mom]
        #P(kids|G) sum of logs instead of product
        pkg=sum(sapply(1:length(progeny), function(z){
            ### take care of missing data
            #if(progeny[[z]][[2]][locus] >= 0 & progeny[[z]][[2]][locus] <=2){
                log(sum(probs[[inferred_mom]][,progeny[[z]][[2]][locus]+1]))
            #}
        } ))
        mom_probs[inferred_mom]=pkg+log(pgg)+log(pg)
    }
    return(which(mom_probs==max(mom_probs))-1)
}
############################################################################





############################################################################
# Setup all possible haplotypes for window of X heterozgous sites
# This needs to be fixed to remove redundancy. E.g. 010 is the same as 101 and 1010 is same as 0101. 
# I don't think should bias things in the meantime, just be slow.
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
# give this mom haplotype and a kid's diploid genotype over the window and returns maximum prob
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
    geno_probs[geno]=sum( sapply(1:length(haplotype), 
                                 function(zz) log( probs[[2]][three_genotypes[[geno]][zz]+1,kidwin[zz]+1])))
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
      } else{ ##returns the minimum distance haplotype (prepare to screw up phase!)
          warning(paste("Likely recombination at",winstart,sep=" "))
          diff1=sum(abs(mom_phase1[winstart:(winstart+(length(win_hap)-2))]-win_hap[1:length(win_hap)-1]))
          diff2=sum(abs(mom_phase2[winstart:(winstart+(length(win_hap)-2))]-win_hap[1:length(win_hap)-1]))
          if(diff1>diff2){ #momphase1 is less similar to current inferred hap
            mom_phase2[length(mom_phase2)+1]=win_hap[length(win_hap)]
            mom_phase1[length(mom_phase1)+1]=1-win_hap[length(win_hap)]
          } else{ #momphase1 is more similar
            mom_phase1[length(mom_phase1)+1]=win_hap[length(win_hap)]
            mom_phase2[length(mom_phase2)+1]=1-win_hap[length(win_hap)]
          }
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



