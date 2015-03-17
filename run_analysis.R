---
title: "Getting and Clenaing Data Course Project"
author: "Didac Busquets"
date: "16/03/2015"
output: html_document
---

## Reading the data 

# Load test and train files (X_ files)
x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")

# Load test and train files (y_ files)
y_test <- read.table("test/y_test.txt")
y_train <- read.table("train/y_train.txt")

## Merge the training and the test sets to create one data set

# Row bind test and train (only X part for now)
all_x_data <- rbind(x_test,x_train)

## Extract only the measurements on the mean and standard deviation for each measurement

# Read the features file 
features <- read.table("features.txt")

# And look for those variables corresponding to the mean or std deviation
mean_index <- grep("mean\\(", features[,2])
std_index <- grep("std", features[,2])

# Append both vectors to get a single one, and sort it so we have the variables in order
mean_std_index <- sort(append(mean_index,std_index))

# Get the corresponding variable names
col_names <- features[mean_std_index,2]

# Select only the mean or std dev variables 
mean_std_data <- all_x_data[,mean_std_index]

# And set the appropriate variables names
colnames(mean_std_data) <- col_names

# Read the subjects for train and test
subj_test <- read.table("test/subject_test.txt")
subj_train <- read.table("train/subject_train.txt")

# First row bind them, and then add them to mean_std_data
all_subj <- rbind(subj_test, subj_train)
mean_std_data$subject <- all_subj[,1]

# Bind the activity 

# Do the same for the y_ data (activity)
all_y_data <- rbind(y_test, y_train)
mean_std_data$activity <- all_y_data[,1]

## Use descriptive activity names to name the activities in the data set

# Read the activity labels
activities <- read.table("activity_labels.txt")

# Use them to factor the activity variable
mean_std_data$activity <- factor(mean_std_data$activity, 
                                levels=activities[,1], 
                                labels = activities[,2])

## Appropriately labels the data set with descriptive variable names

# For better readability replace the dash by underscore and remove ()
new_names <- gsub("-","_",gsub("\\(\\)", "", names(mean_std_data)))
names(mean_std_data) <- new_names

## Create a second, independent tidy data set with the average of each variable for each activity and each subject

averages <- aggregate(. ~ activity+subject, mean_std_data, mean)

## Write results to files

write.table(mean_std_data, file = "tidy_data.txt", row.name=FALSE)
write.table(averages, file = "averages_data.txt", row.name=FALSE)

## Print as output the average data set
averages