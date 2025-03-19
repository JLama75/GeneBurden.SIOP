library(readxl)    # For reading Excel files
library(openxlsx)  # For writing Excel files

# Set the directory containing the .xlsx files
input_directory <- "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/ReplicationAnalysis/results"  # Change this to your directory
output_file <- "Replication.summary.xlsx"  # Name of the output file

# Get a list of all .xlsx files in the directory
file_list <- list.files(path = input_directory, pattern = "*replication.tsv", full.names = TRUE)
# Read each file into a dataframe and store them in a list
df_list <- lapply(file_list, read_table, col_names = TRUE)

# Combine all dataframes into one
final_df <- do.call(rbind, df_list)

write.xlsx(final_df, "summaryTable.Replication.GeneBurden.xlsx")

###############################################
# Get a list of all .xlsx files in the directory
file_list <- list.files(path = input_directory, pattern = "*metal.tsv", full.names = TRUE)
# Read each file into a dataframe and store them in a list
df_list <- lapply(file_list, read_table, col_names = TRUE)

# Combine all dataframes into one
final_df <- do.call(rbind, df_list)

write.xlsx(final_df, "summaryTable.BFpassed.Replication.GeneBurden.xlsx")
