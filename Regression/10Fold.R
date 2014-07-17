library('kernlab')
norm <- read.table("~/Documents/workspace/SIMR/Regression/DATA/norm.txt", quote="\"")

trainerr = 0
testerr = 0

allC = 2.13
allS = 0.041
textC = 3.71
textS = .052
demoC = 21.52
demoS = 0.5


for(a in 1:10){
  cur = norm[sample(134),]
  for ( i in 1:10){
    test = cur[(13*(i-1)+1):(13*i),]
    train = cur[(-(13*(i-1)+1)):(-13*i),]
    attach(test)
    testx = cbind(V1,V2,V3,V4,V5,V6,V7,V8,V9,V26,V27,V28,V29,V30,V31,V32,V33,V34,V35,V36,V37,V38,V39,V40,V41)
    #testx = cbind(V39,V40,V41)
    testy = V43
    detach(test)
    attach(train)
    #trainx = cbind(V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31,V32,V33,V34,V35,V36,V37,V38,V39,V40,V41)
    trainx = cbind(V1,V2,V3,V4,V5,V6,V7,V8,V9,V26,V27,V28,V29,V30,V31,V32,V33,V34,V35,V36,V37,V38,V39,V40,V41)
    #trainx = cbind(V39,V40,V41)
    trainy = V43
    detach(train)
    model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=textS),C=demoC)
    trainerr = trainerr + (sum(predict(model,trainx)!=trainy))/104
    testerr = testerr + (sum(predict(model,testx)!=testy))/13
  }
}
testerr = testerr/100
trainerr = trainerr/100
print(testerr)
print(trainerr)