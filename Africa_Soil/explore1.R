
library(rgl)
library(akima)
library(plot3D)
library(scatterplot3d)
library(Rcmdr) 

p = 'p'
load(paste('data/input',p,'RData',sep='.'))


extractInfraMatrix <- function (df) {
  
  mNames <- grep("^m\\d*",colnames(df),value = TRUE)
  
  
  r <- df[,mNames]
  mNames <- sub("m","",mNames)
  colnames(r) <- mNames
  return(r)
}


im <- extractInfraMatrix(train)

pim <- cbind(P=train$SOC,im)
pim <- pim[order(pim$P),]

oim <- pim[,colnames(im)]

sm <- oim

xo <- train$pH
yo <- as.numeric(colnames(sm))
# sampleX <- seq(1,length(xo),10)
# sampleY <- seq(1,length(yo),10)
# size <- length(sample) * length(sampleY)
# x <- rep(0,size)
# y <- rep(0,size)
# z <- rep(0,size)

# png(filename="figure.png", height=10000, width=10000, 
#     bg="white")
samples <- seq(1,1157,200)
cols <- heat.colors(length(samples))
plot(yo,t(sm[slice,]),type="l",col="blue")
l <- c()
for (i in 1:length(samples)) {
  lines(yo,t(sm[samples[i],]),col=cols[i])
  l <- c(l,pim$P[samples[[i]]])
}

samples <- seq(1,3578,200)
cols <- heat.colors(length(samples))
xo <- sm[slice,]
yo <- as.numeric(colnames(sm))
plot(yo,t(sm[slice,]),type="l",col="blue")
l <- c()
for (i in 1:length(samples)) {
  lines(yo,t(sm[samples[i],]),col=cols[i])
  l <- c(l,pim$P[samples[[i]]])
}

# slice <- 200
# plot(yo,t(sm[slice,]),type="l",col="red")
# pim$P[slice]
# slice <- 100
# lines(yo,t(sm[slice,]),col="green")
# pim$P[slice]
#legend("topright", inset=.05, legend=l,fill=cols,title="P values")
# dev.off()

# zi <- 1
# for (i in sampleX) {
#   print(i)
#   for (j in sampleY) {
#     x[zi] <- xo[i]
#     y[zi] <- yo[j]
#     z[zi] <- im[[i,j]]
#     zi <- zi + 1
#   }
# }

#aki <- interp(x,y,z,xo=xo,yo=yo,duplicate="strip")
#scatterplot3d(x,y,z,highlight.3d = TRUE,col.axis = "blue", col.grid = "lightblue")
#scatter3d(z,x,y,fit=c( "lin"))
#scatter3d(aki$x, aki$y, aki$z)


# pim <- cbind(P=train$P,im)
# pim <- pim[order(pim$P),]
# 
# aki <- interp(pim$P,colnames(im),pim[colnames(im),])
