# FitData Project Summary
Given a raw data set from fitness trackers, create a tidy data set and produce a summary of the trackers

## Purpose and Scope
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. In addition to the script for processing raw data, a Code Book called CodeBook.md is provided herein, within which there are explanations of the variable names contained in the tidy data output, as well as a more detailed explanation of the processing which occurs on the raw data to produce the tidy data.  

  
## Outputs
The FitData Project produces a tidy data set using the run_analysis.R script, providing it with a zip file containing the raw data.  

  
## Inputs
The run_analysis.R script has a function named process_raw_data which accepts a string indicating the zip file containing the raw data to be processed. The script then takes this zip file, extracts it into the working directory (that being the same directory as the location of the run_analysis.R file).  


## Operations
_What follows is a summary of the operations performed. For a more detailed explanation, see the CodeBook.md file._  

The run_analysis.R script's function process_raw_data accepts a filename of the zip file containing raw data, and extracts this zip file alongside the script's directory.  

This results in a directory structure that includes separate directories for test and train data.  

The script then reads in the test data, where the X (direct sensor and derived values), Y (activity ID), and subject data are merged into a large table (noting that the rows of X, Y, and subject all correspond and must be preserved). A data table is created with descriptive headers corresponding to the 561 feature names in the features.txt file and the activity labels in activity_labels.txt, and finally a subject ID.   

The operations performed on the test data are then repeated on the train data, such that the resulting data tables can be easily merged together into a single data set.  

Then the two tables are merged, and all of the columns except those representing a mean or standard deviation (according to their descriptions in features_info.txt and features.txt) are removed.  

Finally, all data for each mean and each standard deviation for each activity and each subject are averaged, such that there is a single average for each column by subject and activity. This result is the tidy data set.  


## Raw Data Origins
The raw data used for this project are collected from the accelerometers of the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
```
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
```
A direct link to the raw data for the project is found here: 
```
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
```