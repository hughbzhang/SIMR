roc <- function(swap){
  
  library(kernlab)
  
  ORIGIN <- read.table("~/Documents/workspace/SIMR/Regression/DATA/NORMSTANFORD.txt", quote="\"")
  surv <- read.table("~/Documents/workspace/SIMR/Regression/DATA/surv.txt", quote="\"")
  names <- read.table("~/Documents/workspace/SIMR/Regression/DATA/StanfordNames.txt", quote="\"")
  clin <- read.table("~/Documents/workspace/SIMR/Regression/DATA/normDemo.txt", quote="\"")
  
  FP = rep(0,101)
  TP = rep(0,101)
  right = rep(0,101)

  neg = 0
  pos = 0
  
  #######EVERYTHING###########
  if(swap==1){
    all = ORIGIN[,c(7,8,23,32)]
    all[,5:8] = clin[ORIGIN$id,c(6,7,8,10)]
    
    BESTC = 10^4
    BESTS = 10^-3
    
    print('EVERYTHING')
  }
  
  ###############ONLY IMAGING######
  else if(swap==2){
    all = ORIGIN[,c(7,8,23,32)]
    
    BESTS = 10^1
    BESTC = 10^1
    
    
    print('IMAGING')
  }
  
  
  ###### ONLY CLINICAL ##########
  else if(swap==3){
    all = data.frame(id = ORIGIN[,32])
    all[,2:5] = clin[ORIGIN$id,c(6,7,8,10)]
    print('CLINICAL')
    
    BESTS = 10^-1
    BESTC = 10^1
    
  }
  else{
    print("ERROR")
    return()
  }
  
  
  
  for (i in 1:100){
    if(i%%10==0){print(i);}
    cur = sample(30)
    
    test = all[all$id %in% cur[1:3],]
    train = all[!(all$id %in% cur[1:3]),]
    
    testx  = as.matrix(test[,!(names(test) %in% 'id')]) 
    testy = as.integer(surv[test$id,1])
    trainx  = as.matrix(train[,!(names(train) %in% 'id')]) 
    trainy = as.integer(surv[train$id,1])
    
    model = ksvm(trainx,trainy,type = "C-svc",kernel = 'rbf',kpar = list(sigma=BESTS),C=BESTC)
    out = as.vector(predict(model,testx,'dec')) 
    cases = unique(test$id)
    ans = surv[cases,1]
    pos = pos + sum(ans==1)
    neg = neg + sum(ans==0)

    if(T){
      for(cut in seq(-5,5,by = .1)){
        arr = rep(0,3)
        dec = as.numeric(out>cut)
	dec[dec==0] = -1
        for(i in 1:length(dec)){
          arr[which(test[i,'id']==cases)] = arr[which(test[i,'id']==cases)]+dec[i]
        }
	
	arr[arr==0] = sample(c(-1,1),1)
        TP[10*cut+51] = TP[10*cut+51] + sum((arr>0)&(ans==1))
        FP[10*cut+51] = FP[10*cut+51] + sum((arr>0)&(ans==0))
	right[10*cut+51] = right[10*cut+51] + sum((arr>0)==ans)
      }
    }
  }
  FP = FP/neg
  TP = TP/pos
  if(swap==1){ lines(FP,TP,type = 's',col = 'red');}
  if(swap==2){ lines(FP,TP,type = 's',col = 'blue');}
  if(swap==3){ lines(FP,TP,type = 's',col = 'green');}
  return(rbind(FP,TP))
    
}
