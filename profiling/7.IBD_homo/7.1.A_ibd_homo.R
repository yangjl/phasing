### Jinliang Yang
### April 5th, 2016

teop <- read.table("largedata/teo_parents_hap_AGPv2.txt", header=TRUE)

teo67 <- read.csv("largedata/ip/imp67.csv")

teo67[teo67 == 0] <- "A A"
teo67[teo67 == 1] <- "A T"
teo67[teo67 == 2] <- "T T"
teo67[teo67 == 3] <- "0 0"

#The first 4 columns of a TPED file are the same as a standard 4-column MAP file. 
#Then all genotypes are listed for all individuals for each particular SNP on each line. 
#The TFAM file is just the first six columns of a standard PED file. 
#In otherwords, we have just taken the standard PED/MAP file format, 
#but swapped all the genotype information between files, after rotating it 90 degrees. 
#For each, the above example PED/MAP fileset

map <- data.frame(chr=1, snpid=row.names(teo67), genetic=0, position=1)
map$chr <- gsub("S|_.*", "", map$snpid)
map$position <- gsub(".*_", "", map$snpid)

tped <- cbind(map, teo67)
write.table(tped, "largedata/ibd/teo67.tped", row.names=FALSE, quote=FALSE, sep="\t", col.names=FALSE)

tfam <- data.frame(fid=1:ncol(teo67), iid=names(teo67), pid=0, mid=0, sex=0, pheno=-9)
write.table(tfam, "largedata/ibd/teo67.tfam", row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")



######################################
system("plink --tfile teo67 --make-bed --out teo67")
system("plink --bfile teo67 --homozyg --out teo67")
#plink --bfile teo67 --genome --out teo67")
system("plink --bfile teo67 --recode vcf --maf 0.01 --out teo67")


library(farmeR)

shcode = c("module load java", "cd largedata/ibd/",
           "java -Xmx32g -jar ~/bin/beagle.22Feb16.8ef.jar gt=teo67.vcf ibd=true out=teo67")
set_array_job(shid = "slurm-script/run_beagle.sh",
              shcode = shcode, arrayjobs = "1", wd = NULL,
              jobid = "beagle", email = "yangjl0930@gmail.com", runinfo = c(TRUE, "bigmemh", "4"))


