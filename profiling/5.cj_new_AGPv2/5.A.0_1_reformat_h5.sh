### Jinliang
### TeoCurated Feb 22th, 2016

# copy the following codes to shell
srun.x11 -p bigmemh --mem 128000 --ntasks=16 --nodelist=bigmem7
module load gcc jdk/1.8 tassel/5

# to export - whatever the hdf5 file is - if you want plink -'Plink' or 'Hapmap' for hmp
cd largedata/teo_updated/
run_pipeline.pl -Xmx128g -fork1 -h5 ZeaGBSv27raw_RareAllelesC2TeoCurated_20160215_AGPv2.h5  -export TeoCurated_20160215_AGPv2 -exportType Hapmap -runfork1

getsnpinfo -i TeoCurated_20160215_AGPv2.hmp.txt -s 12 -o TeoCurated_20160215_AGPv2.hmp.info


## after SNP filtering
snpconvert -a landrace.hmp.txt -i landrace_flt_maf01m8.txt -s 12 -o land_recode.txt

module load vcftools/0.1.13


#### AGPv3
run_pipeline.pl -Xmx128g -fork1 -h5 ZeaGBSv27raw_RareAllelesC2TeoCurated_20160215_AGPv3.h5  -export TeoCurated_20160215_AGPv3 -exportType Hapmap -runfork1
