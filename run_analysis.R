print("Reading data...")

features <- read.table("features.txt")

subject_train <- read.table("train/subject_train.txt")

X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")

X_test<- read.table("test/X_test.txt")
y_test<- read.table("test/y_test.txt")

prinT("Merging data...")

train_data <- data.frame(cbind(subject_train,y_train,X_train))

test_data <- data.frame(cbind(subject_test,y_test,X_test))

mdf <- data.frame(rbind(train_data,test_data))

feature_list <- c("subject","activity",as.vector(features$V2))

names(mdf) <- feature_list

print("Cleaning data...")

std_features <- grep("std()",feature_list,value = T,fixed = T)
mean_features <- grep("mean()",feature_list,value = T,fixed = T)

updated_feature_list <- c("subject","activity",std_features,mean_features)

reduced_mdf <- mdf[updated_feature_list]
names(reduced_mdf) <- updated_feature_list

for(r in c("X","Y","Z","")){
	names(reduced_mdf) <- gsub(paste("-std()-",r,sep=""),paste(paste(".",r,sep=""),".std",sep=""),names(reduced_mdf),fixed = TRUE)
	names(reduced_mdf) <- gsub(paste("-mean()-",r,sep=""),paste(paste(".",r,sep=""),".mean",sep=""),names(reduced_mdf),fixed = TRUE)
}

names(reduced_mdf) <- gsub("-",".",names(reduced_mdf),fixed = TRUE)
names(reduced_mdf) <- gsub("()","",names(reduced_mdf),fixed = TRUE)

activity_labels <- read.table("activity_labels.txt")

reduced_mdf$activity <- activity_labels[reduced_mdf$activity,2]

print("Data frame 1 done!")
print("Preparing tidy data...")

sub_iter = 1:30

tidy_df = data.frame(matrix(nrow=0,ncol=length(names(reduced_mdf))))

c <- 1
k <- dim(reduced_mdf)[2]
for(sub in sub_iter){
	for(act in activity){
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

write.table(tidy_df, file="tidy_data.txt", sep="\t")
print("tidy data created!")