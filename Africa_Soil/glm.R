library(glm2)
library(stats)
library(gbm)
#load(paste(data/input',p,'RData',sep='.'))
load('data/f.RData')

thold <- list(SOC=0.3,pH=0.1,Ca=0.15,P=0.05,Sand=0.3)
usedCols <- c(myData$otherVars,myData$mNames,myData$dNames)
#colnames(formulas) <- myData$vars


pred <- list();

result <- data.frame(PIDN = test$PIDN)

for (i in myData$vars) {
  print(i)
  tmf <- c()
  
  for (j in usedCols) {
    if (myData$CM[[i,j]] > thold[[i]]) {
      tmf <- c(tmf,j)
    }
  }
  tmE <- paste(i,paste(tmf,collapse=' + '),sep = ' ~ ')
  xtrain <- as.matrix(train[,tmf])
  ytrain <- as.matrix(train[,i])
  nTrees = 10
  fit <- gbm.fit(xtrain,ytrain,distribution="gaussian",n.trees = nTrees)
  print("Predict")
  prediction <- predict.gbm(fit, test,type="response",n.trees = nTrees)
  result <- data.frame(result,prediction)
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.gbm.CData')

#0.2723955 0.3717670 0.2651979 0.9210474 0.2561605