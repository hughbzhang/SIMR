library(kernlab)

ORIGIN <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")

total = 0

SOLO = rep(0,31)


for(a in 1:31){
  print(a)
  CV = matrix(data = 0,11,11)
  TRAIN = matrix(data = 0,11,11)
  #CV = rep(0,11)
  #TRAIN = rep(0,11)
  # 7 8 23
  all = ORIGIN[,c(a,32)]

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
      for(SIGMA in seq(-4,1,by = .5)){
        for(OURC in seq(-1,4,by = .5)){
          arr = rep(0,3)
          model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
          out = as.numeric(predict(model,testx))
          out[out==0] = -1
          cases = unique(test$id)
          for(i in 1:length(out)){
            arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
          }
          arr[arr==0] = sample(c(-1,1),1)
          
          CV[2*SIGMA+9,2*OURC+3] = CV[2*SIGMA+9,2*OURC+3] + sum((arr>=0)==as.integer(surv[cases,]))
          TRAIN[2*SIGMA+9,2*OURC+3] = TRAIN[2*SIGMA+9,2*OURC+3] + sum(predict(model,trainx)==as.integer(surv[train$id,1]))
          
        }
      }
    }
    if(F){
      
      for(SIGMA in seq(1,3,by = .2)){
        for(OURC in seq(.1,1,by = .1)){
          arr = rep(0,3)
          model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=SIGMA),C=OURC)
          out = as.numeric(predict(model,testx))
          out[out==0] = -1
          cases = unique(test$id)
          for(i in 1:length(out)){
            arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
          }
          CV[5*SIGMA-4,10*OURC] = CV[5*SIGMA-4,10*OURC] + sum((arr>=0)==as.integer(surv[cases,]))
          TRAIN[5*SIGMA-4,10*OURC] = TRAIN[5*SIGMA-4,10*OURC] + sum(predict(model,trainx)==as.integer(surv[train$id,1]))
          
          
          #CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4]+sum(predict(model,testx)==as.integer(surv[test$id,1]))
        }
      }
    }
    
  }
  SOLO[a] = max(CV)
}
print(SOLO)