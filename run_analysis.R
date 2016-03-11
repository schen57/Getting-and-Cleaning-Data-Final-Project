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

library(plyr)
library(dplyr)
total<-rbind(train,test)
total.activity<-rbind(activity.train,activity.test)
total.subject<-rbind(subject.train,subject.test)

names(total)<-features[,2]
names(total.activity)<-c("activity")
names(total.subject)<-c("subject")


all<-cbind(total.subject,total,total.activity)

all$activity<-factor(all$activity)
levels(all$activity)<-factor(activity.label[,2])

library(dplyr)
lable<-names(all)[grepl("(-mean)|(-std)",names(all))]
lable<-c("subject",lable,"activity")
all.mean.std<-subset(all,select=lable)

names(all.mean.std)<-gsub("^f","Freq",names(all.mean.std))
names(all.mean.std)<-gsub("^t","Time",names(all.mean.std))
names(all.mean.std)<-gsub("Acc","Acceleration",names(all.mean.std))
names(all.mean.std)<-gsub("Gyro","Gyroscope",names(all.mean.std))
names(all.mean.std)<-gsub("Mag","Magnitude",names(all.mean.std))
names(all.mean.std)<-gsub("BodyBody","Body",names(all.mean.std))

all2<-aggregate(.~subject+activity,all.mean.std,mean)
all2<-arrange(all2,subject,activity)
write.table(all2,"tidydata.txt",row.name=FALSE)
