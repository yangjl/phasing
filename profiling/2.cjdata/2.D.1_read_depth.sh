# display depth information
srun.x11 -p bigmemh --mem 64000 --ntasks=8 --nodelist=bigmem1
module load gcc jdk/1.8 tassel/5

cd largedata/lcache
run_pipeline.pl -Xmx64g -h5 teo.h5 -export teo.vcf -exportType VCF


module load vcftools/0.1.13
vcftools --vcf ZeaGBSv27raw_RareAllelesC2TeoCumul_20160105.vcf --site-depth --out site_depth_summary


##Tassel=<ID=GenotypeTable,Version=5,Description="Reference allele is not known. The major allele was used as reference allele">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the reference and alternate alleles in the order listed">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth (only filtered reads used for calling)">
##FORMAT=<ID=GQ,Number=1,Type=Float,Description="Genotype Quality">
##FORMAT=<ID=PL,Number=3,Type=Float,Description="Normalized, Phred-scaled likelihoods for AA,AB,BB genotypes where A=ref and B=alt; not applicable if site is not biallelic">
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
##INFO=<ID=AF,Number=.,Type=Float,Description="Allele Frequency">

#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT 
#GT:AD:DP:GQ:PL 


getvcf -i largedata/iplantdata/ZeaGBSv27raw_RareAllelesC2TeoCumul_20160105.vcf \\
-n largedata/lcache/teo_flt_maf01m8.txt -o largedata/iplantdata/depth.txt
