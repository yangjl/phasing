# display depth information
srun.x11 -p bigmemh --mem 64000 --ntasks=8 --nodelist=bigmem1
module load gcc jdk/1.8 tassel/5

cd largedata/lcache
run_pipeline.pl -Xmx64g -h5 teo.h5 -export teo.vcf -exportType VCF