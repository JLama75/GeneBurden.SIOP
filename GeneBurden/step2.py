#Udated code by Jyoti Lama 02/11/25
import os
import sys
import json
import numpy as np
import pandas as pd
import re
from collections import defaultdict
import json
import subprocess
from collections import Counter
import gc
import time

# Measure Memory Usage
#from memory_profiler import memory_usage

annotationFile = sys.argv[1]
outDir = sys.argv[2]

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

file_bed = './step1/' + annotationFile
DIR = './step2/'
print(f"File name: {file_bed}")

if not os.path.exists(DIR):
    # Create the directory
    os.makedirs(DIR)
    print(f"Directory {DIR} created.")
else:
    print(f"Directory {DIR} already exists.")


#Define different categories
list_LoF1=['stop_gained','splice_acceptor_variant','splice_donor_variant','frameshift_variant','transcript_ablation']
list_LoF2=['stop_lost','start_lost','transcript_amplification','feature_elongation','feature_truncation']
list_missense=['missense_variant']
list_moderate=['inframe_insertion','inframe_deletion','protein_altering_variant']
list_modifier=['NMD_transcript_variant','3_prime_UTR_variant','5_prime_UTR_variant','TF_binding_site_variant','intergenic_variant','intron_variant','mature_miRNA_variant','non_coding_transcript_exon_variant','non_coding_transcript_variant','downstream_gene_variant','regulatory_region_variant','upstream_gene_variant','coding_sequence_variant','TFBS_ablation','TFBS_amplification','regulatory_region_ablation','regulatory_region_amplification','intergenic_variant','sequence_variant']
list_low=['splice_donor_5th_base_variant','splice_region_variant','splice_donor_region_variant','splice_polypyrimidine_tract_variant','incomplete_terminal_codon_variant']
list_synonymous=['synonymous_variant','start_retained_variant','stop_retained_variant']
dicts_annotation={'MANE':0,'LoF1':1,'LoF2':2,'missense':3,'moderate':4,'modifier':5,'low':6,'synonymous':7}

list_LoF1=['MANE_' + x for x in list_LoF1 if str(x)] + list_LoF1
list_LoF2=['MANE_' + x for x in list_LoF2 if str(x)] + list_LoF2
list_missense=['MANE_' + x for x in list_missense if str(x)] + list_missense
list_moderate=['MANE_' + x for x in list_moderate if str(x)] + list_moderate
list_modifier=['MANE_' + x for x in list_modifier if str(x)] + list_modifier
list_low=['MANE_' + x for x in list_low if str(x)] + list_low
list_synonymous=['MANE_' + x for x in list_synonymous if str(x)] + list_synonymous

#%load_ext memory_profiler
#%memit categorize_annotation()
#%memit processAnnotation()

# Categorize the consequence to pre-defined functional annotations

def categorize_annotation(consequence):
    element_annotations = consequence.split(',')  # Split if it's a comma-separated string
    tmp_deleterious = ''
    
    # Categorize based on predefined lists
    for element_annotation in element_annotations:
        if element_annotation in list_LoF1:
            element_annotation_category = 'LoF1'
        elif element_annotation in list_LoF2:
            element_annotation_category = 'LoF2'
        elif element_annotation in list_missense:
            element_annotation_category = 'missense'
        elif element_annotation in list_moderate:
            element_annotation_category = 'moderate'
        elif element_annotation in list_modifier:
            element_annotation_category = 'modifier'
        elif element_annotation in list_low:
            element_annotation_category = 'low'
        elif element_annotation in list_synonymous:
            element_annotation_category = 'synonymous'
        else:
            #print(element_annotation)
            continue
        # Compare and keep the one with the lowest value in dicts_annotation
        if tmp_deleterious == '':
            tmp_deleterious = element_annotation_category
        elif dicts_annotation[element_annotation_category] <= dicts_annotation[tmp_deleterious]:
            tmp_deleterious = element_annotation_category
            
    return tmp_deleterious
    
def extract_chr_pos(snp):
    first_entry = snp.split(',', 1)[0]  # Take only the first variant
    parts = first_entry.split(':')
    return parts[0], parts[1] if len(parts) > 1 else None

