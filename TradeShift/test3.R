#submit <- read.csv("data/submission1234.csv");

#save(submit,file='data/submit.RData')

load('data/submit.RData')
submit$pred[submit$pred < 0.001] <- submit$pred[submit$pred < 0.001] / 100
write.csv(submit, file = "data/submit.csv", row.names = FALSE)