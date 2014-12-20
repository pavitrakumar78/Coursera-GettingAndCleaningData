#Getting And Cleaning Data

#Project Code Book

###Data Gathering and Information:

The data set to be processed and cleaned for this asignment is available in the link given below:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The data is provided by UCI Machine Learning Repository

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years.  
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a 
constant rate of 50Hz. The experiments have been video-recorded to label the data manually. 

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating 
the training data and 30% the test data. The sensor signals (accelerometer and gyroscope) were pre-processed by applying 
noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. 
The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff 
frequency was used. From each window, a vector of features was obtained by calculating variables from the time 
and frequency domain. 

The files in the UCI.zip that will be used for this project are:

* 'README.txt'
* 'features_info.txt':   Information about all the features.
* 'features.txt':        List of all the features.
* 'activity_labels.txt': Maps the class labels with their activity name.
* 'train/X_train.txt':   Training set.
* 'train/y_train.txt':   Training labels.
* 'test/X_test.txt':     Test set.
* 'test/y_test.txt':     Test labels.

###Data Processing

The given data is first loaded in R

```r
features <- read.table("features.txt")

subject_train <- read.table("train/subject_train.txt")

X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")

X_test<- read.table("test/X_test.txt")
y_test<- read.table("test/y_test.txt")

activity_labels <- read.table("activity_labels.txt")
```

We then merge the subject_train, y_train, X_train into one data frame and subject_test, y_test, X_test into another.

```r
train_data <- data.frame(cbind(subject_train,y_train,X_train))

test_data <- data.frame(cbind(subject_test,y_test,X_test))
```

The assignment requires us to combine the given test and data set into one main data frame.

```r
mdf <- data.frame(rbind(train_data,test_data))
```
Now we assign the feature names to our main data frame using the data from `features.txt`
Since `feature.txt` only has the sensor values, we append 2 extra columns namely subject and activity  
to complete out main data frame's feature list

```
feature_list <- c("subject","activity",as.vector(features$V2))

names(mdf) <- feature_list
```
Now the merged and processed main data frame has:

10299 Rows and 563 Columns

###Cleaning Data

It is required to extract only the mean and standard deviation for each measurement.
So, we use grep commands to extract the column names and subset the main data frame accordingly.

```r
std_features <- grep("std()",feature_list,value = T,fixed = T)
mean_features <- grep("mean()",feature_list,value = T,fixed = T)

updated_feature_list <- c("subject","activity",std_features,mean_features)

reduced_mdf <- mdf[updated_feature_list]
names(reduced_mdf) <- updated_feature_list
```
The reduced data frame now has:

10299 Rows and 68 Columns

To improve the readability of data we appropriately name the columns of the newly created data frame.

```r
for(r in c("X","Y","Z","")){
	names(reduced_mdf) <- gsub(paste("-std()-",r,sep=""),paste(paste(".",r,sep=""),".std",sep=""),names(reduced_mdf),fixed = TRUE)
	names(reduced_mdf) <- gsub(paste("-mean()-",r,sep=""),paste(paste(".",r,sep=""),".mean",sep=""),names(reduced_mdf),fixed = TRUE)
}

names(reduced_mdf) <- gsub("-",".",names(reduced_mdf),fixed = TRUE)
names(reduced_mdf) <- gsub("()","",names(reduced_mdf),fixed = TRUE)
```

Column name which looked like:

```
 [1] "subject"                     "activity"                   
 [3] "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
 [5] "tBodyAcc-std()-Z"            "tGravityAcc-std()-X"        
 [7] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
 [9] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"       
[11] "tBodyAccJerk-std()-Z"        "tBodyGyro-std()-X"          
[13] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[15] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"      
[17] "tBodyGyroJerk-std()-Z"       "tBodyAccMag-std()"          
[19] "tGravityAccMag-std()"        "tBodyAccJerkMag-std()"      
[21] "tBodyGyroMag-std()"          "tBodyGyroJerkMag-std()"     
[23] "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
[25] "fBodyAcc-std()-Z"            "fBodyAccJerk-std()-X"       
[27] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[29] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
[31] "fBodyGyro-std()-Z"           "fBodyAccMag-std()"          
[33] "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-std()"     
[35] "fBodyBodyGyroJerkMag-std()"  "tBodyAcc-mean()-X"          
[37] "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"          
[39] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
[41] "tGravityAcc-mean()-Z"        "tBodyAccJerk-mean()-X"      
[43] "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
[45] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[47] "tBodyGyro-mean()-Z"          "tBodyGyroJerk-mean()-X"     
[49] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"     
[51] "tBodyAccMag-mean()"          "tGravityAccMag-mean()"      
[53] "tBodyAccJerkMag-mean()"      "tBodyGyroMag-mean()"        
[55] "tBodyGyroJerkMag-mean()"     "fBodyAcc-mean()-X"          
[57] "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"          
[59] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[61] "fBodyAccJerk-mean()-Z"       "fBodyGyro-mean()-X"         
[63] "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
[65] "fBodyAccMag-mean()"          "fBodyBodyAccJerkMag-mean()" 
[67] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroJerkMag-mean()"
```
 
