library("EBImage")




extractRGB <- function (img) {
  img = resize(img,100)
  kern = imageData(img)
  grayKern = imageData(channel(img,"gray"))
  clusters = kmeans(as.vector(grayKern),2)
  cData = matrix(clusters$cluster,nrow=nrow(kern),ncol=ncol(kern))
  
  cData[cData == 2] = 0
  tmKern = kern
  kern[,,1] = kern[,,1] * cData
  kern[,,2] = kern[,,2] * cData
  kern[,,3] = kern[,,3] * cData
  s = sum(cData)
  r1 = sum(kern[,,1])/s
  g1 = sum(kern[,,2])/s
  b1 = sum(kern[,,3])/s
  rgb1 = c(r1,g1,b1)
  
  kern = tmKern
  cData = 1 - cData
  kern[,,1] = kern[,,1] * cData
  kern[,,2] = kern[,,2] * cData
  kern[,,3] = kern[,,3] * cData
  s = sum(cData)
  r2 = sum(kern[,,1])/s
  g2 = sum(kern[,,2])/s
  b2 = sum(kern[,,3])/s
  rgb2 = c(r2,g2,b2)
  

  d1 = max(rgb1) - min(rgb1)
  d2 = max(rgb2) - min(rgb2)
  
  if (d1 > d2) {
    return (rgb1)
  } else {
    return (rgb2)
  }
  


}

getImageMainColor <- function (img) {
  img_data = imageData(img)
  
#   iWidth = nrow(img_data)
#   iWidth3 = as.integer(iWidth/3)
#   iHeight = ncol(img_data)
#   iHeight3= as.integer(iHeight/3)
  kern = img_data
  #display(rgbImage(red=kern[,,1],green=kern[,,2],blue=kern[,,3]))
  return (extractRGB(img))
}


#rgb1 = c(mean(kern[,,1]),mean(kern[,,2]),mean(kern[,,3]))
#rgb2 = getImageMainColor(i755)


m <- matrix(nrow=0,ncol=4)
for (f in list.files("data")) {
  img = readImage(paste("data",f,sep="/"))
  v = gsub(".jpg","",f)
  r = getImageMainColor(img)
  r = c(r,as.numeric(v))
  print(r)
  m = rbind(m,r)
}

rgbF = data.frame(m)
colnames(rgbF) = c('R','G','B','ph')

fit = lm(ph~R+G+B,rgbF)

# mp = matrix(nrow=0,ncol=3)
# p = c(0.53,0.48,0.25)
# mp = rbind(mp,p)
# mpf = data.frame(mp)
# colnames(mpf) = c('R','G','B')
# 
# predict(fit,mpf)

for (f in list.files("p")) {
  img = readImage(paste("p",f,sep="/"))
  r = getImageMainColor(img);
  mp = matrix(nrow=0,ncol=3)
  mp = rbind(mp,r)
  mpf = data.frame(mp)
  colnames(mpf) = c('R','G','B')
  p = predict(fit,mpf)
  print(paste(f,p))
}


