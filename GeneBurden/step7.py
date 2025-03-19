import os
import sys
import numpy as np
import pandas as pd
import argparse
from statsmodels.stats.multitest import multipletests
import xlsxwriter

#Set up argument parser
parser = argparse.ArgumentParser(description="Final data preparation for each Runs")

# Add arguments
parser.add_argument('--Dir', required=True, help="Path to the input folders")
parser.add_argument('--traitName', required=True, help="Name of the your trait/study")

# Parse the arguments
args = parser.parse_args()

Dir=args.Dir #./step8_to_10/
trait=args.traitName #FAME_Responder

print("Output Directory:", Dir)
print("For Study: ", trait )

# Function to set the working directory
def set_working_directory(user_defined_dir):
    try:
        # Change the current working directory to the user-defined directory
        os.chdir(user_defined_dir)
        print(f"Working directory changed to: {os.getcwd()}")
    except Exception as e:
        print(f"Error: {e}")
        
# Set the working directory
set_working_directory(Dir)

# Ensure output directory exists
if not os.path.exists(Dir):
    print(Dir," :  your output Path does not exists")

Count1=os.path.join(Dir, "Run1_Count.tsv")
Count2=os.path.join(Dir, "Run2_Count.tsv")
Count3=os.path.join(Dir, "Run3_Count.tsv")
Count4=os.path.join(Dir, "Run4_Count.tsv")

Regenie1=os.path.join(Dir, "Regenie_Run1.tsv")
Regenie2=os.path.join(Dir, "Regenie_Run2.tsv")
Regenie3=os.path.join(Dir, "Regenie_Run3.tsv")
Regenie4=os.path.join(Dir, "Regenie_Run4.tsv")


Out1=os.path.join(Dir, trait + "_Run1_merged_Count.tsv")
Out2=os.path.join(Dir, trait + "_Run2_merged_Count.tsv")
Out3=os.path.join(Dir, trait + "_Run3_merged_Count.tsv")
Out4=os.path.join(Dir, trait + "_Run4_merged_Count.tsv")

Dir2="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1/"

Out_1=os.path.join(Dir2, trait + "_Run1_merged_Count.tsv")
Out_2=os.path.join(Dir2, trait + "_Run2_merged_Count.tsv")
Out_3=os.path.join(Dir2, trait + "_Run3_merged_Count.tsv")
Out_4=os.path.join(Dir2, trait + "_Run4_merged_Count.tsv")

#SummaryOut=os.path.join(Dir2, trait + "_TopGenes_summary.tsv")

Output_1=os.path.join(Dir2, trait + "_Run1_sig.tsv")
Output_2=os.path.join(Dir2, trait + "_Run2_sig.tsv")
Output_3=os.path.join(Dir2, trait + "_Run3_sig.tsv")
Output_4=os.path.join(Dir2, trait + "_Run4_sig.tsv")

excelOut=os.path.join(Dir, trait + "_SummaryTable_allRuns.xlsx") #./step8_to_10/FAME_Responder_SummaryTable_allRuns.xlsx
logOut=os.path.join(Dir, trait + "_step7.log") #./step8_to_10/FAME_Responder_step10.log
logOut2=os.path.join(Dir2, "All_step7.log")

def calculate_FDR(df, p_value_column, new_column='FDR_BH_p_value'):
    """
    Applies the Benjamini-Hochberg FDR correction to a DataFrame's P column.

    Parameters:
    df (pd.DataFrame): The DataFrame containing the P-values.
    p_value_column (str): The name of the column containing the raw P-values.
    new_column (str): The name of the new column where FDR-corrected P-values will be stored.
                      Default is 'FDR_BH_p_value'.

    Returns:
    pd.DataFrame: The DataFrame with an additional column for FDR-corrected P-values.
    """
    # Perform Benjamini-Hochberg correction
    df[new_column] = multipletests(df[p_value_column], method='fdr_bh')[1]
    
    # Return the updated DataFrame
    return df
#from scipy import stats
#stats.false_discovery_control(ps)

def reorganize_columns(df):
    # Get the last three columns
    last_three_cols = df.columns[-3:]
    
    # Get all other columns except the last three
    other_cols = df.columns[:-3] #n
    
    # Ensure that the dataframe has at least 14 columns before reorganizing
    if len(other_cols) < 14:
        print("DataFrame has fewer than 14 columns, skipping reorganization.")
        return df
    
    # Insert the last three columns after the 14th column (index 13)
    cols_before_14th = other_cols[:14]
    cols_after_14th = other_cols[14:]
    
    # Combine columns in the desired order
    new_column_order = list(cols_before_14th) + list(last_three_cols) + list(cols_after_14th)
    
    # Reorganize DataFrame
    df_reorganized = df[new_column_order]
    
    return df_reorganized


df_run4_gb=pd.read_csv(Regenie4, sep='\t')
df_run4_gb=df_run4_gb[['GENE','P']]
df_run4_gb.columns=['GENE','P-value.Run4']
#print(df_run4_gb)

