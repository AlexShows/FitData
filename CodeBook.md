FitData CodeBook
================

Project Summary
---------------
Given a raw data set from fitness trackers, create a tidy data set and produce a summary of the data from the trackers. To use the script, place it into a folder alongside the raw data zip file and call the function process_raw_data() from within R. You can optionally specify the name of the zip file with the raw data, but if no zip file name is provided the default UCI HAR Dataset zip file name will be used.  

Prerequisites
-------------
Use of the run_analysis.R script assumes that you have R installed, along with several required libraries, including:
```
data.table
dplyr
sqldf
```
These libraries are required within the script and must be loadable for successful processing of the raw data file.  

Purpose and Scope
-----------------
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.   

Inputs
------
The run_analysis.R script has a function named process_raw_data which accepts a string indicating the zip file containing the raw data to be processed. The script then takes this zip file, extracts it into the working directory (that being the same directory as the location of the run_analysis.R file). If the file is not specified in the function call, the default name of the UCI HAR Dataset zip file will be used.  

Outputs
-------
The FitData Project produces a tidy data set using the run_analysis.R script, in the form of a file named tidyData.txt. The specifics of the summarized data are listed below in the Data Dictionary section of this file.  

Raw Data Origins
----------------
The raw data used for this project are collected from the accelerometers of the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
```
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
```
A direct link to the raw data for the project is found here: 
```
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
```

Operations
----------
The run_analysis.R script's function process_raw_data accepts a filename of the zip file containing raw data or looks for the default zip file name if one is not provided.   

The process_raw_data function then calls validate_and_unzip, which validates the zip file, unzips the contents into the working directory, and validates the ouput of the unzip operation. Further, this function removes the directories for the Inertial Signals from both the test and train data sets, as the inertial signals are extraneous to this exercise. Then the function renames the UCI HAR Dataset directory to simply 'data' for better legibility.  

Once the data is extracted into a known directory structure, the script merges the two data sets from the test and train directories into a single large data set using the merge_data function. It accomplishes this by first reading the X_test.txt and X_train.txt data into tables, followed by reading in the feature names from features.txt to use as the column names. It then reads both the test and train subjects into tables, and the test and train activity IDs from the y_test.txt and y_train.txt. The subject and activity tables correspond to the test and train data as they have the same number of rows. The test data is column bound with its corresponding subject IDs table and activity IDs table, along with appropriate column names, and the same steps to column bind subjects and activities into the train data is performed (with the corresponding tables for train data, not the data from test, which has a different number of rows). Finally, the test and train data are row bound together into a single large table and this merged data is returned from the merge_data function.

Then all of the columns except those representing a mean or standard deviation (according to their descriptions in features_info.txt and features.txt) are removed in the extract_data function by selecting only the subject ID, activity ID, and all mean and standard deviation columns. The extracted data is then returned to the process_raw_data function for further processing.  

After extracting the data, the activity IDs are used to create a new column with the activity name (a string) within the label_activities function using the data found in activity_labels.txt. This is performed with a simple lookup using the activityID as an index into a vector of activy names to create a vector of strings containing the activity names. This new vectors is then added to the data table provided to the function, and this updated table is returned.  

After creating activity labels, the variables are labeled with a dplyr select statement to reorder the columns, and an order statement to reorder first by the SubjectID and then by the ActivityID. These make the table easier to read, preview, and generally look nicer when outputting to a text file.  

Finally, all data for each mean and each standard deviation for each activity and each subject are averaged, such that there is a single average for each column by subject and activity. This is performed in the summarize_data function, which uses an outer loop of 30 and an inner loop of 6, corresponding to the 30 subjects and 6 activities in the raw data. This function uses sqldf to select a subset of the data so the mean can be performed on a per subject and per activity basis, using the summarise_each function. There are two concerns with summarise_each in use within the summarize_data function. First, there are warnings for the activity names not working within the mean function. This is handled by supressing warnings. Second, the summarise_each results in an NA for the activity name field, which is a string. Thus there is an additional step where the ActivityName is copied from the currentActivity into the single row that summarized that activity for that subject. This single row is then row bound into the tidy data table. Once the loop is complete, there are 180 rows which summarize all the means and standard deviations (as averages of all values per column after filtering). This result is the tidy data set. It is this data set that is output to the file tidyData.txt using write.table() with the row.names = FALSE option.  

