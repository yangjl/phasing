# copy the following codes to shell
srun.x11 -p bigmemh --mem 100000 --ntasks=12 --nodelist=bigmem6
module load gcc jdk/1.8 tassel/5

# to export - whatever the hdf5 file is - if you want plink -'Plink' or 'Hapmap' for hmp
run_pipeline.pl -Xmx64g -fork1 -h5 largedata/lcache/teo.h5 -export largedata/lcache/teo -exportType Hapmap -runfork1

getsnpinfo -i teo.hmp.txt -s 12 -o teo.info

snpcovert -h
