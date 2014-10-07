library(caret)
library(rpart)


train <- read.csv("data/training.csv");
test <- read.csv("data/sorted_test.csv");
p = 'p'

test$SOC <- 0
test$pH<- 0
test$Ca <- 0
test$P <- 0
test$Sand <- 0


save(train,test, file=paste('data/input',p,'RData',sep='.'))

#load('data/input.test.RData')