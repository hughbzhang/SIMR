library(kernlab)
norm <- read.table("~/Documents/workspace/SIMR/Regression/DATA/norm.txt", quote="\"")

trainerr = 0
testerr = 0
cverr = 0
traintotal = 0
cvtotal = 0
testtotal = 0

C = vector()
S = vector()
CV = matrix(data = 0,7,7)

for (i in 1:100){
  print(i)
  cur = sample(28)
  test = norm[norm$V44 %in% cur[1:2],]
  train = norm[norm$V44 %in% cur[3:28],]
  
  testx = as.matrix(test[,c(2:9,26:38)])
  testy = as.integer(test$V43)
  trainx = as.matrix(train[,c(2:9,26:38)])
  trainy = as.integer(train$V43)
  bestC = 30
  bestS = 0.001
  
  
  testtotal = testtotal + length(testy)
  traintotal = traintotal + length(trainy)
  if(F){
    for(SIGMA in seq(.001,.01,by = .001)){
      for(OURC in seq(5,50,by = 5)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=SIGMA),C=OURC)
        now = (sum(predict(model,testx)!=testy))
        CV[SIGMA*1000,OURC/5] = CV[SIGMA*1000,OURC/5]+now
        
      }
    }
  }
  if(T){
    for(SIGMA in seq(-3,3,by = 1)){
      for(OURC in seq(-3,3,by = 1)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=10^SIGMA),C=10^OURC)
        now = (sum(predict(model,testx)!=testy))
        CV[SIGMA+4,OURC+4] = CV[SIGMA+4,OURC+4]+now
        
      }
    }
  }

  
   #model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=bestS),C=bestC)
   #trainerr = trainerr + (sum(predict(model,trainx)!=trainy))
   #testerr = testerr +   (sum(predict(model,testx )!=testy))
}
print(testtotal)
print(CV)

# trainerr = trainerr/traintotal
# testerr = testerr/testtotal
# cverr = cverr/cvtotal
# print("FINAL STUFF")
# print(trainerr)
# print(testerr)
# print(cverr)
# print(mean(C))
# print(mean(S))