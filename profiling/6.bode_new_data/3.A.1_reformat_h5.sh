# copy the following codes to shell
srun.x11 -p bigmemh --mem 128000 --ntasks=16 --nodelist=bigmem1
module load gcc jdk/1.8 tassel/5

# to export - whatever the hdf5 file is - if you want plink -'Plink' or 'Hapmap' for hmp
cd largedata/lcache/
run_pipeline.pl -Xmx128g -fork1 -h5 maize_landrace.h5 -excludeSiteNamesInFile exclude_sites.txt -export landrace -exportType Hapmap -runfork1

getsnpinfo -i largedata/lcache/landrace.hmp.txt -s 12 -o largedata/lcache/landrace.info


## after SNP filtering
snpconvert -a landrace.hmp.txt -i landrace_flt_maf01m8.txt -s 12 -o land_recode.txt

module load vcftools/0.1.13




