library(dplyr)
library(readr)

# Get all files ending with _summary.tsv
files <- list.files(path = ".", pattern = "_Run1_sig.tsv$", full.names = TRUE)


# Read all files ensuring CHROM is read as character
df_list <- lapply(files, function(x) {
  read_table(x, col_names = TRUE, col_types = cols(.default = col_character()))
})
# Concatenate all dataframes into one
Run1 <- bind_rows(df_list)

# Print or inspect the final dataframe

#####################
# Get all files ending with _summary.tsv
files <- list.files(path = ".", pattern = "_Run2_sig.tsv$", full.names = TRUE)

# Read all files ensuring CHROM is read as character
df_list <- lapply(files, function(x) {
  read_table(x, col_names = TRUE, col_types = cols(.default = col_character()))
})

# Concatenate all dataframes into one
Run2 <- bind_rows(df_list)
# Print or inspect the final dataframe
print(Run2)

#####################
# Get all files ending with _summary.tsv
files <- list.files(path = ".", pattern = "_Run3_sig.tsv$", full.names = TRUE)

# Read all files ensuring CHROM is read as character
df_list <- lapply(files, function(x) {
  read_table(x, col_names = TRUE, col_types = cols(.default = col_character()))
})

# Concatenate all dataframes into one
Run3 <- bind_rows(df_list)
# Print or inspect the final dataframe
print(Run3)

#####################
# Get all files ending with _summary.tsv
files <- list.files(path = ".", pattern = "_Run4_sig.tsv$", full.names = TRUE)

# Read all files ensuring CHROM is read as character
df_list <- lapply(files, function(x) {
  read_table(x, col_names = TRUE, col_types = cols(.default = col_character()))
})

# Concatenate all dataframes into one
Run4 <- bind_rows(df_list)
# Print or inspect the final dataframe
print(Run4)



library(openxlsx)

# Define the output Excel file
excelOut <- "TopGenes.SummaryTable.xlsx"  # Change this to your desired filename

# Create a new workbook
wb <- createWorkbook()

# Add worksheets and write data
addWorksheet(wb, "Run1")
writeData(wb, "Run1", Run1)

addWorksheet(wb, "Run2")
writeData(wb, "Run2", Run2)

addWorksheet(wb, "Run3")
writeData(wb, "Run3", Run3)

addWorksheet(wb, "Run4")
writeData(wb, "Run4", Run4)

# Save the workbook
saveWorkbook(wb, excelOut, overwrite = TRUE)