Note that, with this sequence of operations, it is easy to read the tidy data back into R with a call to:
```
read.table('tidyData.txt', header=TRUE).  
```

Data Dictionary
---------------
The following data dictionary describes all the variables found in the tidy data set (tidyData.txt) output from the script. 

### SubjectID
A numeric identifier of the subject participating in the study. No personally identifiable information is available in the raw data, thus only the number of the study participant is known. This value is preserved from the raw data's subject_test.txt and subject_train.txt files.

### ActivityID
A numeric identifier of the activity for which the measurements were taken. These correspond to the string values in ActivityName, and are based on the activity_labels.txt file from the raw data.

### ActivityName
A string identifier (friendly name) of the activity for which the measurements were taken. The combination of this friendly name and the subject corresponds with the averages of all the proceeding values in the row. 

### tBodyAcc.mean...X
The mean of all mean accelerometer readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the X axis.  

### tBodyAcc.mean...Y
The mean of all mean accelerometer readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Y axis.  

### tBodyAcc.mean...Z
The mean of all mean accelerometer readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Z axis.  

### tGravityAcc.mean...X
The mean of all mean accelerometer readings from the gravity signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the X axis.  

### tGravityAcc.mean...Y
The mean of all mean accelerometer readings from the gravity signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Y axis.  

### tGravityAcc.mean...Z
The mean of all mean accelerometer readings from the gravity signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Z axis.  

### tBodyAccJerk.mean...X
Jerk signals are derived from the body linear acceleration, and this value is the mean of all mean Jerk readings from the body accelerometer X signals.  

### tBodyAccJerk.mean...Y
Jerk signals are derived from the body linear acceleration, and this value is the mean of all mean Jerk readings from the body accelerometer Y signals.  

### tBodyAccJerk.mean...Z
Jerk signals are derived from the body linear acceleration, and this value is the mean of all mean Jerk readings from the body accelerometer Z signals.

### tBodyGyro.mean...X
The mean of all mean gyroscope readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the X axis.

### tBodyGyro.mean...Y
The mean of all mean gyroscope readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Y axis.

### tBodyGyro.mean...Z
The mean of all mean gyroscope readings from the body signals, thus with all filters applied on the raw data. Note that this is a mean of multiple means sampled for the Z axis.

### tBodyGyroJerk.mean...X
Jerk signals are derived from the body angular velocity, and this value is the mean of all mean Jerk readings from the body accelerometer X signals.  

### tBodyGyroJerk.mean...Y
Jerk signals are derived from the body angular velocity, and this value is the mean of all mean Jerk readings from the body accelerometer Y signals.  

### tBodyGyroJerk.mean...Z
Jerk signals are derived from the body angular velocity, and this value is the mean of all mean Jerk readings from the body accelerometer Z signals.  

### tBodyAccMag.mean..
Magnitude signals are calculated using the Euclidean norm from the body linear acceleration, and this value is the mean of all mean magnitude readings from the body accelerometer.  

### tGravityAccMag.mean..
Magnitude signals are calculated using the Euclidean norm from the gravity linear acceleration, and this value is the mean of all mean magnitude readings from the gravity accelerometer.  

### tBodyAccJerkMag.mean..
Magnitude signals are calculated using the Euclidean norm from the body angular velocity, a jerk factor is derived, and this value is the mean of all mean magnitude readings from the body gyroscope. 

### tBodyGyroMag.mean..
Magnitude signals are calculated using the Euclidean norm from the body angular velocity, and this value is the mean of all mean magnitude readings from the body gyroscope. 

### tBodyGyroJerkMag.mean..
Magnitude signals are calculated using the Euclidean norm from the body angular velocity, a jerk factor is derived, and this value is the mean of all mean magnitude readings from the body gyroscope. 

### fBodyAcc.mean...X
The mean of all mean Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple means samples for the X axis.  

### fBodyAcc.mean...Y
The mean of all mean Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple means samples for the Y axis.

### fBodyAcc.mean...Z
The mean of all mean Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple means samples for the Z axis.

