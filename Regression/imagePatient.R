library(kernlab)

all <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
total = 0

CV = matrix(data = 0,7,7)

for (i in 1:10){
  print(i)
  cur = sample(30)
  test = all[all$id %in% cur[1:3],]
  train = all[all$id %in% cur[4:30],]
  
  testx = as.matrix(test)
  testy = as.integer(surv[cur[1:3],])
  trainx = as.matrix(train)
  trainy = as.integer(surv[train$id,1])
  
  total = total + nrow(testx)
  if(T){
    for(SIGMA in seq(-3,3,by = 1)){
      for(OURC in seq(-3,3,by = 1)){
        arr = rep(0,3)
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=3^SIGMA),C=3^OURC)
        out = as.numeric(predict(model,testx))
        out[out==0] = -1
        cases = unique(test$id)
        for(i in 1:length(out)){
          arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
        }
        arr[arr==0] = sample(c(-1,1),1)
        #CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4] + sum((arr>=0)==as.integer(surv[cases,]))
        CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4]+sum(predict(model,testx)==as.integer(surv[test$id,1]))
      }
    }
  }
}
print(CV)
print(total)

