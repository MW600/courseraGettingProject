library("dplyr")

# 0. DOWNLOAD DATA
# check if data files are on the computer
# if no - download the data from the internet
 if (!file.exists("./UCI HAR Dataset/test/X_test.txt") || !file.exists("./UCI HAR Dataset/train/X_train.txt")) {
  download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "Dataset.zip")
 # unzip the file
 unzip("Dataset.zip")
}

# 1. MERGE DATASETS
# 1.1. Measurements
# read X_test & X_train sets and create one
# data frame, containing all MEASUREMENTS
 test <- read.table("./UCI HAR Dataset/test/X_test.txt")
 train <- read.table("./UCI HAR Dataset/train/X_train.txt")
 data <- rbind(train,test)
# read files with names of variables and assign them to dataset
 features <- read.table("./UCI HAR Dataset/features.txt")
 names(data) <- features[,2]

# 1.2. Subjects and Labels
# initialize empty data frame for Subject & Activity data
 subAct <- as.data.frame(matrix(nrow=length(data[,1]),ncol=2))
# read ACTIVITY labels data
 testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
 trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
 labels <- rbind(trainLabels,testLabels)
# match activity labels with their names 
 activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
 activity <- as.data.frame(matrix(ncol=1,nrow=length(labels[,1])))
 for (i in 1:length(activityLabels[,1])) {
    for (j in 1:length(labels[,1])) {
        if (labels[j,1]==activityLabels[i,1]) {
            activity[j,1] <- as.character(activityLabels[i,2])
        }
    } 
 }
# read SUBJECT labels
 testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
 trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
 subjects <- rbind(trainSub,testSub)
# merge SUBJECT & ACTIVITY
 subAct <- cbind(subjects,activity)
 names(subAct) <- c("subject","activity")
 
# 2. EXTRACT MEASUREMENTS
# get undices of columns with mean() or std() data
 useCols <- grep(pattern = "mean\\(\\)|std\\(\\)",names(data),value=TRUE)
# initialize an empty data frame for extracted columns
 useData <- as.data.frame(matrix(ncol=length(useCols),nrow = length(data[,1])))
 useNames <- c(length(useData))
# fill 'useData' with data from selected columns
for (i in 1:length(useData)) {
 useData[,i] <- data[,useCols[i]]
 useNames[i] <- names(data[useCols[i]])
}
# assign names to variables
 names(useData) <- useNames
# add Subject/Activity columns
 useData <- cbind(subAct,useData)
# 2-level sorting: 1st: subject, 2nd: activity 
 useData <- useData[order(useData$subject, useData$activity),]

# 3. CREATE TIDY, AVERAGED DATA SET
 tidyData <- aggregate.data.frame(useData,by = list(useData$subject,useData$activity),FUN = mean,simplify = TRUE)
 tidyData$subject <- NULL
 tidyData$activity <- NULL
 tidyData <- rename(tidyData, subject = Group.1, activity = Group.2)
# save to a file
 write.table(x = tidyData,file = "tidyData.txt", row.name = FALSE)
