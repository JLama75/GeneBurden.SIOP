library(readxl)    # For reading Excel files
library(openxlsx)  # For writing Excel files

# Set the directory containing the .xlsx files
input_directory <- "/data/Segre_Lab/users/jlama/WES_new.ALL_050824/GeneBurden/META/analysis"  # Change this to your directory
output_file <- "Metal.summary.xlsx"  # Name of the output file

# Get a list of all .xlsx files in the directory
file_list <- list.files(path = input_directory, pattern = "*.xlsx", full.names = TRUE)

# Create a new workbook
wb <- createWorkbook()

# Initialize an empty list to store sheet names
sheet_names <- c()

# Loop through each file
for (file in file_list) {
  
  # Read the Excel file
  sheet_data <- read_excel(file)
  
  # Extract the file name without extension for the sheet name
  sheet_name <- tools::file_path_sans_ext(basename(file))
  
  # Add the sheet name to the list
  sheet_names <- c(sheet_names, sheet_name)
  
  # Add a new sheet to the workbook with the data
  addWorksheet(wb, sheet_name)  # Create a new sheet with the file name
  writeData(wb, sheet_name, sheet_data)  # Write data to the sheet
}

# Save the workbook
saveWorkbook(wb, file = output_file, overwrite = TRUE)

# Create a DataFrame from the list of sheet names
sheet_names_df <- data.frame(sheet_name = sheet_names)

# Print the DataFrame
print(sheet_names_df)

# Message to indicate completion
cat("Summary file created:", output_file, "\n")

write.table(sheet_names_df,"Summary.log", quote = F, row.names = T)
