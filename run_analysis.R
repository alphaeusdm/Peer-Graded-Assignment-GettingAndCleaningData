#create the directory and download the dataset and unzip it
#if(!file.exists("./data")){dir.create("./data")}
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl, destfile = "./data/Dataset.zip")
#unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

#Load the data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#read feature vector and activity labels.
features <- read.table("./data/UCI HAR Dataset/features.txt")
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#4. Appropriately labels the data set with descriptive variable names.
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c("activityId", "activityType")

#1. Merge the training and testing datasets to create one dataset.
mtrain <- cbind(y_train,subject_train,x_train)
mtest <- cbind(y_test,subject_test,x_test)
mergeall <- rbind(mtrain,mtest)

#2. Extract only measurements on mean and standard deviation for each measurement.
colNames <- colnames(mergeall)

mean_std <- (grepl("activityId", colNames) | grepl("subjectId", colNames) | grepl("mean..", colNames) | grepl("std..", colNames))

selectmeanandstd <- mergeall[, mean_std == TRUE]

#3. Uses descriptive activity names to name the activities in the data set
activityNames <- merge(selectmeanandstd, activityLabels, by='activityId', all.x=TRUE)

#step 4 done above

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidySet <- aggregate(selectmeanandstd, activityNames, mean)
tidySet <- tidySet[order(tidySet$subjectId, tidySet$activityId),]
write.table(tidySet,"tidySet.txt",row.names = FALSE)

library(knitr)
knit2html("CodeBook.Rmd")
