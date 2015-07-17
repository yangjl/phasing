### Params and probabilities

size.array=20 # size of progeny array
het.error=0.7 # het->hom error
hom.error=0.002 # hom->other error
numloci=1000 

### setup the neutral SFS
x=1:99/100 #0.01 bins of freq.
freq=1/x
sfs=as.numeric(); 
for(i in 1:99){sfs=c(sfs,rep(x[i],100*freq[i]))}
hist(sfs)

### Probabilities
# row 1 is true_gen 00, row2 is true_gen 01, row 3 is true_gen 11
# cols are obs. genotype (00,01,11)
gen_error_mat<-matrix(c(1-hom.error,hom.error/2,hom.error/2,het.error/2,1-het.error,het.error/2,
                        hom.error/2,hom.error/2,1-hom.error),byrow=T,nrow=3,ncol=3)
gen_error_mat
#     [00]  [01]  [11]
#[00] 0.998 0.001 0.001
#[01] 0.350 0.300 0.350
#[11] 0.001 0.001 0.998

# true_mom is 00
probs<-vector("list",3)
probs[[1]]<-gen_error_mat*matrix(c(1, 0, 0), nrow = 3,byrow=F,ncol=3)
probs[[2]]<-gen_error_mat*matrix(c(1/4, 1/2, 1/4), nrow = 3,byrow=F,ncol=3)
probs[[3]]<-gen_error_mat*matrix(c(0, 0, 1), nrow = 3,byrow=F,ncol=3)


### Simulate and Test

# make mom
p=sample(sfs,numloci) #get freqs for all loci
a1=ran.hap(numloci,p) #make haplotypes
a2=ran.hap(numloci,p)

true_mom=list(a1,a2) #phased 
obs_mom=add_error(a1+a2,hom.error,het.error) #convert to diploid genotype

simp <- data.frame(hap1=a1, hap2=a2, geno=obs_mom)
## tot 142/1000
nrow(subset(simp, (hap1 != hap2)  & (hap1 + hap2 != geno)))/nrow(subset(simp, hap1 != hap2))
# 0.70
nrow(subset(simp, (hap1 == hap2)  & (hap1 + hap2 != geno)))/nrow(subset(simp, hap1 == hap2))
# 0.00125

# make selfed progeny array
progeny<-vector("list",size.array)
progeny<-lapply(1:size.array, function(a) kid(true_mom,true_mom,het.error,hom.error))

# Infer Stuff => do all loci and test mom
estimated_mom=sapply(1:numloci, function(a) infer_mom(obs_mom,a,progeny,p) )
sum(estimated_mom==true_mom[[1]]+true_mom[[2]])
simp$estmon <- estimated_mom


###### try lots
sims=10
size.array=10 # size of progeny array
het.error=0.7 # het->hom error
hom.error=0.002 # hom->other error
numloci=1000 
errors.correct= FALSE # can assume we know error rates or not
freqs.correct=TRUE # can assume we know freqs or not

x=1:99/100 #0.01 bins of freq.
freq=1/x
sfs=as.numeric(); 
for(i in 1:99){sfs=c(sfs,rep(x[i],100*freq[i]))}
gen_error_mat<-matrix(c(1-hom.error,hom.error/2,hom.error/2,het.error/2,1-het.error,het.error/2,hom.error/2,hom.error/2,1-hom.error),byrow=T,nrow=3,ncol=3)
probs[[1]]<-gen_error_mat*matrix(c(1, 0, 0), nrow = 3,byrow=F,ncol=3)
probs[[2]]<-gen_error_mat*matrix(c(1/4, 1/2, 1/4), nrow = 3,byrow=F,ncol=3)
probs[[3]]<-gen_error_mat*matrix(c(0, 0, 1), nrow = 3,byrow=F,ncol=3)
p=sample(sfs,numloci) #get freqs for all loci

sim=as.numeric()
infres <- list()
for(mysim in 1:sims){
    
    if(errors.correct==FALSE){
        het.error=runif(1)/1.67+0.4 # random 0.4-1
        hom.error=10^-(runif(1)*4+1) # random
    }
    if(freqs.correct==FALSE){
        p=sapply(1:numloci, function(a) sum(rbinom(140,1,p[a]))/140) 
        p[which(p==0)]=1/140;
    }
    
    a1=ran.hap(numloci,p) #make haplotypes
    a2=ran.hap(numloci,p)
    true_mom=list(a1,a2) #phased (not necessary here, but a holdover)
    obs_mom=add_error(a1+a2,hom.error,het.error) #convert to diploid genotype
    progeny<-vector("list",size.array)
    progeny<-lapply(1:size.array, function(a) kid(true_mom,true_mom,het.error,hom.error))
    
    estimated_mom=sapply(1:numloci, function(a) infer_mom(obs_mom,a,progeny,p) ) 
    sim[mysim]=sum(estimated_mom==true_mom[[1]]+true_mom[[2]])
    
    simp <- data.frame(hap1=a1, hap2=a2, geno=obs_mom)
    simp$estmom <- estimated_mom
    infres[[mysim]] <- simp
}
mean(sim)
#[1] 917.9

nrow(subset(infres[[1]], hap1!=hap2 & (hap1 + hap2 == estmom) )) / nrow(subset(infres[[1]], hap1 !=hap2))