def studyAnnot_Set_File(collapsed_df):
    
    #Generate sudy_annot.tsv file for REGENIE
    #collapsed_df.columns = ['Symbol', 'SNP', 'Annotation']
    collapsed_df.columns = ['SNP','Symbol', 'Annotation']
    collapsed_df.to_csv('./step2/study_annot.tsv', index=None, sep='\t', header=None)
    
    #Generate study_set.tsv for REGENIE
    
    #Collapse all SNPs (separated by comma) with a common gene 
    df_combined = collapsed_df.groupby('Symbol')['SNP'].apply(','.join).reset_index()
    del(collapsed_df)
    gc.collect()
    #Extract chromosome and Position from the first SNP in a list of SNPs
    
    # Vectorized approach using pandas string methods
    df_combined[['CHR', 'POS']] = df_combined['SNP'].apply(lambda x: pd.Series(extract_chr_pos(x)))
    #df_combined[['CHR', 'POS']] = df_combined['SNP'].str.extract(r'([^:,]+):(\d+):')
    #df_combined[['CHR', 'POS']] = df_combined['SNP'].str.split(',', expand=True)[0].str.split(':', expand=True)[[0, 1]]
    gc.collect()
    df_combined=df_combined[['Symbol','CHR','POS','SNP']]
    df_combined.columns = ['Symbol','CHR','POS', 'SNP']
    #df_combined.to_csv('./step2/study_set.tsv', index=None, sep='\t', header=False)
    #Some SNPs in the list of SNPs might be from different chromosome so remove thoes rows.
    gc.collect()

    # Split the SNP column by commas, then split by ':' to extract the chromosomes
    df_combined['SNP_chrs'] = df_combined['SNP'].str.split(',').apply(lambda x: [s.split(':')[0] for s in x])
    print("df combined list:\n")
    print(df_combined.head())
    
    # Vectorized check if all SNP chromosomes match the 'CHR' column
    df_combined['match'] = df_combined['SNP_chrs'].apply(lambda chrs: all(chr == str(chrs[0]) for chr in chrs))
    # Separate matched and mismatched DataFrames using boolean indexing
    df_matched = df_combined[df_combined['match']]
    df_mismatched = df_combined[~df_combined['match']]

    # Print the unmatched rows
    print(df_mismatched.head())
    print("no. of rows that were removed due to SNPs from different chromosomes for the same gene: ",(len(df_mismatched)))
    
    del(df_combined, df_mismatched)
    gc.collect()
    
    df_matched=df_matched[['Symbol','CHR','POS','SNP']]
    print("saving the file study_set.tsv to ./step2/")
    df_matched.to_csv('./step2/study_set.tsv', index=None, sep='\t', header=False)

    pass


