#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
Pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/phenotype"
KeepIDs="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/phenotype/keepIDs"

your_vcf="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/variantQC/SIOP.variant_qc.093024.filtered.vcf.bgz"
your_exome_target_bed0="/data/Segre_Lab/users/yluo/resource/hg38_v0_exome_calling_regions.v1.interval_list.bed"
#bed file with regions of genome targeted by exome sequencing capture kit in bed 0 format'

#.pheno.tsv
#_cov_pca_022525.csv
#.keepIDs.tsv 

#sbatch submit.step1.a.sh ${your_vcf} ${your_phenotype_file} ${your_exome_target_bed0} ${IDs_to_keep} ${outputDir}

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    your_phenotype_file="${Pheno}/${cohort}.${phenotype}.${population}.pheno.tsv"
    IDs_to_keep="${KeepIDs}/${cohort}.${phenotype}.${population}.keepIDs.tsv"
    if [[ "${phenotype}" == "Responder" || "${phenotype}" == "QT" ]]; then
      trait="responder"
    
    elif [[ "${phenotype}" == "ExResponder" ]]; then
      trait="Ex_responder"
    
    fi
    
    if [[ "${phenotype}" == "QT" ]]; then
      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      echo for QT Regular
      #set -u  # Exit if any variable is unset
      your_phenotype_file="${Pheno}/${cohort}.Responder.${population}.pheno.tsv"
      sbatch submit.step1.a.sh "${your_vcf}" "${your_phenotype_file}" "${your_exome_target_bed0}" "${IDs_to_keep}" "${DIR_Regular}" "${trait}"
      echo sbatch submit.step1.a.sh ${your_vcf} ${your_phenotype_file} ${your_exome_target_bed0} ${IDs_to_keep} ${DIR_Regular} ${trait}
      echo "\n"
      
      echo for QT SKATO
      sbatch submit.step1.a.sh "${your_vcf}" "${your_phenotype_file}" "${your_exome_target_bed0}" "${IDs_to_keep}" "${DIR_SKATO}" "${trait}"
      echo sbatch submit.step1.a.sh ${your_vcf} ${your_phenotype_file} ${your_exome_target_bed0} ${IDs_to_keep} ${DIR_SKATO} ${trait}
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      
      sbatch submit.step1.a.sh "${your_vcf}" "${your_phenotype_file}" "${your_exome_target_bed0}" "${IDs_to_keep}" "${DIR_ALL}" "${trait}"
      echo sbatch submit.step1.a.sh ${your_vcf} ${your_phenotype_file} ${your_exome_target_bed0} ${IDs_to_keep} ${DIR_ALL} ${trait}
      echo "\n"
    fi
    
    
    done

  done

done

#FAME.Responder.ALL and FAME.QT.ALL
#/data/Segre_Lab/users/jlama/WES_new.ALL_050824/Phenotype/FAME.Keep.removeExcludeFromAllanlaysis_sham_EAS.100724.tsv

