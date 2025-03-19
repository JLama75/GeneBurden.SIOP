#!/bin/bash

CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325"
output="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_newPipeline_031325/Meta/MetalOutput"

for phenotype in Responder QT ExResponder; do
    for population in All EUR; do
    
    echo for "${population}.${phenotype}"
    trait="Meta.${phenotype}.${population}_"

    #submitting seperate jobs based on phenotype
    
    if [[ "${phenotype}" == "QT" ]]; then

      FAME_DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/FAME.${population}/step5_to_6/"
      MEE_DIR_Regular="${CurrDir}/${phenotype}/RegularBurden/MEE.${population}/step5_to_6/"
      
      
      FAME_DIR_SKATO="${CurrDir}/${phenotype}/SKATO/FAME.${population}/step5_to_6/"
      MEE_DIR_SKATO="${CurrDir}/${phenotype}/SKATO/MEE.${population}/step5_to_6/"
      
      echo for QT Regular
      trait="Meta.${phenotype}.${population}.Regular_"
  
      for run in {1..4}; do
        # Create the trait variable for the current run
        trait_var="trait$run=\"${trait}Run${run}\""
        fame_var="fame$run=\"${FAME_DIR_Regular}Regenie_Run${run}.tsv\""
        mee_var="mee$run=\"${MEE_DIR_Regular}Regenie_Run${run}.tsv\""
        
        # Output the variables
        echo $trait_var
        echo $fame_var
        echo $mee_var
        
        # Prepare the sbatch command for each run
        sbatch MetaAnalysis.sh "${trait}Run${run}" "${FAME_DIR_Regular}Regenie_Run${run}.tsv" "${MEE_DIR_Regular}Regenie_Run${run}.tsv" "$output"
      done
      
      echo "\n"
      
      echo for QT SKATO
      trait="Meta.${phenotype}.${population}.Regular.SKATO_"
      for run in {1..4}; do
        # Create the trait variable for the current run
        trait_var="trait$run=\"${trait}Run${run}\""
        fame_var="fame$run=\"${FAME_DIR_SKATO}Regenie_Run${run}.tsv\""
        mee_var="mee$run=\"${MEE_DIR_SKATO}Regenie_Run${run}.tsv\""
        
        # Output the variables
        echo $trait_var
        echo $fame_var
        echo $mee_var
        
        # Prepare the sbatch command for each run
        sbatch MetaAnalysis.sh "${trait}Run${run}" "${FAME_DIR_SKATO}Regenie_Run${run}.tsv" "${MEE_DIR_SKATO}Regenie_Run${run}.tsv" "$output"
      done
      
      echo "\n"
      
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then

      FAME_DIR_ALL="${CurrDir}/${phenotype}/FAME.${population}/step5_to_6/"
      MEE_DIR_ALL="${CurrDir}/${phenotype}/MEE.${population}/step5_to_6/"
      
      for run in {1..4}; do
        # Create the trait variable for the current run
        trait_var="trait$run=\"${trait}Run${run}\""
        fame_var="fame$run=\"${FAME_DIR_ALL}Regenie_Run${run}.tsv\""
        mee_var="mee$run=\"${MEE_DIR_ALL}Regenie_Run${run}.tsv\""
        
        # Output the variables
        echo $trait_var
        echo $fame_var
        echo $mee_var
        
        # Prepare the sbatch command for each run
        sbatch MetaAnalysis.sh "${trait}Run${run}" "${FAME_DIR_ALL}Regenie_Run${run}.tsv" "${MEE_DIR_ALL}Regenie_Run${run}.tsv" "$output"
      done
      
      echo "\n"
    fi
    
    
    done

done

