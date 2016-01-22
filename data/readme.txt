### README for teosinte imputation
### Created by Jinliang Yang (jolyang@ucdavis.edu)
### 01/15/2015

You can find the following files in this folder.
1) Imputed data (321,346 SNPs and 4,873 plants = 68 parents + 4,805 kids ).
   Note coding: major=0, het=1, minor=2 and missing=3. The coordinates is AGPv2. 
/iplant/home/yangjl/teo/teo_imputeR_01112016.txt 
   
2) SNP information: in a comma seperated file.
/iplant/home/yangjl/teo/teo_imputeR_01112016_info.csv

The header of the file was attached as below. It includes the SNP ID (snpid, chr_physical postion in AGPv2), 
major, minor alleles, maf0 (minor allele freq before imputation), mr0 (locus missing rate before imputation),
maf (minor allele freq after imputation), mr (locus missing rate after imputation).

snpid,major,minor,maf0,mr0,maf,mr
S1_10638,G,T,0.0321025641025641,0.108512820512821,0.0331418017648266,0
S1_111758,C,T,0.0139487179487179,0.312205128205128,0.0242150625897804,0
S1_128373,C,T,0.273025641025641,0.447179487179487,0.518571721731993,0.000820849579314591


3) depth information: read depth for each site.
/iplant/home/yangjl/teo/teo_depth.txt

4) Genotype data masked by depth (depth >= 10 was turned into missing coded with 3)
/iplant/home/yangjl/teo/teo_masked.txt
  
5) raw data: the original raw data in hdf5 format.
/iplant/home/yangjl/teo/teo.h5

