#This is my code for using an SVM to predict the data
#SVM seems to overfit less than Random Forest

library(kernlab)
cur = all[sample(130),]

trainerr = 0
testerr = 0

for ( i in 1:10){
  check = cur[(13*(i-1)+1):(13*i),]
  
  attach(check)
  #testx = cbind(V26,V3,V6,V4,V34,V41,V17,V21,V24,V15,V27,V7)
  testx = cbind(V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31,V32,V33,V34,V35,V36,V37,V38,V39,V40,V41,V42,V43)
  
  testy = V1
  detach(check)
  train = cur[(-(26*(i-1)+1)):(-26*i),]
  attach(train)
  trainx = cbind(V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31,V32,V33,V34,V35,V36,V37,V38,V39,V40,V41,V42,V43)
  #trainx = cbind(V26,V3,V6,V4,V34,V41,V17,V21,V24,V15,V27,V7)
  trainy = train[,1]
  #.2 .5
  # .05 2
  
  detach(train)
  model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=.05),C=2)
  trainerr = trainerr + (sum(predict(model,trainx)!=trainy))/117
  testerr = testerr + (sum(predict(model,testx)!=testy))/13
}
testerr = testerr/10
trainerr = trainerr/10