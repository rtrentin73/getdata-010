# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation 
# for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and 
# each subject.

library(data.table)

if (getwd() != "/Users/rtrentin/bigdata/rprogramming/UCI HAR Dataset") {
  setwd("/Users/rtrentin/bigdata/rprogramming/UCI HAR Dataset")
}

test_data <- read.table("./test/X_test.txt")
test_data_act <- read.table("./test/y_test.txt")
test_data_sub <- read.table("./test/subject_test.txt")
training_data <- read.table("./train/X_train.txt")
training_data_act <- read.table("./train/y_train.txt")
training_data_sub <- read.table("./train/subject_train.txt")

activities <- read.table("./activity_labels.txt")
test_data_act$V1 <- factor(test_data_act$V1, levels=activities$V1, labels=activities$V2)
training_data_act$V1 <- factor(training_data_act$V1, levels=activities$V1, labels=activities$V2)

features <- read.table("./features.txt")
colnames(test_data) <- features$V2
colnames(training_data) <- features$V2
colnames(test_data_act) <- c("Activity")
colnames(training_data_act) <- c("Activity")
colnames(test_data_sub) <- c("Subject")
colnames(training_data_sub) <- c("Subject")

test_data <- cbind(test_data, test_data_act)
test_data <- cbind(test_data, test_data_sub)
training_data <- cbind(training_data, training_data_act)
training_data <- cbind(training_data, training_data_sub)
all_data <- rbind(test_data, training_data)

all_data_mean <- sapply(all_data, mean, na.rm=TRUE)
all_data_sd <- sapply(all_data, sd, na.rm=TRUE)

DT <- data.table(all_data)
tidy_data <- DT[, lapply(.SD,mean), by="Activity,Subject"]
write.table(tidy_data, file="UCI_HAR_tidy.csv", sep=",",row.names = FALSE)
