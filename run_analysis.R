library(dplyr)
library(data.table)
featnms <- read.table("UCI HAR Datas et/features.txt")
file <- "Coursera_DS3_Final.zip"
if(!file.exists(file)){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, file, method = "curl")
}

if(!file.exists("UCI HAR Dataset")){
unzip(file)
}

feat <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
act <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subj_tst <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_tst <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feat$functions)
y_tst <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feat$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_tst) 
Y <- rbind(y_train, y_tst)
Subj <- rbind(subj_train, subj_tst)
Mrgd_Data <- cbind(Subj, Y, X)

Tidy_Data <- Mrgd_Data %>% select(subject, code, contains("mean"), contains("std"))
Tidy_Data$code <- act[Tidy_Data$code, 2]

names(Tidy_Data)[2] = "activity"
names(Tidy_Data) <- gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data) <- gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data) <- gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data) <- gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data) <- gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data) <- gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data) <- gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data) <- gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data) <- gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data) <- gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data) <- gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data) <- gsub("gravity", "Gravity", names(Tidy_Data))



write.table(FinalData, "FinalData.txt", row.name=FALSE)
  FinalData <- Tidy_Data %>%
  group_by(subject, activity) %>%
summarise_all(funs(mean))

str(FinalData)
FinalData

