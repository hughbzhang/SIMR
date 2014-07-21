library(kernlab)

ORIGIN <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")

total = 0

TEST = matrix(data = 0,11,11)
CV = matrix(data = 0,11,11)
TRAIN = matrix(data = 0,11,11)
all = cbind(ORIGIN,clin[ORIGIN$id,])
result = rep(0,43)

for (i in 1:1){
  print(i)
  cur = sample(30)
  
  
  test  = all[all$id %in% cur[1:3],] 
  cv    = all[all$id %in% cur[4:6],]
  train = all[all$id %in% cur[7:30],]
  
  testx  = as.matrix(test[,!(names(test) %in% 'id')]) 
  cvx    = as.matrix(cv[,!(names(cv) %in% 'id')])
  trainx = as.matrix(train[,!(names(train) %in% 'id')])
  
  trainy = as.integer(surv[train$id,1])
  
  total = total + nrow(trainx)
  
  #Feature selection
  
  for(a in 1:43){
    print(a)
    for(SIGMA in seq(-5,5,by = 1)){
      for(OURC in seq(-5,5,by = 1)){
        arr = rep(0,3)
        model = ksvm(trainx[,a],trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
        out = as.numeric(predict(model,cvx[,a]))
        out[out==0] = -1
        cases = unique(cv$id)
        for(i in 1:length(out)){
          arr[which(cv[i,'id']==cases)] = arr[which(cv[i,'id']==cases)]+out[i]
        }
        CV[SIGMA+6,OURC+6] = sum((arr>=0)==surv[cases,])
      }
    }
  }
  
  
}

print(CV)
print(TRAIN)