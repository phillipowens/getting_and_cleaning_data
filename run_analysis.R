## Script to load and prepare a clean data set
## Phillip Owens - December 2017 

## ensure that referenced libraries are loaded
require(dplyr)
require(tidyr)

## #############################################################################
## function to select name based on Vn name
## #############################################################################
newname <- function(x) { tbl_names[substring(x,2),2] }

## #############################################################################
## function to load set of files from test or train folder
## #############################################################################
createtable <- function(dataset) {

## read X, Y and subject test files
file <- file.path(path, dataset, paste0("X_", dataset, ".txt"))
tbl_x <- read.table(file)

file <- file.path(path, dataset, paste0("y_", dataset, ".txt"))
tbl_y <- read.table(file)

file <- file.path(path, dataset, paste0("subject_", dataset, ".txt"))
tbl_s <- read.table(file)

## select only mean() and std() signal variables and add subject and activity
tbl_x <- tbl_x %>% 
  select(grep("(mean|std)[(][)]", tbl_names$V2)) %>%
  rename_at(vars(starts_with("V")), funs(newname(.))) %>%
  cbind(subject = tbl_s$V1) %>%
  cbind(activitycode = tbl_y$V1) %>%
  merge(tbl_activity, by.x = "activitycode", by.y = "V1") 

## Add a unique ID to each row to allow re-merge later
tbl_x$ID <- seq.int(nrow(tbl_x))

## create tidy table of means and remove function from signal name
tbl_mean <- tbl_x %>%
  select(ID, subject, activity = V2, grep("-mean[(][)]", names(tbl_x))) %>% 
  gather(key = "signal", value = "mean", -ID, -subject, -activity) %>%
  mutate(signal = sub("(-mean)[(][)]", "", signal))

## create tidy table of stds and remove function from signal name
tbl_std <- tbl_x %>%
  select(ID, subject, activity = V2, grep("-std[(][)]", names(tbl_x))) %>% 
  gather(key = "signal", value = "std", -ID, -subject, -activity) %>%
  mutate(signal = sub("(-std)[(][)]", "", signal))

## merge and return mean and std tables
merge(tbl_mean, tbl_std) %>%
  select(subject, activity, signal, mean, std)
}

## #############################################################################
## Main processing 
## #############################################################################

## check that the source data exists - download and/or unzip if required.
fileset <- c("UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", 
  "UCI HAR Dataset/test/subject_test.txt", "UCI HAR Dataset/train/X_train.txt", 
  "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/train/subject_train.txt",
  "UCI HAR Dataset/features.txt", "UCI HAR Dataset/activity_labels.txt")

zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

lapply(fileset, function(f){ if (!file.exists(f)) {
	if (!file.exists("wearables.zip")) {download.file(zipurl, "wearables.zip")}
      unzip("wearables.zip" , f)}}
)

## set path to source data 
path <- file.path(getwd(), "UCI HAR Dataset")

## read the variable names and expand t and f variable name prefixes 
file <- file.path(path, "features.txt")
tbl_names <- read.table(file, stringsAsFactors = FALSE)
tbl_names[grep("^[t]", tbl_names$V2),2] <- sub("^[t]", "time-", tbl_names[grep("^[t]", tbl_names$V2),2])
tbl_names[grep("^[f]", tbl_names$V2),2] <- sub("^[f]", "freq-", tbl_names[grep("^[f]", tbl_names$V2),2])

## load activity labels
file <- file.path(path, "activity_labels.txt")
tbl_activity <- read.table(file)

## call function to create table for each dataset
test <- createtable("test")
train <- createtable("train")

## create final dataset summarising mean and std by subject, activity and signal
all <- test %>%
  rbind(train) %>%
  group_by(subject, activity, signal) %>% 
  summarise(mean=mean(mean), std=mean(std))

## save to disk
write.table(all,"wearables.txt", row.name=FALSE)
