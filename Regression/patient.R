library(kernlab)
norm <- read.table("~/Documents/workspace/SIMR/Regression/DATA/STANFORD.txt", quote="\"")

trainerr = 0
testerr = 0
cverr = 0
traintotal = 0
cvtotal = 0
testtotal = 0

C = vector()
S = vector()
CV = matrix(data = 0,13,13)

for (i in 1:10){
  print(i)
  cur = sample(26)
  test = norm[norm$V66 %in% cur[1:4],]
  train = norm[norm$V66 %in% cur[5:26],]
  
  testx = as.matrix(test[,-(64:66)])
  testy = as.integer(test$V43)
  trainx = as.matrix(train[,-(64:66)])
  trainy = as.integer(train$V43)
  
  if(F){
    for(SIGMA in seq(.01,.1,by = .01)){
      for(OURC in seq(.2,.8,by = .1)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=SIGMA),C=OURC)
        now = (sum(predict(model,cvx)!=cvy))
        CV[SIGMA*100,OURC*10] = CV[SIGMA*100,OURC*10]+now
        if(now<best){
          best = now;
          bestS = SIGMA
          bestC = OURC
        }
      }
    }
  }
  if(TRUE){
    for(SIGMA in seq(-3,3,by = .5)){
      for(OURC in seq(-3,3,by = .5)){
        model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=10^SIGMA),C=10^OURC)
        now = (sum(predict(model,testx)!=testy))
        CV[2*SIGMA+7,2*OURC+7] = CV[2*SIGMA+7,2*OURC+7]+now
      }
    }
  }
}

#   model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=bestS),C=bestC)
#   trainerr = trainerr + (sum(predict(model,trainx)==trainy))
#   testerr = testerr +   (sum(predict(model,testx )==testy))
#   cverr = cverr +       (sum(predict(model,cvx   )==cvy))
#   C = append(C,bestC)
#   S = append(S,bestS)






# trainerr = trainerr/traintotal
# testerr = testerr/testtotal
# cverr = cverr/cvtotal
# print("FINAL STUFF")
# print(trainerr)
# print(testerr)
# print(cverr)
# print(mean(C))
# print(mean(S))