#Udated code by Jyoti Lama 02/13/25
import os
import sys
import argparse
import numpy as np
import pandas as pd
import re
from collections import defaultdict
import json
import subprocess
import scipy
from collections import Counter
from io import StringIO
from scipy.stats import chi2_contingency
#Following pakages were added later
from pysnptools.snpreader import Bed
import gc
import glob
import time
from scipy.stats import fisher_exact

# Measure Memory Usage
#from memory_profiler import memory_usage

#Remove extractSNP
#First subset Regenie output

def ProcessRegenieFile(regenie_output):
  
  global list_annot_run
  
  #Following chunk of code will prune the regenie output file. It will seperate/subset the output from 4 different runs and select the Run you want.
  df_regenie=pd.read_csv(regenie_output, sep='\s+')
  
  #print("regenie summary statistics .tsv file from step9: \n")
  #print(df_regenie.head())
  
  #Extract GENE from the ID column of Regenie
  list_gene=[]
  for row in df_regenie.itertuples():
      tmp_row=getattr(row, 'ID')
      tmp_gene=tmp_row.split('.')[0]
      list_gene.append(tmp_gene)
  df_regenie['GENE']=list_gene
  
  condition_mask1 = df_regenie['ID'].str.contains('Mask1')
  condition_mask2 = df_regenie['ID'].str.contains('Mask2')
  condition_mask3 = df_regenie['ID'].str.contains('Mask3')
  condition_mask4 = df_regenie['ID'].str.contains('Mask4')
  condition_af01 = df_regenie['ID'].str.contains('0.01')
  #print(list_annot_run == "list_annot_run1") 
  
  if list_annot_run == "list_annot_run1":
      print('RUNNING run1')
      combined_condition_af01 = condition_mask1 & condition_af01
      df_regenie_Mask_af01 = df_regenie[combined_condition_af01]
      #list_annot_run=list_annot_run1
  
  elif list_annot_run == "list_annot_run2":
      print('RUNNING run2')
      combined_condition_af01 = condition_mask2 & condition_af01
      df_regenie_Mask_af01 = df_regenie[combined_condition_af01]
      #list_annot_run=list_annot_run2
  
  elif list_annot_run == "list_annot_run3":
      print('RUNNING run3')
      combined_condition_af01 = condition_mask3 & condition_af01
      df_regenie_Mask_af01 = df_regenie[combined_condition_af01]
      #list_annot_run=list_annot_run3
  
  elif list_annot_run == "list_annot_run4":
      print('RUNNING run4')
      combined_condition_af01 = condition_mask4 & condition_af01
      df_regenie_Mask_af01 = df_regenie[combined_condition_af01]
      #list_annot_run=list_annot_run4
  
  print("regenie summary statistics for selected Mask: \n")
  print(df_regenie_Mask_af01.head())
  return(df_regenie_Mask_af01)

