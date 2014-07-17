rm(list=ls())
library("glmnet")  
library("survival")
library("survpack")
library("R.matlab")
library("R.utils")
library("cvTools")

#setwd('C:/Users/adrie_000/Documents/R/svmCancer')
#setwd('/home/adepeurs/R/svmCancer')
## FUNCTION: make cross-validation folds with stratification
# strata is boolean vector of the same length as vals specifying classes
# over which to stratify
cv_with_strata = function(n, nfolds, strata, balance_by='strata') {
  
  vals = 1:n
  
  # Separately get cross-validation folds for positive and negative group
  # Groups may have fewer values than nfolds, in which case, use leave-one-out
  # Cross-validation for that group
  vals_pos = vals[as.logical(strata)]
  
  cvp_pos = cvFolds(length(vals_pos), K=min(nfolds, length(vals_pos)))
  
  cvp_pos$subsets = as.matrix(vals_pos[cvp_pos$subsets])
  vals_neg = vals[!as.logical(strata)]
  cvp_neg = cvFolds(length(vals_neg), K=min(nfolds, length(vals_neg)))
  cvp_neg$subsets = as.matrix(vals_neg[cvp_neg$subsets])
  
  # Concatenate together
  cvp = cvp_pos
  cvp$n = cvp_pos$n + cvp_neg$n
  cvp$subsets = rbind(cvp_pos$subsets, cvp_neg$subsets)
  
  if (balance_by == 'strata')
    cvp$which = c(cvp_pos$which, cvp_neg$which) # Total number per fold less balanced
  else if (balance_by == 'num')
    cvp$which = c(cvp_pos$which, nfolds - cvp_neg$which + 1) # Stratification less balanced
  else
    stop(paste('Invalid entry for balance_by:', balance_by))
  
  return(cvp)
}

# Load mat file
#pathname <- file.path("/Users/Adrien/Documents/stanford/MasahiroLung/features", "features_solid_N2J2_HUcontourError3_alignedMagnitudes.mat")
#pathname <- file.path("/home/IMAGEROOT/adrien/MasahiroLung/features", "test.mat")
#features <- readMat(pathname)

#d=data.frame(features$features)


load("/Users/tingliu/Downloads/code/LexROIs_ReitzHist/ReiszHistExpanded_Combined_RajanMap_June2.RData")
removeNAs = which(is.na(allReiszExpanded[,12]))
d1 = data.frame(allReiszExpanded[-removeNAs,-1])
##d1 = data.frame(allReiszExpanded[,-1])
##normalization of matrix
#d2 = d1[,-c(1:2)]
#minimum = t(data.frame(apply(d2, 2, min)))
#d3 = d2 - minimum[rep(1, nrow(d2)), ]
#maximum = t(data.frame(apply(d3, 2, max)))
#d4 = cbind(d1[,c(1,2)], d3/(maximum[rep(1, nrow(d3)),])) 
#d = d4[, c(1:(ncol(d4)-1))] # remove the last row, which is all NaNs
########################################################
Riesz = d1[,c(1:11)]
histogram = d1[,c(1,2,12:26)]
d = d1[,-27]
d = Riesz
d = cbind(histogram[,c(1,2)], histogram[,-c(1,2)]/rowSums(histogram[,-c(1,2)]) )


#d = d1
colnames(d) = c("X1", "X2", colnames(d)[-c(1:2)])
PatientIDs = levels(allReiszExpanded[,1])[allReiszExpanded[,1]]

nbOfFolds<-10
nbOfRepetitions<-20

cIndsTrain<-numeric()
cIndsTest<-numeric()

for (iterRep in 1:nbOfRepetitions) {
  
  cvp = cv_with_strata(length(d[,1]), nfolds=nbOfFolds, strata= d[,2], balance_by='strata')
  
  cIndsTestTemp<-numeric()
  
  for (iterFolds in 1:nbOfFolds) {
    
    idx_train = cvp$subsets[cvp$which != iterFolds]
    idx_test = cvp$subsets[cvp$which == iterFolds]
    
    # ensure that all lesions of a given patient fall in the same fold
    trainPatients<-PatientIDs[idx_train]
    testPatients<-PatientIDs[idx_test]
    idxPatientsInBoth<-numeric()
    
    for (iterTrain in 1:length(trainPatients)) {
      for (iterTest in 1:length(testPatients)) {
        if (trainPatients[iterTrain]==testPatients[iterTest]) {
          
          idxPatientsInBoth<-c(idxPatientsInBoth,iterTrain)
        }
      }
    }
    # regroup lesions by patient
    if (length(idxPatientsInBoth)!=0) {
      idx_test<-c(idx_test,idx_train[idxPatientsInBoth])
      idx_train<-idx_train[-idxPatientsInBoth]
    }
    
    trainPatients<-PatientIDs[idx_train]
    testPatients<-PatientIDs[idx_test]
    for (iterTrain in 1:length(trainPatients)) {
      for (iterTest in 1:length(testPatients)) {
        if (trainPatients[iterTrain]==testPatients[iterTest]) {          
          print("---------------------")
          print(trainPatients[iterTrain])
          print(testPatients[iterTest])
        }
      }
    }
    
    dTrain=d[idx_train,]
    dTest=d[idx_test,]
    
    # ensure that no features has all zero values
    diff=apply(dTrain,2,max)-apply(dTrain,2,min)    
    if (min(diff)!=0) {
      
      # Train
      xTrain=as.matrix(dTrain[,3:length(dTrain)])
      y=cbind(time=dTrain$X1,status=dTrain$X2) 
      glmnet_model=glmnet(xTrain,y,family="cox",nlambda = 10)
      plot(glmnet_model,label = TRUE)
      
      #print(log(glmnet_model$lambda.min))
      
      #predicted.score = predict(glmnet_model, xTrain)
      #predicted.score = predict(glmnet_model,xTrain,s="lambda.min")
      
      #cInd<-cindex(Surv(X1,X2)~predicted.score[,ncol(predicted.score)], data=dTrain)
      #print(cInd[1])
      #cIndsTrain<-c(cIndsTrain,cInd[1])
      
      selected.variables=predict(glmnet_model,xTrain,type="coefficients")
      #print(selected.variables)
      
      # Test
      xTest=as.matrix(dTest[,3:length(dTest)])
      predicted.score = predict(glmnet_model, xTest)
      #predicted.score = predict(glmnet_model,xTest,s="lambda.1se")
      #print(ncol(predicted.score))
      #print(glmnet_model)
      cInd<-cindex(Surv(X1,X2)~predicted.score[,ncol(predicted.score)], data=dTest)
      #cInd<-cindex(Surv(X1,X2)~predicted.score[,20], data=dTest)
      #print(cInd[1])
      cIndsTest<-c(cIndsTest,cInd[1])
      
      cIndsTestTemp<-c(cIndsTestTemp,cInd[1])
      
    } #else {print("error")}
  }

  cIndsTestTemp<-cIndsTestTemp[complete.cases(cIndsTestTemp)] # remove unexpected NaN values 
  mTestTemp<-mean(cIndsTestTemp)
  print(mTestTemp)
}
cIndsTest<-cIndsTest[complete.cases(cIndsTest)] # remove unexpected NaN values 
mTest<-mean(cIndsTest)
sTest<-sd(cIndsTest)
seTest<-sTest/sqrt(length(cIndsTest)) #standard error
print("--------------------")
print(mTest)
print(sTest)
print(seTest)
