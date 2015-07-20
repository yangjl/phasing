### Jinliang Yang
### BLOCK Paritioning (bmh)

ob <- load("cache/sim123456.RData")


####


File Formats
------------
    
ENT accepts sequences of the form 0/1/2/? where 0/1 denote the 
genotypes that are homozygous for the major/minor allele, 
2 denotes a heterozygous genotype, and ? denotes an unknown genotype.

The ENT input file format is as follows:
    
# * First line: <number of individuals> <number of snps>
# * Additional lines:
# <individual id> <sex> <parent 1 id> <parent 2 id> <genotype sequence>
# All individual id's must be non-zero, a parent id of 0 represents no 
known parent.