def extractSNP_forGT(collapsed_df):
  
  '''
  extracting GENE and SNP for each functional consequence
  '''
  
  global list_annot_run
  global output_control, output_cases
  
  #list_annot_run = "list_annot_run1"
  collapsed_df.columns=['Uploaded_variation','SYMBOL', 'FunctionalCatagory']
  
  df_geneset_LoF1 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF1", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_LoF2 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF2", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_missense = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "missense", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_moderate = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "moderate", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_modifier = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "modifier", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_low = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "low", ['SYMBOL', 'Uploaded_variation']]
  df_geneset_synonymous = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "synonymous", ['SYMBOL', 'Uploaded_variation']]
     
  df_geneset_LoF1.columns=['GENE','SNP']
  df_geneset_LoF2.columns=['GENE','SNP']
  df_geneset_missense.columns=['GENE','SNP']
  df_geneset_moderate.columns=['GENE','SNP']
  df_geneset_modifier.columns=['GENE','SNP']
  df_geneset_low.columns=['GENE','SNP']
  df_geneset_synonymous.columns=['GENE','SNP']
  
  if list_annot_run == "list_annot_run1":
      Run_df=df_geneset_LoF1
      #print(len(Run_df))
      #LoF1 = pd.DataFrame(df_geneset_LoF1['SNP'].drop_duplicates(), columns=['SNP'])
      #print("LoF1 for run ", list_annot_run ,"\n", LoF1.head())
      
      #LoF1.to_csv("./step5_to_6/Run1.SNP.tsv", sep='\t', index=False, header=False)
      #extractSNP="./step5_to_6/Run1.SNP.tsv"
      
      output_control="./step5_to_6/tmp/output5.Run1.controls"
      output_cases="./step5_to_6/tmp/output5.Run1.cases"
      #del(LoF1)
      gc.collect()
      
  elif list_annot_run == "list_annot_run2":
 
      # Combine the dataframes
      df_combined = pd.concat([df_geneset_LoF1, df_geneset_LoF2, df_geneset_missense], ignore_index=True)
      Run_df=df_combined
      
      # Get unique SNP values
      #df_combined = pd.DataFrame(df_combined['SNP'].drop_duplicates(), columns=['SNP'])
      #print("Run2 for run ", list_annot_run ,"\n", df_combined.head())
      
      #df_combined.to_csv("./step5_to_6/Run2.SNP.tsv", sep='\t', index=False, header=False)
      #extractSNP="./step5_to_6/Run2.SNP.tsv"
      output_control="./step5_to_6/tmp/output5.Run2.controls"
      output_cases="./step5_to_6/tmp/output5.Run2.cases"
      
      del(df_combined)
      gc.collect()
      
  elif list_annot_run == "list_annot_run3":
     
      # Combine the dataframes
      df_combined = pd.concat([df_geneset_LoF1, df_geneset_LoF2, df_geneset_missense, df_geneset_moderate, df_geneset_modifier, df_geneset_low], ignore_index=True)
      Run_df=df_combined
      
      # Get unique SNP values
      #df_combined = pd.DataFrame(df_combined['SNP'].drop_duplicates(), columns=['SNP'])
      #print("Run3 for run ", list_annot_run ,"\n", df_combined.head())
      #df_combined.to_csv("./step5_to_6/Run3.SNP.tsv", sep='\t', index=False, header=False)
      #extractSNP="./step5_to_6/Run3.SNP.tsv"
      
      output_control="./step5_to_6/tmp/output5.Run3.controls"
      output_cases="./step5_to_6/tmp/output5.Run3.cases"
      del(df_combined)
      gc.collect()

  elif list_annot_run == "list_annot_run4":
      Run_df=df_geneset_synonymous
      #synonymous = pd.DataFrame(df_geneset_synonymous['SNP'].drop_duplicates(), columns=['SNP'])
      #synonymous.to_csv("./step5_to_6/Run4.SNP.tsv", sep='\t', index=False, header=False)
      #extractSNP="./step5_to_6/Run4.SNP.tsv"
      #print("Run4 for run ", list_annot_run ,"\n", synonymous.head())
      output_control="./step5_to_6/tmp/output5.Run4.controls"
      output_cases="./step5_to_6/tmp/output5.Run4.cases"
      
      #del(synonymous)
      gc.collect()
    
  del(df_geneset_LoF1, df_geneset_LoF2, df_geneset_missense, df_geneset_moderate, df_geneset_modifier, df_geneset_low,df_geneset_synonymous)
  return(Run_df)

