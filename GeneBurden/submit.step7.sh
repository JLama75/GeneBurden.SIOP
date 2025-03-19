#!/bin/bash
#SBATCH --job-name=step7   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=1G --nodes=1              # Job memory request
#SBATCH --output=Step7_%j.log   # Standard output and error log
#SBATCH --partition=medium,long,short

#Note: the input for  step10 the output files from step9 should be in folder./step8_to_10.
echo -e "running step7..."

dir=$1
trait=$2

#dir='./step8_to_10'
#trait='MEE.Responder.ALL' #replace it with your_study_name

python step7.py --Dir "${dir}/step5_to_6" --traitName "${trait}" 
