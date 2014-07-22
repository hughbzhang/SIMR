library(kernlab)

ORIGIN <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")

total = 0

SOLO = rep(0,11)


for(a in 1:11){
  print(a)
  CV = matrix(data = 0,11,11)
  TRAIN = matrix(data = 0,11,11)
  #CV = rep(0,11)
  #TRAIN = rep(0,11)
  # 7 8 23
  all = cbind(clin[,a],surv)
  
  for (i in 1:100){
    cur = sample(30)
    test = all[all$id %in% cur[1:3],]
    train = all[all$id %in% cur[4:30],]
    
    testx = as.matrix(test)
    testy = as.integer(surv[cur[1:3],])
    trainx = as.matrix(train)
    trainy = as.integer(surv[train$id,1])
    
    total = total + nrow(trainx)
    if(T){
      for(SIGMA in seq(-5,5,by = 1)){
        for(OURC in seq(-5,5,by = 1)){
          arr = rep(0,3)
          model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
          out = as.numeric(predict(model,testx))
          out[out==0] = -1
          cases = unique(test$id)
          for(i in 1:length(out)){
            arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
          }
          arr[arr==0] = sample(c(-1,1),1)
          
          CV[SIGMA+6,OURC+6] = CV[2*SIGMA+9,2*OURC+3] + sum((arr>=0)==as.integer(surv[cases,]))
          TRAIN[SIGMA+6,OURC+6] = TRAIN[2*SIGMA+9,2*OURC+3] + sum(predict(model,trainx)==as.integer(surv[train$id,1]))
          
        }
      }
    }
  }
  SOLO[a] = max(CV)
}
print(SOLO)