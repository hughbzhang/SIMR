%This function attempts to extract statistical features from the images.

function morphMeans = extractFeatures(id)
    close all;
    
    
    morphMeans = [];
    %Data contains the mean for each of the six morphs
    statsbn = [];
   
    avails = dir(strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/ROI CEL/ROI_CEL_Slice *.roi'));
    avails_ids = [];
    for i = 1:length(avails)
        avails(i).name;
        length(avails(i).name);
        avail_id = avails(i).name(14: (strfind(avails(1).name, '.roi')-1)); %CEL = 10
        avails_ids = [avails_ids, str2num(avail_id)];
    end
    
    allinROIbn=[];
    allinROI=[];
    ids = [];
    stats = zeros(6);
    %Cols are the morphs
    %Rows are the 6 stat values
    
    for k = 1:length(avails_ids)
    %for k = 1:1
        sn = avails_ids(k);
        
        fid = fopen(sprintf('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/%s/ROI CEL/ROI_CEL_Slice %d.roi', id, sn));
        tline = fgetl(fid);
        factor = 0;
        if strcmp(tline, 'LARGE')
            factor = 6;
        elseif strcmp(tline, 'MEDIUM')
            factor = 4;
        else
            print "dont know the factor"
        end
        tline = fgetl(fid);
        x = [];
        y = [];
        while ischar(tline)
            tline = fgetl(fid);
                if (tline ~= -1);
                    a = str2num(tline(1, 1:3));
                    b = str2num(tline(1, 5:7));
                    x = [x a];
                    y = [y b];   
            end
        end
        morphMeans = [morphMeans;zeros(1,6)];
        
        fdir = strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/processed CBV leakage corrected maps/Image#', num2str(sprintf('%03d',sn)), '.dcm');
        I1 = dicomread(fdir);
        I = imresize(I1, factor, 'nearest');
        %I = im2uint8(imresize(I1, factor, 'nearest'));
        %I = I.*ceil(255/max(max(I)));
        %x = [x x(1)];
        %y = [y y(1)];
        %smoothx = smooth(smooth(smooth(x)));
        %smoothy = smooth(smooth(smooth(y)));
       
        for i = 1:6
            [cx,cy] = s_pertube_roi(x,y,i,I);
            m = roipoly(I,cx,cy);
            %figure(10*k+i);
            %imagesc(I);
            %I
            %hold on;
            %plot(cx,cy,'LineWidth',2,'Color','Red');
            %m1 = imresize(m, 1/factor);
            inROI = I(m);
            %inROI = I1(m1);


            %inROI
            inf = dicominfo(fdir);
            %inf.Private_0077_1001
            morphMeans(k,i) = mean(double(inROI))* inf.Private_0077_1001;
            stats(i,1) = mean(double(inROI))* inf.Private_0077_1001;
            stats(i,2) = median(double(inROI))* inf.Private_0077_1001;
            stats(i,3) = std(double(inROI))* inf.Private_0077_1001;
            stats(i,4) = max(double(inROI))* inf.Private_0077_1001;
            stats(i,5) = min(double(inROI))* inf.Private_0077_1001;
            stats(i,6) = sum(sum(m))*inf.PixelSpacing(1)*inf.PixelSpacing(1);
            %name = sprintf('%sLAYER%d.txt',id,k);
            %cd Statistics
            %save(name,'stats','-ascii');
            %cd ..
        end
        
    end
    %morphMeans = morphMeans./length(avails_ids);
        
        
        

    
    %statAll(1) = mean(double(allinROI))* inf.Private_0077_1001;
    %statAll(2) = median(double(allinROI))* inf.Private_0077_1001;
    %statAll(3) = std(double(allinROI))* inf.Private_0077_1001;
    %statAll(4) = max(double(allinROI))* inf.Private_0077_1001;
    %statAll(5) = min(double(allinROI))* inf.Private_0077_1001;
    
    
    
    
    

function paramDirs  = getPerfusionImagePath(anatomicalPerfusionMatchingNum, sampleID)  %paramType = rCBV, rCBV (standardized)...
paramType = 'rCBV';
dir1 = strcat('/Users/tingliu/Documents/RajanProject/perfusionDataFromRajan/perfusionImaingData/IBNeuro_correctSteps/', id, '/', id, '_perfusion/');
perfImages= dir(strcat(dir1, '*.dcm'))
paramDirs = [];
for j = 1:length(perfImages)
    paraDir = strcat(dir1, perfImages(j).name)
    paramDirs = [paramDirs; paraDir]
end

% for j = 1:length(anatomicalPerfusionMatchingNum)
%     paramDir='';
%     for i = 1:length(perfImages)
%         perfPath = strcat(dir1, perfImages(i).name);
%         perfPath_info = dicominfo(perfPath);
%         if (strcmp(perfPath_info.PatientID, sampleID) && strcmp(perfPath_info.SeriesDescription, strcat(paramType,' (normalized) (RESEARCH)')) && perfPath_info.InstanceNumber == anatomicalPerfusionMatchingNum(j))
%             paramDir = perfPath
%         end
%     end
%     paramDirs = [paramDirs; paramDir]
% end
paramDirs 
end
end

