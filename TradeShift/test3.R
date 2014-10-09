load('data/train.RData')
load('data/test.RData')

# 
# for (i in colnames(train)) {
#   if (is.numeric(train[,i])) {
#     min = min(train[,i])
#     max = max(train[,i])
#     train[,i] = train[,i] / (max - min)
#   }
# }

nums = c(5, 6, 7, 8, 9, 15, 16, 17, 18, 19, 20, 21, 22, 23, 27, 28, 29, 36, 37, 38, 39, 40, 46, 47, 48, 49, 50, 51, 52, 53, 54, 58, 59, 60, 66, 67, 68, 69, 70, 76, 77, 78, 79, 80, 81, 82, 83, 84, 88, 89, 90, 96, 97, 98, 99, 100, 106, 107, 108, 109, 110, 111, 112, 113, 114, 118, 119, 120, 121, 122, 123, 124, 125, 131, 132, 133, 134, 135, 136, 137, 138, 139, 143, 144, 145)

for (n in nums) {
  i = paste("x",n,sep="")
  print(i)
  min = min(train[,i],test[,i])
  max = max(train[,i],test[,i])
  train[,i] = train[,i] / (max - min)
  test[,i] = test[,i] / (max - min)
  
}

# for (n in nums) {
#   i = paste("x",n,sep="")
#   print(i)
#   min = min(test[,i])
#   max = max(test[,i])
#   test[,i] = test[,i] / (max - min)
#   
# }

write.csv(train, file = "data/train_3.csv", row.names = FALSE)
write.csv(test, file = "data/test_3.csv", row.names = FALSE)