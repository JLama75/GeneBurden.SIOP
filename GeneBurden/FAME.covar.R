setwd("/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/Updated_PCs_022525/")

ProcessFile <- function(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl) {
  df<- read_table(covar, col_names = T)
  #Reading covariates file ...
  if (cohort=="FAME") {
    print("FAME dataframe: ")
    print(head(df))
    df <- df[,c(1:7)]
    print(colnames(df))
  } else if (cohort == "MEE") {
    print("FAME dataframe: ")
    print(head(df))
    df <- df[,c(1:9)]
    print(colnames(df))
  }
  #Reading PCs file ...
  print("reading PCA eignenvec file...")
  if (popl=="EUR") {
    PCA <- read_table(pca)
    PCA <- PCA %>% select(IID,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 )
    merge_df <- merge(df, PCA, by="IID")
  } else if (popl=="ALL"){
    PCA <- read_table(pca)
    PCA <- PCA %>% select(IID,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10)
    merge_df <- merge(df, PCA, by="IID")
  }
  #Extracting the no. of synonymous mutation from the covar table
  df<- read_table(covar, col_names = T)
  df <- df %>%  select(IID, count_synonymous)
  print("extracting count_synonymous column")
  print(head(df))
  merge_df <- merge(merge_df, df, by="IID")
  outFile=paste0("./phenotype/", outFile)
  merge_df <- merge_df[, c(2, 1, 3:ncol(merge_df))]
  
  print(head(merge_df))
  write.table(merge_df, outFile, quote = F, row.names = F)
  
  print("reading phenotype file... \n")
  df<- read_table(pheno, col_names = T)
  if (grepl("ExResponder", trait)) {
    print("ExResponder")
    df_case <- df %>% subset( Ex_responder == 1) %>% select(FID, IID)
    df_control <- df %>% subset( Ex_responder == 0) %>% select(FID, IID)
  }
  else {
    df_case <- df %>% subset(responder==1) %>% select(FID, IID)
    df_control <- df %>% subset(responder==0) %>% select(FID, IID)
  }
  
  write.table(df_case, keep.cases.Dir, quote = F, row.names = F, sep = "\t")
  write.table(df_control, keep.controls.Dir, quote = F, row.names = F,  sep = "\t")
  
  return
}

#FAME Responder ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/FAME.GWAS_cov_pca_100924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME/study_pca.eigenvec"
trait="FAME.Responder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/FAME.Responder.pheno.csv"
outDir="./Responders/FAME.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="ALL"

ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE Responder ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All/step5_to_6/MEE.GWAS_cov_pca_102224.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.sub/study_pca.eigenvec"
trait="MEE.Responder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All/step5_to_6/MEE.GWAS.pheno.tsv"
outDir="./Responders/MEE.sub.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="MEE"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#FAME Responder EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR/step5_to_7/FAME_EUR.GWAS_cov_pca20_101724.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME.EUR/study_pca.eigenvec"
trait="FAME.Responder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR/step5_to_7/FAME_EUR.Responder.pheno.csv"
outDir="./Responders/FAME.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="EUR"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE Responder EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR/step5_to_6/MEE_EUR.GWAS_cov_pca_101724.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.EUR.sub/study_pca.eigenvec"
trait="MEE.Responder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR/step5_to_6/MEE_EUR.Responder.pheno.csv"
outDir="./Responders/MEE.sub.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
popl="EUR"
cohort="MEE"

ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

###################
#Quantitative Trait, Regular

#FAME QT ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME/step5_to_6/FAME.MaxIOP.RINT.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME/study_pca.eigenvec"
trait="FAME.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/FAME.Responder.pheno.csv"
outDir="./Quantitative/RegularBurden/FAME.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE-sub QT ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE/step5_to_6/MEE.MaxIOPRINT.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.sub/study_pca.eigenvec"
trait="MEE.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All/step5_to_6/MEE.GWAS.pheno.tsv"
outDir="./Quantitative/RegularBurden/MEE.sub.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="MEE"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#FAME QT EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME_EUR/step5_to_6/FAME.EUR.MaxIOP.RINT.GWAS_cov_pca20_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME.EUR/study_pca.eigenvec"
trait="FAME.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR/step5_to_7/FAME_EUR.Responder.pheno.csv"
outDir="./Quantitative/RegularBurden/FAME.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="EUR"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE-sub QT EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE_EUR/step5_to_6/MEE_EUR.MaxIOPrint.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.EUR.sub/study_pca.eigenvec"
trait="MEE.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR/step5_to_6/MEE_EUR.Responder.pheno.csv"
outDir="./Quantitative/RegularBurden/MEE.sub.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
popl="EUR"
cohort="MEE"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

