 %This code calculates ALL THE FEATURES




function all = allFeatures(EXPANDED)
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('Original');
    list = list(3:end);
    %remove the . and .. as well as .DS_Store (sometimes there)

    all = zeros(size(list,1),29);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RIESZ FEATURE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=2;     % Riesz order
    pyramid=true; % pyramid wavelet decomposition VS undecimated
    align=false;  % maximize the response of R^(0,N) (see [1])
    J=floor(log2(128))-4 % number of decomposition levels
    %J = 3 by manual inspection
    num = size(list,1);
    ENERGY = zeros(num,9);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for i = 1:num
        
        %if(size(strfind(list(i).name,'.jpg'),1)==0) continue; end  %If this is not a jpg
        I = imread(strcat('Original/',list(i).name));
        
        load(strcat('ROI/',strrep(list(i).name,'ORIGINAL.tif','ROI.mat')));
        
        
        
        X = ROI(1,:); %X values of the ROI
        Y = ROI(2,:); %Y values of the ROI
        K = convhull(X,Y); %Convex Hull of the ROI
        M = roipoly(I,X,Y); %Polygon of the ROI
        GLCMPHOTO = double(I);
        GLCMPHOTO(~M) = NaN;
        tumor = I(M); %Values inside the tumor
        tumor = double(tumor(:));
        
        outside = roipoly(I,X(K),Y(K))&~M; %Outside is the area just outside of the tumor (inside the convex hull outside the ROI)
        frontier = I(outside); %Frontier is where the tumor can easily expand (assuming convex growth)
        frontier = double(frontier(:));
        
        [cx cy] = s_pertube_roi(X,Y,1,I); %Dilated x and y values
        morph = roipoly(I,cx,cy)&~M; %Dilated area just outside of the tumor
        dilate = I(morph); %Values in the dilated region (DOES NOT INCLUDE TUMOR ITSELF)
        dilate = double(dilate(:));
        
        
        imagesc(I);
        hold on;
        plot(X(K),Y(K),'Color','White','LineWidth',1);
        cd CONV
        export_fig(strrep(list(i).name,'ORIGINAL',''));
        cd ..
        
        
        
        all(i,1) = polyarea(X(K),Y(K)); %Convex Area
        all(i,2) = polyarea(X,Y); %Original Area
        all(i,3) = mean(tumor); %Mean inside Tumor
        all(i,4) = std(tumor); %Std inside tumor
        all(i,5) = min(tumor); %Min in tumor
        all(i,6) = max(tumor); %Max in tumor
        all(i,7) = sum(sum(I)); %Total Blood Flow
        all(i,8) = sum(tumor)/all(i,7); %Relative Blood flow inside a tumor
        all(i,9) = contrast(I,M); %contrast within the tumor

        all(i,10) = sum(sum(outside)); %size of the outside
        all(i,11) = contrast(I,outside); %contrast in outside
        all(i,12) = mean(frontier);% mean in outside
        all(i,13) = std(frontier);% std in outside
        all(i,14) = min(frontier);% min in outside
        all(i,15) = max(frontier); %max in outside
        all(i,16) = sum(frontier); %total in outside
        all(i,17) = sum(frontier)/(sum(sum(I))); %percent in outside vs total perfusion values

        all(i,18) = sum(sum(morph)); %size of the dilated
        all(i,19) = contrast(I,morph); %contrast in dilated
        all(i,20) = mean(dilate);% mean in dilated
        all(i,21) = std(dilate);% std in dilated
        all(i,22) = min(dilate);% min in dilated
        all(i,23) = max(dilate); %max in dilated
        all(i,24) = sum(dilate); %total in dilated
        all(i,25) = sum(dilate)/(sum(sum(I))); %percent in dilated vs total perfusion values
        
        rieszCoeffs=RieszTextureAnalysis(I,N,J,align,pyramid);
        ENERGY(i,:) = rieszEnergiesInMask(rieszCoeffs,M,pyramid);
        
        glcm = get_glcm_properties(GLCMPHOTO); %GLCM properties
        all(i,26) = glcm.Contrast; 
        all(i,27) = glcm.Correlation;
        all(i,28) = glcm.Energy;
        all(i,29) = glcm.Homogeneity;
        
        
    end
    
    %all 30-38 are RIESZ ENERGIES
    %all 39 is AGE
    %all 40 is KARN SCORE
    %all 41 is GENDER
    %all 42 is survival days
    %all 43 is low (0) or high (1) survival
    
    all = [all ENERGY EXPANDED(:,2:end) EXPANDED(:,1)];
    all(:,43) = EXPANDED(:,1)>mean(EXPANDED(:,1));
    
end
 
