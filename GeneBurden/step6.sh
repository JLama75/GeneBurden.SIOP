#!/bin/bash
#SBATCH --job-name=step9   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jlama@meei.harvard.edu     # Where to send mail    
#SBATCH --mem=1G --nodes=1              # Job memory request
#SBATCH --output=Step6.extractGT.count_101524_%j.log   # Standard output and error log
#SBATCH --partition=medium,long,short

#User should update the path to vcf and study name of regenie summary statistic

list_annot_run=$1 #list_annot_run=list_annot_run2 
out_name=$2 #Run2_Count, Run3_Count .. so on
export RegeniefileName=$3
output_path=$4

regenie_out='./step5_to_6/'${RegeniefileName}'.tsv'

echo $vcf
echo $regenie_out
echo running for $list_annot_run

python step6.py --regenie_output ${regenie_out} --output_path ${output_path} --output_name ${out_name} --list_annot_run ${list_annot_run}
