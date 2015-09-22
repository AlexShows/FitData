# Given a filename of a zip file containing the raw data
# from the fitness trackers, extract the zip file, merge
# the test and train data sets, create a tidy data set,
# and then output the tidy data set
process_raw_data <- function(raw_data_zip_filename) {
  
  # TODO: Check for empty string being passed, and try
  # to use the default zip file name for the dataset 
  # checking the working directory to see if it's there
  
  # Validate, extract, validate again, and rename
  # If this is successful, we have a data folder
  # containing all the data we expect to use
  res <- validate_and_extract(raw_data_zip_filename)
  if(res == FALSE) stop('Failure extracting data. Exiting.')
  
  print('Merging data...')
  mergedData <- merge_data()
  if(is.null(mergedData)) stop('Failure merging data. Exiting.')
  print('Merge complete.')
  
  print('Extracting measurements of mean and standard deviation...')
  extractedData <- extract_data(mergedData)
  if(is.null(extractedData)) stop('Failure extracting data. Exiting.')
  print('Extraction complete.')
  
  # TODO: Add a column to testActivities giving a text explanation of 
  # the activity corresponding to the numbered activity which
  # is in data/activity_labels.txt
  
  # Get all the activity names for the various activities
  activityNames <- read.table('data/activity_labels.txt')
  # This will be used as a lookup table for the activity numbers
  
  # TODO: Label the data set with descriptive variable names
  
  # TODO: Create a second, tidy data set with the average of each
  # variable for each activity and each subject
  # Maybe do an inner and outer loop, where the outer is the SubjectID
  # and the inner is the ActivityID, and summarise_each() then rbind?
  
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
  unlink('data/test/Inertial Signals', recursive = TRUE)
  unlink('data/train/Inertial Signals', recursive = TRUE)
  
  return(TRUE)
  
} # End of validate_and_extract function

# Take the test data from the corresponding folder (assumes this is
# already extracted) and train data, and merge them
merge_data <- function() {
  
  require(data.table)
  
  testData <- read.table('data/test/X_test.txt')
  testData <- data.table(testData)
  
  trainData <- read.table('data/train/X_train.txt')
  trainData <- data.table(trainData)
  
  # Get all the feature names for the 561 columns
  featureNames <- read.table('data/features.txt')
  # Convert to a vector of strings
  featuresVec <- c(as.character(featureNames[,2]))
  
  # Set the names using make.names so they're R-compliant headers
  setnames(testData, old=c(names(testData)), new=c(make.names(featuresVec)))
  setnames(trainData, old=c(names(trainData)), new=c(make.names(featuresVec)))
  
  # Create data table with the subjects
  testSubjects <- read.table('data/test/subject_test.txt')
  names(testSubjects) <- c("SubjectID")
  testSubjects <- data.table(testSubjects)
  
  trainSubjects <- read.table('data/train/subject_train.txt')
  names(trainSubjects) <- c("SubjectID")
  trainSubjects <- data.table(trainSubjects)
  
  # Create data table with the activities
  testActivities <- read.table('data/test/y_test.txt')
  names(testActivities) <- c("ActivityID")
  testActivities <- data.table(testActivities)
  
  trainActivities <- read.table('data/train/y_train.txt')
  names(trainActivities) <- c("ActivityID")
  trainActivities <- data.table(trainActivities)
  
  # column-bind the test subjects and test activities into the testData
  testData <- cbind(testData, testSubjects)
  testData <- cbind(testData, testActivities)
  
  # Repeat for the train data
  trainData <- cbind(trainData, trainSubjects)
  trainData <- cbind(trainData, trainActivities)
  
  mergedData <- rbind(testData, trainData)
  
  return(mergedData)
  
}

# Given a merged data set, extract only the measurements on the mean and standard deviation
# for each measurement as well as SubjectID and ActivityID
extract_data <- function(data) {
  
  require(data.table)
  require(dplyr)

  # Using the dplyr select function, select only the SubjectID, ActivityID,
  # and any columns matching (case-insensitively) 'mean' or 'std'
  extracted_data <- select(data, matches('SubjectID'),
                           matches('ActivityID'),
                           contains('mean', ignore.case = TRUE), 
                           contains('std', ignore.case = TRUE))

  return(extracted_data)
  
}