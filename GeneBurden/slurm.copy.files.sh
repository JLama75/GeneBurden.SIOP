#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
outDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325/vep/"

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    outputFileName="${cohort}.${phenotype}.${population}.output5.vcf"
    
    if [[ "${phenotype}" == "QT" ]]; then
      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      cp "${DIR_Regular}/step1/output5.vcf" "${outDir}${outputFileName}"
      echo for QT SKATO
      cp "${DIR_SKATO}/step1/output5.vcf" "${outDir}${outputFileName}"

    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      cp "${DIR_ALL}/step1/output5.vcf" "${outDir}${outputFileName}"
      echo "\n"
    fi
    
    done

  done

done

