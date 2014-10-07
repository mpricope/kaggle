library(caret)
library(rpart)


train1 <- read.csv("data/training.csv");

set.seed(8)
trainIndex <- createDataPartition(1:nrow(train1), p = 0.5, 
                                  list = FALSE, times = 1)
train <- train1[trainIndex,]
test <- train1[-trainIndex,]

save(train,test, file='data/input.test.RData')

#load('data/input.test.RData')