#!/bin/bash
#SBATCH --job-name=Step1   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=2G --nodes=1              # Job memory request
#SBATCH --output=Step1_%j.log   # Standard output and error log
#SBATCH --partition=medium,long,short

your_vcf=$1
your_phenotype_file=$2
your_exome_target_bed0=$3
#bed file with regions of genome targeted by exome sequencing capture kit in bed 0 format'
IDs_to_keep=$4
outputDir=$5
trait=$6

python step1.a.py --vcf ${your_vcf} --phenoFile ${your_phenotype_file} \
                  --missingness 0.02 --maf 0.01 \
                  --exome_interval ${your_exome_target_bed0} --keep ${IDs_to_keep} --outDir ${outputDir} --trait ${trait}
                  
#--missingness and --maf are optional as the default is hardcoded in the code
#--exome_interval and --keep are optional if you don't want to filter off targets and subset samples.
#your_exome_target_bed0 should be in bed0 format. Change this in source code (step1.a.py) if your format is bed1.
