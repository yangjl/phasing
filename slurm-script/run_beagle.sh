#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/phasing
#SBATCH -o /home/jolyang/Documents/Github/phasing/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/phasing/slurm-log/err-%j.txt
#SBATCH -J beagle
#SBATCH --array=1
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

module load java
cd largedata/ibd/
java -Xmx32g -jar ~/bin/beagle.22Feb16.8ef.jar gt=teo67.vcf ibd=true out=teo67