def processAnnotation(file_bed):
    
    global DIR
    
    data = []

    with open(file_bed) as vcf_in:
        for line in vcf_in:
            if line.startswith('#'):
                continue  # Skip header lines
            
            fields = line.rstrip().split('\t')  # Split by tab
            
            # Extract required columns
            uploaded_variation = fields[0]
            consequence = fields[6]
            tmp_Extra = fields[13]
            
            if 'SYMBOL=' in tmp_Extra:
                result=re.search('SYMBOL=(.*);SYMBOL_SOURCE', tmp_Extra)
                tmp_gene=result.group(1)
            elif 'SYMBOL=' not in tmp_Extra:
                continue
    
            # Extract MANE_SELECT
            if 'MANE_SELECT=' in tmp_Extra:
                #result=re.search('MANE_SELECT=(.*);TSL', tmp_Extra)
                result=re.search(r"MANE_SELECT=([^;]+)", tmp_Extra)
                mane_select=result.group(1)
            elif 'MANE_SELECT=' not in tmp_Extra:
                mane_select="-"
                
            if 'MANE_PLUS_CLINICAL=' in tmp_Extra:
                #result=re.search('MANE_PLUS_CLINICAL=(.*);CCDS', tmp_Extra)
                result=re.search(r"MANE_PLUS_CLINICAL=([^;]+)", tmp_Extra)
                mane_plus_clinical=result.group(1)
            elif 'MANE_PLUS_CLINICAL=' not in tmp_Extra:
                mane_plus_clinical="-"
            
            # Append extracted data to the list
            data.append([uploaded_variation, consequence, tmp_gene, mane_select, mane_plus_clinical])
    
    # Create a DataFrame
    df = pd.DataFrame(data, columns=['Uploaded_variation', 'Consequence', 'SYMBOL', 'MANE_SELECT', 'MANE_PLUS_CLINICAL'])

    #df = pd.read_csv(file_bed, sep='\t', comment='#')
    #df.columns=['Uploaded_variation', 'SYMBOL', 'Consequence', 'MANE_SELECT', 'MANE_PLUS_CLINICAL']
    
    print(len(df)) #3,822,153
    
    # Step 1: Create new_consequence column where the values will have 'MANE_' added in the beginning when 'MANE' column is not empty
    df.loc[(df['MANE_SELECT'] != '-') | (df['MANE_PLUS_CLINICAL'] != '-'), 'new_consequence'] = df['Consequence'].apply(
        lambda x: ','.join(['MANE_' + c for c in x.split(',')])
    )
    gc.collect()

    # Fill NaN values in new_consequence (for cases where condition is False)
    df['new_consequence'] = df['new_consequence'].fillna(df['Consequence'])
    # Step 2: Collapse values based on 'SNP' and 'Gene'
    collapsed_df = df.groupby(['Uploaded_variation', 'SYMBOL'])['new_consequence'].apply(lambda x: ','.join(set(x))).reset_index()
    
    del(df)
    gc.collect()

    # Remove everything that is not MANE_ when MANE_ is present in the 'new_consequence'
    collapsed_df['new_consequence'] = collapsed_df['new_consequence'].apply(
        lambda x: ','.join([item for item in x.split(',') if 'MANE_' in item]) if 'MANE_' in x else x
    )

    # Apply the categorize_annotation function to the 'Consequence' column and create a new column 'FunctionalCategory'
    collapsed_df['FunctionalCatagory'] = collapsed_df['new_consequence'].apply(categorize_annotation)
    
    list_LoF1 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF1", "Uploaded_variation"]
    list_LoF2 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF2", "Uploaded_variation"]
    list_missense = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "missense", "Uploaded_variation"]
    list_moderate = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "moderate", "Uploaded_variation"]
    list_modifier = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "modifier", "Uploaded_variation"]
    list_low = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "low", "Uploaded_variation"]
    list_synonymous = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "synonymous", "Uploaded_variation"]
    
    print("printing no. of rows of each list: ")


    list_LoF1=list_LoF1.drop_duplicates()
    list_LoF2=list_LoF2.drop_duplicates()
    list_missense=list_missense.drop_duplicates()
    list_moderate=list_moderate.drop_duplicates()
    list_modifier=list_modifier.drop_duplicates()
    list_low=list_low.drop_duplicates()
    list_synonymous=list_synonymous.drop_duplicates()
    
    print("LoF1: ",len(list_LoF1))
    print("LoF2: ",len(list_LoF2))
    print("missense: ",len(list_missense))#
    print("moderate: ",len(list_moderate))
    print("modifier: ",len(list_modifier))#
    print("low: ",len(list_low))
    print("synonymous: ",len(list_synonymous))# 
    
    LoF1 = os.path.join(DIR, "list_LoF1.tsv")
    LoF2 = os.path.join(DIR, "list_LoF2.tsv")
    missense = os.path.join(DIR, "list_missense.tsv")
    moderate = os.path.join(DIR, "list_moderate.tsv")
    modifier = os.path.join(DIR, "list_modifier.tsv")
    low = os.path.join(DIR, "list_low.tsv")
    synonymous = os.path.join(DIR, "list_synonymous.tsv")

    list_LoF1.to_csv(LoF1, index=None, sep='\t')
    list_LoF2.to_csv(LoF2, index=None, sep='\t')
    list_missense.to_csv(missense, index=None, sep='\t')
    list_moderate.to_csv(moderate, index=None, sep='\t')
    list_modifier.to_csv(modifier, index=None, sep='\t')
    list_low.to_csv(low, index=None, sep='\t')
    list_synonymous.to_csv(synonymous, index=None, sep='\t')
    
    del(list_LoF1, list_LoF2, list_missense, list_moderate, list_modifier, list_low, list_synonymous)
    gc.collect()
    
    '''
    df_LoF1 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF1", ['SYMBOL', 'Uploaded_variation']]
    df_LoF2 = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "LoF2", ['SYMBOL', 'Uploaded_variation']]
    df_missense = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "missense", ['SYMBOL', 'Uploaded_variation']]
    df_moderate = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "moderate", ['SYMBOL', 'Uploaded_variation']]
    df_modifier = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "modifier", ['SYMBOL', 'Uploaded_variation']]
    df_low = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "low", ['SYMBOL', 'Uploaded_variation']]
    '''
    #df_synonymous = collapsed_df.loc[collapsed_df['FunctionalCatagory'] == "synonymous", ['SYMBOL', 'Uploaded_variation']]
    
    '''
    df_LoF1=df_LoF1.drop_duplicates()
    df_LoF2=df_LoF2.drop_duplicates()
    df_missense=df_missense.drop_duplicates()
    df_moderate=df_moderate.drop_duplicates()
    df_modifier=df_modifier.drop_duplicates()
    df_low=df_low.drop_duplicates()
    '''
    
    #df_synonymous=df_synonymous.drop_duplicates()
    '''
    df_LoF1.to_csv('./step2/study_LoF1.SetID', sep='\t', header=False, index=None)
    df_LoF2.to_csv('./step2/study_LoF2.SetID', sep='\t', header=False, index=None)
    df_missense.to_csv('./step2/study_missense.SetID', sep='\t', header=False, index=None)
    df_moderate.to_csv('./step2/study_moderate.SetID', sep='\t', header=False, index=None)
    df_modifier.to_csv('./step2/study_modifier.SetID', sep='\t', header=False, index=None)
    df_low.to_csv('./step2/study_low.SetID', sep='\t', header=False, index=None)
    '''
    #df_synonymous.to_csv('./step2/study_synonymous.SetID', sep='\t', header=False, index=None)
    
    #del(df_LoF1, df_LoF2, df_missense, df_moderate, df_modifier, df_low, df_synonymous)

    #del(df_synonymous)
    gc.collect()
    
    collapsed_df = collapsed_df[["Uploaded_variation","SYMBOL", "FunctionalCatagory"]]
    
    studyAnnot_Set_File(collapsed_df)

    pass



#start_time = time.time()

#mem_usage = memory_usage((processAnnotation, (file_bed,)), interval=1)
#print(f"Memory Usage: {max(mem_usage)} MB")
processAnnotation(file_bed)
#end_time = time.time()
#print(f"Execution Time: {end_time - start_time:.4f} seconds")