### fBodyAcc.meanFreq...X
Mean of the weighted average of the frequency components used in the FFT performed on the body accelerometer readings. Note that this is a mean of multiple weighted averages for the X axis.  

### fBodyAcc.meanFreq...Y
Mean of the weighted average of the frequency components used in the FFT performed on the body accelerometer readings. Note that this is a mean of multiple weighted averages for the Y axis.  

### fBodyAcc.meanFreq...Z
Mean of the weighted average of the frequency components used in the FFT performed on the body accelerometer readings. Note that this is a mean of multiple weighted averages for the Z axis.  

### fBodyAccJerk.mean...X
Mean of all mean FFTs for the body accelerometer's derived jerk value for the X axis.

### fBodyAccJerk.mean...Y
Mean of all mean FFTs for the body accelerometer's derived jerk value for the Y axis.

### fBodyAccJerk.mean...Z
Mean of all mean FFTs for the body accelerometer's derived jerk value for the Z axis.

### fBodyAccJerk.meanFreq...X
Mean of all weighted average frequency components for the FFT of the body accelerometer's derived jerk value for the X axis.  

### fBodyAccJerk.meanFreq...Y
Mean of all weighted average frequency components for the FFT of the body accelerometer's derived jerk value for the Y axis.  

### fBodyAccJerk.meanFreq...Z
Mean of all weighted average frequency components for the FFT of the body accelerometer's derived jerk value for the Z axis.  

### fBodyGyro.mean...X
Mean of all mean FFTs for the body gyroscope readings for the X axis.  

### fBodyGyro.mean...Y
Mean of all mean FFTs for the body gyroscope readings for the Y axis.  

### fBodyGyro.mean...Z
Mean of all mean FFTs for the body gyroscope readings for the Z axis.  

### fBodyGyro.meanFreq...X
Mean of all weighted average frequency components for the FFT of the body gyroscope readings for the X axis.  

### fBodyGyro.meanFreq...Y
Mean of all weighted average frequency components for the FFT of the body gyroscope readings for the Y axis.  

### fBodyGyro.meanFreq...Z
Mean of all weighted average frequency components for the FFT of the body gyroscope readings for the Z axis.  

### fBodyAccMag.mean..
Mean of all means of the Euclidean norm magnitude of body accelerometer readings.  

### fBodyAccMag.meanFreq..
Mean of all weighted average frequency components for the FFT of the Euclidean norm magnitude of body accelerometer readings.  

### fBodyBodyAccJerkMag.mean..
Mean of all means of the derived jerk factor Euclidean norm magnitude of body accelerometer readings.  

### fBodyBodyAccJerkMag.meanFreq..
Mean of all weighted average frequency components for the FFT of the derived jerk factor Euclidean norm magnitude of body accelerometer readings.  

### fBodyBodyGyroMag.mean..
Mean of all means of the derived jerk factor Euclidean norm magnitude of body gyroscope readings.  

### fBodyBodyGyroMag.meanFreq..
Mean of all weighted average frequency components for the FFT of the derived jerk factor Euclidean norm magnitude of body gyroscope readings.  

### fBodyBodyGyroJerkMag.mean..
Mean of all means of the derived jerk factor Euclidean norm magnitude of body gyroscope readings.  

### fBodyBodyGyroJerkMag.meanFreq..
Mean of all weighted average frequency components for the FFT of the derived jerk factor Euclidean norm magnitude of body gyroscope readings.  

### angle.tBodyAccMean.gravity.
Mean of all angles of gravity for the body accelerometer means.

### angle.tBodyAccJerkMean..gravityMean.
Mean of all angles of mean of gravity for the body accelerometers derived jerk factor based on linear acceleration.  

### angle.tBodyGyroMean.gravityMean.
Mean of all angles of mean of gravity for the body gyroscope derived jerk factor based on linear acceleration.  

### angle.tBodyGyroJerkMean.gravityMean.
Mean of all angles of mean of gravity for the body gyroscope derived jerk factor based on linear acceleration.  

### angle.X.gravityMean.
Mean of all means of the X-axis of gravity angle measurements.  

### angle.Y.gravityMean.
Mean of all means of the Y-axis of gravity angle measurements.  

### angle.Z.gravityMean.
Mean of all means of the Z-axis of gravity angle measurements.  

