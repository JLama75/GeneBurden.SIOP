#!/bin/bash
#SBATCH --job-name=WES.022525   # Job name #name_bfile_date
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jlama@meei.harvard.edu     # Where to send mail    
#SBATCH --mem=2G --nodes=1             # Job memory request
#SBATCH --output=WES.022525_%j.log   # Standard output and error log
#SBATCH --partition=short,medium,long

trait=$1
FAME=$2
MEE=$3
Metal=$4
Run=$5

Rscript --no-save TopGenes.R --First_gwas ${FAME} --Second_gwas ${MEE} --metal ${Metal} --trait ${trait} --Run ${Run}