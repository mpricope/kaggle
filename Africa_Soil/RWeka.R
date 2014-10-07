library(RWeka)
#load(paste('data/input',p,'RData',sep='.'))
load('data/f.RData')

formulas <- list()
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
  fit <- SMO(formula(tmE),data = train)
  prediction <- predict(fit, test)
  result <- data.frame(result,prediction)
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.SMO_1.CData')

#0.2723955 0.3717670 0.2651979 0.9210474 0.2561605