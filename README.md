# collectFitnessSmartphoneData

This is course project for the "Getting and Cleaning Data" course on coursera.
It creates tidy data of wearable device sensors data for different activities.
The resulting data can be useful for training machine learning algorithm to detect activities by such sensors.

###Usage
Just call **collectFitnessData()** function from collectFitnessData.R for default behaviour.

You can specify different url to target zip file and different files locations inside zip archive.

```R
collectFitnessData(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  files = c("UCI HAR Dataset/features.txt", "UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt") 
                  )
```

Script will download and unpack needed files to **inputData** directory. And will place resulting tidy tables to **outputData**.

###Script results
All results are stored to the **outputData** directory.

- activity_sensors.txt - tidy set of sensors values/activity label for all observations (includes test and train sets from original). 
- summary.txt - table of average values for all sensors types grouped by activity type.


###Requirements:
- R language
- curl
- R libraries (use install.packages):
  - dplyr
  - urltools 