was changed to a more readable version like the one below:

```
 [1] "subject"                   "activity"                 
 [3] "tBodyAcc.X.std"            "tBodyAcc.Y.std"           
 [5] "tBodyAcc.Z.std"            "tGravityAcc.X.std"        
 [7] "tGravityAcc.Y.std"         "tGravityAcc.Z.std"        
 [9] "tBodyAccJerk.X.std"        "tBodyAccJerk.Y.std"       
[11] "tBodyAccJerk.Z.std"        "tBodyGyro.X.std"          
[13] "tBodyGyro.Y.std"           "tBodyGyro.Z.std"          
[15] "tBodyGyroJerk.X.std"       "tBodyGyroJerk.Y.std"      
[17] "tBodyGyroJerk.Z.std"       "tBodyAccMag.std"          
[19] "tGravityAccMag.std"        "tBodyAccJerkMag.std"      
[21] "tBodyGyroMag.std"          "tBodyGyroJerkMag.std"     
[23] "fBodyAcc.X.std"            "fBodyAcc.Y.std"           
[25] "fBodyAcc.Z.std"            "fBodyAccJerk.X.std"       
[27] "fBodyAccJerk.Y.std"        "fBodyAccJerk.Z.std"       
[29] "fBodyGyro.X.std"           "fBodyGyro.Y.std"          
[31] "fBodyGyro.Z.std"           "fBodyAccMag.std"          
[33] "fBodyBodyAccJerkMag.std"   "fBodyBodyGyroMag.std"     
[35] "fBodyBodyGyroJerkMag.std"  "tBodyAcc.X.mean"          
[37] "tBodyAcc.Y.mean"           "tBodyAcc.Z.mean"          
[39] "tGravityAcc.X.mean"        "tGravityAcc.Y.mean"       
[41] "tGravityAcc.Z.mean"        "tBodyAccJerk.X.mean"      
[43] "tBodyAccJerk.Y.mean"       "tBodyAccJerk.Z.mean"      
[45] "tBodyGyro.X.mean"          "tBodyGyro.Y.mean"         
[47] "tBodyGyro.Z.mean"          "tBodyGyroJerk.X.mean"     
[49] "tBodyGyroJerk.Y.mean"      "tBodyGyroJerk.Z.mean"     
[51] "tBodyAccMag.mean"          "tGravityAccMag.mean"      
[53] "tBodyAccJerkMag.mean"      "tBodyGyroMag.mean"        
[55] "tBodyGyroJerkMag.mean"     "fBodyAcc.X.mean"          
[57] "fBodyAcc.Y.mean"           "fBodyAcc.Z.mean"          
[59] "fBodyAccJerk.X.mean"       "fBodyAccJerk.Y.mean"      
[61] "fBodyAccJerk.Z.mean"       "fBodyGyro.X.mean"         
[63] "fBodyGyro.Y.mean"          "fBodyGyro.Z.mean"         
[65] "fBodyAccMag.mean"          "fBodyBodyAccJerkMag.mean" 
[67] "fBodyBodyGyroMag.mean"     "fBodyBodyGyroJerkMag.mean"
```

Unnecessary characters like `()` and `-` were removed and the position of property i.e `mean`, `std` and the dimension `X`,`Y`
and `Z` were changed so that we can easily understand the meaning of the variable.

Also, the activity labels are mapped (as given below) to the ones given in `activity.txt` 


*  1  -> WALKING
*  2  -> WALKING_UPSTAIRS
*  3  -> WALKING_DOWNSTAIRS
*  4  -> SITTING
*  5  -> STANDING
*  6  -> LAYING


```r
reduced_mdf$activity <- activity_labels[reduced_mdf$activity,2]
```
###Generating Tidy Data

It was required to make an independent tidy data set with the average of each variable for each activity and each subject.

```r
sub_iter = 1:30

tidy_df = data.frame(matrix(nrow=0,ncol=length(names(reduced_mdf))))

c <- 1
k <- dim(reduced_mdf)[2]

for(sub in sub_iter){
	for(act in activity){
		# extracting all sensor values for a given subject and an activity
		temp <- reduced_mdf[reduced_mdf$subject == sub & reduced_mdf$activity == act,3:k]
		avg_values <- colMeans(temp)
		tidy_df[c,1] <- sub
		tidy_df[c,2] <- act
		tidy_df[c,3:k] <- avg_values
		c<- c+1		
	}
}

names(tidy_df) <- names(reduced_mdf)
tidy_df <- data.frame(tidy_df)
```

The required tidy data set was created by subsetting the reduced main data frame obtained from `Cleaning Data` section  
with respect to each subject for each activity and then taking the average by column of that subsetted data  
and appending it to a new data frame (which is our tidy data) along with the respective subject and activity values.

