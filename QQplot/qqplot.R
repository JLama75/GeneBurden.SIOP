#!/usr/bin Rscript

#install.packages("qqman")
library("qqman")
library("ggplot2")
library("dplyr")
library("stringr")
library("data.table")
library("readr")
library("argparse")
library("calibrate")

# Create a function to parse command line arguments
parse_args <- function() {
  parser <- ArgumentParser(description = "Plot manhattan plot")
  parser$add_argument("--gwasPath", required = TRUE, help = "Path to the gwas file with chr pos SNP P-value as columns")
  parser$add_argument("--trait", required = TRUE, help = "Trait name")
  parser$add_argument("--Run", required = TRUE, help = "Run number")
  parser$add_argument("--number", required = TRUE, help = "plot number")
  return(parser$parse_args())
}

args <- parse_args()

# Print the input arguments
cat("Trait:", args$trait, "\n")
cat("GWAS File:", args$gwasPath, "\n")
cat("Run:", args$Run, "\n")

trait <- args$trait
gwasPath <- args$gwasPath
Run = args$Run
outputName = paste0(trait, Run,".geneBurden.qqplot.tiff")
number = args$number
outPath="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/META/analysis/QQplot/plots/"

#gwas <- data.table::fread("/data/Segre_Lab/users/jlama/GSA_new.All_040424/GWAS/FAME/ExtremeResponder.updSteroidMedication/GWAS.plot/fame.pgen.noSham.newVarID.080824.extreme_responder.glm.logistic.hybrid.upt")
gwas_tmp <- data.table::fread(gwasPath)

gwas_tmp <- gwas_tmp[complete.cases(gwas_tmp$p), ]
gwas_tmp$CHISQ <- qchisq(gwas_tmp$p, df = 1, lower = F)
gwas_tmp <- gwas_tmp[complete.cases(gwas_tmp$CHISQ), ]
lambda<-median(gwas_tmp$CHISQ)/qchisq(0.5,1)
lambda <- round(lambda, 3)
# Append lambda to "lambda.log"
log_file <- paste0(outPath, "lambda.log")
cat(paste(Sys.time(), trait, "\t", Run, "\t", number, "\t", round(lambda, 3), "\n"), file = log_file, append = TRUE)

## Plot QQ-plot

#pdf((paste0(outPath, outputName)), width=4, height=4.5)
tiff(filename=(paste0(outPath, outputName)), units="in",width=4, height=4, res=600, compression = 'lzw')
par(mar = c(5, 5, 4, 2))
qq(gwas_tmp$p, main = paste("Lambda =", lambda), cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, font.main = 1)
#qq(gwas_tmp$p)
dev.off()




