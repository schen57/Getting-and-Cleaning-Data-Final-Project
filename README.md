# Getting-and-Cleaning-Data-Final-Project
Getting and Cleaning data final
---
title: "Getting and Cleaning Data Final Project"
author: "Shengyu Chen"
date: "March 9, 2016"
output: html_document
---
#Run Analysis 
###Getting and Cleaning Data - Final Project

Project Goal:
###

Reading the training data into R
Reading the test data into R
Reading features dataset into R
Reading activity training dataset into R
Reading activity test dataset into R
Reading subject train dataset into R
Reading activity label dataset into R
```{r}
setwd("C:/Users/Shengyu Chen/Dropbox/Academics/Coursera/Data Science Specialization/Getting and Cleaning Data/Final Project/UCI HAR Dataset")
#----
train<-read.table("./train/X_train.txt")
test<-read.table("./test/X_test.txt")
features<-read.table("features.txt")
#----
activity.train<-read.table("./train/y_train.txt")
activity.test<-read.table("./test/y_test.txt")
#----
subject.train<-read.table("./train/subject_train.txt")
subject.test<-read.table("./test/subject_test.txt")
#----
activity.label<-read.table("./activity_labels.txt")
```

Rowbind training and testing data sets
Rowbind activit.train and activity test data sets

```{r}
library(plyr)
library(dplyr)
total<-rbind(train,test)
total.activity<-rbind(activity.train,activity.test)
total.subject<-rbind(subject.train,subject.test)
```


Renaming total dataset
Rename activity dataset
Rename subject dataset

```{r}
names(total)<-features[,2]
names(total.activity)<-c("activity")
names(total.subject)<-c("subject")
```

##Merges the training and the test sets to create one data set.
Mergine the previous dataset altogether 
```{r}
all<-cbind(total.subject,total,total.activity)
```

##Uses descriptive activity names to name the activities in the data set
Subsitute the levels of activities
```{r}
all$activity<-factor(all$activity)
levels(all$activity)<-factor(activity.label[,2])
```

##Extracts only the measurements on the mean and standard deviation for each measurement.
Extract all the names that satisfy the condition
Select the columns that satisfy the ocndition 
```{r}
library(dplyr)
lable<-names(all)[grepl("(-mean)|(-std)",names(all))]
lable<-c("subject",lable,"activity")
all.mean.std<-subset(all,select=lable)
```


##Appropriately Label all the variables 
```{r}
names(all.mean.std)<-gsub("^f","Freq",names(all.mean.std))
names(all.mean.std)<-gsub("^t","Time",names(all.mean.std))
names(all.mean.std)<-gsub("Acc","Acceleration",names(all.mean.std))
names(all.mean.std)<-gsub("Gyro","Gyroscope",names(all.mean.std))
names(all.mean.std)<-gsub("Mag","Magnitude",names(all.mean.std))
names(all.mean.std)<-gsub("BodyBody","Body",names(all.mean.std))
```

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}
all2<-aggregate(.~subject+activity,all.mean.std,mean)
all2<-arrange(all2,subject,activity)
write.table(all2,"tidydata.txt",row.name=FALSE)
```

