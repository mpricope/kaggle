library(rgl)
library(akima)
library(plot3D)
library(scatterplot3d)
library(Rcmdr) 

p = 'p'
load(paste('data/input',p,'RData',sep='.'))

mNames <- grep("^m\\d*",colnames(train),value = TRUE)
mValues <- as.numeric(sub("m","",mNames))

vars <- c('SOC','pH','Ca','P','Sand')

res <-data.frame(matrix(NA,nrow=0,ncol=length(mValues)))
colnames(res) <- mValues

for (var in vars) {
  v.cor <- rep(0,length(mNames))
  
  #train <- train[order(train$P),]
  
  for (i in 1:length(mNames)) {
    v.cor[i] <- abs(cor(train[,mNames[i]],train[,var],method="spearman"))
  }
  
  res <- rbind(res,var=v.cor)
  
}

corMatrix <- res

save(corMatrix,file='data/corMatrix.CData')


summary(t(res))