-Coursera-GettingAndCleaningData
================================

A course on collecting and cleaning data for downstream analysis and sharing

The goal of this project is to clean the UCI HAR data for later analysis.

Summary of data processing:
* Data downloaded from UCI machine learning repository.
* Train, Test is combined into one main data frame along with subject and activity columns.
* A reduced data frame which has only the mean and standard deviation was created from the main data frame.
* The feature names are edited to improve their redability.
* An independent tidy data set with the average of each variable for each activity and each subject is created and written into a text file.


The code analysis and data explanation can be found in the CookBook.md
Link: https://github.com/pavitrakumar78/-Coursera-GettingAndCleaningData/blob/master/CodeBook.md

The R code used to clean and process the data can be found in run_analysis.R
Link: https://github.com/pavitrakumar78/-Coursera-GettingAndCleaningData/blob/master/run_analysis.R
