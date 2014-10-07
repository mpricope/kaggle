library(caret)
library(rpart)

p='p'

source(paste('loader',p,'R',sep='.'),echo=TRUE)
source('var_engineering.R',echo=TRUE)
source('corMatrix2.R',echo=TRUE)

nfolds <- 5;
flds <- createFolds(1:nrow(train), k = nfolds)

origTrain <- train
err<- data.frame(matrix(nrow=0,ncol=(length(myData$vars) + 1)))

myData$vars <- c('Ca','P')

for (idxFold in 1:nfolds) {
  test <- origTrain[flds[[idxFold]],]
  train <- origTrain[-flds[[idxFold]],]
  save(train,test,myData,file='data/f.RData')
  
  source('knn.R',echo=TRUE)
#  source('h2o_1.R',echo=TRUE)
  source('combine.R',echo=TRUE)
  
  tme <- c(e,em)
  err[idxFold,] <- tme
  
}

colnames(err) <- c(myData$vars,'All')

analyzeErr <- data.frame(matrix(nrow=0,ncol=(length(myData$vars) + 1)))

analyzeErr['means',] <- colMeans(err)
analyzeErr['maxes',] <- apply(err, 2, max)
analyzeErr['mins',] <- apply(err,2,min)
analyzeErr['deviance',] <- (analyzeErr['maxes',] - analyzeErr['mins',]) / analyzeErr['means',]
colnames(analyzeErr) <- c(myData$vars,'All')

#source('RWeka.R',echo=TRUE)
# source('rforest1.R',echo=TRUE)
# source('cforest1.R',echo=TRUE)
