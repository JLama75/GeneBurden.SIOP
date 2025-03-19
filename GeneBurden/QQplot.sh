#!/bin/bash
#SBATCH --job-name=QQplot   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=1G --nodes=1              # Job memory request
#SBATCH --output=QQplot_%j.log   # Standard output and error log
#SBATCH --partition=medium,long,short

DIR=$1
trait=$2

echo running QQplot for ${trait}

Rscript --no-save QQplot.R --file1 ${DIR}"/${trait}_Run1_merged_Count.tsv" --file2 ${DIR}"/${trait}_Run2_merged_Count.tsv" --file3 ${DIR}"/${trait}_Run3_merged_Count.tsv" --file4 ${DIR}"/${trait}_Run4_merged_Count.tsv" --trait ${trait} --output ${DIR}
