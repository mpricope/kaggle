library(randomForest)
#install.packages('party')
library(party)
library(doParallel)
library(foreach)


load(paste('data/input',p,'RData',sep='.'))
load('data/corMatrix.CData')

formulas <- list()
thold <- list(SOC=0.58,pH=0.2,Ca=0.42,P=0.1,Sand=0.62)
fSize <- list()
#colnames(formulas) <- myData$vars

for (i in myData$vars) {
  cors <- myData$CM[i,]
  
  tmf <- c()
  
  for (j in colnames(myData$CM)) {
    if (myData$CM[[i,j]] > thold[[i]]) {
      tmf <- c(tmf,j)
    }
  }
  tmE <- paste(i,paste(tmf,collapse=' + '),sep = ' ~ ')
  formulas[i] <- tmE
  fSize[i] <- length(tmf)
}


pred <- list();

result <- data.frame(PIDN = test$PIDN)

for (i in myData$vars) {
  print(i)
#  fit <- randomForest(formula(formulas[[i]]), data=train,importance=TRUE, ntree=200,mtry=sqrt(fSize[[i]]),do.trace=TRUE)
  
#   fit <- foreach(ntree=rep(10, 2), .combine=combine, .multicombine=TRUE,
#                  .packages='randomForest') %dopar% {
#                    randomForest(formula(formulas[[i]]), data=train,importance=TRUE, ntree=ntree,do.trace=TRUE)
#                  }
     fit <- cforest(formula(formulas[[i]]),data = train, 
                                 controls=cforest_unbiased(ntree=100, mtry=sqrt(fSize[[i]]), trace=TRUE))
   prediction <- predict(fit, test, OOB=TRUE, type = "response")
  #predictions <- cbind(predictions, bart_model$yhat.test.mean)    
  result <- data.frame(result, prediction)
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.cforest_1.CData')

#[1] 0.3181883 0.2783921 0.1986112 0.9727586 0.2765177
#[1] 0.3095697 0.2750911 0.1858575 0.9697993 0.2767274
#0.2853063 0.2721118 0.1405402 0.9732137 0.2532755