library("EBImage")
library("stats")
library(trimcluster)
library('kernlab')


i755 = readImage("data/4.9.jpg")
grayimage<-channel(i755,"gray")
#i755 = readImage("data/test.png")
kern = imageData(grayimage)

clusters = kmeans(as.vector(kern),2)
cData = matrix(clusters$cluster,nrow=nrow(kern),ncol=ncol(kern))
mid = cData[nrow(kern)/2,ncol(kern)/2]

kern = imageData(i755)

# for (i in 1:nrow(kern)) {
#   for (j in 1:ncol(kern)) {
#     if (cData[i,j] != mid) {
#       kern[i,j,] = c(0,0,0)
#     }
#   }
# }

cData[cData == 1] = 0
kern[,,1] = kern[,,1] * cData
kern[,,2] = kern[,,2] * cData
kern[,,3] = kern[,,3] * cData
sum(kern[,,1])/sum(cData)

#cData[cData == 2] = 0
    

#display(rgbImage(red=cData))
#display(i755)
display(rgbImage(red=kern[,,1],green=kern[,,2],blue=kern[,,3]))
