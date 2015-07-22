options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
co=as.numeric(args[1])
bob=co+3
print(bob)
print(co*2)
print(rpois(1,co))
