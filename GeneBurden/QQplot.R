#!/usr/bin Rscript

#install.packages("qqman")
library("qqman")
library("ggplot2")
library("dplyr")
library("stringr")
library("data.table")

# Load required libraries
library(optparse)

# Define command-line options
option_list <- list(
  make_option("--file1", type="character", default=NULL, help="Path to file 1", metavar="character"),
  make_option("--file2", type="character", default=NULL, help="Path to file 2", metavar="character"),
  make_option("--file3", type="character", default=NULL, help="Path to file 3", metavar="character"),
  make_option("--file4", type="character", default=NULL, help="Path to file 4", metavar="character"),
  make_option("--trait", type="character", default=NULL, help="Trait name", metavar="character"),
  make_option("--output", type="character", default=NULL, help="path to output file", metavar="character")
)

# Parse the arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

file1=opt$file1
file2=opt$file2
file3=opt$file3
file4=opt$file4
trait=opt$trait
output=opt$output
output2="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1/QQplot"
output3="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1/lambda"

# Print the arguments for debugging
print(paste("File 1:", opt$file1))
print(paste("File 2:", opt$file2))
print(paste("File 3:", opt$file3))
print(paste("File 4:", opt$file4))
print(paste("Trait:", opt$trait))
print(paste("Trait:", opt$output))

qqplot <- function(df, trait, Run, output){
  
  df$P <- as.numeric(df$P)
  #df <- run1[!is.na(df$P)]
  summary(df$P)
  
  ##GC Lambda
  
  df$CHISQ <- qchisq(df$P, df = 1, lower = F)
  #df <- df[complete.cases(df$CHISQ), ]
  lambda<- median(df$CHISQ)/qchisq(0.5,1)
  lambda <- round(lambda, 3)
  
  name=paste0(output,"/",trait,".",Run,"_qq.tiff")
  #DIR=
  #jpeg(name,
  #     height=1350,width=1200,res=300)
  #qq(df$P)
  
  tiff(filename=name, units="in",width=4, height=4, res=600, compression = 'lzw')
  par(mar = c(5, 5, 4, 2))
  qq(df$P, main = paste("Lambda =", lambda), cex.axis = 1.5, cex.lab = 1.5, cex.main = 1.5, font.main = 1)
  
  dev.off()
  

  # Return lambda and run identifier
  return(data.frame(Run = Run, Lambda = lambda))
  
}

run1 <- data.table::fread(file1)
run2 <- data.table::fread(file2)
run3 <- data.table::fread(file3)
run4 <- data.table::fread(file4)

R1 <- qqplot(run1, trait, "Run1", output2)
R2 <- qqplot(run2, trait, "Run2", output2)
R3 <- qqplot(run3, trait, "Run3", output2)
R4 <- qqplot(run4, trait, "Run4", output2)

# Combine the results into a single dataframe
lambda_df <- rbind(R1, R2, R3, R4)
write.table(lambda_df, paste0(output, "/", trait,".lambda_values.tsv"), quote = F, row.names = F)
write.table(lambda_df, paste0(output3, "/", trait,".lambda_values.tsv"), quote = F, row.names = F)