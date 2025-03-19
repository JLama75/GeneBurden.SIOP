#!/bin/sh
#SBATCH --job-name=annotation    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=50G --nodes=1               # Job memory request
#SBATCH --output=annotation.vcf_%j.log   # Standard output and error log
#SBATCH --partition=short,long,medium

#Make sure you activate VEP environment to run this code
#Give your output annotated file a file name such as GlaucomaStudy.annotated.txt 

#export outputFileName=$1
#export currDir=$2

export Input=$2
export OUT1=$1
#For large datasets you can subset your output4.vcf to only exclude the genotype information of samples
# You can do this by stitching the VCF header to the list of variants in the bim file to make a VCF 

#echo ${outputFileName}
#DIR1= "${currDir}/step1/output5.vcf"
#OUT1="${currDir}/step1/${outputFileName}"

#DIR1="/gpfs/fs1/data/Segre_Lab/users/jlama/WES_new.ALL_050824/trial/Unit_test/GeneBurden_with_Maj_ref_force/step1/output5.vcf"
#OUT1="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325/Responder/FAME.All/step1/file1.vcf"

echo $Input
echo $OUT1

#For large data-sets:
#vep --cache --dir_cache /data/genomes/VEP/VEP_110dot1/GRCh38/cache/ENSEMBL/ --input_file ${DIR1} --force_overwrite --output_file ${OUT1} --tab --mane --symbol --fields "Uploaded_variation,SYMBOL,Consequence,MANE_SELECT,MANE_PLUS_CLINICAL" --dir_plugins /data/genomes/VEP/VEP_110dot1/GRCh38/plugins/ --fasta /data/Segre_Lab/users/yluo/Liftover/data/GRCh38.p13.genome.fa --fork 8 
#vep --cache --dir_cache /data/genomes/VEP/VEP_110dot1/GRCh38/cache/ENSEMBL/ --input_file ${DIR1} --output_file ${OUT1} --force_overwrite --everything --offline --nearest symbol --mane --dir_plugins /data/genomes/VEP/VEP_110dot1/GRCh38/plugins/  --fasta /data/Segre_Lab/users/yluo/Liftover/data/GRCh38.p13.genome.fa --fork 10
vep --cache --dir_cache /data/genomes/VEP/VEP_110dot1/GRCh38/cache/ENSEMBL/ --input_file ${Input} --output_file ${OUT1} --force_overwrite --everything --offline --nearest symbol --mane --dir_plugins /data/genomes/VEP/VEP_110dot1/GRCh38/plugins/  --fasta /data/Segre_Lab/users/yluo/Liftover/data/GRCh38.p13.genome.fa --fork 8

