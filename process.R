x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(x_test,subject_test,y_test)
train <- cbind(x_train,subject_train,y_train)
data <- rbind(train,test)
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
data <- setNames(data,c(as.character(features[,2]),"subject","activity"))
use_features <- c(grep("mean\\(\\)|std\\(\\)",names(data)),562,563)
data_trim <- data[,use_features]
for(id in 1:nrow(activities)) {
  data_trim$activity[data_trim$activity %in% activities$V1[id]] <- as.character(activities$V2[id])
}