ptm <- proc.time()


load('data/train.RData')
# load('data/test.RData')
# load('data/trainLabels.RData')


# sy <- apply(trainLabels[,2:34],1,sum)

ctrl <- glm.control(epsilon = 1e-8, maxit = 25, trace = TRUE)

sSize <- 100000;


#combi <- cbind(train[1:sSize,2:10],trainLabels[1:sSize,2:3])

hf <- c()

for (i in colnames(train)) {
  if (is.factor(train[,i]) && (nlevels(train[,i]))>10) {
    train[,i] <- as.character(train[,i])
    hf <- c(hf,i)
  }
}

print(hf)
hf2 <- c()
for (i in 1:(length(hf) - 1)) {
  for (j in (i + 1):length(hf)) {
    hfi <- hf[[i]]
    hfj <- hf[[j]]
    nc <- paste(hfi,hfj)
    print(nc)
    hf2 <- c(hf2,nc)
    train[,nc] <- paste(train[,hfi],train[,hfj])
  }
}



print("Back to factor")

for (i in c(hf,hf2)) {
  print(i)
  train[,i] <- factor(train[,i])
}

save(test,file='data/test2.RData')
print("and to numeric")


for (i in colnames(train)) {
  if (is.factor(train[,i])) {
    train[,i] <- as.numeric(train[,i])
  }
}

# xtrain <- train[1:sSize,2:146]
# ytrain <- as.matrix(trainLabels[1:sSize,2])

#mf <- model.matrix(f,combi)
#fit <- glm.fit(xtrain,ytrain,control=ctrl,family=binomial(logit))
#fit <- glm(f, combi, control=ctrl,family=binomial(logit))

write.csv(train, file = "data/train_2.csv", row.names = FALSE)
proc.time() - ptm