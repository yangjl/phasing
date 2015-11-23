plotpa <- function(sim, kids=10, cols=c("red", "blue"), ...){
    ### input from sim objects returned from SimSelfer
    simp <- sim[[1]]
    simp$id <- 1:nrow(simp)
    plot(x=c(1,nrow(simp)), y=c(1, 4*(kids+1)+2), type = "n", 
         xlab="", ylab="", xaxt="n", yaxt="n", ...) # This sets up the plot but doesn't actually
    
    #plot the points
    
    addsnps(genotab=simp, yl=4*(kids+1)+1,  cols=cols)
    abline(h=4*kids+1, lwd=2, col="grey")
    
    simk <- sim[[2]]
    for(i in 1:kids){
        kidi <- simk[[i]]
        infoi <- kidi[[1]]
        genoi <- kidi[[2]]
        genoi$id <- 1:nrow(genoi)
        
        addsnps_rec(genotab=genoi, yl=4*(kids+1)-4*i, infoi=infoi,  cols=cols)
        
    }   
}


addsnps <- function(genotab=simp, yl=11,  cols=c("red", "blue")){
    text(x=genotab$id, y=yl, labels=genotab$hap1, col= cols[1]) # This adds labels to positions (x,y)
    text(x=genotab$id, y=yl-1, labels=genotab$hap2, col= cols[2]) # This adds labels to positions (x,y)
    #text(x=1:100, y=9, labels=simp$geno[1:100], col="black") # This adds labels to positions (x,y)
    #text(x=1:100, y=9, labels=simp$obs[1:100], col="red") # This adds labels to positions (x,y)
    text(x=genotab$id, y= yl-2, labels=genotab$obs, col="black") # This adds labels to positions (x,y)
    sub <- subset(genotab, obs != (hap1+hap2))
    text(x=sub$id, y= yl-2, labels=sub$obs, col="red") # This adds labels to positions (x,y)
    abline(h=yl-3, lwd=2, col="grey")
}

addsnps_rec <- function(genotab=simk, yl=11, infoi=infoi,  cols=c("red", "blue")){
    
    hap1 <- infoi[[1]]
    for(j in 1:nrow(hap1)){
        text(x=hap1$start[j]:(hap1$end[j]-1), y=yl, labels=genotab[hap1$start[j]:(hap1$end[j]-1), 1], 
             col= cols[hap1$hap[j]]) 
    }
    
    hap2 <- infoi[[2]]
    for(k in 1:nrow(hap2)){
        text(x=hap2$start[k]:(hap2$end[k]-1), y=yl-1, labels=genotab[hap2$start[k]:(hap2$end[k]-1), 2], 
             col= cols[hap2$hap[k]]) 
    }
    
    text(x=genotab$id, y=yl-2, labels=genotab$obs, col= "black") 
    sub <- subset(genotab, hap1+hap2 != obs)
    if(nrow(sub) >0){
        text(x=sub$id, y=yl-2, labels=sub$obs, col= "red") 
    }
    
    abline(h=yl-3, lwd=2, col="grey")
}