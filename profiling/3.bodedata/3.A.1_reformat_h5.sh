# copy the following codes to shell
srun.x11 -p bigmemh --mem 64000 --ntasks=8 --nodelist=bigmem1
module load gcc jdk/1.8 tassel/5

# to export - whatever the hdf5 file is - if you want plink -'Plink' or 'Hapmap' for hmp
run_pipeline.pl -Xmx64g -fork1 -h5 largedata/lcache/maize_landrace.h5 -export largedata/lcache/landrace -exportType Hapmap -runfork1

getsnpinfo -i landrace.hmp.txt -s 12 -o landrace.info


