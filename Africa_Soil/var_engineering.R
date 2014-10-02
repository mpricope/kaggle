library(caret)
library(rpart)


load(paste('data/input',p,'RData',sep='.'))

mNames <- grep("^m\\d*",colnames(train),value = TRUE)
mValues <- as.numeric(sub("m","",mNames))

vars <- c('SOC','pH','Ca','P','Sand')

tmNames <- colnames(train)
otherVars <- tmNames[! tmNames %in% c('PIDN','Depth',mNames,vars)]
myData <- list(mNames=mNames,mValues=mValues,vars=vars,otherVars=otherVars)

trainSize = nrow(train)
testSize = nrow(test)

combi <- rbind(train, test);

vDiff <- function (r) {
  x1 <- r[1:(length(r) - 1)]
  x2 <- r[2:(length(r))]
  return (x2 - x1)
}

#diff <- data.frame(matrix(NA,nrow=0,ncol=(length(myData$mValues) -1) ))

dmV <- vDiff(myData$mValues)

mDiff <- function (x,dm) {
  r <- vDiff(x) / dm
  return (r)
}

df <- t(apply(combi[,myData$mNames],1,mDiff,dm=dmV))
diff <- data.frame(df)

dNames <- sub("m","d",myData$mNames[1:(length(myData$mNames) - 1)]);

myData$dNames <- dNames
colnames(diff)<- dNames
# for (i in 1:nrow(combi)) {
#   print(i)
#   r <- combi[i,myData$mNames]
#   x1 <- r[1:(length(r) - 1)]
#   x2 <- r[2:(length(r))]
#   tmd <- (x2 - x1)
#   #   for (j in 1:(length(myData$mValues) -1)) {
# #     
# #     n1 <- myData$mNames[j];
# #     n2 <- myData$mNames[j + 1]
# #     tmd[j] <- (combi[[i,n1]] - combi[[i,n2]]) / (myData$mValues[j + 1] - myData$mValues[j])
# #   }
#   diff[i,] <- tmd
# }

combi <- data.frame(combi,diff)


train <- combi[1:trainSize,]
test <- combi[(trainSize + 1):(trainSize+testSize),]


save(train,test,myData,file='data/e.RData')