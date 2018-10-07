
#Download package
library(dplyr)

#get zip URL
Zip_URL  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download zip
download.file(Zip_URL, destfile = "Dataset.zip")

#unzip file
unzip("Dataset.zip")

#get all files
activity_labels <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/features.txt")
subject_test <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("C:/Users/francisca.marinho/Documents/Data Science Specialization/03. Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")
colnames(activity_labels) <- c("activityID", "activity")

#join databases
db_test <- cbind(subject_test, y_test, x_test)
db_train <- cbind(subject_train, y_train, x_train)
database <- rbind(db_test, db_train)

#add column names
colnames(database) <- c("subject", features[,2], "activity")

#get from database subject, activity, mean and std
database_cols <- grepl("subject|activity|mean|std", colnames(database))

#filter the previous colunmns
database <- database[, database_cols]

#change activity names
database$activity <- factor(database$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#give column names
database_colnames  <- colnames(database)

#remove characters
database_colnames <- gsub("[\\(\\)-]", "", database_colnames)

#give column names
colnames(database) <- database_colnames

#summarize by mean and std, grouped database by activity and subjetct
database_meanStd <- database %>% group_by(subject, activity) %>% summarise_all(funs(mean))

#print result
write.table(database_meanStd, "PA_database.txt", row.name = FALSE)

