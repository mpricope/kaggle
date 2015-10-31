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
