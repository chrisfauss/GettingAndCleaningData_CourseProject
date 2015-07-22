# READ ME Document

* This document describes the code written in the R-script run_analysis.R for the course project of "Getting and Cleaning Data".
* Additional libraries used: library(dplyr)

## Step 0: Preparation
        * Working Directory needs to be in /UCI HAR Dataset
        * Reading in the required files from the directory /UCI HAR Dataset: activity_labels.txt, features.txt
        * Saving the results of those data sets in 2 vaiables: activity_labels, features
        * Reading in the files from the subfolder "test": subject_test.txt, X_test.txt, Y_test.txt
        * Saving the results of those data sets in 3 vaiables: subject_test, x_test, y_test
        * Reading in the files from the subfolder "train": subject_train.txt, X_train.txt, Y_train.txt
        * Saving the results of those data sets in 3 vaiables: subject_train, x_train, y_train
        
## Step 1: Merge the training and the test sets to create one data set
        * Before training and test data set can be merged each data set needs to be added with the following information 
        * Starting with test data set:
        * a. Add the variable names to the data set. Set names of features on x_test and "subject_ID" on subject_test and "activity" on y_test
        * b. Add the acitvities IDs to the data set. Merging x_test with y_test. Save result in variable test_all_1.
        * c. Add the subjects to the data set. Merging test_all_1 with subject_test. Save result in variable test_all_2.
        * Continueing with train data set:
        * d. Add the variable names to the data set. Set names of features on x_train and "subject_ID" on subject_train and "activity" on y_train
        * e. Add the acitvities IDs to the data set. Merging x_train with y_train. Save result in variable train_all_1.
        * f. Add the subjects to the data set. Merging train_all_1 with subject_train. Save result in variable train_all_2.
        * Now the test and train data has the required information added and can now be merged together
        * The enriched data sets need to be merged: test_all_2 and train_all_2
        * The merging is saved in the varialbe test_train_data
                
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement
        * From the 561 measurements all measurements which have an "mean()" or an "std()" need to be extracted.
        * Getting the feature names from the list of features (=file feature) and store it in the variable feature_names.
        * Extracting the position of the feature names which have "mean()" included. Result stored in feature_names_mean.
        * Extracting the position of the feature names which have "std()" included. Result stored in feature_names_std.
        * Creating an integer vector feature_names_mean_std with all the positions which have either mean() or std() in their feature name.
        * Since we need to apply this vector for subsetting from test_train_data we need to raise every position by 2.
        * This needs to be done because we have subject_ID and activity as first columns of the data set.
        * The result is stored in the same variable
        * Applying the integer vector feature_names_mean_std on the test_train_data data set.
        * Subsetting just the first 2 columns (subject_ID, activity) and the variables with either mean() or std() in their feature name.
        * The result is stored in the variable test_train_data_2
        
## Step 3: Use descriptive activity names to name the activities in the data set
        * In order to do this the IDs in test_train_data_2$activity need to be replace by the activity_labels stored in activity_labels
        * The numbers 1-6 will then be replaced by describtive names
        * The replacement is done with the following steps:
			* Merging data sets test_train_data_2 with activity labes on the variables activity and V1. The result is stored in test_train_data_3
			* A new columns V2 is added to test_train_data_3 which has the activity_labels in it. Those values should be written into activity
			* Now we rearrange the columns 1 and 2 so that the subject_ID is column 1 and activity column 2.
			* With subsetting in total columns 1 to 68 we get rid of the new, temporarily added column V2. 
			* Result is updated in test_train_data_3.
		* We sort test_train_data_3 by subject_ID and store it in the same variable.
        
## Step 4: Appropriately label the data set with descriptive variable names
        * The variable names are alraedy set up as descriptive names
        
## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        * Based on the data set test_train_4 a new tidy data set needs to be greated.
        * It should group the existing data set on subject_ID and activity. The variables should be calculated as mean of the group.
        * This means that we will get a for every subject (30) each of the 6 different activities and for each of those.
        * For all those 6 activities per subject we will have an aggregation of the variables as mean.
        * The test_train_data_final data set needs to be written into a txt-file, not showing row names