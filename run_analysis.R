library(dplyr)

## Step 0: Preparation

        ## Working Directory needs to be in /UCI HAR Dataset
        
        ## Reading in the required files from the directory /UCI HAR Dataset: activity_labels.txt, features.txt
        ## Saving the results of those data sets in 2 vaiables: activity_labels, features
        activity_labels <- read.table("activity_labels.txt") ## 6 rows, 2 columns
        features <- read.table("features.txt") ## 561 rows, 2 columns
        
        ## Reading in the files from the subfolder "test": subject_test.txt, X_test.txt, Y_test.txt
        ## Saving the results of those data sets in 3 vaiables: subject_test, x_test, y_test
        subject_test <- read.table("./test/subject_test.txt")
        x_test <- read.table("./test/X_test.txt") ## 2947 rows, 561 columns
        y_test <- read.table("./test/Y_test.txt") ## 2947 rows, 1 column
        
        ## Reading in the files from the subfolder "train": subject_train.txt, X_train.txt, Y_train.txt
        ## Saving the results of those data sets in 3 vaiables: subject_train, x_train, y_train
        subject_train <- read.table("./train/subject_train.txt") 
        x_train <- read.table("./train/X_train.txt") ## 7352 rows, 561 columns
        y_train <- read.table("./train/Y_train.txt") ## 7352 rows, 1 column

        
## Step 1: Merge the training and the test sets to create one data set
        
        ## Before training and test data set can be merged each data set needs to be added with the following information 
        ## Starting with test data set:
        ## a. Add the variable names to the data set. Set names of features on x_test and "subject_ID" on subject_test and "activity" on y_test
        ## b. Add the acitvities IDs to the data set. Merging x_test with y_test. Save result in variable test_all_1.
        ## c. Add the subjects to the data set. Merging test_all_1 with subject_test. Save result in variable test_all_2.
        
        ## Step 1a.:
        names(x_test) <- as.vector(features[,2])
        names(subject_test) <- c("subject_ID") 
        names(y_test) <- c("activity")
        
        ## Step 1b.:
        test_all_1 <- cbind(y_test, x_test)
        
        ## Step 1c.:
        test_all_2 <- cbind(subject_test, test_all_1)
        
        ## Continueing with train data set:
        ## d. Add the variable names to the data set. Set names of features on x_train and "subject_ID" on subject_train and "activity" on y_train
        ## e. Add the acitvities IDs to the data set. Merging x_train with y_train. Save result in variable train_all_1.
        ## f. Add the subjects to the data set. Merging train_all_1 with subject_train. Save result in variable train_all_2.
        
        ## Step 1d.:
        names(x_train) <- as.vector(features[,2])
        names(subject_train) <- c("subject_ID") 
        names(y_train) <- c("activity")
        
        ## Step 1e.:
        train_all_1 <- cbind(y_train, x_train)
        
        ## Step 1f.:
        train_all_2 <- cbind(subject_train, train_all_1)
        
        ## Now the test and train data has the required information added and can now be merged together
        ## The enriched data sets need to be merged: test_all_2 and train_all_2
        ## The merging is saved in the varialbe test_train_data
        test_train_data <- rbind(test_all_2, train_all_2)
        
        
## Step 2: Extract only the measurements on the mean and standard deviation for each measurement
        
        ## From the 561 measurements all measurements which have an "mean()" or an "std()" need to be extracted.
        ## Getting the feature names from the list of features (=file feature) and store it in the variable feature_names.
        feature_names <- as.vector(features$V2)
        
        ## Extracting the position of the feature names which have "mean()" included. Result stored in feature_names_mean.
        feature_names_mean <- grep("[m][e][a][n][(]", feature_names)
        ## Extracting the position of the feature names which have "std()" included. Result stored in feature_names_std.
        feature_names_std <- grep("std()", feature_names)
        ## Creating an integer vector feature_names_mean_std with all the positions which have either mean() or std() in their feature name.
        feature_names_mean_std <- c(feature_names_mean,feature_names_std)
        ## Since we need to apply this vector for subsetting from test_train_data we need to raise every position by 2.
        ## This needs to be done because we have subject_ID and activity as first columns of the data set.
        ## The result is stored in the same variable
        feature_names_mean_std <- feature_names_mean_std+c(2)
        
        ## Applying the integer vector feature_names_mean_std on the test_train_data data set.
        ## Subsetting just the first 2 columns (subject_ID, activity) and the variables with either mean() or std() in their feature name.
        ## The result is stored in the variable test_train_data_2
        test_train_data_2 <- test_train_data[,c(1,2,feature_names_mean_std)]
        
## Step 3: Use descriptive activity names to name the activities in the data set
        
        ## In order to do this the IDs in test_train_data_2$activity need to be replace by the activity_labels stored in activity_labels
        ## The numbers 1-6 will then be replaced by describtive names
        ## The replacement is done with the following steps:
        ## Merging data sets test_train_data_2 with activity labes on the variables activity and V1. The result is stored in test_train_data_3
        test_train_data_3 <- merge(test_train_data_2,activity_labels, by.x = "activity", by.y = "V1")
        ## A new columns V2 is added to test_train_data_3 which has the activity_labels in it. Those values should be written into activity
        test_train_data_3 <- mutate(test_train_data_3, activity = V2)
        ## Now we rearrange the columns 1 and 2 so that the subject_ID is column 1 and activity column 2.
        ## With subsetting in total columns 1 to 68 we get rid of the new, temporarily added column V2. 
        ## Result is updated in test_train_data_3.
        test_train_data_3 <- test_train_data_3[,c(2,1,3:68)]
        ## We sort test_train_data_3 by subject_ID and store it in the same variable.
        test_train_data_4 <- arrange(test_train_data_3,subject_ID)
        
## Step 4: Appropriately label the data set with descriptive variable names
        ## The variable names are alraedy set up as descriptive names
        
## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        ## Based on the data set test_train_4 a new tidy data set needs to be greated.
        ## It should group the existing data set on subject_ID and activity. The variables should be calculated as mean of the group.
        ## This means that we will get a for every subject (30) each of the 6 different activities and for each of those.
        ## For all those 6 activities per subject we will have an aggregation of the variables as mean.
        test_train_data_final <- test_train_data_4 %>% group_by(subject_ID) %>% group_by(activity, add = TRUE) %>% summarise_each(funs(mean))
        
        ## The test_train_data_final data set needs to be written into a txt-file, not showing row names
        write.table(test_train_data_final, file = "courseProject_tidy_data_set.txt", sep = ",", row.name=FALSE)

        
