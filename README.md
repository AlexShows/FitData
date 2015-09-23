# FitData Project Summary
Given a raw data set from fitness trackers, create a tidy data set and produce a summary of the trackers

## Purpose and Scope
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. In addition to the script for processing raw data, a Code Book called CodeBook.md is provided herein, within which there are explanations of the variable names contained in the tidy data output, as well as a more detailed explanation of the processing which occurs on the raw data to produce the tidy data.  

  
## Outputs
The FitData Project produces a tidy data set using the run_analysis.R script, in the form of a file named tidyData.txt.  

  
## Inputs
The run_analysis.R script has a function named process_raw_data which accepts a string indicating the zip file containing the raw data to be processed. The script then takes this zip file, extracts it into the working directory (that being the same directory as the location of the run_analysis.R file). If the file is not specified in the function call, the default name of the UCI HAR Dataset zip file will be used.


## Operations
_What follows is a summary of the operations performed. For a more detailed explanation, see the CodeBook.md file._  

The run_analysis.R script's function process_raw_data accepts a filename of the zip file containing raw data, and extracts this zip file alongside the script's directory, or looks for the default zip file name if one is not provided. 

This results in a directory structure that includes separate directories for test and train data. The script then removes the inertial signals directories from test and train data as these are extraneous. Afterward, it renames the UCI HAR Dataset directory to simply 'data' for better legibility.  

Once the data is extracted into a known directory structure, the script merges the two data sets from the test and train directories into a single large data set, including the activity and subject data which correspond to individual rows for each of test and train. This large data table is created with descriptive headers corresponding to the 561 feature names in the features.txt file and the activity labels in activity_labels.txt, and finally a subject ID.   

Then all of the columns except those representing a mean or standard deviation (according to their descriptions in features_info.txt and features.txt) are removed by selecting only the subject ID, activity ID, and all mean and standard deviation columns. The activity IDs are then given string names using a lookup table based on the activity_labels.txt file.  

Finally, all data for each mean and each standard deviation for each activity and each subject are averaged, such that there is a single average for each column by subject and activity. This result is the tidy data set. It is this data set that is output to the file tidyData.txt using write.table() with the row.names = FALSE option.  

Note that, with this sequence of operations, it is easy to read the tidy data back into R with a call to read.table('tidyData.txt', header=TRUE). 

## Raw Data Origins
The raw data used for this project are collected from the accelerometers of the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
```
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
```
A direct link to the raw data for the project is found here: 
```
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
```