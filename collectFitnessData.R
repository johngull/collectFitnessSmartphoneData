require(dplyr)
require(urltools)

#download and unpack zip file
downloadAndUnpackInputData <- function(url, unpackDirName, files)
{
    url <- url_encode(url)
    
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


collectFitnessData <- function(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                               files = c("UCI HAR Dataset/features.txt", "UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt") 
                               )
{
    
    downloadAndUnpackInputData(url, "data", files)
}