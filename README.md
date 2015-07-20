### Imputation and Phasing


### Simulation

1. A function to simulate a parent-progeny population using GBS with differnt het/hom error rate

```
SimSelfer(size.array=20, het.error=0.7, hom.error=0.002, numloci=1000, recombination=TRUE)
```

2. Visualize object returned from `SimSelfer`.

```
plotpa(sim, kids=10, cols=c("red", "blue"), ...)
```

### Evaluation 

1. imputatation rate
2. error rate (phasing and imputation)
3. efficiency
4. others

### List of software to test


------------

0. [ProgenyArray]()  
1. [ENT]()   
2. [reHC-*](http://rehcstar.algolab.eu/#usage)
3. [mpimpute](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4012496/), [source code](https://github.com/behuang/mpMap)
4. [LinkImpute](http://www.cultivatingdiversity.org/software/)
5. [Haploscribe](http://www.sciencedirect.com/science/article/pii/S0002929711003181)

------------

- Beagle trios
- MACH
- FIMPUTE
- findhap.f90
- PHASEBOOK
- Alpha{Phase, Impute}
- LDMIP


