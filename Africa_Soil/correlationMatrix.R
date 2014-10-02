library(rgl)
library(akima)
library(plot3D)
library(scatterplot3d)
library(Rcmdr) 


load(paste('data/input',p,'RData',sep='.'))

mNames <- grep("^m\\d*",colnames(train),value = TRUE)
mValues <- as.numeric(sub("m","",mNames))

vars <- c('SOC','pH','Ca','P','Sand')
#vars <- c('P')

addParams <- c('BSAN','BSAS','BSAV','CTI','ELEV','EVI','LSTD','LSTN',
               'REF1','REF2','REF3','REF7','RELI','TMAP','TMFI')

res.cor <-data.frame(matrix(NA,nrow=0,ncol=length(mValues)))


for (v in vars) {
  v.cor <- rep(0,length(mNames))
  #train <- train[order(train$P),]
  
  for (i in 1:length(mNames)) {
    v.cor[i] <- abs(cor(train[,mNames[i]],train[,v],method="spearman"))
  }
  
  res.cor <- rbind(res.cor,v=v.cor)
  
}

colnames(res.cor) <- mNames
rownames(res.cor) <- vars


corMatrix <- res.cor



res.cor <-data.frame(matrix(NA,nrow=0,ncol=length(addParams)))

for (v in vars) {
  v.cor <- rep(0,length(addParams))
  
  
  for (i in 1:length(addParams)) {
    v.cor[i] <- abs(cor(train[,addParams[i]],train[,v],method="spearman"))
  }
  
  res.cor <- rbind(res.cor,v=v.cor)
  
}


colnames(res.cor) <- addParams
rownames(res.cor) <- vars

addCorrM <- res.cor


CM<- cbind(addCorrM,corMatrix)

myData <- list(CM=CM,corMatrix=corMatrix,mNames=mNames,mValues=mValues,vars=vars)
# dt$CM <- CM
# dt$corMatrix = corMatrix
# dt$mNames = mNames
# dt$mValues = mValues

save(myData,file='data/corMatrix.CData')


