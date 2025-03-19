library("qqman")
library("ggplot2")
library("dplyr")
library("stringr")
library("data.table")
setwd("/gpfs/fs1/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/META/analysis")
gwas_tmp <- read_table("Meta.MaxIOP.Regenie.ALL.Run3.tsv", col_names = T)
## Plot QQ-plot

jpeg("Meta.MaxIOP.regenie.run3.jpeg",
     height=1350,width=1200,res=300)
qq(gwas_tmp$p)
dev.off()


##GC Lambda

gwas_tmp$CHISQ <- qchisq(gwas_tmp$p, df = 1, lower = F)
#gwas_tmp_retain <- gwas_tmp_retain[complete.cases(gwas_tmp_retain$CHISQ), ]
median(gwas_tmp$CHISQ)/qchisq(0.5,1)

gwas_tmp <- read_table("Meta.ExResp.All.Run1.tsv", col_names = T)
## Plot QQ-plot

jpeg("Meta.ExResp.run1.jpeg",
     height=1350,width=1200,res=300)
qq(gwas_tmp$p)
dev.off()


##GC Lambda

gwas_tmp$CHISQ <- qchisq(gwas_tmp$p, df = 1, lower = F)
#gwas_tmp_retain <- gwas_tmp_retain[complete.cases(gwas_tmp_retain$CHISQ), ]
median(gwas_tmp$CHISQ)/qchisq(0.5,1)
