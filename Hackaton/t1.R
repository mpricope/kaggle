library("EBImage")

 
#i755 = readImage("data/7.55.jpg")
#i755 = resize(i755,300)
#i755_data = imageData(i755)

# iWidth = nrow(i755_data)
# iWidth3 = as.integer(iWidth/3)
# iHeight = ncol(i755_data)
# iHeight3= as.integer(iHeight/3)
# 
# kern = i755_data[iWidth3:(2*iWidth3),iHeight3:(2*iHeight3),]



extractRGB <- function (kern) {
  s = c(0,0,0)
  count = 0
  for (i in 1:nrow(kern)) {
    for (j in 1:ncol(kern)) {
      r = kern[i,j,1]
      g = kern[i,j,2]
      b = kern[i,j,3]
      rgb = c(r,g,b)
      if (abs(min(rgb) - max(rgb)) > 0.07) {
        s = s + rgb
        count = count + 1
      }
    }
  }
  return (s/count)
}

getImageMainColor <- function (img) {
  img_data = imageData(img)
  
  iWidth = nrow(img_data)
  iWidth3 = as.integer(iWidth/3)
  iHeight = ncol(img_data)
  iHeight3= as.integer(iHeight/3)
  kern = img_data[iWidth3:(2*iWidth3),iHeight3:(2*iHeight3),]
  #display(rgbImage(red=kern[,,1],green=kern[,,2],blue=kern[,,3]))
  return (extractRGB(kern))
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


