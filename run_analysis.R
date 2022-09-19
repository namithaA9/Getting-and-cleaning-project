> 
> # 1. Merges the training and the test sets to create one data set.
> # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> # 3. Uses descriptive activity names to name the activities in the data set
> # 4. Appropriately labels the data set with descriptive variable names.
> # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> 
> # Load Packages and get the Data
> packages <- c("data.table", "reshape2")
> sapply(packages, require, character.only=TRUE, quietly=TRUE)
data.table   reshape2 
     FALSE      FALSE 
> path <- getwd()
> url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(url, file.path(path, "dataFiles.zip"))
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 MB)
downloaded 59.7 MB

> unzip(zipfile = "dataFiles.zip")
> 
> # Load activity labels + features
> activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
+                         , col.names = c("classLabels", "activityName"))
Error in fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"),  : 
  could not find function "fread"
> features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
+                   , col.names = c("index", "featureNames"))
Error in fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index",  : 
  could not find function "fread"
> featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
Error in is.factor(x) : object 'features' not found
> measurements <- features[featuresWanted, featureNames]
Error: object 'features' not found
> measurements <- gsub('[()]', '', measurements)
Error in is.factor(x) : object 'measurements' not found
> 
> # Load train datasets
> train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
Error in fread(file.path(path, "UCI HAR Dataset/train/X_train.txt")) : 
  could not find function "fread"
> data.table::setnames(train, colnames(train), measurements)
Error in loadNamespace(x) : there is no package called ‘data.table’
> trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
+                        , col.names = c("Activity"))
Error in fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity")) : 
  could not find function "fread"
> trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
+                        , col.names = c("SubjectNum"))
Error in fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"),  : 
  could not find function "fread"
> train <- cbind(trainSubjects, trainActivities, train)
Error in cbind(trainSubjects, trainActivities, train) : 
  object 'trainSubjects' not found
> 
> # Load test datasets
> test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
Error in fread(file.path(path, "UCI HAR Dataset/test/X_test.txt")) : 
  could not find function "fread"
> data.table::setnames(test, colnames(test), measurements)
Error in loadNamespace(x) : there is no package called ‘data.table’
> testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
+                         , col.names = c("Activity"))
Error in fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity")) : 
  could not find function "fread"
> testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
+                       , col.names = c("SubjectNum"))
Error in fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"),  : 
  could not find function "fread"
> test <- cbind(testSubjects, testActivities, test)
Error in cbind(testSubjects, testActivities, test) : 
  object 'testSubjects' not found
> 
> # merge datasets
> combined <- rbind(train, test)
Error in rbind(train, test) : object 'train' not found
> 
> # Convert classLabels to activityName basically. More explicit. 
> combined[["Activity"]] <- factor(combined[, Activity]
+                               , levels = activityLabels[["classLabels"]]
+                               , labels = activityLabels[["activityName"]])
Error in factor(combined[, Activity], levels = activityLabels[["classLabels"]],  : 
  object 'combined' not found
> 
> combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
Error in is.factor(x) : object 'combined' not found
> combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
Error in loadNamespace(x) : there is no package called ‘reshape2’
> combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)
Error in loadNamespace(x) : there is no package called ‘reshape2’
> 
> data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)
