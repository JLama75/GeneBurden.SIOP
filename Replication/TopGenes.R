#!/usr/bin Rscript
setwd("/data/Segre_Lab/users/jlama/WES_new.ALL_050824/ReplicationAnalysis/results/")
#install.packages("qqman")
library("qqman")
library("ggplot2")
library("dplyr")
library("stringr")
library("data.table")
library("argparse")


#GWAS path for FAME primary ALL (columns=ID, P, SE, Beta) and P<10-5
#GWAS path to FAME primary ALL (columns=ID, P, SE, Beta) and subset
#Metal path to primary ALL# Create a function to parse command line arguments
parse_args <- function() {
  parser <- ArgumentParser(description = "Top Genes")
  parser$add_argument("--First_gwas", required = TRUE, help = "path to FAME gwas")
  parser$add_argument("--Second_gwas", required = TRUE, help = "path to MEE gwas")
  parser$add_argument("--metal", required = TRUE, help = "path to Metal gwas")
  parser$add_argument("--trait", required = TRUE, help = "trait")
  parser$add_argument("--Run", required = TRUE, help = "Run")
  return(parser$parse_args())
}

args <- parse_args()
FAME <- args$First_gwas
MEE <- args$Second_gwas
Metal <- args$metal
trait <- args$trait
Run <- args$Run

process.gwas <- function(gwas, string, cohort){
  #if (string == "Primary") {
  if (cohort == "FAME" ) {
    gwas <- read.table(gwas, sep = "\t", header = TRUE)
    gwas <- gwas %>% select(GENE, ALLELE1, A1FREQ, BETA, SE, P, FDR_BH_p_value, P.value.Run4, BonferroniCutoff)
    print("FAME dataframe: ")
    print(head(gwas))
    #gwas$LOG10P <- as.numeric(gwas$LOG10P)
    #gwas.sub <- gwas[gwas$log10P >= 3, ]
    gwas <- gwas[gwas$P <= 0.001, ]
    print("fame with P<10-3: ")
    print(head(gwas))
    print(dim(gwas)[1])
    
    gwas$A1FREQ <- round(as.numeric(gwas$A1FREQ), 2)
    gwas$BETA <- round(as.numeric(gwas$BETA), 2)
    gwas$SE<- round(as.numeric(gwas$SE), 2)
    gwas$FDR_BH_p_value<- round(as.numeric(gwas$FDR_BH_p_value), 2)
    print("columns to update: 2 to 9")
    cols_to_update <- 2:9  # Define column indices 
    colnames(gwas)[cols_to_update] <- paste0(colnames(gwas)[cols_to_update], "_", cohort)

  } else if (cohort == "MEE") {
    gwas <- read.table(gwas, sep = "\t", header = TRUE)
    gwas <- gwas %>% select(GENE, BETA, SE, P, FDR_BH_p_value, P.value.Run4)
    print("MEE dataframe: ")
    print(head(gwas))
    
    gwas$BETA <- round(as.numeric(gwas$BETA), 2)
    gwas$SE<- round(as.numeric(gwas$SE), 2)
    gwas$FDR_BH_p_value<- round(as.numeric(gwas$FDR_BH_p_value), 2)
    print("columns to update: 2 to 6")
    cols_to_update <- 2:6  # Define column indices 
    colnames(gwas)[cols_to_update] <- paste0(colnames(gwas)[cols_to_update], "_", cohort)
    
  }
  
  else {
    gwas <- read.table(Metal, sep = " ", header = TRUE)
    gwas <- gwas %>% select(GENE, beta, se, p, direction, het_pval, BH)
    print("METAL: \n")
    print(head(gwas))
    
    gwas$beta <- round(as.numeric(gwas$beta), 2)
    gwas$se<- round(as.numeric(gwas$se), 2)
    gwas$het_pval<- round(as.numeric(gwas$het_pval), 2)
    gwas$BH<- round(as.numeric(gwas$BH), 2)
    print("columns to update: 2 to 7")
    cols_to_update <- 2:7  # Define column indices 
    colnames(gwas)[cols_to_update] <- paste0(colnames(gwas)[cols_to_update], "_", cohort)
    
  }
  return(gwas)
}


