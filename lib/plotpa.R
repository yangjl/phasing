plotpa <- function(sim, kids=10, cols=c("red", "blue"), ...){
    
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
        if((infoi$momrec == 0) & (infoi$dadrec == 0)){
            addsnps(genotab=simp, yl=4*(kids+1)-4*i,  cols=cols)
        }else{
            addsnps_rec(genotab=genoi, yl=4*(kids+1)-4*i, infoi=infoi,  cols=cols)
        }
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

addsnps_rec <- function(genotab=simp, yl=11, infoi=infoi,  cols=c("red", "blue")){
    
    text(x=genotab$id[1:infoi$momrec], y=yl, labels=genotab$hap1[1:infoi$momrec], col= cols[infoi$momh1])
    text(x=genotab$id[(infoi$momrec+1):nrow(genotab)], y=yl, 
         labels=genotab$hap1[(infoi$momrec+1):nrow(genotab)], col= cols[infoi$momh2])
    
    text(x=genotab$id[1:infoi$dadrec], y=yl-1, labels=genotab$hap2[1:infoi$dadrec], col= cols[infoi$dadh1]) 
    text(x=genotab$id[(infoi$dadrec+1):nrow(genotab)], y=yl-1, 
         labels=genotab$hap2[(infoi$dadrec+1):nrow(genotab)], col= cols[infoi$dadh2]) 
    
    text(x=genotab$id, y= yl-2, labels=genotab$obs, col="black") # This adds labels to positions (x,y)
    sub <- subset(genotab, obs != (hap1+hap2))
    if(nrow(sub) >0){
        text(x=sub$id, y= yl-2, labels=sub$obs, col="red") # This adds labels to positions (x,y)
    }
    abline(h=yl-3, lwd=2, col="grey")
}