def CountGT_from_bedFile(bed, prefix, chunk_size):
  print("size of bed file: ", bed.sid_count)
  # Process SNPs in chunks
  
  list_ID = []
  list_GT = []
  list_nonMiss = []
  list_individual = []
  
  for start in range(0, bed.sid_count, chunk_size):
    end = min(start + chunk_size, bed.sid_count)
    #print("max size of bed file: ", end)
      
    # Read the chunk of genotype data
    snp_data = bed[:, start:end].read()
    
    # Extract SNP names and genotype matrix
    snp_names = snp_data.sid  # SNP IDs
    
    
    sample_ids = snp_data.iid[:, 1]  # Individual IDs
    genotypes = snp_data.val  # Genotype matrix (0 = 0/0, 1 = 0/1, 2 = 1/1, NaN = missing)
   
    # Loop through each SNP and compute stats
    for i, snp in enumerate(snp_names):
      temp_GT = genotypes[:, i]  # Get all samples' genotypes for this SNP

      # Count minor allele incidences (0/0 and 0/1)
      if np.sum(temp_GT == 2) > np.sum(temp_GT == 0):
          minor_allele_count = np.sum((temp_GT == 0)*2 + (temp_GT == 1))
          # Get list of individuals carrying minor alleles
          individuals_with_minor_allele = sample_ids[(temp_GT == 0) | (temp_GT == 1)].tolist()       
      else:
          minor_allele_count = np.sum((temp_GT == 2)*2 + (temp_GT == 1))
          individuals_with_minor_allele = sample_ids[(temp_GT == 2) | (temp_GT == 1)].tolist()
      # Count non-missing genotypes (not NaN)
      non_missing_count = np.sum(~np.isnan(temp_GT))*2

      # Store results
      list_ID.append(snp)
      list_GT.append(minor_allele_count)
      list_nonMiss.append(non_missing_count)
      list_individual.append(individuals_with_minor_allele)
    
  # Debugging: Print first 5 values safely
  #print("SNP IDs:", list_ID[:5])
  #print("CountGT ", prefix,":", list_GT[:5])
  #print("Non-missing ", prefix,":", list_nonMiss[:5])
  #print("Individuals with minor allele ", prefix,":", list_individual[:5])
    
  # Create summary DataFrame
  summary_GT = pd.DataFrame({
      'SNP': list_ID,
      f'CountGT_{prefix}': list_GT,
      f'nonMiss_{prefix}': list_nonMiss,
      f'individual_{prefix}': list_individual
  })
  '''
  print(prefix, ": ")
  print(summary_GT.head())
  print("length of SNPs, list_ID:")
  print(len(list_ID))
  print("length of summary table: ")
  print(len(summary_GT))
  '''
  del(genotypes, snp_names, sample_ids, snp_data)
  gc.collect()
  return(summary_GT)

def CountGT(annot, Run_df, df_regenie_Mask_af01):
  '''
  Takes in plink bed file to count no. of functional consequences
  
  a) Extract the list of SNPs with specific annotations (annot) only for genes in Regenie output (final_SNPs_df)
  b) Subsets the plink bed file based on cases and controls using keep_control.tsv and keep_cases.tsv files 
  c) Extracts SNPs with specific functional consequences in bed file using final_SNPs_df
  d) Counts the no. of mutations/functional consequences using the subsetted bed file for cases and control sepeartely and concatenate the dataframe
  '''
  
  global Keep_control, Keep_cases, BedFile, plink, list_annot_run, output_cases, output_control
  
  print("annot: ",annot)
  out_step1='./step2/list_'+annot+".tsv" #list_missense.tsv
  print(out_step1)
  out_control= output_control + "_" + annot
  out_cases= output_cases + "_" + annot
  extract_SNP = output_control + "_" + annot + "_SNP.txt"
  
  Annot_list = pd.read_csv(out_step1, sep="\t", header=0)
  Annot_list.columns = ["SNP"]
  Annot_list = pd.merge(Run_df, Annot_list, on="SNP", how="inner") #SNP, GENE
  
  df_regenie_Mask_af01 = df_regenie_Mask_af01[['GENE']]
  final_SNPs_df = Annot_list[Annot_list['GENE'].isin(df_regenie_Mask_af01['GENE'])] #SNP, GENE
  final_SNPs_df = final_SNPs_df["SNP"] 
  print(f"No. of the SNPs to be extracted for {annot}: {len(final_SNPs_df)}")
  
  final_SNPs_df.to_csv(extract_SNP, sep='\t', index=False, header=False)
  
  os.system(f"{plink} --bfile {BedFile} --make-bed --keep {Keep_control} --extract {extract_SNP} --out {out_control}")
  os.system(f"{plink} --bfile {BedFile} --make-bed --keep {Keep_cases} --extract {extract_SNP} --out {out_cases}")
  
  #Process for cases first:
  
  # Load PLINK .bed file (Assumes .bim and .fam are present)
  bed_file = out_cases + ".bed"
  bed = Bed(bed_file, count_A1=True)
  chunk_size = 10000
  
  summary_GT_cases = CountGT_from_bedFile(bed, "cases", chunk_size)

  gc.collect()
  
  #Now process the control GT data:
  bed_file = out_control + ".bed"
  bed = Bed(bed_file, count_A1=True)
  chunk_size = 10000
  
  summary_GT_control = CountGT_from_bedFile(bed, "control", chunk_size)

  gc.collect()

  #Concatenate the cases and controls
  summary_GT_case_control=pd.merge(summary_GT_control,summary_GT_cases,on=['SNP'],how='inner')
  
  del(summary_GT_control, summary_GT_cases)
  gc.collect()
  
  #Remove the output_control and output_case
  # Get the list of files to delete
  files_to_delete = glob.glob(out_control + "*") + glob.glob(out_cases + "*") 
  #print(files_to_delete)
  # Loop through each file and delete if it exists
  for file_path in files_to_delete:
      if os.path.exists(file_path):
          os.remove(file_path)
          print(f"{file_path} has been deleted.")
      else:
          print(f"{file_path} does not exist.")
          
  return(summary_GT_case_control)


