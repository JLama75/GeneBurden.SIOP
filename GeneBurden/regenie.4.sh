#!/bin/bash
#SBATCH --job-name=Regenie  # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mem=5G --nodes=1              # Job memory request
#SBATCH --output=regenie.studyName_%j.log   # Standard output and error log
#SBATCH --partition=short,long,medium

#module load regenie/2.0.1 #Recommend to install latest version regenie and use that instead
module load plink2/alpha5.11

############################### Input files     ###############################
RegenieOutput=$1 #Your output file name
phenoFile=$2 #"./Your_pheno.csv" #add your phenotype file
covarFile=$3 #"./Your_covariate.csv" #add your covariate file
phenotypeColumn=$4 #Column name of your phenotype 
covarList=$5 #Add your covariates column names. count_synonymous is mandatory. Following is an example.
#covarList=Age,Sex,steroid.medication,hx.glaucoma,drops.during6m,PC{1:10},count_synonymous
trait=$6 #binary or quantitative
test=$7 #regular or skato
outputPath=$8 #Your Working directory
build_mask=$9 #Use 'max' for max (default of regenie) ; use 'sum' for sum ; use 'comphet' for comphet.
#AAF=$10

# outputPath is the working directory. Ensure outputPath ends with "/"
if [[ "${outputPath}" != */ ]]; then
    outputPath="${outputPath}/"
fi

study_set="${outputPath}step2/study_set.tsv"
annot_file="${outputPath}step2/study_annot.tsv"
outputFile="${outputPath}step4/${RegenieOutput}"

mkdir -p "${outputPath}/step4"

############################### Code for Regenie    ###############################

Regenie_Regular_binary() {
    echo running regular burden test for binary trait using regenie
    regenie \
        --step 2 \
        --ignore-pred \
        --bed "${outputPath}step1/output5" \
        --bt \
        --phenoFile ${phenoFile} \
        --covarFile ${covarFile} \
        --phenoCol ${phenotypeColumn} \
        --covarColList ${covarList} \
        --set-list ${study_set} \
        --anno-file ${annot_file} \
        --minMAC 0.5 \
        --mask-def ./study_Mask.tsv \
        --build-mask ${build_mask} \
        --out ${outputFile}
#--aaf-file ./AAF_list.tsv \ #Add this step when gnomad was used in step1
}

Regenie_Regular_quantitative() {
    echo running regular burden test for quantitative trait using regenie
    regenie \
        --step 2 \
        --ignore-pred \
        --bed "${outputPath}step1/output5" \
        --phenoFile ${phenoFile} \
        --covarFile ${covarFile} \
        --phenoCol ${phenotypeColumn} \
        --covarColList ${covarList} \
        --set-list ${study_set} \
        --anno-file ${annot_file} \
        --minMAC 0.5 \
        --mask-def ./study_Mask.tsv \
        --build-mask ${build_mask} \
        --write-mask-snplist \
        --check-burden-files \
        --strict-check-burden \
        --out ${outputFile}
  #--aaf-file ./AAF_list.tsv \ #Add this step when gnomad was used in step1
}

Regenie_SKATO_binary() {
    echo running SKATO test for binary trait using regenie
     regenie \
        --step 2 \
        --ignore-pred \
        --bed "${outputPath}step1/output5" \
        --bt \
        --phenoFile ${phenoFile} \
        --covarFile ${covarFile} \
        --phenoCol ${phenotypeColumn} \
        --covarColList ${covarList} \
        --vc-tests skato \
        --set-list ${study_set} \
        --anno-file ${annot_file} \
        --minMAC 0.5 \
        --mask-def ./study_Mask.tsv \
        --build-mask ${build_mask} \
        --out ${outputFile}
#--aaf-file ./AAF_list.tsv \ #Add this step when gnomad was used in step1
}

Regenie_SKATO_quantitative() {
        echo running SKATO test for quantitative trait using regenie
        regenie \
        --step 2 \
        --ignore-pred \
        --bed "${outputPath}step1/output5" \
        --phenoFile ${phenoFile} \
        --covarFile ${covarFile} \
        --phenoCol ${phenotypeColumn} \
        --covarColList ${covarList} \
        --vc-tests skato \
        --set-list ${study_set} \
        --anno-file ${annot_file} \
        --minMAC 0.5 \
        --mask-def ./study_Mask.tsv \
        --build-mask ${build_mask} \
        --out ${outputFile}
        #--aaf-file ./AAF_list.tsv \ #Add this step when gnomad was used in step1
        # --write-mask-snplist \
        #--check-burden-files \
        #--strict-check-burden \
}

: <<'COMMENT'
#--aaf-file /data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/AAF_list.tsv \
COMMENT

if [[ "$trait" == "binary" && "$test" == "regular" ]]; then
    Regenie_Regular_binary
elif [[ "$trait" == "quantitative" && "$test" == "regular" ]]; then
    Regenie_Regular_quantitative
elif [[ "$trait" == "binary" && "$test" == "skato" ]]; then
    Regenie_SKATO_binary
elif [[ "$trait" == "quantitative" && "$test" == "skato" ]]; then
    Regenie_SKATO_quantitative
else
    echo "Invalid combination of trait and test."
fi

