## Project : You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.
db_xvalues <- rbind(x_train, x_test)
db_yvalues <-rbind(y_train, y_test)
db_subject <- rbind(subject_train, subject_test)
database <- cbind(db_subject, db_xvalues , db_yvalues )

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
database_MeanAndStd <- database %>% select(subject, activityID, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set
database_MeanAndStd$activityID <- activity_labels[database_MeanAndStd$activityID ,2]

#4. Appropriately labels the data set with descriptive variable names.
names(database_MeanAndStd) <- gsub("Acc", "accelerometer", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("Gyro", "gyroscope", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("BodyBody", "body", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("Mag", "magnitude", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("^t", "time", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("^f", "frequency", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("tBody", "time_body", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("-mean()", "mean", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("-std()", "std", names(database_MeanAndStd))
names(database_MeanAndStd) <- gsub("-freq()", "frequency", names(database_MeanAndStd))
names(database_MeanAndStd)[2] <- "activity"

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
new_database <- database_MeanAndStd %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(new_database, "Project.txt", row.name = FALSE)

