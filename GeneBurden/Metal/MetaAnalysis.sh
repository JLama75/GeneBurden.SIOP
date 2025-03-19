#!/bin/bash
#SBATCH --job-name=MetaAnalysis_102924    # Job name #name_bfile_date
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jlama@meei.harvard.edu     # Where to send mail    
#SBATCH --mem=2G --nodes=1             # Job memory request
#SBATCH --output=MetalAnalysis_102924_%j.log   # Standard output and error log
#SBATCH --partition=short,medium,long

trait=$1
file1=$2
file2=$3
out=$4

Rscript MetaAnalysis.R --file1 $file1 --file2 $file2 --trait $trait --outDir $out

