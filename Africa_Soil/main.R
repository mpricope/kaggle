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
for (idxFold in 1:nfolds) {
  test <- origTrain[flds[[idxFold]],]
  train <- origTrain[-flds[[idxFold]],]
  save(train,test,myData,file='data/f.RData')
  
  source('svm_1.R',echo=TRUE)
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

# SOC         pH         Ca         P       Sand       All
# means    0.08429452 0.11167649 0.11673376 0.8522810 0.09775450 0.2525481
# maxes    0.14607436 0.16054005 0.21054676 2.6176358 0.13051936 0.6069491
# mins     0.05490154 0.08379653 0.05418521 0.2644054 0.07931227 0.1175616
# deviance 1.08159838 0.68719492 1.33947156 2.7610969 0.52383357 1.9377995

#source('RWeka.R',echo=TRUE)
# source('rforest1.R',echo=TRUE)
# source('cforest1.R',echo=TRUE)
