combo <- function(swap){

  library(kernlab)
  
  ORIGIN <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
  surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
  names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
  clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")
  
  total = 0
  
  CV = matrix(data = 0,16,16)
  TRAIN = matrix(data = 0,16,16)
  #CV = rep(0,11)
  #TRAIN = rep(0,11)
  # 7 8 23
  
  #######EVERYTHING###########
  if(swap==1){
    all = ORIGIN[,c(7,8,23,32)]
    all[,5:8] = clin[ORIGIN$id,c(6,7,8,10)]
    print('EVERYTHING')
  }
  
  ###############ONLY IMAGING######
  else if(swap==2){
    all = ORIGIN[,c(7,8,23,32)]
    print('IMAGING')
  }
  
  
  ###### ONLY CLINICAL ##########
  else if(swap==3){
    all = data.frame(id = ORIGIN[,32])
    all[,2:5] = clin[ORIGIN$id,c(6,7,8,10)]
    print('CLINICAL')
  }
  else{
    print("ERROR")
    return()
  }
  
  
  
  
  for (i in 1:100){
    if(i%%10==0){ print(i);}
    cur = sample(30)
    
    
    test = all[all$id %in% cur[1:3],]
    train = all[!(all$id %in% cur[1:3]),]
    
    testx  = as.matrix(test[,!(names(test) %in% 'id')]) 
    testy = as.integer(surv[test$id,1])
    trainx  = as.matrix(train[,!(names(train) %in% 'id')]) 
    trainy = as.integer(surv[train$id,1])
    
    total = total + nrow(trainx)
    if(T){
      for(SIGMA in seq(-10,5,by = 1)){
        for(OURC in seq(-5,10,by = 1)){
          arr = rep(0,3)
          model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=2^SIGMA),C=2^OURC)
          out = as.numeric(predict(model,testx))
          out[out==0] = -1
          cases = unique(test$id)
          for(i in 1:length(out)){
            arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+out[i]
          }
          
          CV[SIGMA+11,OURC+6] = CV[SIGMA+11,OURC+6] + sum((arr>=0)==surv[cases,])
          TRAIN[SIGMA+11,OURC+6] = TRAIN[SIGMA+11,OURC+6] + sum(predict(model,trainx)==as.integer(surv[train$id,1]))
          
        }
      }
    }
   
    
  }
  
  print(TRAIN)
  return(CV)
}