df_run1_gb=pd.read_csv(Regenie1, sep='\t')
df_run1_step2=pd.read_csv(Count1, sep='\t')
df_run1=pd.merge(df_run1_gb, df_run1_step2, left_on=['GENE'], right_on=['GENE'], how='inner')
df_run1=pd.merge(df_run1,df_run4_gb, on=['GENE'], how='left')
df_run1=calculate_FDR(df_run1, 'P')
df_run1.fillna('NA', inplace=True)
#print(df_run1)
print(f"Number of rows for run1: {df_run1.shape[0]}")
print(f"Number of cols for run1: {df_run1.shape[1]}")
# Open a log file in append mode (so it doesn't overwrite previous entries)

# Bonferroni Correction
BonferroniCutoff1 = 0.05 / df_run1.shape[0]
print("BonferroniCutoff: ", BonferroniCutoff1)
Run1_sig = df_run1[(df_run1['P'] <= BonferroniCutoff1) | (df_run1['FDR_BH_p_value'] <= 0.2)]
# Add BonferroniCutoff1 column
Run1_sig["BonferroniCutoff"] = BonferroniCutoff1
# Add BF_passed column
Run1_sig["BF_passed"] = Run1_sig["P"].apply(lambda x: "passed" if x <= BonferroniCutoff1 else "No")


df_run1['BonferroniCutoff'] = BonferroniCutoff1
df_run1 = reorganize_columns(df_run1)
df_run1.to_csv(Out1, index=None, sep='\t')
df_run1.to_csv(Out_1, index=None, sep='\t')
Run1_sig["trait"] = trait
Run1_sig.to_csv(Output_1, index=None, sep='\t')

########################################################
#RUN2

df_run2_gb=pd.read_csv(Regenie2, sep='\t')
df_run2_step2=pd.read_csv(Count2, sep='\t')
df_run2=pd.merge(df_run2_gb, df_run2_step2, left_on=['GENE'], right_on=['GENE'], how='inner')
df_run2=pd.merge(df_run2,df_run4_gb, on=['GENE'], how='left')
df_run2=calculate_FDR(df_run2, 'P')
df_run2.fillna('NA', inplace=True)
#print(df_run2)
print(f"Number of rows for run2: {df_run2.shape[0]}")
print(f"Number of cols for run2: {df_run2.shape[1]}")

# Bonferroni Correction
BonferroniCutoff2 = 0.05 / df_run2.shape[0]
print("BonferroniCutoff: ", BonferroniCutoff2)
Run2_sig = df_run2[(df_run2['P'] <= BonferroniCutoff2) | (df_run2['FDR_BH_p_value'] <= 0.2)]
# Add BonferroniCutoff1 column
Run2_sig["BonferroniCutoff"] = BonferroniCutoff2
# Add BF_passed column
Run2_sig["BF_passed"] = Run2_sig["P"].apply(lambda x: "passed" if x <= BonferroniCutoff2 else "No")


df_run2['BonferroniCutoff'] = BonferroniCutoff2
df_run2 = reorganize_columns(df_run2)
df_run2.to_csv(Out2, index=None, sep='\t')
df_run2.to_csv(Out_2, index=None, sep='\t')
Run2_sig["trait"] = trait
Run2_sig.to_csv(Output_2, index=None, sep='\t')
########################################################
#RUN3

df_run3_gb=pd.read_csv(Regenie3, sep='\t')
df_run3_step2=pd.read_csv(Count3, sep='\t')
df_run3=pd.merge(df_run3_gb, df_run3_step2, left_on=['GENE'], right_on=['GENE'], how='inner')
df_run3=pd.merge(df_run3,df_run4_gb, on=['GENE'], how='left')
df_run3=calculate_FDR(df_run3, 'P')
df_run3.fillna('NA', inplace=True)
#print(df_run3)
print(f"Number of rows for run3: {df_run3.shape[0]}")
print(f"Number of cols for run3: {df_run3.shape[1]}")


# Bonferroni Correction
BonferroniCutoff3 = 0.05 / df_run3.shape[0]
print("BonferroniCutoff: ", BonferroniCutoff3)
Run3_sig = df_run3[(df_run3['P'] <= BonferroniCutoff3) | (df_run3['FDR_BH_p_value'] <= 0.2)]
# Add BonferroniCutoff1 column
Run3_sig["BonferroniCutoff"] = BonferroniCutoff3
# Add BF_passed column
Run3_sig["BF_passed"] = Run3_sig["P"].apply(lambda x: "passed" if x <= BonferroniCutoff3 else "No")


df_run3['BonferroniCutoff'] = BonferroniCutoff3
df_run3 = reorganize_columns(df_run3)
df_run3.to_csv(Out3, index=None, sep='\t')
df_run3.to_csv(Out_3, index=None, sep='\t')
Run3_sig["trait"] = trait
Run3_sig.to_csv(Output_3, index=None, sep='\t')
################################################################################
#RUN 4

