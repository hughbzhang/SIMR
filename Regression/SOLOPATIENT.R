library(kernlab)

surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")

total = 0

SOLO = rep(0,11)
LOL = rep(0,11)

for(a in 1:11){
  print(a)
  CV = matrix(data = 0,11,11)
  TRAIN = matrix(data = 0,11,11)
  #CV = rep(0,11)
  #TRAIN = rep(0,11)
  # 7 8 23
  #all = clin[,-3]
  all = clin[,a]
  
  for (i in 1:100){
    
    cur = sample(30)
    test = all[cur[1:3]]
    train = all[cur[4:30]]
    
    testx = as.matrix(test)
    testy = as.integer(surv[cur[1:3],])
    
    trainx = as.matrix(train)
    trainy = as.integer(surv[cur[4:30],])
    
    total = total + nrow(trainx)
    if(T){
      for(SIGMA in seq(-5,5,by = 1)){
        for(OURC in seq(-5,5,by = 1)){
          arr = rep(0,3)
          model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
          out = as.numeric(predict(model,testx))
          
          CV[SIGMA+6,OURC+6] = CV[SIGMA+6,OURC+6] + sum(out==testy)
          TRAIN[SIGMA+6,OURC+6] = TRAIN[SIGMA+6,OURC+6] + sum(predict(model,trainx)==trainy)
          
        }
      }
    }
  }
  SOLO[a] = max(CV)
  LOL[a] = max(TRAIN)
}
print(LOL)