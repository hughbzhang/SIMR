 %This code calculates STANFORD FEATURES




function STANFORD = allStanford(names,age,karn,gender,death)
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('StanfordROI/CEL');
    list = list(3:end);
    %remove the . and .. as well as .DS_Store (sometimes there)

    STANFORD = zeros(size(list,1),33);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RIESZ FEATURE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=2;     % Riesz order
    pyramid=true; % pyramid wavelet decomposition VS undecimated
    align=false;  % maximize the response of R^(0,N) (see [1])
    J=floor(log2(128))-4 % number of decomposition levels
    %J = 3 by manual inspection
    num = size(list,1);
    ALLENERGY = zeros(num,9);    
    CELENERGY = zeros(num,9);    
    NECENERGY = zeros(num,9);
    demo = zeros(num,5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for i = 1:1
        
        
        name = strrep(list(i).name,'CEL.tif','')
        index = find(strcmp(names,name(1:12)));
        demo(i,1) = age(index);
        demo(i,2) = karn(index);
        demo(i,3) = gender(index);
        demo(i,4) = death(index);
        demo(i,5) = death(index)>505;
 
        I = imread(strcat('StanfordImages/',name,'.tif'));
        CEL = imread(strcat('StanfordROI/CEL/',name,'CEL.tif'));
        NEC = imread(strcat('StanfordROI/NEC/',name,'NEC.tif'));
        CONV = bwconvhull(I);
        
        cel = double(I(CEL&~NEC));
        cel = cel(:);
        nec = double(I(NEC));
        nec = nec(:);
        all = double(I(CEL));
        all = all(:);
        if(isempty(all)) all = 0; end
        if(isempty(cel)) cel = 0; end
        if(isempty(nec)) nec = 0; end
        
        GLCMCEL = double(I);
        GLCMNEC = GLCMCEL;
        GLCMALL = GLCMCEL;
        GLCMALL(~CEL) = NaN;
        GLCMNEC(~NEC) = NaN;
        GLCMCEL(~CEL|NEC) = NaN;
        
        
        glcmall = get_glcm_properties(GLCMALL); %GLCM properties
        glcmnec = get_glcm_properties(GLCMNEC); %GLCM properties
        glcmcel = get_glcm_properties(GLCMCEL); %GLCM properties
        
        
        
        STANFORD(i,1) = sum(sum(CONV)); %Convex Area
        STANFORD(i,2) = sum(sum(CEL)); %Tumor Total Area
        STANFORD(i,3) = sum(sum(CEL&~NEC)); %Size of CEL ONLY
        STANFORD(i,4) = sum(sum(NEC)); %Necrosis Only
        STANFORD(i,5) = mean(all); %Mean inside Tumor
        STANFORD(i,6) = mean(cel); %Mean inside CEL
        STANFORD(i,7) = mean(nec); %Mean NEC Tumor
        STANFORD(i,8) = std(all); %Std inside tumor
        STANFORD(i,9) = min(all); %Min in tumor
        STANFORD(i,10) = max(all); %Max in tumor
        STANFORD(i,11) = std(cel); %Std inside cel
        STANFORD(i,12) = min(cel); %Min in cel
        STANFORD(i,13) = max(cel); %Max in cel
        STANFORD(i,14) = std(nec); %Std inside nec
        STANFORD(i,15) = min(nec); %Min in nec
        STANFORD(i,16) = max(nec); %Max in nec
        
        STANFORD(i,17) = sum(sum(I)); %Total Blood Flow
        STANFORD(i,18) = sum(sum(cel))/sum(sum(I)); %Relative Blood flow inside a tumor
        STANFORD(i,19) = contrast(I,CEL); %contrast within the tumor
        STANFORD(i,20) = contrast(I,CEL&~NEC); %contrast within the tumor
        STANFORD(i,21) = contrast(I,NEC); %contrast within the tumor
        
        
        
        STANFORD(i,22) = glcmall.Contrast; 
        STANFORD(i,23) = glcmall.Correlation;
        STANFORD(i,24) = glcmall.Energy;
        STANFORD(i,25) = glcmall.Homogeneity;
        STANFORD(i,26) = glcmcel.Contrast; 
        STANFORD(i,27) = glcmcel.Correlation;
        STANFORD(i,28) = glcmcel.Energy;
        STANFORD(i,29) = glcmcel.Homogeneity;
        STANFORD(i,30) = glcmnec.Contrast; 
        STANFORD(i,31) = glcmnec.Correlation;
        STANFORD(i,32) = glcmnec.Energy;
        STANFORD(i,33) = glcmnec.Homogeneity;
        
        
        
                
        rieszCoeffs=RieszTextureAnalysis(I,N,J,align,pyramid);
        ALLENERGY(i,:) = rieszEnergiesInMask(rieszCoeffs,CEL,pyramid);
        CELENERGY(i,:) = rieszEnergiesInMask(rieszCoeffs,CEL&~NEC,pyramid);
        NECENERGY(i,:) = rieszEnergiesInMask(rieszCoeffs,NEC,pyramid);
        size(ALLENERGY)
        size(CELENERGY)
        size(NECENERGY)
        
    end
    STANFORD = [STANFORD ALLENERGY CELENERGY NECENERGY demo];
    
    
        
    
    %STANFORD 34-60 are RIESZ ENERGIES
    %STANFORD 61 is AGE
    %STANFORD 62 is KARN SCORE
    %STANFORD 63 is GENDER
    %STANFORD 64 is survival days
    %STANFORD 65 is low (0) or high (1) survival
    
     
end
 
