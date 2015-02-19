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