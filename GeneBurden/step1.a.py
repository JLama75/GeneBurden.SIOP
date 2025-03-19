#Udated code by Jyoti Lama 03/12/25
import os
import sys
import argparse
import numpy as np
import pandas as pd
import subprocess

import time
# Measure Memory Usage
from memory_profiler import memory_usage

plink3='/modules/ogi-mbc/software/plink3/alpha3/bin/plink3'
plink2='/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2'
plink='/modules/EasyBuild/software/PLINK/1.9b-6.10/plink'

#Set up argument parser
parser = argparse.ArgumentParser(description="Prepare files for Gene-burden test")

# Add arguments
parser.add_argument('--vcf', required=True, help="Path to the post-VariantQC VCF file")
parser.add_argument('--keep', required=False, help="list of samples to keep")
parser.add_argument('--missingness', type=float, default=0.02, help="specify your missingness threshold, default is 0.02")
parser.add_argument('--phenoFile', required=True, help="path to phenotype file with cases and controls")
parser.add_argument('--maf', type=float, default=0.01, help="specify the maf threshold, default is 0.01")
parser.add_argument('--exome_interval', required=False, help="path to the bed file with regions of genome targeted by exome sequencing capture kit in bed0 format")
parser.add_argument('--outDir', required=True, help="output path to save files")
parser.add_argument('--trait', required=True, help="phenotype name")


# Parse the arguments
args = parser.parse_args()

pheno=args.phenoFile
vcf=args.vcf
keep_samples=args.keep
missingness=args.missingness
maf=args.maf
outDir=args.outDir
trait=args.trait

print("maf value: ", maf)
print("missingness value: ", missingness)
#/data/Segre_Lab/users/yluo/resource/hg38_v0_exome_calling_regions.v1.interval_list.bed
#/data/Segre_Lab/data/Resources_from_Broad/hg38_v0_exome_calling_regions.v1.interval_list.bed
exome_target_region=args.exome_interval

# Function to set the working directory
def set_working_directory(user_defined_dir):
    try:
        # Change the current working directory to the user-defined directory
        os.chdir(user_defined_dir)
        print(f"Working directory changed to: {os.getcwd()}")
    except Exception as e:
        print(f"Error: {e}")
        
# Set the working directory
set_working_directory(outDir)


output_path = './step1/'

if not os.path.exists(output_path):
  # Create the directory
  os.makedirs(output_path)
  print(f"Directory {output_path} created.")
else:
  print(f"Directory {output_path} already exists.")


def ProcessVCF(pheno):
  
  global output_path

out0=os.path.join(output_path, "output0")
out1=os.path.join(output_path, "output1")
out2=os.path.join(output_path, "output2")
out3=os.path.join(output_path, "output3")
out4=os.path.join(output_path, "output4")
out5=os.path.join(output_path, "output5")

#Update sex for new version of plink2
#plink3 --bfile $OUT --update-sex ${PHENO} --make-bed --out $OUT"_2"
#--update-sex expects a file with FIDs and IIDs in the first two columns, and sex information (1 or M = male, 2 or F = female, 0 = missing) in the 3rd column. 
#column names: #FID IID SEX

if args.keep:
  os.system(f"/modules/ogi-mbc/software/plink3/alpha3/bin/plink3 --vcf {vcf} --keep {keep_samples} --not-chr MT --set-all-var-ids @:#:\$r:\$a --new-id-max-allele-len 2000 --double-id --make-bed --out {out0}")
else:
  os.system(f"/modules/ogi-mbc/software/plink3/alpha3/bin/plink3 --vcf {vcf} --not-chr MT --set-all-var-ids @:#:\$r:\$a --new-id-max-allele-len 2000 --double-id --make-bed --out {out0}")

if exome_target_region:
  os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2 --bfile {out0} --extract bed0 {exome_target_region} --make-bed --out {out1}")
else:
  os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2  --bfile {out0} --make-bed --out {out1}")

os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2  --bfile {out1} --missing --out {out1}")
os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2  --bfile {out1} --geno {missingness} --make-bed --out {out2}")

# Run wc -l and capture output
output_mono = subprocess.check_output("wc -l ./step1/output2.fam", shell=True, text=True)

# Extract the first number (line count)
N = int(output_mono.split()[0])  # Convert first part to an integer

print("computing monomorphic threshold based on the no. of samples in output2.fam")
monoThreshold = 1/(2*N)

print(f"No. of samples: {N}, Monomorphic Threshold: {monoThreshold}")

os.system(f"/modules/ogi-mbc/software/plink3/alpha3/bin/plink3 --bfile {out2} --maf {monoThreshold} --make-bed --out {out3}")

#output4 are the variant list showing maf < 1% in our dataset.
os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2 --bfile {out3} --max-maf {maf} --double-id --make-bed --out {out4}")
#os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2 --bfile {out4} --export vcf-4.2  id-paste=iid --out {out4}")
os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2 --bfile {out4} --maj-ref 'force' --double-id --make-bed --out {out5}") #This file will be used in the regenie step
os.system(f"/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2 --bfile {out5} --export vcf-4.2  id-paste=iid --out {out5}") #This file will be used in VEP annotation in the next step

#The following chunk of code will generate keep.control.tsv and keep.case.tsv, which will have IDs of individuals in control and cases respectively.
#These files will be used in step6 to generate the counts of rare variants in the summary table 
print("phenotype file: ",pheno)
df_phenotype=pd.read_csv(pheno, sep=' ')
print(df_phenotype)
df_phenotype=pd.read_csv(pheno, sep='\s')
print(df_phenotype)
df_phenotype = df_phenotype[['IID', trait]]
df_phenotype.columns=['IID','phenotype']
print("phenotype file... \n")
print(df_phenotype.head())

df_control=df_phenotype[df_phenotype['phenotype']==0]
df_control=df_control.loc[:,['IID']]
df_control['FID'] = df_control['IID']
print(len(df_control))

df_case=df_phenotype[df_phenotype['phenotype']==1]
df_case=df_case.loc[:,['IID']]
df_case['FID'] = df_case['IID']
print(len(df_case))

print("outputing the extracted GT for controls and cases: \n")
df_control.to_csv("./step1/keep.controls.tsv", sep='\t', index=False)
df_case.to_csv("./step1/keep.cases.tsv", sep='\t', index=False)

pass

start_time = time.time()

mem_usage = memory_usage((ProcessVCF, (pheno,)))
print(f"Memory Usage: {max(mem_usage)} MB")

end_time = time.time()
print(f"Execution Time: {end_time - start_time:.4f} seconds")

