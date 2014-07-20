library(kernlab)

all <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")

CV = matrix(data = 0,11,1)

for (i in 1:10125/0){
  print(i)
  cur = sample(30)
  test = all[cur[1:3],]
  train = all[cur[4:30],]

  testx = as.matrix(test[,-3])
  testy = as.integer(surv[cur[1:3],])
  trainx = as.matrix(train[,-3])
  trainy = as.integer(surv[cur[4:30],])
  
  if(F){
    for(SIGMA in seq(-3,0,by = .5)){
      for(OURC in seq(0,3,by = .5)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
        now = (sum(predict(model,testx)!=testy))
        CV[SIGMA*2+7,2*OURC+1] = CV[2*SIGMA+7,2*OURC+1]+now
      }
    }
  }
  if(T){
    for(OURC in seq(-5,5,by = 1)){
      model = ksvm(trainx,trainy,type = "C-svc",kernel = 'vanilla',kpar = list(),C=2^OURC)
      now = (sum(predict(model,testx)!=testy))
      CV[OURC+6] = CV[OURC+6]+now
    }
  
  }
}
print(CV)

