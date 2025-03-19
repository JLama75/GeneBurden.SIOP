#!/bin/bash

RunMetal() {
  
    echo running metal function1
  
    trait="$1"
    fame="$2"
    mee="$3"
    Metal=$4
    output="$5"
    
    suffix="_merged_Count.tsv"
    suffix2=".tsv"
    
    for run in {1..4}; do
    
      # Create the trait variable for the current run
      trait_var="trait$run=\"${trait}Run${run}\""
      fame_var="fame$run=\"${fame}Run${run}${suffix}\""
      mee_var="mee$run=\"${mee}Run${run}${suffix}\""
      Metal_var="Metal$run=\"${Metal}Run${run}${suffix2}\""
      Run="Run${run}"
      
      # Output the variables
      echo $trait_var
      echo $fame_var
      echo $mee_var
      echo $Metal_var
      
      # Prepare the sbatch command for each run
      sbatch submit.ReplicationTopHits.sh "${trait}Run${run}" "${fame}Run${run}${suffix}" "${mee}Run${run}${suffix}" "${Metal}Run${run}${suffix2}" "$Run"
done

}

outDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/ReplicationAnalysis"
CurrDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1"

for phenotype in Responder QT ExResponder; do
    for population in All EUR; do
    output=${outDir}
    trait="${phenotype}.${population}_"
    
    if [[ "${phenotype}" == "QT" ]]; then
      echo For Regular QT
      
      trait=".${population}_${phenotype}_"
      fame="${CurrDir}/FAME.${phenotype}.${population}.Regular_"
      mee="${CurrDir}/MEE.${phenotype}.${population}.Regular_"
      Metal="${CurrDir}/Meta.${phenotype}.${population}.Regular_"
      trait="${phenotype}.${population}.Regular_"
  
      RunMetal "${trait}" "${fame}" "${mee}" "${Metal}" "${output}"
      
      echo for SKATO QT
      
      trait=".${population}_${phenotype}_"
      fame="${CurrDir}/FAME.${phenotype}.${population}.Regular.SKATO_"
      mee="${CurrDir}/MEE.${phenotype}.${population}.Regular.SKATO_"
      Metal="${CurrDir}/Meta.${phenotype}.${population}.Regular.SKATO_"
      trait="${phenotype}.${population}.Regular.SKATO_"
  
      RunMetal "${trait}" "${fame}" "${mee}" "${Metal}" "${output}"
    
    
    elif [[ "${phenotype}" == "Responder" || "${phenotype}" == "ExResponder" ]]; then
    
      trait=".${population}_${phenotype}_"
      fame="${CurrDir}/FAME.${phenotype}.${population}_"
      mee="${CurrDir}/MEE.${phenotype}.${population}_"
      Metal="${CurrDir}/Meta.${phenotype}.${population}_"
      trait="${phenotype}.${population}_"
  
      RunMetal "${trait}" "${fame}" "${mee}" "${Metal}" "${output}"
  
    
    fi
  done
done
    
  