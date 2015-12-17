### Jinliang Yang
### 12/16/2015
### simulation of impute_parent

library(imputeR)

### completely selfed kids
set.seed(1234)
tem1 <- data.frame()
for(k in 1:10){
    out1 <- sim_ip(numloci=1000, selfrate=1, truep=0, outfile="cache/simip_out1.csv")
    out1$rand <- k
    tem1 <- rbind(tem1, out1)
}
write.table(tem1, "cache/simip_out1.csv", sep=",", row.names=FALSE, quote=FALSE)

### half selfed kids and half oc (parents unknow)
set.seed(1234)
tem2 <- data.frame()
for(k in 1:10){
    out2 <- sim_ip(numloci=1000, selfrate=0.5, truep=0, outfile="cache/simip_out2.csv")
    out2$rand <- k
    tem2 <- rbind(tem2, out2)
}
write.table(tem2, "cache/simip_out2.csv", sep=",", row.names=FALSE, quote=FALSE)


### half selfed kids and half oc (know parents)
set.seed(1234)
tem3 <- data.frame()
for(k in 1:10){
    out3 <- sim_ip(numloci=1000, selfrate=0.5, truep=1, outfile="cache/simip_out3.csv")
    out3$rand <- k
    tem3 <- rbind(tem3, out3)
}
write.table(tem3, "cache/simip_out3.csv", sep=",", row.names=FALSE, quote=FALSE)

### complete oc (unknow parents)
set.seed(12345)
tem4 <- data.frame()
for(k in 1:5){
    out4 <- sim_ip(numloci=1000, selfrate=0, truep=0, outfile="cache/simip_out4_2.csv")
    out4$rand <- k
    tem4 <- rbind(tem4, out4)
}
write.table(tem4, "cache/simip_out4_2.csv", sep=",", row.names=FALSE, quote=FALSE)

### complete oc (know parents)
set.seed(1234)
tem5 <- data.frame()
for(k in 1:10){
    out5 <- sim_ip(numloci=1000, selfrate=0, truep=1, outfile="cache/simip_out5.csv")
    out5$rand <- k
    tem5 <- rbind(tem5, out5)
}
write.table(tem5, "cache/simip_out5.csv", sep=",", row.names=FALSE, quote=FALSE)



