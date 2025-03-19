#!/bin/bash
#SBATCH --job-name=GWASplot_102524   # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jlama@meei.harvard.edu     # Where to send mail    
#SBATCH --output=CombinePlots_%j.log   # Standard output and error log
#SBATCH --partition=short,medium,xnetwork,long

#Rscript --no-save ManhattanPlot.QQ.R >& extremeRes.plot.log
#module load R/4.0.5

#filePath=$1
trait=$1
echo ${trait}
pwd
module list
#Rscript --no-save ManhattanPlot.QQ.R --gwasPath $filePath --trait $trait --title $title
#Rscript --no-save qqplot.R --gwasPath "../${filePath}" --trait $trait --Run ${Run} --number $4

Rscript --no-save /data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1/QQplot/combine.QQplot.R --trait ${trait} 