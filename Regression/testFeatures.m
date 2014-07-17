%This code allows me to extract test features which may or may not be
%useful.




function test = testFeatures()
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('Original');
    list = list(3:end);
    test = zeros(size(list,1),17);
    
    %num = 1;
    num = size(list,1);
    
    for i = 1:num
        
        %if(size(strfind(list(i).name,'.jpg'),1)==0) continue; end  %If this is not a jpg
        I = imread(strcat('Original/',list(i).name));
        load(strcat('ROI/',strrep(list(i).name,'ORIGINAL.tif','ROI.mat')));
        X = ROI(1,:);
        Y = ROI(2,:);
        K = convhull(X,Y);
        M = roipoly(I,X,Y);
        outside = roipoly(I,X(K),Y(K))&~M; %Outside is the area just outside of the tumor (inside the convex hull outside the ROI)
        [cx cy] = s_pertube_roi(X,Y,1,I);
        morph = roipoly(I,cx,cy)&~M; %Dilated area just outside of the tumor
        
        tumor = I(M);
        tumor = double(tumor(:));
        frontier = I(outside); %Frontier is where the tumor can easily expand
        frontier = double(frontier(:));
        dilate = I(morph);
        dilate = double(dilate(:));
        
        test(i,1) = contrast(I,M); %contrast within the tumor
        test(i,2) = sum(sum(outside)); %size of the outside
        test(i,3) = contrast(I,outside); %contrast in outside
        test(i,4) = mean(frontier);% mean in outside
        test(i,5) = std(frontier);% std in outside
        test(i,6) = min(frontier);% min in outside
        test(i,7) = max(frontier); %max in outside
        test(i,8) = sum(frontier); %total in outside
        test(i,9) = test(i,8)/(sum(sum(I))); %percent in outside vs total perfusion values
        test(i,10) = sum(sum(morph)); %size of the outside
        test(i,11) = contrast(I,morph); %contrast in outside
        test(i,12) = mean(dilate);% mean in outside
        test(i,13) = std(dilate);% std in outside
        test(i,14) = min(dilate);% min in outside
        test(i,15) = max(dilate); %max in outside
        test(i,16) = sum(dilate); %total in outside
        test(i,17) = test(i,16)/(sum(sum(I))); %percent in outside vs total perfusion values
        
    end
end
 
