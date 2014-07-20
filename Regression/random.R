library(kernlab)

CV = matrix(data = 0,7,7)
TRAIN = matrix(data = 0,7,7)

sum = 0;



for (i in 1:100){
  
  random = matrix(data = runif(3000),ncol = 30,nrow = 100)
  print(i)
  test = random[1:5,]
  train = random[6:100,]
  
  Y = c(rep(0,50),rep(1,50))
  Y = Y[sample(100)]
  
  
  if(F){
    for(SIGMA in seq(-3,3,by = 1)){
      for(OURC in seq(-3,3,by = 1)){
        model = ksvm(train,Y[6:100],type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
        now = (sum(predict(model,test)!=Y[1:5]))
        CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4]+now
        TRAIN[SIGMA+4,OURC+4] = TRAIN[SIGMA+4,OURC+4]+sum(predict(model,train)!=Y[6:100])
      }
    }
  }
}

print(CV)
print(TRAIN)