#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
#PhenoDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/phenotype"

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    trait="${cohort}.${phenotype}.${population}"

    #submitting seperate jobs based on phenotype
    
    if [[ "${phenotype}" == "QT" ]]; then

      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      trait="${trait}.Regular"
  
      sbatch submit.step7.sh "${DIR_Regular}" "${trait}" 
      echo sbatch submit.step7.sh "${DIR_Regular}" "${trait}" 
      echo "\n"
      
      echo for QT SKATO
      trait="${trait}.SKATO"
      sbatch submit.step7.sh "${DIR_SKATO}" "${trait}" 
      echo sbatch submit.step7.sh "${DIR_SKATO}" "${trait}"      
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      
      sbatch submit.step7.sh "${DIR_ALL}" "${trait}" 
      echo sbatch submit.step7.sh "${DIR_ALL}" "${trait}"      
      
      echo "\n"
    fi
    
    
    done

  done

done

