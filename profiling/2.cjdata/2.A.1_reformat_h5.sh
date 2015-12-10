# copy the following codes to shell
srun.x11 -p bigmemh --mem 64000 --ntasks=8 --nodelist=bigmem4
module load gcc jdk/1.8 tassel/5

# to export - whatever the hdf5 file is - if you want plink -'Plink' or 'Hapmap' for hmp
run_pipeline.pl -Xmx64g -fork1 -h5 teo.h5 -export teo -exportType Hapmap -runfork1

snpfrq -i teo.hmp.txt -s 12 -m N -o teo.info
