# Code book for analysis


## Contents
* Data Sources and Background - source of the data, two paragraphs directly quoted from the README provided by the experiment's original autgors, description of the 8 files used for this project
* Data processing and transformation - pseudo-code for the run_analysis.R script, including variable renaming
* Contents of the final tidyData - description of the final tidyData set, including dimensions and variables 


## Data Sources and Background
Data is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data is based on work originally conducted by:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for further details

Quoting directly from README in ZIP file from download, "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain."

The downloaded data is a ZIP file which creates a folder "UCI HAR Dataset".  There are two sub-folders, "test" and "train".  For purposes of this project, we are asked to ignore Inertial Signals, a further sub-folder contained under test/ and train/

The main folder of the download includes a README and a features_info.txt that describes the various measurements taken.  There are also 8 space-delimited text files (no headers) of relevance for the requested project work:

* test/X_test.txt has 2947 rows and 561 columns, representing 561 measurements taken at various times for subject-activity
* test/y_test.txt has 2947 rows and 1 column, containing the activity code associated to each row in X_test
* test/subj_test.txt has 2947 rows and 1 column, containing the subject associated to each row in X_test
* train/X_train.txt has 7352 rows and 561 columns, representing 561 measurements taken at various times for subject-activity
* train/y_train.txt has 7352 rows and 1 column, containing the activity code associated to each row in X_train
* train/subj_train.txt has 7352 rows and 1 column, containing the subject associated to each row in X_train
* activity_labels.txt has 6 rows and 2 columns, containing a map from activity number to activity description
* features.txt has 561 rows and 2 columns, containing a map from column number to column description


## Data Processing and Transformations
The script run_analysis.R included in this repo was run on 28-Jan-2016 using 64-bit R 3.2.3 on a Windows 7 machine.  The package dplyr is required.

The overall processing is to load these raw data files and then piece them together like a puzzle.  Specifically, the following actions are performed in the script:

* Load the raw data files as space-delimited text and confirm that dimensions are as expected
* Use features to label the columns of X_test and X_train
* Create useTestData by binding subj_test (variable subject), y_test (variable activity id), and X_test (main data)
* Create useTrainData by binding subj_train (variable subject), y_train (variable activity id), and X_train (main data)
* Create useData by row-binding useTestData, useTrainData
* Create an easy to read activity name by mapping activityID in useData against the activity_labels file

The 561 measasurement columns are then analyzed for whether they contain the string mean() or std().  There are 66 columns that meet this "or" criteria, and the other 495 measurement columns are discarded.

For simplicity of reading, measurements starting with tBody are renamed as timeBody, measurements starting with fBody are renamed as freqBody, and measurements starting with tGravity are renamed as timeGravity.  The () were extracted out of the variable names, and the dash(-) were converted to underscore(_) for easier use without requiring quoting.  The _ were left in the variable names since timeBodyAcc_mean_X is more readable than timeBodyAccmeanX.

Lastly, a dataset tidyData is creating using group_by(subject,activity) and summzrize_each(funs(mean)) using dplyr.  This final dataset contains 180 rows (30 subjects x 6 activities) and 68 columns (subject, activity, 66 mean or std measurements).  The data displayed in the measurement columns is the mean for that measurement across multiple raw records for subject and activity


## Contents of the final tidyData

The tidyData file contains the average over multiple samples for 66 measurements, summarized by subject (number from 1-30) and activity (one of 6 activities monitored).  Each subject-activity combination exists so there are 180 rows.

Adapted from features_info.txt in ZIP file:

Raw variables calculated from the time domain start with t.  FFT applied to raw variables produces additional variables that start with f.  To simplify reading, this script converts t -> time and f -> freq at the front of the variable names.

As described in the README, signals were split as to whether they are Body acceleration or Gravity accelerations.  This is reflected by a variable containing the word Body or Gravity.

As described in the README, signals came from the accelerometer or the gyroscope.  This is reflected by a variable name containing the word Acc or Gyro.

Jerk and Mag (magnitude) componenst were calculated for select variables.  The features_info.txt explains this process as "Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag)."

Accordingly, the final variables included in tidyData are:
* subject - integer ranging from 1-30 corresponding to 30 unique subjects
* activity - character taking on one of the 6 unique activities studied
* timeGravityAcc_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the XYZ components of gravity
* timeGravityAccMag_[mean or std] - 2 variables representing the total magnitude of gravity
* timeBodyAcc_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the XYZ components of body acceleration
* timeBodyAccJerk_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the XYZ jerk components of body acceleration
* timeBodyAccMag_[mean or std] - 2 variables representing the total magnitude of body acceleration
* timeBodyAccJerkMag_[mean or std] - 2 variables representing the total magnitude of jerk body acceleration
* timeBodyGyro_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the XYZ components of gyroscope
* timeBodyGyroJerk_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the XYZ jerk components of gyroscope
* timeBodyGyroMag_[mean or std] - 2 variables representing the total magnitude of gyroscope
* timeBodyGyroJerkMag_[mean or std] - 2 variables representing the total magnitude of gyroscope jerk
* freqBodyAcc_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the FFT of XYZ components of body acceleration
* freqBodyAccJerk_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the FFT of XYZ jerk components of body acceleration
* freqBodyAccMag_[mean or std] - 2 variables representing the total magnitude of FFT of body acceleration
* freqBodyGyro_[mean or std]_[X or Y or Z] - 6 variables with the mean/std of the FFT of XYZ components of gyroscope
* freqBodyBodyAccJerkMag_[mean or std] - 2 variables with the mean/std of the FFT of Body Jerk magnitude
* freqBodyBodyGyroMag_[mean or std] - 2 variables with the mean/std of the FFT of Gryo magnitude
* freqBodyBodyGyroJerkMag_[mean or std] - 2 variables with the mean/std of the FFT of Gyro Jerk magnitude

As per the information from the experiment authors, "- Features are normalized and bounded within [-1,1]."  As such, there is no dimension or unit to the variables.  No further modifications to this data have been performed
