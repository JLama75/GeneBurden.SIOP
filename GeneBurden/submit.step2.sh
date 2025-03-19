#!/bin/sh
#SBATCH --job-name=step2    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=1G --nodes=1               # Job memory request
#SBATCH --output=Step2_to_4_%j.log   # Standard output and error log
#SBATCH --partition=medium

#step2.py expects your annotated file in step1 folder in your working directory.
#The output files will be stored in step2 folder in your working directory

export AnnotatedVCF=$1
export outDir=$2

#mkdir -p ./step2
python step2.py "${AnnotatedVCF}" "${outDir}"
