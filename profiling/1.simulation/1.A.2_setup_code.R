### Jinliang Yang
### use impute_parent in CJ data

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")

# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/step1_sim_ip1.sh",
             shcode='R --no-save "--args 1 ${SLURM_ARRAY_TASK_ID}" < profiling/1.simulation/1.A.1_impute_parent_sim.R',
             arrayjobs="10-100",
             wd=NULL, jobid="imputeR-ip1", email="yangjl0930@gmail.com")

##>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh largedata/scripts/step1_sim_ip.sh