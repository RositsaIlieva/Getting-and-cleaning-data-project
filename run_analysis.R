#donwoading the data
getwd()
setwd("D:/R/data")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,
         destfile = "./Data/GettingAndCleaningDataCourseProject.zip")


#Unzip the data

zipF<-file.choose("./Data/GettingAndCleaningDataCourseProject.zip") # lets you choose a file and save its file path in R (at least for windows)
outDir<-"D:/R/data/unzipfolder" # Define the folder where the zip file should be unzipped to 
unzip(zipF,exdir=outDir)  # unzip your file 

#Reading and marging the data

setwd("D:/R/data/unzipfolder/UCI HAR Dataset/train")

X_train <- read.table("X_train.txt", 
                 header = FALSE)

y_train <- read.table("y_train.txt", 
                     header = FALSE)

subject_train <- read.table("subject_train.txt", 
                      header = FALSE)
traindataset<- cbind(y_train,subject_train,X_train)

setwd("D:/R/data/unzipfolder/UCI HAR Dataset/test")
X_test <- read.table("X_test.txt", 
                      header = FALSE)

y_test<- read.table("y_test.txt", 
                     header = FALSE)

subject_test<- read.table("subject_test.txt", 
                            header = FALSE)
testdataset<- cbind(y_test,subject_test,X_test)

#Merges the training and the test sets to create one data set

names(testdataset)
names(traindataset)
allData <- rbind(traindataset, testdataset)


# Load activity labels + features
setwd("D:/R/data/unzipfolder/UCI HAR Dataset")
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

colnames(allData) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors

library(reshape2)
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)






