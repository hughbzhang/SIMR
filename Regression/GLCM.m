%This code lets me get the GLCM texture features of each image.

function GLCM = GLCM()

    cd ~/Documents/workspace/SIMR/Regression
    list = dir('Original');
    list = list(3:end);
    
    %num = 1;
    num = size(list,1);
    GLCM = zeros(num,4);
    
    for i = 1:num
        
        I = double(imread(strcat('Original/',list(i).name)));
        load(strcat('ROI/',strrep(list(i).name,'ORIGINAL.tif','ROI.mat')));
        X = ROI(1,:);
        Y = ROI(2,:);
        m = roipoly(I,X,Y);
        I(~m) = NaN;
        glcm = get_glcm_properties(I);
        GLCM(i,1) = glcm.Contrast;
        GLCM(i,2) = glcm.Correlation;
        GLCM(i,3) = glcm.Energy;
        GLCM(i,4) = glcm.Homogeneity;
        
        
        
        
    end
 


end