#FAME="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/updated/step5_to_6/draft_5PCs/FAME.updated_Run1_merged_Count.tsv"
#MEE="/data/Segre_Lab/users/jlama/GSA_new.All_040424/GWAS/MEE/Qt.noAsians/newVarID.refomit/qt.mee.pgen.577IDs.080524.MaxIOPriseRINT.glm.linear"
#Metal="/data/Segre_Lab/users/jlama/GSA_new.All_040424/GWAS/metal/Primary.noAsians/metal.stderr.gc.FAMEv1.MEEv1.MaxIOPRise_rank.072924.add.1tbl"
outdir="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/ReplicationAnalysis/results/"
print(paste0("Analysis for trait: ", trait))


FAME.df <- process.gwas(FAME, "Primary", "FAME") #169
MEE.df <- process.gwas(MEE, "Primary", "MEE") #164
Metal.df <- process.gwas(Metal, "Primary", "Metal")

merge.df <- merge(FAME.df, MEE.df, by="GENE")#164
print("no. of rows of FAME-MEE merged data: \n")
nrows=dim(merge.df)[1]
BF=0.05/nrows

print("Repliation Bonferroni cutoff: ")
print(BF)
merge.df$BF <- BF
merge.df$trait <- trait
merge.df$Run <- Run

#Genes only passing BF
merge.df.passed <- merge.df[merge.df$P_MEE <= BF,]
Metal.merge.passed <- merge(merge.df.passed, Metal.df, by="GENE")

#ALL Genes
merge.df$passedBF <- ifelse(merge.df$GENE %in% merge.df.passed$GENE, "Yes", "No" )
Metal.merge <- merge(merge.df, Metal.df, by="GENE")
print("no. of rows of FAME-MEE-METAL merged data: \n")
print(dim(Metal.merge)[1])
print(Metal.merge)

print("Repliation Bonferroni corrected")
print(merge.df.passed)

tableName=paste0(outdir, trait,"_FAME_MEE_METAL.replication.tsv")
tableName0=paste0(outdir,"FAME_MEE/",trait,"_FAME_MEE.replication.tsv")

StudyName <- sub("_[^_]+$", "", trait)
SummaryName <- paste0(outdir,"summary/",StudyName,"_Summary.replication.tsv")
#tableName2=paste0(trait,"_Replication_BF_passed.tsv")
MetalName=paste0(trait,"_TopGenes.metal.tsv")


print(getwd())
print(paste0("saving the dataframe FAME-MEE-Metal  to", tableName, "\n"))
write.table(Metal.merge, tableName, quote = F, row.names = F)
print(paste0("saving the dataframe FAME-MEE df to", tableName0, "\n"))
write.table(merge.df, tableName0, quote = F, row.names = F)

if (FALSE) {
  if (!file.exists(SummaryName)) {
    print(paste0("saving the FAME-MEE-METAL data from all runs to a single file: "), SummaryName)
    # If file doesn't exist, write with headers
    write.table(Metal.merge, SummaryName, quote = FALSE, row.names = FALSE, sep = "\t", col.names = TRUE)
  } else {
    print(paste0("saving the FAME-MEE-METAL data from all runs to a single file: "), SummaryName)
    # If file exists, append without headers
    write.table(Metal.merge, SummaryName, quote = FALSE, row.names = FALSE, sep = "\t", append = TRUE, col.names = FALSE)
  }
}

if (nrow(merge.df.passed) > 0) {
  #write.table(merge.df.passed, tableName2, quote = FALSE, row.names = FALSE)
  print("yes, MEE BF passed")
  write.table(Metal.merge.passed, MetalName, quote = F, row.names = F)
}



