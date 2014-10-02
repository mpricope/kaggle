library(RWeka)
load(paste('data/input',p,'RData',sep='.'))
load('data/corMatrix.CData')

formulas <- list()
thold <- list(SOC=0.58,pH=0.32,Ca=0.42,P=0.1,Sand=0.62)
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
}


pred <- list();

result <- data.frame(PIDN = test$PIDN)

for (i in myData$vars) {
  print(i)
  fit <- M5P(formula(formulas[[i]]),data = train)
  prediction <- predict(fit, test)
  result <- data.frame(result,prediction)
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.M5P_1.CData')

#0.2723955 0.3717670 0.2651979 0.9210474 0.2561605