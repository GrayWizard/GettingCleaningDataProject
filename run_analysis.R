# Read the Train and Test datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge the test data, subject and activities into a single table
test <- cbind(x_test,subject_test,y_test)
# Merge the training data, subject and activities into a single table
train <- cbind(x_train,subject_train,y_train)
# Merge all of the data into a single set
data <- rbind(train,test)

# Load the text descriptions of features and activities
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Replace the names of the dataset columns with the desctiptive names 
# from the features file (plus the subject and activity)
names(data) <- c(as.character(features[,2]),"subject","activity")

# Select the features to use in the tidy data set
# i.e. only the variables with the mean() or std() in their names
use_features <- c(grep("mean\\(\\)|std\\(\\)",names(data)),562,563)

# Clean up the feature names:
# remove the brackets, replace the dashes with underscores 
# and shorten the (probably erroneous) BodyBody to Body
clean_names <- gsub("()","",names(data),fixed=TRUE)
clean_names <- gsub("-","_",clean_names,fixed=TRUE)
clean_names <- gsub("BodyBody","Body",clean_names,fixed=TRUE)
names(data) <- clean_names

# Change the activities from the numeric to textual descriptions
for(id in 1:nrow(activities)) {
  data$activity[data$activity %in% activities$V1[id]] <- as.character(activities$V2[id])
}

# Subset the original data with the required features to obtain the first tidy dataset 
tidy_data_origin <- data[,use_features]

# Calculate the mean for every subject/activity/feature combination
tidy_data <- aggregate(tidy_data_origin[1:66],by=list(tidy_data_origin$subject,tidy_data_origin$activity),FUN=mean,na.rm=TRUE)

# Fix the names that were modified by the aggregation
names(tidy_data)<-c("subject","activity",names(tidy_data)[3:68])

# Output the final tidy dataset
write.csv(tidy_data,"tidy_data.csv")
