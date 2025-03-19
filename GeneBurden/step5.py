import os
import sys
import pandas as pd
import numpy as np
import csv
import argparse
import matplotlib.pyplot as plt

#Set up argument parser
parser = argparse.ArgumentParser(description="Process output of Regenie")
parser.add_argument('--regenie', required=True, help="Path to the regenie output file")
parser.add_argument('--outDir', required=True, help="Path to current work directory")
# Parse the arguments
args = parser.parse_args()

outDir=args.outDir

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

# Ensure output directory exists
if not os.path.exists(outDir):
    print("args.output_path :  your output Path does not exists")

DIR1='./step4/'
DIR2='./step5_to_6/'

# Ensure output directory exists
if not os.path.exists(DIR2):
    os.makedirs(DIR2, exist_ok=True)

if "regenie" in args.regenie:
    regenie = os.path.join(DIR1, args.regenie)
else:
    regenie = os.path.join(DIR1, args.regenie + ".regenie")
    
out= os.path.join(DIR2, args.regenie + ".tsv")

print("your input: ", regenie, "\n")
print("your output: ", out, "\n")

# Open the input CSV file and output CSV file
with open(regenie, 'r') as input_file, open(out, 'w', newline='') as output_file:
    # Create CSV reader and writer objects
    csv_reader = csv.reader(input_file)
    csv_writer = csv.writer(output_file)
    
    # Skip the first row
    next(csv_reader)  # Skip the header row
    
    # Write the remaining rows to the output file
    for row in csv_reader:
        csv_writer.writerow(row)
  
list_gene=[]
df_regenie=pd.read_csv(out, sep='\s+')
for row in df_regenie.itertuples():
    tmp_row=getattr(row, 'ID')
    tmp_gene=tmp_row.split('.')[0]
    list_gene.append(tmp_gene)
df_regenie['GENE']=list_gene
df_regenie['P']=10 ** (df_regenie['LOG10P']*(-1))
print('regenie summary statistics dataframe .. /n')
print(df_regenie)

condition_mask1 = df_regenie['ID'].str.contains('Mask1')
condition_mask2 = df_regenie['ID'].str.contains('Mask2')
condition_mask3 = df_regenie['ID'].str.contains('Mask3')
condition_mask4 = df_regenie['ID'].str.contains('Mask4')
condition_af01 = df_regenie['ID'].str.contains('0.01')

#Mask1
combined_condition_1 = condition_mask1 & condition_af01
df_regenie_Mask1 = df_regenie[combined_condition_1]
sorted_df_regenie_Mask1 = df_regenie_Mask1.sort_values(by='LOG10P', ascending=False)
print("Mask1 /n")
print(sorted_df_regenie_Mask1)

#Mask2
combined_condition_2 = condition_mask2 & condition_af01
df_regenie_Mask2 = df_regenie[combined_condition_2]
sorted_df_regenie_Mask2 = df_regenie_Mask2.sort_values(by='LOG10P', ascending=False)
print("Mask2 /n")
print(sorted_df_regenie_Mask2)

#Mask3
combined_condition_3 = condition_mask3 & condition_af01
df_regenie_Mask3 = df_regenie[combined_condition_3]
sorted_df_regenie_Mask3 = df_regenie_Mask3.sort_values(by='LOG10P', ascending=False)
print("Mask3 /n")
print(sorted_df_regenie_Mask3)

#Mask4&singleton
combined_condition_4 = condition_mask4 & condition_af01
df_regenie_Mask4 = df_regenie[combined_condition_4]
sorted_df_regenie_Mask4 = df_regenie_Mask4.sort_values(by='LOG10P', ascending=False)
print("Mask4 /n")
print(sorted_df_regenie_Mask4)

for i in range(1, 5):
    print(f"Outputting Regenie table for run {i} to ./step5_to_6/Regenie_Run{i}.tsv")

sorted_df_regenie_Mask1.to_csv('./step5_to_6/Regenie_Run1.tsv', index=None, sep='\t')
sorted_df_regenie_Mask2.to_csv('./step5_to_6/Regenie_Run2.tsv', index=None, sep='\t')
sorted_df_regenie_Mask3.to_csv('./step5_to_6/Regenie_Run3.tsv', index=None, sep='\t')
sorted_df_regenie_Mask4.to_csv('./step5_to_6/Regenie_Run4.tsv', index=None, sep='\t')