def ProcessGTcounts(summary_GT_case_control, Run_df, df_regenie_Mask_af01, annot):
  
  '''
  Merges the genotype data (summary_GT_case_control) and the genes in the regenie summary statistics.  
  Sums all the SNPs accross each gene.
  '''
  
  summary_GT_case_control["SNP"] = summary_GT_case_control["SNP"].astype(str)
  Run_df["SNP"] = Run_df["SNP"].astype(str)
  
  summary_GT_case_control = summary_GT_case_control.merge(
      Run_df,  
      on="SNP", 
      how="inner")
      
  
  #Only keep genes from Regenie output
  summary_GT_case_control = summary_GT_case_control.merge(
      df_regenie_Mask_af01[['GENE']],  # Drop the column during the merge
      left_on="GENE", 
      right_on="GENE", 
      how="inner"
  )
  
  #print("summary_GT_case_control regenie filtered:\n")
  #print(summary_GT_case_control.head())

  #Collapse the deteterious SNPs within the Genes and count the no. of mutations 
  summary_GT_case_control_subset = summary_GT_case_control.groupby('GENE').agg({
      'SNP': lambda x: ', '.join(x),            # Concatenate SNP values
      'individual_control': 'sum', # Concatenate sample1 values
      'individual_cases': 'sum',  # Concatenate sample values
     'CountGT_control': 'sum',                 # Sum count1
      'CountGT_cases': 'sum',                   # Sum count2
      'nonMiss_control': 'sum',                 # Sum count3
      'nonMiss_cases': 'sum'                    # Sum count4
  }).reset_index()
  
  del(summary_GT_case_control)
  gc.collect()
  
  #print("summary_GT_case_control_subset after collapsing: \n")
  #print(summary_GT_case_control_subset.head())

  #Count no. of individuals
  summary_GT_case_control_subset['individual_control_count'] = summary_GT_case_control_subset['individual_control'].apply(lambda x: len(set(x)))
  summary_GT_case_control_subset['individual_cases_count'] = summary_GT_case_control_subset['individual_cases'].apply(lambda x: len(set(x)))
  
  summary_GT_case_control_subset.rename(columns={
    'individual_control': f'individual_control_{annot}',
    'individual_cases': f'individual_cases_{annot}',
    'CountGT_control': f'CountGT_control_{annot}',
    'CountGT_cases': f'CountGT_cases_{annot}',
    'nonMiss_control': f'nonMiss_control_{annot}',
    'nonMiss_cases': f'nonMiss_cases_{annot}',
    'individual_control_count': f'individual_control_count_{annot}',
    'individual_cases_count': f'individual_cases_count_{annot}'

    }, inplace=True)
    
  summary_GT_case_control_subset = summary_GT_case_control_subset.drop(columns=['SNP', f'individual_cases_{annot}', f'individual_control_{annot}'])
  
  #print("summary_GT_case_control_subset final: \n")
  #print(summary_GT_case_control_subset.head())
  return(summary_GT_case_control_subset)