The tidy data frame now has:

180 Rows and 68 Columns

(i.e there are 30 subjects, we are required to average the sensor data for each of the activity (totally 6) for each of the 
  subjects so 30 * 6 = 180, and the number of columns stay the same since they are just column wise average)
  
This tidy data frame is written to a `tidy_df.txt` text file.

```r
write.table(tidy_df, file="tidy.txt", sep="\t")
```


###Explanation of variables and data

The dimensions of train data:
7352  561

The dimensions of test data:
2947  561

The dimensions of subject data(test):
2947    1

The dimensions of subject data(train):
7352    1

The the above specifications, we can infer that after merging the test,train and subject data we  
get a main data frame of dimensions:

10299 563

(7352 + 2947 and 561 + 1+ 1)

Features:

* tBodyAcc-XY		x 3  
* tGravityAcc-XY	x 3  
* tBodyAccJerk-XY	x 3  
* tBodyGyro-XY		x 3  
* tBodyGyroJerk-XY	x 3  
* tBodyAccMag          
* tGravityAccMag        
* tBodyAccJerkMag     
* tBodyGyroMag           
* tBodyGyroJerkMag        
* fBodyAcc-XY		x 3  
* fBodyAccJerk-XY	x 3  
* fBodyGyro-XYZ 	x 3  
* fBodyAccMag           
* fBodyAccJerkMag       
* fBodyGyroMag         
* fBodyGyroJerkMag      

For our reduced data set only mean and standard deviation was required.
From the above table we can see that we have a total of 33 basic features and for each of these there is a   
mean and a standard deviation.

Total = 33 * 2 + 1 + 1 = 68 columns in the reduced data set.

The extra 2 columns are activity label and subject.

List of all the features of the reduced data set after cleaning:

```
 [1] "subject"                   "activity"                 
 [3] "tBodyAcc.X.std"            "tBodyAcc.Y.std"           
 [5] "tBodyAcc.Z.std"            "tGravityAcc.X.std"        
 [7] "tGravityAcc.Y.std"         "tGravityAcc.Z.std"        
 [9] "tBodyAccJerk.X.std"        "tBodyAccJerk.Y.std"       
[11] "tBodyAccJerk.Z.std"        "tBodyGyro.X.std"          
[13] "tBodyGyro.Y.std"           "tBodyGyro.Z.std"          
[15] "tBodyGyroJerk.X.std"       "tBodyGyroJerk.Y.std"      
[17] "tBodyGyroJerk.Z.std"       "tBodyAccMag.std"          
[19] "tGravityAccMag.std"        "tBodyAccJerkMag.std"      
[21] "tBodyGyroMag.std"          "tBodyGyroJerkMag.std"     
[23] "fBodyAcc.X.std"            "fBodyAcc.Y.std"           
[25] "fBodyAcc.Z.std"            "fBodyAccJerk.X.std"       
[27] "fBodyAccJerk.Y.std"        "fBodyAccJerk.Z.std"       
[29] "fBodyGyro.X.std"           "fBodyGyro.Y.std"          
[31] "fBodyGyro.Z.std"           "fBodyAccMag.std"          
[33] "fBodyBodyAccJerkMag.std"   "fBodyBodyGyroMag.std"     
[35] "fBodyBodyGyroJerkMag.std"  "tBodyAcc.X.mean"          
[37] "tBodyAcc.Y.mean"           "tBodyAcc.Z.mean"          
[39] "tGravityAcc.X.mean"        "tGravityAcc.Y.mean"       
[41] "tGravityAcc.Z.mean"        "tBodyAccJerk.X.mean"      
[43] "tBodyAccJerk.Y.mean"       "tBodyAccJerk.Z.mean"      
[45] "tBodyGyro.X.mean"          "tBodyGyro.Y.mean"         
[47] "tBodyGyro.Z.mean"          "tBodyGyroJerk.X.mean"     
[49] "tBodyGyroJerk.Y.mean"      "tBodyGyroJerk.Z.mean"     
[51] "tBodyAccMag.mean"          "tGravityAccMag.mean"      
[53] "tBodyAccJerkMag.mean"      "tBodyGyroMag.mean"        
[55] "tBodyGyroJerkMag.mean"     "fBodyAcc.X.mean"          
[57] "fBodyAcc.Y.mean"           "fBodyAcc.Z.mean"          
[59] "fBodyAccJerk.X.mean"       "fBodyAccJerk.Y.mean"      
[61] "fBodyAccJerk.Z.mean"       "fBodyGyro.X.mean"         
[63] "fBodyGyro.Y.mean"          "fBodyGyro.Z.mean"         
[65] "fBodyAccMag.mean"          "fBodyBodyAccJerkMag.mean" 
[67] "fBodyBodyGyroMag.mean"     "fBodyBodyGyroJerkMag.mean"
```
