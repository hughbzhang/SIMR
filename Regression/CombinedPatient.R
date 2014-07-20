library(kernlab)

all <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
demo <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")

CV = matrix(data = 0,7,7)

for (i in 1:100){
  print(i)
  cur = sample(30)
  test = all[all$id %in% cur[1:3],]
  train = all[all$id %in% cur[4:30],]
  
  testx = as.matrix(test)
  testy = as.integer(surv[cur[1:3],])
  trainx = as.matrix(train)
  trainy = as.integer(surv[train$id,1])
  
  
  if(T){
    for(SIGMA in seq(-3,3,by = 1)){
      for(OURC in seq(-3,3,by = 1)){
        arr = rep(0,3)
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=10^SIGMA),C=2^OURC)
        out = as.numeric(predict(model,testx,'decision'))
        cases = unique(test$id)
        for(i in 1:length(out)){
          arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
        }
        CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4] + sum((arr>=0)==testy)
      }
    }
  }
  
}
print(CV)