def OddsRatio_ChiSquare(summary_GT_case_control_subset):
  global outputName, list_annot_run
  
  #Calculate the total no. mutations by summing up across multiple functional categories for that Run
  
  prefix_control_GT='CountGT_control_'
  prefix_case_GT='CountGT_cases_'
  prefix_control_nonMiss='nonMiss_control_'
  prefix_case_nonMiss='nonMiss_cases_'
  
  output_step2_control_GT=summary_GT_case_control_subset.filter(like=prefix_control_GT, axis=1)
  output_step2_case_GT=summary_GT_case_control_subset.filter(like=prefix_case_GT, axis=1)
  output_step2_control_nonMiss=summary_GT_case_control_subset.filter(like=prefix_control_nonMiss, axis=1)
  output_step2_case_nonMiss=summary_GT_case_control_subset.filter(like=prefix_case_nonMiss, axis=1)

  summary_GT_case_control_subset['CountGT_control_All']=output_step2_control_GT.sum(axis=1, skipna=True)
  summary_GT_case_control_subset['CountGT_case_All']=output_step2_case_GT.sum(axis=1, skipna=True)
  summary_GT_case_control_subset['CountGT_control_nonMiss']=output_step2_control_nonMiss.sum(axis=1, skipna=True)
  summary_GT_case_control_subset['CountGT_case_nonMiss']=output_step2_case_nonMiss.sum(axis=1, skipna=True)
  
  del(output_step2_control_GT, output_step2_case_GT, output_step2_control_nonMiss, output_step2_case_nonMiss)
  gc.collect()
  
  #Calculate odds ratio and Chi-squares
  summary_GT_case_control_subset['Odds_Ratio']=((summary_GT_case_control_subset['CountGT_case_All']+1)*(summary_GT_case_control_subset['CountGT_control_nonMiss']-summary_GT_case_control_subset['CountGT_control_All']+1))/((summary_GT_case_control_subset['CountGT_control_All']+1)*(summary_GT_case_control_subset['CountGT_case_nonMiss']-summary_GT_case_control_subset['CountGT_case_All']+1))
  
  array_chisquare=summary_GT_case_control_subset.loc[:,['CountGT_case_All','CountGT_case_nonMiss','CountGT_control_All','CountGT_control_nonMiss']]
  array_chisquare['CountGT_case_All_other']=array_chisquare['CountGT_case_nonMiss']-array_chisquare['CountGT_case_All']
  array_chisquare['CountGT_control_All_other']=array_chisquare['CountGT_control_nonMiss']-array_chisquare['CountGT_control_All']
  contingency_table=array_chisquare.loc[:,['CountGT_case_All','CountGT_case_All_other','CountGT_control_All','CountGT_control_All_other']]
  
  print(array_chisquare[['CountGT_case_All', 'CountGT_case_All_other', 'CountGT_control_All', 'CountGT_control_All_other']].min())
   
  print("contingency table: \n")
  print(contingency_table.head())
  
  '''
  def chi_square_test(row):
     obs = [[row['CountGT_case_All'], row['CountGT_case_All_other']],
            [row['CountGT_control_All'], row['CountGT_control_All_other']]]
     chi2, p, dof, ex = chi2_contingency(obs)
     return p
  
  p=contingency_table.apply(chi_square_test, axis=1)
  '''

  def chi_square_or_fisher(row):
      obs = [[row['CountGT_case_All'], row['CountGT_case_All_other']],
             [row['CountGT_control_All'], row['CountGT_control_All_other']]]
  
      # Convert to NumPy array
      obs = np.array(obs)
  
      # If any expected frequency is <=5, use Fisher's exact test
      if np.any(obs == 0) or np.any(obs < 5):
          _, p = fisher_exact(obs)
          #print("using fisher exact test instead of chisquare due to low sample size")
      else:
          chi2, p, dof, ex = chi2_contingency(obs)
  
      return p
  p = contingency_table.apply(chi_square_or_fisher, axis=1)
  summary_GT_case_control_subset['P_Chi-Square']=p
  #summary_GT_case_control_subset.rename(columns={'GENE': 'SYMBOL'}, inplace=True)
  #summary_GT_case_control_subset.rename(columns={'SNP': 'GENE'}, inplace=True)
  out='./step5_to_6'
  Dir=os.path.join(out, outputName + ".tsv")
  #Dir=os.path.join(args.output_path, args.output_name + ".tsv")
  print("outputs are saved to: ",Dir)
  summary_GT_case_control_subset.to_csv(Dir, sep='\t', index=None)
  return

