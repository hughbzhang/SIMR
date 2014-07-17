%This code allows me to extract my own personalized features from the ROI and the image.




function stats = extractFeatures()
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('Original');
    list = list(3:end);
    stats = zeros(size(list,1),8);
    
    for i = 1:size(list,1)
        
        %if(size(strfind(list(i).name,'.jpg'),1)==0) continue; end  %If this is not a jpg
        I = imread(strcat('Original/',list(i).name));
        load(strcat('ROI/',strrep(list(i).name,'ORIGINAL.tif','ROI.mat')));
        X = ROI(1,:);
        Y = ROI(2,:);
        K = convhull(X,Y);
        M = roipoly(I,X,Y);
        tumor = I(M);
        tumor = double(tumor(:));
        
        stats(i,1) = polyarea(X(K),Y(K)); %Convex Area
        stats(i,2) = polyarea(X,Y); %Original Area
        stats(i,3) = mean(tumor); %Mean inside Tumor
        stats(i,4) = std(tumor); %Std inside tumor
        stats(i,5) = min(tumor); %Min in tumor
        stats(i,6) = max(tumor); %Max in tumor
        stats(i,7) = sum(sum(I)); %Total Blood Flow
        stats(i,8) = sum(tumor)/stats(i,7); %Relative Blood flow inside a tumor
        
        
        
        
        
        
        %EDGE VALUES
        %LOCATION VALUES
    end
end
 
