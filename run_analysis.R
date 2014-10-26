# Download the dataset and unzip the files.
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip", method="curl")
unzip("Dataset.zip")

# Make a combined tidy dataset.

# load the activity lables
activity.labels <- read.table("UCI HAR Dataset//activity_labels.txt")
colnames(activity.labels) <- c("level", "label")

# load the dataset features(column names)
features <- read.table("UCI HAR Dataset//features.txt")
colnames(features) <- c("column", "feature")
# select the features which will be part of the final tidy dataset
# per the instructions keep mean and standard deviation for each measurement
features$keep <- FALSE
features$keep[grep("mean\\(", features$feature)] <- TRUE
features$keep[grep("std\\(", features$feature)] <- TRUE
# clean up the feature names so they will work as column names
features$feature <- sub("\\(\\)", "", features$feature)
features$feature <- gsub("-", ".", features$feature)



# load and combine test and train datasets
load.dataset <- function(dataset) {
  # takes a path/filename loads the dataset and returns a tidy data frame
  
  # load the dataset
  x.table <- read.table(paste0("UCI HAR Dataset/", dataset,"/X_", dataset, ".txt"))
  y.table <- read.table(paste0("UCI HAR Dataset/", dataset,"/y_", dataset, ".txt"))
  subject.table <- read.table(paste0("UCI HAR Dataset/", dataset,"/subject_", dataset, ".txt"))
  
  # label the features and limit the features to those previously selected
  colnames(x.table) <- features$feature
  x.table <- x.table[, features$keep]
  
  # fix the column names for subject and activities
  colnames(subject.table) <- "subject"
  colnames(y.table) <- "activity"
  
  # construct the prototype tidy data frame
  output <- data.frame(dataset, 
                       subject.table, 
                       y.table,
                       x.table)
  
  # convert the activity to a appropriately labeled factor variable
  output[, 3] <- factor(output[, 3], labels=activity.labels$label)
  
  
  output
}

merged.data <- rbind(load.dataset("test"), load.dataset("train"))


# summary table
library(plyr)
summarized.table <- ddply(merged.data, .(subject, activity), function(df) {
    unlist(lapply(df[, -c(1:3)], mean))
  })
write.table(summarized.table, "summarized.table.txt", row.names=F)
