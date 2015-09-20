# Given a filename of a zip file containing the raw data
# from the fitness trackers, extract the zip file, merge
# the test and train data sets, create a tidy data set,
# and then output the tidy data set
process_raw_data <- function(raw_data_zip_filename) {
  
  # Validate, extract, validate again, and rename
  # If this is successful, we have a data folder
  # containing all the data we expect to use
  res <- validate_and_extract(raw_data_zip_filename)
  if(res == FALSE) stop('Failure extracting data. Exiting.')
  
  # TODO: Tidy up the data
  testData <- read.table('data/test/X_test.txt')
  trainData <- read.table('data/train/X_train.txt')
  
} # End of process_raw_data function

# Validate that we have a zip file, it exists, can be
# extracted, and contains the data we expect
validate_and_extract <- function(filename) {
  
  # Make sure it's a zip file
  if(substr(filename,
            nchar(filename)-3,
            nchar(filename))
     != '.zip') {
    print("Error: filename provided does not appear to be a zip file.")
    return(FALSE)
  }
  
  # Check that the file exists
  if(!file.exists(filename)) {
    print("Error: Unable to locate the filename provided:")
    print(filename)
    print("Check that the file exists and try again.")
    return(FALSE)
  }
  
  # Extract its contents
  unzip(filename)
  
  # Check if the directory we expect is present
  if(!file.exists('UCI HAR Dataset')) {
    print("Error: Unable to locate the directory containing UCI HAR Dataset")
    print("Check the contents of the zip file and try again.")
    return(FALSE)
  }
  
  # Rename, for ease of use, the data directory
  file.rename('UCI HAR Dataset', 'data')
  
  # Remove the intertial signals subdirectories (extraneous)
  unlink('data/test/Inertial Signals', recursive = T)
  unlink('data/train/Inertial Signals', recursive = T)
  
  return(TRUE)
  
} # End of validate_and_extract function
  