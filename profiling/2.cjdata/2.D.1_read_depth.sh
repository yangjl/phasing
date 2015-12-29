# display depth information
srun.x11 -p bigmemh --mem 64000 --ntasks=8 --nodelist=bigmem1
module load gcc jdk/1.8 tassel/5

run_pipeline.pl -Xmx64g -h5 largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.h5 -export largedata/iplantdata/RareAllelesC2Teo2015_ZeaGBSv27raw.vcf -exportType VCF