###################
#Quantitative Trait, SKATO

#FAME QT ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME/step5_to_6/FAME.MaxIOP.RINT.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME/study_pca.eigenvec"
trait="FAME.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step5_to_6/FAME.Responder.pheno.csv"
outDir="./Quantitative/SKATO/FAME.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE-sub QT ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE/step5_to_6/MEE.MaxIOPRINT.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.sub/study_pca.eigenvec"
trait="MEE.QT.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.All/step5_to_6/MEE.GWAS.pheno.tsv"
outDir="./Quantitative/SKATO/MEE.sub.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="MEE"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#FAME QT EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/FAME_EUR/step5_to_6/FAME.EUR.MaxIOP.RINT.GWAS_cov_pca20_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME.EUR/study_pca.eigenvec"
trait="FAME.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_EUR/step5_to_7/FAME_EUR.Responder.pheno.csv"
outDir="./Quantitative/SKATO/FAME.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="EUR"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE-sub QT EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/QuantitativeTrait/MEE_EUR/step5_to_6/MEE_EUR.MaxIOPrint.GWAS_cov_pca_101924.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.EUR.sub/study_pca.eigenvec"
trait="MEE.QT.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE.sub/UpdatedPCs/MEE.EUR/step5_to_6/MEE_EUR.Responder.pheno.csv"
outDir="./Quantitative/SKATO/MEE.sub.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
popl="EUR"
cohort="MEE"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

##########################
#Extreme Responders

#FAME Ex Responder ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME/step5_to_6/FAME.ExResponders.GWAS_cov_pca_102124.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME.ExResponder/study_pca.eigenvec"
trait="FAME.ExResponder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME/step5_to_6/FAME.ExResponders.pheno.csv"
outDir="./Ex.Responders/FAME.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE Ex Responder ALL
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE/step5_to_6/MEE.ExResponders.GWAS_cov_pca_102124.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.ExResponder/study_pca.eigenvec"
trait="MEE.ExResponder.All"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE/step5_to_6/MEE.ExResponders.pheno.csv"
outDir="./Ex.Responders/MEE.sub.ALL/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="MEE"
popl="ALL"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#FAME Ex Responder EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME_EUR/step5_to_6/FAME.EUR.ExResponders.GWAS_cov_pca20_102124.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/FAME.EUR.ExResponder/study_pca.eigenvec"
trait="FAME.ExResponder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/FAME_EUR/step5_to_6/FAME.ExResponders.pheno.csv"
outDir="./Ex.Responders/FAME.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
cohort="FAME"
popl="EUR"
ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)

#MEE ExResponder EUR
covar= "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE_EUR/step5_to_6/MEE_EUR.ExResponders.GWAS_cov_pca_102124.csv"
pca="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/PCA/UpdatedPCA/MEE.EUR.ExResponder/study_pca.eigenvec"
trait="MEE.ExResponder.EUR"
pheno="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/ExtremeResponders/MEE_EUR/step5_to_6/MEE_EUR.ExResponders.pheno.csv"
outDir="./Ex.Responders/MEE.sub.EUR/"
keep.cases.Dir= paste0(outDir, "step1/keep.cases.tsv")
keep.controls.Dir= paste0(outDir, "step1/keep.controls.tsv")
outFile= paste0(trait,"_cov_pca_022525.csv")
popl="EUR"
cohort="MEE"

ProcessFile(covar, pca, trait, pheno, keep.cases.Dir, keep.controls.Dir, outFile, cohort, popl)



