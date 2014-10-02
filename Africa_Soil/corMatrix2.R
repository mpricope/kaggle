load('data/e.RData')

computeCorr <- function(vars,mNames,m) {
  
  #mNames <- colnames(m)
  
  res.cor <-data.frame(matrix(NA,nrow=0,ncol=length(mNames)))
  
  
  for (v in vars) {
    v.cor <- rep(0,length(mNames))
    #train <- train[order(train$P),]
    
    for (i in 1:length(mNames)) {
      v.cor[i] <- abs(cor(m[,mNames[i]],m[,v],method="spearman"))
    }
    
    res.cor <- rbind(res.cor,v=v.cor)
    
  }
  
  colnames(res.cor) <- mNames
  rownames(res.cor) <- vars
  
  
  return (res.cor)
}


cols <- colnames(train)
remove <- c('PIDN','Depth',myData$vars)
cols <- cols[! cols %in% remove]

myData$CM <- computeCorr(myData$vars,cols,train)

save(train,test,myData,file='data/c.RData')