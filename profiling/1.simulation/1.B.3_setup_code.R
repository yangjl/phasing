### Jinliang Yang
### use impute_parent in CJ data

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/newpp_sim1.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID} 1" < profiling/1.simulation/1.B.1_phase_parent_sim.R',
             arrayjobs="1-100",
             wd=NULL, jobid="pp_r1", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/newpp_sim1.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents
set_arrayjob(shid="largedata/scripts/newpp_sim2.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID} 0.5" < profiling/1.simulation/1.B.1_phase_parent_sim.R',
             arrayjobs="1-100",
             wd=NULL, jobid="pp_r2", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/newpp_sim2.sh

#$SLURM_ARRAY_TASK_ID $SLURM_JOB_ID
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
# run array job of impute_parents: imputed with only phased outcrossed parents
set_arrayjob(shid="largedata/scripts/newpp_sim3.sh",
             shcode='R --no-save "--args ${SLURM_ARRAY_TASK_ID} 0" < profiling/1.simulation/1.B.1_phase_parent_sim.R',
             arrayjobs="1-100",
             wd=NULL, jobid="pp_r3", email="yangjl0930@gmail.com")

###>>> In this path: cd /home/jolyang/Documents/Github/phasing
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemm largedata/scripts/newpp_sim3.sh
