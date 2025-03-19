#!/bin/bash
#SBATCH --job-name=step5_to_6   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=1G --nodes=1              # Job memory request
#SBATCH --output=Step5_to_6_%j.log   # Standard output and error log
#SBATCH --partition=medium,long,short

#For step5 your regenie file should be in the step4 folder inside your workdir (./step4/)

export RegeniefileName=$1 #Change to your Regenie file name
export outputDir=$2

mkdir -p "${outputDir}/step5_to_6"

echo -e "running step5 ..."

python step5.py --regenie ${RegeniefileName} --outDir ${outputDir}

echo -e "running step6..."
#Enter --vcf path_to_your_annotated_vcf 

./slurm.step6.sh --RegeniefileName ${RegeniefileName} --outputDir ${outputDir}