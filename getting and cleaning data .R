library(dplyr)
features <- read.table("~/RS/coursera3/UCI HAR Dataset/features.txt", col.names = c("n","functions"))

activity_labels <- read.table("~/RS/coursera3/UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
subj_test <- read.table("~/RS/coursera3/UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
X_test <- read.table("~/RS/coursera3/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("~/RS/coursera3/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subj_train <- read.table("~/RS/coursera3/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("~/RS/coursera3/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
 
#Merging data sets
y_train <- read.table("~/RS/coursera3/UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_merged <- rbind(X_train,X_test)
y_merged <- rbind(y_train, y_test)
subject <- rbind(subj_train,subj_test)
merged_data <- cbind(subject, x_merged, y_merged)

#Extract measurements
tidy_data <- merged_data %>%
  select(subject, code, contains("mean"), contains("std"))

#Labeling appropriately 
names(tidy_data)[2] = "activity"
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mug", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t","Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("mean()", "Mean", names(tidy_data), ignore.case = T)
names(tidy_data) <- gsub("std()", "STD", names(tidy_data), ignore.case = T)
names(tidy_data) <- gsub("-g=freq()", "Frequency", names(tidy_data), ignore.case = T)
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

#Creating second data
final_data <- tidy_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))

#creating text file
write.table(final_data, "FinalData.text", row.names = F)

#Checking final data
str(final_data)

head(final_data)