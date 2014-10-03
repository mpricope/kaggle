# The following two commands remove any previously installed H2O packages for R.
# if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
# if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }
# 
# # Next, we download, install and initialize the H2O package for R.
# install.packages("h2o", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-lambert/5/R", getOption("repos"))))
#install.packages("h2o", repos=(c("http://s3.amazonaws.com/h2o-release/h2o/master/1522/R", getOption("repos"))))
library(h2o)
#localH2O = h2o.init()
localH2O <- h2o.init(ip = 'localhost', port =54321, startH2O = TRUE)

# Finally, let's run a demo to see H2O at work.
#demo(h2o.glm)
#thold <- list(SOC=0.58,pH=0.2,Ca=0.42,P=0.1,Sand=0.62)
#thold <- list(SOC=0.5,pH=0.1,Ca=0.4,P=0.1,Sand=0.5)
thold <- list(SOC=0.05,pH=0.05,Ca=0.05,P=0.05,Sand=0.05)


tmf <- paste(getwd(),'data/tmp.csv',sep='/')
write.csv(train,'data/tmp.csv')
train_hex <- h2o.importFile(localH2O, path = tmf, key = "train.hex")
write.csv(test,'data/tmp.csv')
test_hex <- h2o.importFile(localH2O, path = tmf, key = "test.hex")

#train_hex_split <- h2o.splitFrame(train_hex, ratios = 0.8, shuffle = TRUE)

result <- data.frame(PIDN = test$PIDN)

for (i in myData$vars) {
  print(i)
  
  tmf <- c()
  
  for (j in colnames(myData$CM)) {
    if (myData$CM[[i,j]] > thold[[i]]) {
      tmf <- c(tmf,j)
    }
  }
  
  
  model <- h2o.deeplearning(x = tmf,
                            y = i,
                           data = train_hex,
#                              data = train_hex_split[[1]],
#                              validation = train_hex_split[[2]],
                            activation = "RectifierWithDropout",
                            hidden = c(150, 150,150),
                            epochs = 50,
                            seed=123456,
                            
                            classification = FALSE,
                            balance_classes = FALSE)
  
  print(model)
  
  prediction <-as.matrix(h2o.predict(model, test_hex))
  #result <- data.frame(result, i=prediction)
  result[,i] <- prediction
}

colnames(result) <- c('PIDN',myData$vars)

save(result,file='data/result.h2o_1.CData')

h2o.shutdown(localH2O, prompt = FALSE)

#thold <- list(SOC=0.58,pH=0.2,Ca=0.42,P=0.1,Sand=0.62)
#[1] 0.2340749 0.3144453 0.1573988 0.9390527 0.2559151


#thold <- list(SOC=0.5,pH=0.1,Ca=0.4,P=0.1,Sand=0.5)
#0.2235268 0.2083472 0.1463633 0.8489877 0.2466914
#c(200, 75,75,75),
#[1] 0.3397601 0.3008425 0.1450592 0.8949653 0.3654738
#c(75, 75,75,75),
#[1] 0.3393470 0.3384734 0.2219386 0.8673410 0.4205581


#1] 0.2501543 0.3231305 0.1960264 0.9035039 0.3500675