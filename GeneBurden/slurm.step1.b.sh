#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
InputFile="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325/vep/"
module load plink2/alpha5.11

for phenotype in Responder QT ExResponder; do
  for cohort in FAME MEE; do
    for population in All EUR; do
    
    echo for "${cohort}.${population}.${phenotype}"
    outputFileName="${cohort}.${phenotype}.${population}.vcf"
    Filename="${cohort}.${phenotype}.${population}.output5.vcf"
    
    if [[ "${phenotype}" == "QT" ]]; then
      DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/${cohort}.${population}"
      DIR_SKATO="${CurrDir}/${phenotype}/SKATO/${cohort}.${population}"
      
      echo for QT Regular
      #set -u  # Exit if any variable is unset
      bedFile="${DIR_Regular}/step1/output4"
      #plink2 --bfile "${bedFile}" --export vcf-4.2  id-paste=iid --out "${bedFile}"
      
      bedFile2="${DIR_SKATO}/step1/output4"
      #plink2 --bfile "${bedFile2}" --export vcf-4.2  id-paste=iid --out "${bedFile2}"

      sbatch vep.annot.step.1.b.sh "${DIR_Regular}/step1/${outputFileName}" "${InputFile}${Filename}"     
      echo sbatch vep.annot.step.1.b.sh "${DIR_Regular}/step1/${outputFileName}" "${InputFile}${Filename}"
      echo "\n"
      
      echo for QT SKATO
      sbatch vep.annot.step.1.b.sh "${DIR_SKATO}/step1/${outputFileName}" "${InputFile}${Filename}"     
      echo sbatch vep.annot.step.1.b.sh "${DIR_SKATO}/step1/${outputFileName}" "${InputFile}${Filename}"
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
      DIR_ALL="${CurrDir}/${phenotype}/${cohort}.${population}"
      
      bedFile="${DIR_ALL}/step1/output4"
      #plink2 --bfile "${bedFile}" --export vcf-4.2  id-paste=iid --out "${bedFile}"

      sbatch vep.annot.step.1.b.sh "${DIR_ALL}/step1/${outputFileName}" "${InputFile}${Filename}"     
      echo sbatch vep.annot.step.1.b.sh "${DIR_ALL}/step1/${outputFileName}" "${InputFile}${Filename}"
      echo "\n"
    fi
    
    
    done

  done

done

