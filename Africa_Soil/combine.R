load(paste('data/input',p,'RData',sep='.'))
load('data/f.RData')

algs <- c('svm_1')
#algs <- c('dl_1','M5P_1')
#algs <- c('M5P_1','rforest_1','cforest_1')

cr <- data.frame(PIDN = test$PIDN)

cNames <- data.frame(matrix(nrow=0,ncol=length(myData$vars)))


for (i in algs) {
  file <- paste('data/result',i,'CData',sep='.')
  load(file)
  tmName <- c()
  for (j in myData$vars) {
    cname <- paste(j,i,sep='.')
    cr[,cname] <- result[,j]
    tmName <- c(tmName,cname)
  }
  cNames[i,] <- tmName
  
}

colnames(cNames) <- myData$vars


# for (i in myData$vars) {
#   cols <- cNames[,i]
#   tmp <- apply(cr[,cols],1,mean)
#   cr[,i] <- tmp
# }


evalSoil <- function (res,test,vars) {
  r <- c()
  l <- 1/nrow(res)
  for (i in vars) {
    r <- c(r,l*sum(((res[,i])-(test[,i]))^2))
  }
  return(r)
  
}

# cr[,'SOC'] <- cr[,'SOC.h2o_1']
# cr[,'pH'] <- cr[,'pH.h2o_1']
cr[,'Ca'] <- cr[,'Ca.svm_1']
cr[,'P'] <- cr[,'P.svm_1']
# cr[,'Sand'] <- cr[,'Sand.h2o_1']

# cr[,'SOC'] <- cr[,'SOC.dl_1']
# cr[,'pH'] <- cr[,'pH.dl_1']
# cr[,'Ca'] <- cr[,'Ca.dl_1']
# cr[,'P'] <- cr[,'P.dl_1']
# cr[,'Sand'] <- cr[,'Sand.dl_1']



e <- evalSoil(cr,test,myData$vars)
em <- sum(e)/(length(myData$vars))

print(c(e,em))

# outv <- c('PIDN',myData$vars)
# 
# write.csv(cr[,outv], paste('data/predictions',p,'csv',sep='.'), row.names=FALSE)

