#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
#PhenoDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/phenotype"

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    RegenieOutput="${cohort}.${phenotype}.${population}"

    #submitting seperate jobs based on phenotype
    
    if [[ "${phenotype}" == "QT" ]]; then

      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      RegenieOutput="${RegenieOutput}_Max_IOPRise_RINT"
  
      sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_Regular}"
      echo sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_Regular}"
      echo "\n"
      
      echo for QT SKATO
      test="skato"
      
      sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_SKATO}"
      echo sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_SKATO}"
      
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      if [[ "${phenotype}" == "Responder" ]]; then
        RegenieOutput="${RegenieOutput}_responder"
      elif [[ "${phenotype}" == "ExResponder" ]]; then
        RegenieOutput="${RegenieOutput}_Ex_responder"
      fi
      sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_ALL}"
      echo sbatch submit.step5_to_6.sh "${RegenieOutput}" "${DIR_ALL}"
      
      echo "\n"
    fi
    
    
    done

  done

done

