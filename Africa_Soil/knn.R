library(ridge)
library(RSofia)

#load(paste('data/input',p,'RData',sep='.'))
load('data/f.RData')


#usedCols <- c(myData$mNames)
usedCols <- c(myData$otherVars,myData$mNames)
#usedCols <- myData$otherVars

#thold <- list(SOC=0,pH=0,Ca=0,P=0,Sand=0)
#thold <- list(SOC=0.3,pH=0.1,Ca=0.15,P=0.05,Sand=0.3)
thold <- list(SOC=0.05,pH=0.05,Ca=0.05,P=0.05,Sand=0.05)

result <- data.frame(PIDN = test$PIDN)



for (i in myData$vars) {
  
  tmf <- c()
  
  for (j in usedCols) {
    if (myData$CM[[i,j]] > thold[[i]]) {
      tmf <- c(tmf,j)
    }
  }
  print(paste(i,length(tmf),sep=":"))
  tmE <- paste(i,paste(tmf,collapse=' + '),sep = ' ~ ')
  
   xtrain <- as.matrix(train[,tmf])
   ytrain <- as.vector(train[,i])
  #   
  print ('Fitting Model')
  #x <- parse_formula(formula(tmE),train)

  tmp <- tempfile()
  write.svmlight(ytrain, xtrain, tmp)
  #write.svmlight(x$labels, x$data, tmp)
  fit <- sofia(tmp,iterations = 1e+05, learner_type="romma")
  unlink(tmp)
  #fit <- sofia(formula(tmE),train,scaling="none",iterations=10, learner_type="sgd-svm")
  # fit <- svm(xtrain,ytrain,type="eps-regression",
  #            kernel="radial basis",cost=10000)
  
  print("Prediction")
  #   xtest <- test[i,]
  ypred = predict(fit,newdata=as.matrix(test[,tmf]), prediction_type = "linear")
  result[,i] <- ypred
  
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.rdg.CData')

#[1] 0.07624523 0.11366035 0.11834555 0.81061377 0.12388556
#[1] 0.08729766 0.14411501 0.11366048 0.81696271 0.10589954