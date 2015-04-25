setwd("c:/users/marc/documents/r")

if(!file.exists("data")){
  dir.create("data")
}
library(dplyr)

#get the activity labels
act_desc<-data.frame("id"=1:6, 
  "act_desc"=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
               "SITTING","STANDING","LAYING"))
#get variable labels
varLabel<-read.table("./data/proj1/UCI HAR Dataset/features.txt")

fl<-"./data/proj1/UCI HAR Dataset/test/X_test.txt"
test_x<-read.table(fl)
names(test_x)<-varLabel$V2 #rename the variables

fl<-"./data/proj1/UCI HAR Dataset/test/y_test.txt"
test_activity<-read.table(fl)
test_activity<-rename(test_activity,act.id=V1) #rename variable for readability
fl<-"./data/proj1/UCI HAR Dataset/test/subject_test.txt"
test_subject<-read.table(fl)
test_subject<-rename(test_subject,subj.id=V1) #rename variable for readability

test<-cbind(test_x,test_subject,test_activity)
test<-merge(test,act_desc,by.x="act.id",by.y="id")

# training data
fl<-"./data/proj1/UCI HAR Dataset/train/X_train.txt"
train_x<-read.table(fl)
names(train_x)<-varLabel$V2 #rename the variables

fl<-"./data/proj1/UCI HAR Dataset/train/y_train.txt"
train_activity<-read.table(fl)
train_activity<-rename(train_activity,act.id=V1) #rename variable for readability
fl<-"./data/proj1/UCI HAR Dataset/train/subject_train.txt"
train_subject<-read.table(fl)
train_subject<-rename(train_subject,subj.id=V1) #rename variable for readability

train<-cbind(train_x,train_subject,train_activity)
train<-merge(train,act_desc,by.x="act.id",by.y="id")

total<-rbind(test,train)

#find columns with variable names containing 'mean' or 'std'
ind<-grep("mean|std|act_desc|subj.id",names(total))

total<-total[,ind]  #reduce total data frame to vars of interest

#finally group it up by subject and activity and find mean
final<-aggregate(total[,1:79],list(total$subj.id,total$act_desc),mean)
final<-rename(final,subj.id=Group.1,activity=Group.2)

write.table(final,"./data/final.txt",row.names=F)



