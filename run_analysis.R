# require libraries

library(data.table)
library(dplyr)

# download files

fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists("./data")){dir.create("./data")}
download.file(fileurl,destfile="./data/Dataset.zip")

# unzip data

unzip(zipfile="./data/Dataset.zip",exdir="./data")


# reading/convert trainings tables

data_trainX <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
data_trainACT <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
data_trainSUB <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# reading/convert testing tables

data_testX <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
data_testACT <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
data_testSUB <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#read/convert features

features <- read.table('./data/UCI HAR Dataset/features.txt')
features <- as.character(features[,2])

#convert data

data_train <- data.frame(data_trainSUB, data_trainACT, data_trainX)
names(data_train) <- c(c('Subject', 'Activity'), features)

data_test <- data.frame(data_testSUB, data_testACT, data_testX) 
names(data_test) <- c(c('Subject', 'Activity'), features)

# 1 - Merges the training and the test sets to create one data set.

all_dataSET <- rbind(data_train, data_test)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

meanSTAN <- grep('mean|STAN', features)
dataSUBSET <- all_dataSET[,c(1,2,meanSTAN + 2)]

# 3 - Uses descriptive activity names to name the activities in the data set

labelsACT <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
labelsACT <- as.character(labelsACT[,2])
dataSUBSET$Activity <- labelsACT[dataSUBSET$Activity]

# 4 - Appropriately labels the data set with descriptive variable names. 

names(dataSUBSET) <- gsub("Freq", "", names(dataSUBSET))
names(dataSUBSET) <- gsub("BodyBody", "Body", names(dataSUBSET))
names(dataSUBSET) <- gsub("Acc", "Accelerometer", names(dataSUBSET))
names(dataSUBSET) <- gsub("^t", "Time", names(dataSUBSET))
names(dataSUBSET) <- gsub("gravity", "Gravity", names(dataSUBSET))
names(dataSUBSET) <- gsub("Gyro", "Gyroscope", names(dataSUBSET))
names(dataSUBSET) <- gsub("Mag", "Magnitude", names(dataSUBSET))
names(dataSUBSET) <- gsub("^f", "Frequency", names(dataSUBSET))
names(dataSUBSET) <- gsub("mean", "Mean", names(dataSUBSET))
names(dataSUBSET) <- gsub("[(][)]", "", names(dataSUBSET))

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

dataFINAL <- aggregate(dataSUBSET[,3:46], by = list(Activity = dataSUBSET$Activity, Subject = dataSUBSET$Subject),FUN = mean)
write.table(x = dataFINAL, file = "dataFINAL.txt", row.names = FALSE)