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

### List of software to test

1. Beagle trios
2. MACH
3. FIMPUTE
4. findhap.f90
5. PHASEBOOK
6. Alpha{Phase, Impute}
7. LDMIP



