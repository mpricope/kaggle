ptm <- proc.time()

#train <- read.csv("data/train.csv");
test <- read.csv("data/test.csv");
trainLabels <- read.csv('data/trainLabels.csv')

load('data/train.RData')

#save(train,file='data/train.RData')
save(test,file='data/test.RData')
save(trainLabels,file='data/trainLabels.RData')


proc.time() - ptm
