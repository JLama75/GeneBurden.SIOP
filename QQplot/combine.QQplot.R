#!/usr/bin Rscript

#install.packages("qqman")
library("dplyr")
library("data.table")
library("readr")
library("argparse")
library("imager")
library("grid")

# Create a function to parse command line arguments
parse_args <- function() {
  parser <- ArgumentParser(description = "Combine QQ-plot")
  parser$add_argument("--trait", required = TRUE, help = "Trait name")
  return(parser$parse_args())
}

args <- parse_args()

# Print the input arguments
cat("Trait:", args$trait, "\n")

trait <- args$trait
outputName = paste0(trait,"GB.qqplot.allruns.tiff")
outPath="/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/GeneBurden.Results1/QQplot/combinedPlots/"
output=paste0(outPath,outputName)

plot1=paste0(trait,"Run1","_qq.jpeg")
plot2=paste0(trait,"Run2","_qq.jpeg")
plot3=paste0(trait,"Run3","_qq.jpeg")
plot4=paste0(trait,"Run4","_qq.jpeg")


# Read TIFF file using imager
img1 <- load.image(plot1)
img2 <- load.image(plot2)
img3 <- load.image(plot3)
img4 <- load.image(plot4)

# Check the dimensions of the image
print(dim(img1))  # Prints the dimensions of the image
print(dim(img2))  # Prints the dimensions of the image
print(dim(img3))  # Prints the dimensions of the image
print(dim(img4))  # Prints the dimensions of the image

# Arrange the images in a 2x2 layout without scales

#tiff(output, width = 8, height = 8, units = "in", res = 300)
tiff(output, width = 8, height = 8, units = "in", res = 600)
par(mfrow = c(2, 2), mar = c(1, 1, 3, 1)) 

# Plot each image without axes
#plot(img1, main = "Run 1", axes = FALSE, frame.plot = FALSE, cex.main = 1.5, font.main = 1)
plot(img1, axes = FALSE)
mtext("Run 1", side = 3, line = 1, cex = 2)  # Add custom title

plot(img2, axes = FALSE)
mtext("Run 2", side = 3, line = 1, cex = 2)

plot(img3, axes = FALSE)
mtext("Run 3", side = 3, line = 1, cex = 2)

plot(img4, axes = FALSE)
mtext("Run 4", side = 3, line = 1, cex = 2)

par(mfrow = c(2, 2))  # Reset layout to default
dev.off()  # Save and close the TIFF file
