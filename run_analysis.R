## Check if the package "reshape2" is installed, if not do so..

if (!("reshape2" %in% rownames(installed.packages())) ) {
  installed.packages("reshape2")
} else {
  
  ## If the package "reshape2" is installed...
  
  library(reshape2)
  
  ## Read all data files
  activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))
  features <- read.table("features.txt")
  
  testX <- read.table("./test/X_test.txt")
  testY <- read.table("./test/y_test.txt")
  testSub <- read.table("./test/subject_test.txt")
  
  trainX <- read.table("./train/X_train.txt")
  trainY <- read.table("./train/y_train.txt")
  trainSub <- read.table("./train/subject_train.txt")
  
  feature_names <-  features[,2]  # Extract only feature names
  
  colnames(testX) <- feature_names
  colnames(testSub) <- "subject_id"
  colnames(testY) <- "activity_id"
  
  colnames(trainX) <- feature_names
  colnames(trainSub) <- "subject_id"
  colnames(trainY) <- "activity_id"
  
  ##Combine the test subject id's, the test activity id's 
  test_data <- cbind(testSub, testY, testX)
  ##Combine the test subject id's, the test activity id's 
  train_data <- cbind(trainSub, trainY, trainX)
  ##Combine the test data and the train data into one dataframe
  all_data <- rbind(train_data,test_data)
  
  mean_idx <- grep("mean",names(all_data),ignore.case=TRUE)
  mean_names <- names(all_data)[mean_idx]
  std_idx <- grep("std",names(all_data),ignore.case=TRUE)
  std_names <- names(all_data)[std_idx]
  
  full_data <-all_data[,c("subject_id","activity_id",mean_names,std_names)]
  
  
  ##Merge the activities datase with the mean/std values datase 
  descr_data <- merge(activity_labels,full_data,by.x="activity_id",by.y="activity_id",all=TRUE)
  
  ##Melt everything according to each variable (activity_id, activity_name, and subject_id)
  melt_data <- melt(descr_data,id=c("activity_id","activity_name","subject_id"))
  
  ##Cast the melted dataset according to the average of each variable 
  mean_data <- dcast(melt_data,activity_id + activity_name + subject_id ~ variable,mean)
  
  ## Create a file with the new tidy dataset
  write.table(mean_data,"./tidy_data.txt")
  
  
}




