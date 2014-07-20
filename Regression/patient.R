library(kernlab)

all <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")

CV = matrix(data = 0,11,11)
TRAIN = matrix(data = 0,11,11)

for (i in 1:30){
  if(i%%10==0){print(i)}
  test = all[i,]
  train = all[-i,]

  testx = as.matrix(test[,-3])
  testy = as.integer(surv[i,])
  trainx = as.matrix(train[,-3])
  trainy = as.integer(surv[-i,])
  
  if(T){
    for(SIGMA in seq(-5,5,by = 1)){
      for(OURC in seq(-5,5,by = 1)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
        CV[SIGMA+6,OURC+6] = CV[SIGMA+6,OURC+6]+sum(predict(model,testx)==testy)
        TRAIN[SIGMA+6,OURC+6] = TRAIN[SIGMA+6,OURC+6]+sum(predict(model,trainx)==trainy)
        
      }
    }
  }
  if(F){
    for(OURC in seq(-5,5,by = 1)){
      model = ksvm(trainx,trainy,type = "C-svc",kernel = 'vanilla',kpar = list(),C=2^OURC)
      now = (sum(predict(model,testx)==testy))
      CV[OURC+6] = CV[OURC+6]+now
    }
  }
}
print(CV)
print(TRAIN)

