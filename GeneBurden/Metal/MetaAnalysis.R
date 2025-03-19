#!/usr/bin Rscript

library(readr)
library(readxl)
#install.packages("metafor")
#install.packages("meta")
library(metafor)
library(meta)
library(dplyr)
library(writexl)

#We used the inverse variance weighting for Meta-Burden and the REML estimation of variance component for Meta-Burden-RE via the metafor package
# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Define arguments with default values
file1 <- NULL
file2 <- NULL
trait <- NULL
outDir <- NULL

# Match arguments by position 
file1_argument <- match("--file1", args) + 1 #Should be fame
file2_argument <- match("--file2", args) + 1 #Should be mee
trait_argument <- match("--trait", args) + 1
outDir_argument <- match("--outDir", args) + 1
outDir2 <- "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1"

# Assign values from command line arguments
if (!is.na(file1_argument)) file1 <- args[file1_argument]
if (!is.na(file2_argument)) file2 <- args[file2_argument]
if (!is.na(trait_argument)) trait <- args[trait_argument]
if (!is.na(outDir_argument)) outDir <- args[outDir_argument]

# Print arguments to confirm they are correctly assigned
cat("file1:", file1, "\n")
cat("file2:", file2, "\n")
cat("trait:", trait, "\n")
cat("outDir:", outDir, "\n")

#fame <- read_table("/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/FAME_updated/step8_to_10/Regenie_Run1.tsv", col_names = T)
#mee <- read_table("/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/MEE/step8_to_10/Regenie_Run1.tsv", col_names = T)

#fame <- read_table(file1, col_names = T)
#mee <- read_table(file2, col_names = T)

fame <- read.delim(file1)
mee <- read.delim(file2)

fame = fame %>% select(GENE, BETA, SE, P)
colnames(fame) <- c("GENE", "fame.Beta", "fame.SE", "fame.P")
mee = mee %>% select(GENE, BETA, SE, P)
colnames(mee) <- c("GENE", "mee.Beta", "mee.SE", "mee.P")

gcc <- merge(fame, mee, by="GENE")
print(paste0("no. of common genes ", trait))
print(dim(gcc)[1])

# add meta-analysis results
# Initialize columns in gcc with NAs
gcc$I2 <- gcc$ci.upper <- gcc$ci.lower <- gcc$p <- gcc$se <- gcc$beta <- rep(NA, nrow(gcc))

for (i in 1:nrow(gcc)) {
  temp1 <- gcc[i, 2:4]  # Assuming these are beta, se, p for one set of studies
  temp2 <- gcc[i, 5:7]  # Assuming these are beta, se, p for another set of studies
  
  # Rename columns for both temp1 and temp2
  colnames(temp1) <- c("beta", "se", "p")
  colnames(temp2) <- c("beta", "se", "p")
  
  # Combine both sets of studies into one DataFrame
  temp <- rbind(temp1, temp2)
  
  # Remove rows with NAs in beta or se
  temp <- na.omit(temp)
  
  # Verify if there are valid studies left
  if (nrow(temp) == 0) {
    next  # Skip to the next row if no valid studies are left
  }
  
  # Run the rma function
  res <- rma(yi = temp$beta, sei = temp$se, method = "REML")  # Ensure proper referencing
  
  # Store results in gcc
  gcc$beta[i] <- round(res$beta[1], 3)
  gcc$se[i] <- round(res$se, 3)
  gcc$p[i] <- res$pval
  gcc$ci.lower[i] <- round(res$ci.lb, 3)
  gcc$ci.upper[i] <- round(res$ci.ub, 3)
  gcc$I2[i] <- round(res$I2, 1)
  gcc$het_pval[i] <- round(res$QEp, 1)  # Heterogeneity p-value (Q-test p-value)
  gcc$direction[i] <- paste(ifelse(temp$beta > 0, "+", "-"), collapse = "")
  # Determine direction of effect
  
}

gcc$log10P <- -log10(gcc$p)
gcc <- gcc %>% arrange(desc(log10P))
gcc$BH <- p.adjust(gcc$p, method = "BH")
gcc$BonferroniCutoff <- 0.05/(dim(gcc)[1])

out=paste0(outDir, "/", trait, ".tsv")
out2=paste0(outDir, "/", trait, ".xlsx")
out3=paste0(outDir2, "/", trait, ".tsv")

print(paste0("save the file in: ",out))
print(paste0("Also save the file in: ",out3))
print(paste0("save the file as excel in: ",out2))

write.table(gcc, out, quote = F, row.names=F)
write.table(gcc, out3, quote = F, row.names=F)
write_xlsx(gcc, path = out2)
