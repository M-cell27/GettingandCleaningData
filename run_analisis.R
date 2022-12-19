# Downloading and unzipping dataset

if(!file.exists("./data")){dir.create("./data")}

# Project Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip files
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading relevant libraries
library(tidyr)
library(plyr)
library(dplyr)

# Create one R script called run_analysis.R that does the following.
##Step 1
1.Merges the training and the test sets to create one data set.
# Read files
trainX<-read.table('./data/UCI HAR Dataset/train/X_train.txt')
trainY<-read.table('./data/UCI HAR Dataset/train/y_train.txt')
trainsubject<-read.table('./data/UCI HAR Dataset/train/subject_train.txt')

testX<-read.table('./data/UCI HAR Dataset/test/X_test.txt')
testY<-read.table('./data/UCI HAR Dataset/test/y_test.txt')
testsubject<-read.table('./data/UCI HAR Dataset/test/subject_test.txt')

# Read features
features<-read.table('./data/UCI HAR Dataset/features.txt')

# Change column names
names(trainX)<-features[,2]
names(trainY)<-"ActivityNo"
names(trainsubject)<-"VolunteerNo"

names(testX)<-features[,2]
names(testY)<-"ActivityNo"
names(testsubject)<-"VolunteerNo"

# Column Binding the subject and activity ids
train_data<-cbind(trainX,trainY,trainsubject)
test_data<-cbind(testX,testY,testsubject)

# Row binding train and test data
merged_dataset<-rbind(train_data,test_data)

## Step 2
2.-Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std_data<-merged_dataset[,names(merged_dataset)[grepl("mean\\(\\)|std\\(\\)|ActivityNo|VolunteerNo",names(merged_dataset))]]

## Step 3
3. Uses descriptive activity names to name the activities in the data set
activitylabels<-read.table('./data/UCI HAR Dataset/activity_labels.txt')
names(activitylabels)<-c("V1","ActivityLabel")
merged_activitylabel<-left_join(mean_std_data,activitylabels,by=c("ActivityNo"="V1"))

## Step 4
4. Appropriately labels the data set with descriptive variable names.

## Step 5
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Making a second tidy data set
mean_var_customer_activity<-merged_activitylabel %>% group_by(ActivityNo,ActivityLabel,VolunteerNo) %>% summarize_all(mean) 

# Writing second tidy data set in txt file
write.table(mean_var_customer_activity, "secTidySet.txt", row.name=FALSE)