def main():
  global list_annot_run, Keep_control, Keep_cases, BedFile, plink, outputName

  #Set up argument parser
  parser = argparse.ArgumentParser(description="Extract GT for each Run")
  
  # Add arguments
  #parser.add_argument('--annotatedVCF', required=True, help="Path to the annotated VCF file")
  parser.add_argument('--regenie_output', required=True, help="Path to the Regenie output file")
  parser.add_argument('--output_path', required=True, help="Directory path where output files will be saved")
  parser.add_argument('--output_name', required=True, help="Name for the output files")
  parser.add_argument('--list_annot_run', required=True, help="Name of the annotation run out of four runs: list_annot_run1, list_annot_run2, list_annot_run3 or list_annot_run4")

  # Parse the arguments
  args = parser.parse_args()
  
  # Function to set the working directory
  def set_working_directory(user_defined_dir):
      try:
          # Change the current working directory to the user-defined directory
          os.chdir(user_defined_dir)
          print(f"Working directory changed to: {os.getcwd()}")
      except Exception as e:
          print(f"Error: {e}")
          
  # Set the working directory
  set_working_directory(args.output_path)
  
  # Ensure output directory exists
  if not os.path.exists(args.output_path):
      print("args.output_path :  your output Path does not exists")
      
  # Ensure output directory exists
  if not os.path.exists("./step5_to_6/tmp"):
      os.makedirs("./step5_to_6/tmp", exist_ok=True)
  
  #Input files

  list_annot_run=args.list_annot_run
  regenie_output=args.regenie_output
  Keep_control="./step1/keep.controls.tsv"
  Keep_cases="./step1/keep.cases.tsv"
  BedFile="./step1/output5" #path to your QC'd bed file with rare variants (the same one used in regenie test in step 7)
  outputName=args.output_name
  #plink='/modules/EasyBuild/software/PLINK/1.9b-6.10/plink'
  #plink='/modules/ogi-mbc/software/plink3/alpha3/bin/plink3'
  plink='/modules/ogi-mbc/software/plink2/alpha5.11/bin/plink2'
  collapsed="./step2/study_annot.tsv"
  list_annot_directory='./step2/' #list_LOF1.tsv, list_LOF2.tsv ...so on
  suffix='.tsv'
  
  if list_annot_run=="list_annot_run1":
    run=['LoF1']
  elif list_annot_run=="list_annot_run2":
    run=['LoF1','LoF2','missense']
  elif list_annot_run=="list_annot_run3":
    run=['LoF1','LoF2','missense','moderate','modifier','low']
  elif list_annot_run=="list_annot_run4":
    run=['synonymous']
  
  print(list_annot_run)
  print(args.output_name)
  #Processing the Regenie and bed files ...
  collapsed_df=pd.read_csv(collapsed, sep='\t', header=None)
  
  df_regenie_Mask_af01 = ProcessRegenieFile(regenie_output)
  Run_df = extractSNP_forGT(collapsed_df)
  del(collapsed_df)
  gc.collect()
  
  dicts = {}  # Dictionary to store DataFrames
  
  for annot in run:
    print("annot: ", annot)
    summary_GT_case_control = CountGT(annot, Run_df, df_regenie_Mask_af01)
    dicts[f'summary_GT_case_control_subset_{annot}'] = ProcessGTcounts(summary_GT_case_control, Run_df, df_regenie_Mask_af01, annot)
  
  # Get the first DataFrame from the dictionary
  merged_df = list(dicts.values())[0]

  # Loop through the rest of the DataFrames and merge them by 'GENE'
  for df in list(dicts.values())[1:]:  # Skip the first one since it's already in merged_df
    merged_df = pd.merge(merged_df, df, on='GENE', how='outer')
  #print("merged dataset:\n")  
  #print(merged_df.head())

  del(Run_df, df_regenie_Mask_af01, dicts)
  gc.collect()
  
  OddsRatio_ChiSquare(merged_df) 

if __name__ == "__main__":
    #start_time = time.time()
    #mem_usage = memory_usage(main, interval=1)  # Profile memory for main()
    #print(f"Memory Usage: {max(mem_usage)} MB") 
    main()
    #end_time = time.time()
    #print(f"Execution Time: {end_time - start_time:.4f} seconds")