df_run4_gb_new=pd.read_csv(Regenie4, sep='\t')
df_run4_step2=pd.read_csv(Count4, sep='\t')
df_run4=pd.merge(df_run4_gb_new, df_run4_step2, left_on=['GENE'], right_on=['GENE'], how='inner')
df_run4=pd.merge(df_run4,df_run4_gb, on=['GENE'], how='left')
df_run4=calculate_FDR(df_run4, 'P')
df_run4.fillna('NA', inplace=True)

#print(df_run4)
print(f"Number of rows for run4: {df_run4.shape[0]}")
print(f"Number of cols for run4: {df_run4.shape[1]}")

# Bonferroni Correction
BonferroniCutoff4 = 0.05 / df_run4.shape[0]
print("BonferroniCutoff: ", BonferroniCutoff4)
Run4_sig = df_run4[(df_run4['P'] <= BonferroniCutoff4) | (df_run4['FDR_BH_p_value'] <= 0.2)]
# Add BonferroniCutoff1 column
Run4_sig["BonferroniCutoff"] = BonferroniCutoff4
# Add BF_passed column
Run4_sig["BF_passed"] = Run4_sig["P"].apply(lambda x: "passed" if x <= BonferroniCutoff4 else "No")


df_run4['BonferroniCutoff'] = BonferroniCutoff4
df_run4.to_csv(Out4, index=None, sep='\t')
df_run4.to_csv(Out_4, index=None, sep='\t')
Run4_sig["trait"] = trait
Run4_sig.to_csv(Output_4, index=None, sep='\t')


with pd.ExcelWriter(excelOut, engine='xlsxwriter') as writer:
    df_run1.to_excel(writer, sheet_name='Run1_merged_Count', index=False)
    df_run2.to_excel(writer, sheet_name='Run2_merged_Count', index=False)
    df_run3.to_excel(writer, sheet_name='Run3_merged_Count', index=False)
    df_run4.to_excel(writer, sheet_name='Run4_merged_Count', index=False)
    Run1_sig.to_excel(writer, sheet_name='Run1_significant', index=False)
    Run2_sig.to_excel(writer, sheet_name='Run2_significant', index=False)
    Run3_sig.to_excel(writer, sheet_name='Run3_significant', index=False)
    Run4_sig.to_excel(writer, sheet_name='Run4_significant', index=False)
  
    
with open(logOut2, 'a') as log_file2:
    # Log details for df_run1
    print("######################################################################################", file=log_file2)
    print(f"For study: ", trait, file=log_file2)
    print(f"Number of genes for run1: {df_run1.shape[0]}", file=log_file2)
    print(f"Number of bonferroni Cutoff for run1: {BonferroniCutoff1}", file=log_file2)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run1: {Run1_sig.shape[0]}", file=log_file2)
    
    # Log details for df_run2
    print(f"Number of genes for run2: {df_run2.shape[0]}", file=log_file2)
    print(f"Number of bonferroni Cutoff for run2: {BonferroniCutoff2}", file=log_file2)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run2: {Run2_sig.shape[0]}", file=log_file2)
    
    print(f"Number of genes for run3: {df_run3.shape[0]}", file=log_file2)
    print(f"Number of bonferroni Cutoff for run3: {BonferroniCutoff3}", file=log_file2)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run3: {Run3_sig.shape[0]}", file=log_file2)
    
    # Log details for df_run4
    print(f"Number of genes for run4: {df_run4.shape[0]}", file=log_file2)
    print(f"Number of bonferroni Cutoff for run4: {BonferroniCutoff4}", file=log_file2)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run4: {Run4_sig.shape[0]}", file=log_file2)

with open(logOut, 'a') as log_file:
    # Log details for df_run1
    print(f"Number of genes for run1: {df_run1.shape[0]}", file=log_file)
    print(f"Number of bonferroni Cutoff for run1: {BonferroniCutoff1}", file=log_file)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run1: {Run1_sig.shape[0]}", file=log_file)
    
    # Log details for df_run2
    print(f"Number of genes for run2: {df_run2.shape[0]}", file=log_file)
    print(f"Number of bonferroni Cutoff for run2: {BonferroniCutoff2}", file=log_file)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run2: {Run2_sig.shape[0]}", file=log_file)
    
    print(f"Number of genes for run3: {df_run3.shape[0]}", file=log_file)
    print(f"Number of bonferroni Cutoff for run3: {BonferroniCutoff3}", file=log_file)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run3: {Run3_sig.shape[0]}", file=log_file)
    
    # Log details for df_run4
    print(f"Number of genes for run4: {df_run4.shape[0]}", file=log_file)
    print(f"Number of bonferroni Cutoff for run4: {BonferroniCutoff4}", file=log_file)
    print(f"Number of significant genes (Bonferroni or FDR/Benjamini-Hochberg) for run4: {Run4_sig.shape[0]}", file=log_file)
