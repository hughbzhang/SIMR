 %This code calculates NEW STANFORD FEATURES




function newFeatures = newStanford(names,age,karn,gender,death)
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('StanfordROI/CEL');
    list = list(3:end);
    %remove the . and .. as well as .DS_Store (sometimes there)

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RIESZ FEATURE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=2;     % Riesz order
    pyramid=true; % pyramid wavelet decomposition VS undecimated
    align=false;  % maximize the response of R^(0,N) (see [1])
    J=floor(log2(128))-4; % number of decomposition levels
    J2=floor(log2(128))-5; % number of decomposition levels for CONVEX HULL
    %J = 3 by manual inspection
    num = size(list,1);
    demo = zeros(num,4);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for i = 1:num
        
        
        name = strrep(list(i).name,'CEL.tif','');
        index = find(strcmp(names,name(1:12)));
        demo(i,1) = age(index);
        demo(i,2) = karn(index);
        demo(i,3) = gender(index);
        demo(i,4) = death(index);
 
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
        GCLMCEL(~CEL|NEC) = NaN;
        glcmconv = get_glcm_properties(GLCMCONV); %GLCM properties
        glcmcel = get_glcm_properties(GLCMCEL); %GLCM properties
        
        
        
        mean(conv);
        std(conv);
        max(conv);
        mean(cel);
        std(cel);
        max(cel);
        contrast(I,CONV&~CEL);
        contrast(I,CEL&~NEC);
        glcmcel.Contrast; 
       	glcmcel.Correlation;
        glcmcel.Energy;
        glcmcel.Homogeneity;
        glcmconv.Contrast; 
       	glcmconv.Correlation;
        glcmconv.Energy;
        glcmconv.Homogeneity;
        
        rieszCoeffs=RieszTextureAnalysis(I,N,J,align,pyramid);
        rieszCoeffsCONV=RieszTextureAnalysis(I,N,J2,align,pyramid);
        
        rieszEnergiesInMask(rieszCoeffsCONV,CONV&~CEL,pyramid);
        rieszEnergiesInMask(rieszCoeffs,CEL&~NEC,pyramid)
       

        
        
        
    end
     
end
 
