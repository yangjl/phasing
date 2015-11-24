# Jinliang Yang
# 11.23/2015
# collect simulation results


collect_sim <- function(){
    files <- list.files(path="largedata/sim1/", pattern ="csv$", full.names=TRUE)
    out <- data.frame()
    for(i in 1:length(files)){
        res <- read.csv(files[i])
        
        #error rates
        e1 <- nrow(subset(res, gmax != true_parent ))/nrow(res)
        e2 <- nrow(subset(res, gor != true_parent & gor !=3 ))/nrow(res)
        
        tem <- data.frame(file=files[i], err1=e1, err2=e2)
        out <- rbind(out, tem)
    }
    return(out)
}

res <- collect_sim()
