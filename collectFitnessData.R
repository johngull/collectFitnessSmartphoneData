require(dplyr)
require(urltools)

#download and unpack zip file
downloadAndUnpackInputData <- function(url, unpackDirName, files)
{
    #download
    if(!file.exists("inputData"))
        dir.create("inputData")
    
    zipFileName <- basename(url_decode(url))
    zipPath <- paste("inputData",zipFileName, sep="/")
    if(!file.exists(zipPath))
    {
        res <- download.file(url, destfile=zipPath, method="curl", quiet=TRUE)
        if(res)
            stop(paste("Can't download file from:", url))
    }
    
    #unpack
    unpackPath <- paste("inputData",unpackDirName, sep="/")
    resList <- unzip(zipPath, files, junkpaths = TRUE, exdir = unpackPath)
    if(length(resList)!=length(files))
        stop(paste("Can't extract file(s) from the list:",toString(files)))
}

#load Features and combine test + train data
loadSensorsData <- function(unpackDirName)
{
    unpackPath <- paste("inputData",unpackDirName, sep="/")
    testSensors <- read.table(paste(unpackPath, "X_test.txt", sep="/"))
    trainSensors <- read.table(paste(unpackPath, "X_train.txt", sep="/"))
    
    rbind(testSensors, trainSensors)
}

loadFeaturesNames <- function(unpackDirName)
{
    unpackPath <- paste("inputData",unpackDirName, sep="/")
    features <- read.table(paste(unpackPath, "features.txt", sep="/"), stringsAsFactors=FALSE)
    features[,2]
}

loadActivities <- function(unpackDirName)
{
    unpackPath <- paste("inputData",unpackDirName, sep="/")
    testAct <- read.table(paste(unpackPath, "y_test.txt", sep="/"))
    trainAct <- read.table(paste(unpackPath, "y_train.txt", sep="/"))
    
    rbind(testAct, trainAct)
}

loadActivitiesNames <- function(unpackDirName)
{
    unpackPath <- paste("inputData",unpackDirName, sep="/")
    features <- read.table(paste(unpackPath, "activity_labels.txt", sep="/"), stringsAsFactors=FALSE)
    features[,2]
}

# keep only mean and std values
featureIndeces <- function(sensorData, featuresNames)
{
    meanCols <- grep("mean()", unlist(featuresNames), fixed=TRUE)
    stdCols <- grep("std()", unlist(featuresNames), fixed=TRUE)
    
    c(meanCols, stdCols)
}

saveResultTables <- function(result, featureNames)
{
    if(!file.exists("outputData"))
        dir.create("outputData")
    names(result) <- featureNames
    write.table(result, "outputData/activity_sensors.txt", row.names = FALSE, col.names = TRUE);
}


collectFitnessData <- function(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                               files = c("UCI HAR Dataset/features.txt", "UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt") 
                               )
{    
    unpackSubDir <- "data"
    
    downloadAndUnpackInputData(url, unpackSubDir, files)
    
    #1. Merges the training and the test sets to create one data set.
    sensors <- loadSensorsData(unpackSubDir)
    
    #2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    featureNames <- loadFeaturesNames(unpackSubDir)
    featureIdx <- featureIndeces(sensors, featureNames)
    sensors <- sensors[,featureIdx]
    featureNames <- featureNames[featureIdx]
    
    #3. Uses descriptive activity names to name the activities in the data set
    activities <- loadActivities(unpackSubDir)
    actNames <- loadActivitiesNames(unpackSubDir)
    
    #4. Appropriately labels the data set with descriptive variable names. 
    activities <- as.data.frame(activities)
    names(activities) <- "act"
    activities <- mutate(activities, act=actNames[act])
    # activities now is clear labeled, so combine
    result <- cbind(sensors, activities$act)
    featureNames <- c(featureNames, "activity")
    #save all
    saveResultTables(result, featureNames)
    
}