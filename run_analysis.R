###############################
## Download and process the "Human Activity Recognition Using Smartphones" dataset
## Generate two tidy data sets, one including all the items, and a second summarizing the first by Activity and SubjectID

###############################
## Download and load packages used, unless they are already installed

if("dplyr" %in% rownames(installed.packages()) == FALSE)
{ install.packages("dplyr") }
library(dplyr)

###############################
## Downloading and preparing the files


## If files already are present, we assume that they are correct
## I would not always necessarily trust this to be true, but it avoids uneccsary downloads for this exercise

## First make sure we remove any pre-existing data folder - the subfolder will be created with this name when unzipping the file downloaded
subDirectory <- "UCI HAR Dataset"

if (!file.exists(subDirectory))
{
   
   ## We're assuming that no other files will be in the subdirectory, so we can always delete any existing subfolder with that name to start from scratch
   ## Skip this since we're not re-downloading each time
   ## if (file.exists(subDirectory)){
   ##   unlink(subDirectory, recursive = TRUE, force = TRUE)
   ## }
   
   ## Download the files from the URL to the working directory and unzip them
   ##destinationFile = "Dataset.zip"
   download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = file.path(destinationFile))
   unzip(file.path(destinationFile))
   ## Delete the zip file
   file.remove(file.path(destinationFile))
}

###############################
## Actual analysis

## Read in the files that will be used to create the unified dataset

#### Common
activityLabels <- read.table(paste(subDirectory,"/","activity_labels.txt", sep = ""))
features <- read.table(paste(subDirectory,"/","features.txt", sep = ""))
featureColumnNames <- features$V2

#### Data sets

## The data consists of 2 sets of files for each of the data subsets, Training and Test.
## The files have the same structure so we loop through the data subsets and process them using the same commands
dataSubsetNames <- c("test", "train")

##Initialize the variable the loop will store the subsets to
dataSet = data.frame()

for ( dataSubsetName in dataSubsetNames )
{
   
   ## Read in the files
   subjectIDs <- read.table(paste(subDirectory,"/",dataSubsetName,"/subject_",dataSubsetName,".txt", sep = ""))
   featureData <- read.table(paste(subDirectory,"/",dataSubsetName,"/X_",dataSubsetName,".txt", sep = ""))
   activityIDs <- read.table(paste(subDirectory,"/",dataSubsetName,"/y_",dataSubsetName,".txt", sep = ""))
   
   ## Add Feature names to the featureData from the file read above
   colnames(featureData) <- featureColumnNames
   
   ## Select only the feature columns that contain mean and std values
   selectedFeatureData <- featureData[,grep("mean()|std()",colnames(featureData))]

   ## Add all the elements together to a single subset
   dataSubsetWithAdditionalColumns <- cbind(subjectIDs, activityIDs, selectedFeatureData)
   
   ## Add names to the unnamed columns
   colnames(dataSubsetWithAdditionalColumns)[1] <- "SubjectID"
   colnames(dataSubsetWithAdditionalColumns)[2] <- "ActivityID"
   
   ##Merge with activity labels to get the human-readable label
   dataSubsetWithActivityNameAndActivityID <- merge(dataSubsetWithAdditionalColumns, activityLabels, by.x = "ActivityID", by.y = "V1")
   
   ## Add a name to the activity name column merged as the last column
   colnames(dataSubsetWithActivityNameAndActivityID)[ncol(dataSubsetWithActivityNameAndActivityID)] <- "Activity"
   
   ## Remove the ActivityID column, no longer needed
   dataSubsetWithActivityName <- dataSubsetWithActivityNameAndActivityID[-1]
   
   ## The tidy data subset is now complete
   dataSubset <- dataSubsetWithActivityName
   
   ## Add the tidy data subset to the data set
   dataSet <- rbind(dataSet, dataSubset)
   
}

## Save the tidy data set to a file
write.table(dataSet, file="UCI_HAR_Dataset_Tidy.txt")

## From the tidy dataset created above, we generate a second data set with the averages for each activity and subject
dataSetGrouped <- dataSet %>% group_by(Activity, SubjectID)
dataSetGrouped %>% summarize_all(mean)

## Save the grouped tidy data set to a file
write.table(dataSetGrouped, file="UCI_HAR_Dataset_Tidy_Grouped.txt")