### tBodyAcc.std...X
Mean of all standard deviations of X axis measurements for all body accelerometer readings.  

### tBodyAcc.std...Y
Mean of all standard deviations of Y axis measurements for all body accelerometer readings.  

### tBodyAcc.std...Z
Mean of all standard deviations of Z axis measurements for all body accelerometer readings.  

### tGravityAcc.std...X
Mean of all standard deviations of X axis measurements for all gravity accelerometer readings.  

### tGravityAcc.std...Y
Mean of all standard deviations of Y axis measurements for all gravity accelerometer readings.  

### tGravityAcc.std...Z
Mean of all standard deviations of Z axis measurements for all gravity accelerometer readings.  

### tBodyAccJerk.std...X
Mean of all standard deviations of X axis measurements for all derived jerk factors for body accelerometer readings.  

### tBodyAccJerk.std...Y
Mean of all standard deviations of Y axis measurements for all derived jerk factors for body accelerometer readings.  

### tBodyAccJerk.std...Z
Mean of all standard deviations of Z axis measurements for all derived jerk factors for body accelerometer readings.  

### tBodyGyro.std...X
Mean of all standard deviations of X axis measurements for all body gyroscope readings.  

### tBodyGyro.std...Y
Mean of all standard deviations of Y axis measurements for all body gyroscope readings.  

### tBodyGyro.std...Z
Mean of all standard deviations of Z axis measurements for all body gyroscope readings.  

### tBodyGyroJerk.std...X
Mean of all standard deviations of X axis measurements for all derived jerk factors for body gyroscope readings.  

### tBodyGyroJerk.std...Y
Mean of all standard deviations of Y axis measurements for all derived jerk factors for body gyroscope readings.  

### tBodyGyroJerk.std...Z
Mean of all standard deviations of Z axis measurements for all derived jerk factors for body gyroscope readings.  

### tBodyAccMag.std..
Mean of all standard deviation of body accelerometer magnitude computed using Euclidean norm of the body accelerometer signals.  

### tGravityAccMag.std..
Mean of all standard deviation of gravity accelerometer magnitude computed using Euclidean norm of the gravity accelerometer signals.  

### tBodyAccJerkMag.std..
Mean of all standard deviation of all derived jerk factors of body accelerometer magnitude computed using Euclidean norm of the body accelerometer signals.  

### tBodyGyroMag.std..
Mean of all standard deviation of all derived jerk factors of body gyroscope magnitude computed using Euclidean norm of the body gyroscope signals.  

### tBodyGyroJerkMag.std..
Mean of all standard deviation of all derived jerk factors of body gyroscope magnitude computed using Euclidean norm of the body gyroscope signals.  

### fBodyAcc.std...X
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple standard deviations for the X axis.  

### fBodyAcc.std...Y
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple standard deviations for the Y axis.  

### fBodyAcc.std...Z
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer. Note that this is a mean of multiple standard deviations for the Z axis.  

### fBodyAccJerk.std...X
The mean of all standard deviations of Fast Fourier Transform signal processing results for the derived jerk factor of the body accelerometer. Note that this is a mean of multiple standard deviations for the X axis.  

### fBodyAccJerk.std...Y
The mean of all standard deviations of Fast Fourier Transform signal processing results for the derived jerk factor of the body accelerometer. Note that this is a mean of multiple standard deviations for the Y axis.  

### fBodyAccJerk.std...Z
The mean of all standard deviations of Fast Fourier Transform signal processing results for the derived jerk factor of the body accelerometer. Note that this is a mean of multiple standard deviations for the Z axis.  

### fBodyGyro.std...X
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer for the X axis.

### fBodyGyro.std...Y
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer for the Y axis.

### fBodyGyro.std...Z
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer for the Z axis.

### fBodyAccMag.std..
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer Euclidean norm magnitude.  

### fBodyBodyAccJerkMag.std..
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body accelerometer derived jerk factor Euclidean norm magnitude.  

### fBodyBodyGyroMag.std..
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body gyroscope Euclidean norm magnitude.  

### fBodyBodyGyroJerkMag.std..
The mean of all standard deviations of Fast Fourier Transform signal processing results for the body gyroscope derived jerk factor Euclidean norm magnitude.  

