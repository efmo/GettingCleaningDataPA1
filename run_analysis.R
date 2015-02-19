#First read in the sensor measurements, activity labels, and subject labels for the test data set
dfTest <- read.table("test/X_test.txt");
labelTest <- read.table("test/y_test.txt");
subjectTest <- read.table("test/subject_test.txt");

#Do the same for the training set
dfTrain <- read.table("train/X_train.txt");
labelTrain <- read.table("train/y_train.txt");
subjectTrain <- read.table("train/subject_train.txt");

#Read in the headers corresponding to the sensor measurements
features <- read.table("features.txt")

#Read in the key for decoding the activity labels
activityLabels <- read.table("activity_labels.txt")

#find all column indices with sensor measurement descriptions that contain "mean()" or "std()"
indicesMeanStddev = grep("mean\\(\\)|std\\(\\)", as.character(features$V2))

#attach the subject data, label data, and sensor measurements of interest together
dfTest <- cbind(subjectTest, labelTest, dfTest[,indicesMeanStddev])
dfTrain <- cbind(subjectTrain, labelTrain, dfTrain[,indicesMeanStddev])

#merge the test and train sets
dfAll <- rbind(dfTest, dfTrain)

#rename column headers with appropriate descriptions 
names(dfAll) <- c("Subject", "Activity", as.character(features$V2[indicesMeanStddev]))

#reorder rows first by subject then by activity
dfAll <- dfAll[order(dfAll$Subject, dfAll$Activity),]

#rename activity values with their corresponding activity descriptions
dfAll$Activity <- sapply(dfAll$Activity,function(x) activityLabels[x,2])

#Now create a tidy data set.

#create an empty data frame with appropriate dimensions:
#number of rows = (number of unique subjects) * (number of unique activities)
#number of columns = number of unique sensor measurement types + 2 (for subject and activity)
uniqueSubjects <- unique(dfAll$Subject)
uniqueActivities <- unique(dfAll$Activity)

dfTidy <- data.frame(matrix(0, nrow = length(uniqueSubjects) * length(uniqueActivities), ncol = ncol(dfAll)))

#names remain the same
names(dfTidy) <- names(dfAll)

#ordering of subjects and activities matches the ordering of dfAll
dfTidy$Subject <- rep(uniqueSubjects, each = length(uniqueActivities))
dfTidy$Activity <- rep(uniqueActivities, times = length(uniqueSubjects))

#Calculate the mean of all values for each sensor type pertaining to a unique subject and activity
for(i in 1:nrow(dfTidy)) {
    for(col in 3:ncol(dfTidy)) {
        meanSensorVal <- mean(dfAll[which(dfAll$Subject == dfTidy[i,1] & 
                                  dfAll$Activity == dfTidy[i,2]),names(dfAll[col])])
        dfTidy[i,col] <- meanSensorVal
    }
}

write.table(dfTidy,"tidyData.txt", row.names = FALSE)

