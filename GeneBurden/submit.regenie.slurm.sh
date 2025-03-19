#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
PhenoDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/phenotype"

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    build_mask="max"
    RegenieOutput="${cohort}.${phenotype}.${population}"
    study="${cohort}.${phenotype}.${population}"
    phenoFile="${PhenoDir}/${study}.pheno.tsv" #"./Your_pheno.csv" #add your phenotype file
    covarFile="${PhenoDir}/${study}.covariate.mod.tsv" #"./Your_covariate.csv" #add your covariate file
    
    #CovarList for each study
    if [[ "${cohort}" == "FAME" && "${population}" == "All" ]]; then
      covarList=Age,Sex,steroid.medication,hx.glaucoma,drops.during6m,PC{1:5},count_synonymous
    elif [[ "${cohort}" == "FAME" && "${population}" == "EUR" ]]; then
      covarList=Age,Sex,steroid.medication,hx.glaucoma,drops.during6m,PC{1:20},count_synonymous 
    elif [[ "${cohort}" == "MEE" && "${population}" == "All" ]]; then
      covarList=Age,Sex,steroid_indication,steroid_medication,hx.glaucoma_OH,drops.during6m,diabetes,PC{1:5},count_synonymous
    elif [[ "${cohort}" == "MEE" && "${population}" == "EUR" ]]; then
      covarList=Age,Sex,steroid_indication,steroid_medication,hx.glaucoma_OH,drops.during6m,diabetes,PC{1:10},count_synonymous
    fi
    
    #submitting seperate jobs based on phenotype
    
    if [[ "${phenotype}" == "QT" ]]; then
      phenotypeColumn="Max_IOPRise_RINT"
      trait="quantitative"
      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      test="regular"
      #set -u  # Exit if any variable is unset

      sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_Regular}" "max"
      echo sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_Regular}" "max"
      echo "\n"
      
      echo for QT SKATO
      test="skato"
      
      sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_SKATO}" "max"
      echo sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_SKATO}" "max"
      
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      trait="binary"
      test="regular"
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      if [[ "${phenotype}" == "Responder" ]]; then
        phenotypeColumn="responder"
      elif [[ "${phenotype}" == "ExResponder" ]]; then
        phenotypeColumn="Ex_responder"
      fi
      
      sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_ALL}" "max"
      echo sbatch regenie.4.sh "${RegenieOutput}" "${phenoFile}" "${covarFile}" "${phenotypeColumn}" "${covarList}" "${trait}" "${test}" "${DIR_ALL}" "max"

      echo "\n"
    fi
    
    
    done

  done

done

