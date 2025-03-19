#!/bin/bash

#FAME Responder ALL
CurrentDir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_022525"

dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated"
outDir="Responders/FAME.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1" "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#MEE Responder ALL

dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All"
outDir="Responders/MEE.sub.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#FAME Responder EUR

dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR"
outDir="Responders/FAME.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#MEE Responder EUR

dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR"
outDir="Responders/MEE.sub.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

###################
#Quantitative Trait, Regular

#FAME QT ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME"
outDir="Quantitative/RegularBurden/FAME.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#MEE-sub QT ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE.sub/UpdatedPCs/MEE.All"
outDir="Quantitative/RegularBurden/MEE.sub.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"


#FAME QT EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME_EUR"
outDir="Quantitative/RegularBurden/FAME.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"


#MEE-sub QT EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE.sub/UpdatedPCs/MEE.EUR"
outDir="Quantitative/RegularBurden/MEE.sub.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

###################
#Quantitative Trait, SKATO

#FAME QT ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME"
outDir="Quantitative/SKATO/FAME.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#MEE-sub QT ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE.sub/UpdatedPCs/MEE.All"
outDir="Quantitative/SKATO/MEE.sub.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"


#FAME QT EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME_EUR"
outDir="Quantitative/SKATO/FAME.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"


#MEE-sub QT EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE.sub/UpdatedPCs/MEE.EUR"
outDir="Quantitative/SKATO/MEE.sub.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

##########################
#Extreme Responders

#FAME Ex Responder ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME"
outDir="Ex.Responders/FAME.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"


#MEE Ex Responder ALL
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE"
outDir="Ex.Responders/MEE.sub.ALL/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#FAME Ex Responder EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME_EUR"
outDir="Ex.Responders/FAME.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

#MEE ExResponder EUR
dir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE_EUR"
outDir="Ex.Responders/MEE.sub.EUR/"
echo "${dir}/step1"
echo "${CurrentDir}/${outDir}"
cp -r "${dir}/step1"  "${CurrentDir}/${outDir}"
cp -r "${dir}/step2_to_4"  "${CurrentDir}/${outDir}"

