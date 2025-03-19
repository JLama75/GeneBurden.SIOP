#!/bin/bash
outDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_022525/phenotype"

trait="FAME.Responder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/FAME.Responder.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
#######

trait="MEE.Responder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All/step5_to_6/MEE.GWAS.pheno.tsv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="FAME.Responder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR/step5_to_7/FAME_EUR.Responder.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="MEE.Responder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR/step5_to_6/MEE_EUR.Responder.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="FAME.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME/step5_to_6/FAME.MaxIOP.RINT.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="MEE.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE/step5_to_6/MEE.MaxIOPRINT.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="FAME.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME_EUR/step5_to_6/FAME.MaxIOP.RINT.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="MEE.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE_EUR/step5_to_6/MEE_EUR.MaxIOPrint.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="FAME.ExResponder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME/step5_to_6/FAME.ExResponders.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="MEE.ExResponder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE/step5_to_6/MEE.ExResponders.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="FAME.ExResponder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME_EUR/step5_to_6/FAME.ExResponders.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"
##########

trait="MEE.ExResponder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE_EUR/step5_to_6/MEE_EUR.ExResponders.pheno.csv"

cp ${pheno} "${outDir}/${trait}.pheno.tsv"
echo -e "${pheno}\nFile copied and renamed to: ${outDir}/${trait}.pheno.tsv"

##########
