%This is my helper function to utilizing Adrian's Riesz Energy library for computing texture. It computes the Riesz energies for all the photos in my library. NOTE: You must add the code from http://publications.hevs.ch/index.php/publications/show/1373 to your MATLAB path or this will NOT run.



function ENERGY = computeRieszEnergies(EXPANDID)

      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RIESZ FEATURE STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=2;     % Riesz order
    pyramid=true; % pyramid wavelet decomposition VS undecimated
    align=false;  % maximize the response of R^(0,N) (see [1])
    J=floor(log2(128))-4 % number of decomposition levels
    %J = 3 by manual inspection
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    num = size(EXPANDID,1);
    ENERGY = zeros(num,9);

    
    for i = 1:num
        
        
        I = imread(strcat('Original/',EXPANDID{i})); %LOAD IMAGE
        load(strcat('ROI/',strrep(EXPANDID{i},'ORIGINAL.tif','ROI.mat'))); %LOAD ROI
        m = roipoly(I,ROI(1,:),ROI(2,:)); %CREATE MASK OF TUMOR (1 in tumor 0 outside tumor)
       
        rieszCoeffs=RieszTextureAnalysis(I,N,J,align,pyramid);
        
        ENERGY(i,:) = rieszEnergiesInMask(rieszCoeffs,m,pyramid)';
        
    end


end
