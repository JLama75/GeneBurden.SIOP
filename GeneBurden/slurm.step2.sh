#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    AnnotatedVCF="${cohort}.${phenotype}.${population}.vcf"
    
    if [[ "${phenotype}" == "QT" ]]; then
      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      #set -u  # Exit if any variable is unset

      sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_Regular}"     
      echo sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_Regular}"
      echo "\n"
      
      echo for QT SKATO
      sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_SKATO}"     
      echo sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_SKATO}"
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      
      sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_ALL}"     
      echo sbatch submit.step2.sh "${AnnotatedVCF}" "${DIR_ALL}"
      echo "\n"
    fi
    
    
    done

  done

done

