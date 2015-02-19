---
title: "Description of run_analysis.R Processing Script"
output: html_document
---

The original data set included by the authors of the Human Activity Recognition study is massive and distributed. The run_analysis.R script is designed to separate the measurement data into a much narrower set of measurements and condense all the data into one tidy file.

The steps taken in the script are annotated with code comments but can be summarized as follows:

1. All sensor measurements along with the activity label and subject identifier files for both test and train sets are loaded into R as individual data frames.

2. The appropriate activity descriptions and sensor variable descriptions are loaded into R.

3. The sensor variables of interest, which are any variable including the identifier text "mean()" or "std()", are singled out within the test and train sensor variable data frames and the rest of the data are excluded.

4. The matching subject, activity, and sensor variable data for both test and train data sets are merged together. This correlates each row of sensor variables with the subject being measured and the activity performed while the measurement was taken.

5. The two fully merged test and train data sets are merged into one single data frame. The descriptive column names are also added.

6. The unified data frame is reordered, first by subject and then by activity.

At this point the data has been sufficiently cleaned in order for the script to efficiently process the desired result, which is the average sensor variable data per activity per subject.

7. An empty data frame is created with a number of rows equal to the number of subjects times the number of unique subject activities. This will eventually be the tidy data set returned by the script.

8. Sensor variable data corresponding to each particular subject and each activity of that subject are collected separately and an average is calculated.

9. The complete summary data frame is exported to a text file in tidy table form.

