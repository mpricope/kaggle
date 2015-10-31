library('LargeRegression')

# load('data/train.RData')
# load('data/trainLabels.RData')

nums = c(5,6,7,9,29,36,37,38,39,47,59,66,67,68,69,70,
         90,96,97,98,99,100,120,121,122,123,124,125,145)

nums = paste('x',nums,sep='')

boundedSig = function (x) {
  return (1. / (1. + exp(-max(min(x, 20.), -20.))))
}

logloss = function (p,y) {
  p = max(min(p, 1. - 10e-15), 10e-15)
  if (y == 1) {
    return(-log(p))
  } else {
    return(-log(1-p))
  }
  
}

logloss = Vectorize(logloss,c('p','y'))

vSig = Vectorize(boundedSig,c('x'))

predict = function (X,w) {
  return(vSig(X %*% w))
}

sgd <- function (Y, X, B = matrix(0, ncol(as.matrix(X)), ncol(as.matrix(Y))), 
          alpha = 1/nrow(Y), convergence.threshold = 1e-04, penalty = 0, 
          min.iters = 0, max.iters = 200, gpu = F, intercept = F, 
          verbose = T) 
{
  if (!is.matrix(Y)) 
    Y = as.matrix(Y)
  if (!is.matrix(X)) 
    X = as.matrix(X)
  if (intercept) {
    design = cbind(1, X)
  }
  else {
    design = X
  }
  n = nrow(Y)
  p = ncol(Y)
  if (gpu & require(cudaMatrixOps)) {
    XTX = gpuCrossprod(design)
    XTY = gpuCrossprod(design, Y)
    for (iter in 1:max.iters) {
      update.step = XTY - gpuMatMult(XTX, B) + penalty * 
        B
      B.new = B + alpha * update.step
      if (sum((B.new - B)^2) < (convergence.threshold * 
                                  p) & (iter > min.iters)) {
        if (verbose) 
          print(paste("Converged on iteration", iter))
        return(B.new)
      }
      else {
        if (verbose) 
          print(paste("End iteration", iter))
        B = B.new
      }
    }
  }
  else {
    XTX = crossprod(design)
    XTY = crossprod(design, Y)
    for (iter in 1:max.iters) {
      #PredR = design %*% B
      
      Pred = predict(design,B)
      #update.step = XTY - XTX %*% B + penalty * B
      update.step = crossprod(design, (Y - Pred))
      B.new = B + alpha * update.step
      loss = sum(logloss(Pred,Y)) / (nrow(Y) * ncol(Y))
      
      if (loss < (convergence.threshold * 
                                  p) & (iter > min.iters)) {
        if (verbose) {
          print(paste("Converged on iteration", iter))
          print (paste("Error:",loss))
        }
        return(B.new)
      }
      else {
        if (verbose) {
          print(paste("End iteration", iter))
          print (paste("Error:",loss))
        }
        B = B.new
      }
    }
  }
  if (verbose) 
    print("Did not converge")
  return(B)
}

size = 100000

W = sgd(trainLabels[1:size,2:34],train[1:size,nums],max.iters = 10, gpu = FALSE)

p1 = predict(as.matrix(train[(size+1):(2*size),nums]),W) 
Y = as.matrix(trainLabels[(size+1):(2*size),2:34])
loss = sum(logloss(p1,Y)) / (nrow(Y) * ncol(Y))
loss
