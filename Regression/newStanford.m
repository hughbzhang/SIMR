 %This code calculates NEW STANFORD FEATURES




function [demo,newStanford] = newStanford(names,age,karn,gender,death,con,newNames,newClin)
    addpath(genpath('~/Documents/MATLAB/RieszTextureAnalysis2D_v1.0'));
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('StanfordROI/CEL');
    list = list(4:end);
    %remove the . and .. as well as .DS_Store (sometimes there)
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RIESZ FEATURE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=2;     % Riesz order
    pyramid=true; % pyramid wavelet decomposition VS undecimated
    align=false;  % maximize the response of R^(0,N) (see [1])
    J=floor(log2(128))-4; % number of decomposition levels
    J2=floor(log2(128))-5; % number of decomposition levels for CONVEX HULL
    %J = 3 by manual inspection
    num = size(list,1);
    demo = zeros(num,13);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newStanford = zeros(num,31);
    
    for i = 1:num
        
        
        name = strrep(list(i).name,'CEL.tif','');
        index = find(strcmp(names,name(1:12)));
        newindex = find(strcmp(newNames,name(1:12)));
        demo(i,1) = age(index);
        demo(i,2) = karn(index);
        demo(i,3) = gender(index);
        if(death(index)==0)
            demo(i,4) = con(index);
        else
            demo(i,4) = death(index);
        end
        demo(i,5:13) = newClin(newindex,:);
        
    

    
 
        I = uint16(dicomread(strcat('StanfordImages/',name,'.dcm')));
     
        CEL = imread(strcat('StanfordROI/CEL/',name,'CEL.tif'));
        NEC = imread(strcat('StanfordROI/NEC/',name,'NEC.tif'));
        
        
        
        CONV = bwconvhull(CEL);
        cel = double(I(CEL&~NEC));
        cel = cel(:);
        conv = double(I(CONV&~CEL));
        conv = conv(:);
        
        if(isempty(cel)) cel = 0; end
        if(isempty(conv)) conv = 0; end
        
        GLCMCEL = double(I);
        GLCMCONV = double(I);
        GLCMCONV(~CONV|CEL) = NaN;
        GLCMCEL(~CEL|NEC) = NaN;
        glcmconv = get_glcm_properties(GLCMCONV); %GLCM properties
        glcmcel = get_glcm_properties(GLCMCEL); %GLCM properties
        
        rieszCoeffs=RieszTextureAnalysis(I,N,J,align,pyramid);
        rieszCoeffsCONV=RieszTextureAnalysis(I,N,J2,align,pyramid);
        
        newStanford(i,1) = mean(conv);
        newStanford(i,2) = std(conv);
        newStanford(i,3) = max(conv);
        newStanford(i,4) = mean(cel);
        newStanford(i,5) = std(cel);
        newStanford(i,6) = max(cel);
        newStanford(i,7) = contrast(I,CONV&~CEL);
        newStanford(i,8) = contrast(I,CEL&~NEC);
        newStanford(i,9) = glcmcel.Contrast;
        newStanford(i,10) = glcmcel.Correlation;
        newStanford(i,11) = glcmcel.Energy;
        newStanford(i,12) = glcmcel.Homogeneity;
        newStanford(i,13) = glcmconv.Contrast;
        newStanford(i,14) = glcmconv.Correlation;
        newStanford(i,15) = glcmconv.Energy;
        newStanford(i,16) = glcmconv.Homogeneity;
        newStanford(i,17:22) = rieszEnergiesInMask(rieszCoeffsCONV,CONV&~CEL,pyramid);
        newStanford(i,23:31) = rieszEnergiesInMask(rieszCoeffs,CEL&~NEC,pyramid);
       

        
        
        
    end
     
end
 
