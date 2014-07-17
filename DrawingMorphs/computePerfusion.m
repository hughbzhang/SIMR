%This was my code for trying to display the perfusion images in a viewable way.

function param = computePerfusion(id)
    
    
    stats = [];
    statsbn = [];
   
    avails = dir(strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/ROI CEL/ROI_CEL_Slice *.roi'));
    %length(avails)
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
        
        %Here I try to overlay the Region of Interest (ROI) over a picture
        %in false color
        
        
        fdir = strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/processed CBV leakage corrected maps/Image#', num2str(sprintf('%03d',sn)), '.dcm');
        info = dicominfo(fdir);
        I1 = dicomread(info);
        
        
        
        I = im2uint8(imresize(I1, factor, 'nearest'));
        %Resize the photo to its proper size and convert it into a uint8
        %matrix
        
        I = I.*floor(255/max(max(I)));
        %Scale the photo so that it goes from 0 to 255. This way the photo
        %is more visible instead of being dark all over.
        
        
        
        %%%%%%%%%%%%Experiments DWAI%%%%%%%%%%%%%%
        
       
        
        %figure(2);
        %color = uint8(ones(512,512,3));
        %color(:,:,1) = color(:,:,1).*50;
        %color(:,:,2) = color(:,:,2).*100;
        %color(:,:,3) = color(:,:,3).*100;
        
        %color(:,:,1) = I.*floor(250/max(max(I)));;
        %color(:,:,2) = I.*floor(250/max(max(I)));;
        %color(:,:,3) = I.*floor(250/max(max(I)));;
        
        %imshow(I,'Colormap',jet(255));
        
        
        %lol = uint16(ones(100,100,3));
        %lol(:,:,1) = lol(:,:,1)*10000;
        %lol(:,:,2) = lol(:,:,2)*200;
        %lol(:,:,3) = lol(:,:,3)*50000;
        %figure(1);
        %imshow(lol);
        
        %imshow(I,[min(min(I)),max(max(I))]);
        
        RGB = im2uint8(zeros(size(I,1),size(I,2),3));
        RGB(:,:,1) = I;
        RGB(:,:,2) = I;
        RGB(:,:,3) = I;
        
        %imshow(RGB);
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %if(k~=num) continue; end;
        for i = 5:5
            %size(I)
            [cx,cy] = s_pertube_roi(x,y,i,I);
            if(size(cx,2)==1) cx = cx'; end
            if(size(cy,2)==1) cy = cy'; end
            
            %cx and cy are changed y and x
            %size(cx)
            polygon = zeros(1,2*length(x));
            cpolygon = zeros(1,2*length(cx));

            polygon(1:2:end) = x;
            polygon(2:2:end) = y;
            cpolygon(1:2:end) = cx;
            cpolygon(2:2:end) = cy;
            points = zeros(length(cx),2);
            points(:,1) = cx;
            points(:,2) = cy;
            cx = [cx cx(1)];
            cy = [cy cy(1)];
            x = [x x(1)];
            y = [y y(1)];
            %insert shape into the photo
            %lol = 1:pi/10:2*pi;
            
            %figure(3);
            
            %imagesc([1,2*pi],[1,2*pi],RGB);
            %hold on;
            %plot(lol,sin(lol),'LineWidth',10);
            h = figure(round(rand()*90000));
            %figure('Visible','Off');
            imagesc(I);
            colormap(jet(255));
            hold on;
            %plot(x,y,'LineWidth',2,'Color','Red');
            plot(smooth(smooth(smooth(x))),smooth(smooth(smooth(y))),'LineWidth',2,'Color','Red');
            %plot(smooth(smooth(smooth(cx))),smooth(smooth(smooth(cy))),'LineWidth',2,'Color','White');
            %set(gcf,'Units','Normalized','Position',[0,0,.6,1]);
            %set(gca,'Visible','off')
            
            %set(gcf,'Units','Normalized','Position',[0,0,.5,1]);
            %set(gcf,'Units','Inches','Position',[0,0,9,10]);
            %set(gcf,'un','n','pos',[0,0,2,2]);figure(gcf);
            %set(h,'Axes','off');
            %fnplt( csapi(cx, cy)); 
            %fnplt( spaps(cx, cy,  0.02), 'r', 2 )
            smoothx = smooth(smooth(smooth(x)));
            smoothy = smooth(smooth(smooth(y)));
            %smoothcw = smooth(smooth(smooth(x));
            %smoothx = smooth(smooth(smooth(x));        
            polygon = zeros(2*length(smoothx),1);
            %size(smoothx)
            %size(smoothy)
            %size(polygon)
            polygon(1:2:end) = smoothx;
            polygon(2:2:end) = smoothy;
            polygon = polygon';
            hold off;
            %figure(2);
            %one = insertShape(RGB,'FilledPolygon',polygon,'Color','Red','Opacity',.2);
            %two = insertShape(RGB,'FilledPolygon',polygon,'Color','Red','Opacity',1);
            %sum(sum(sum(two-one)))/sum(sum(sum(one~=two)))
            
            %diff = ((rgb2gray(original)~=I))&(logical(invhilb(size(RGB,1))<0));
            %size(logical(invhilb(size(RGB,1))<0))
            %size(original~=RGB)
            %original(diff) = 100;
            %size(diff)
            %size(original)
            %imagesc(original);
            %colormap(jet(255));
            
            %original = insertShape(original,'Polygon',polygon,'Color','Green');
            %changed = rgb2gray(insertShape(I,'Polygon',cpolygon,'Color','White'));
            %imshow(original);

            %display images
            %h = figure(num*10+k);
            %figure('visible','off');
            %imshow(original,'Colormap',jet(255));
            %hobbysplines(points);
            name = strcat(id,'LAYER',num2str(k));
            switch(i)
                case 1
                    name = strcat(name,'dilation');
                case 2
                    name = strcat(name,'erosion');
                case 3
                    name = strcat(name,'translation');
                case 4
                    name = strcat(name,'rotation');
                case 5
                    name = strcat(name,'randomdrag');
            end
            %name = strcat(name,'.tif');
            %cd 'AllPlotMorphs'
            cd CroppedMorphs
            %export_fig(name);
            cd ..
            %cd ..
            %close all;
        %figure(2*k);
        %imshow(changed,'Colormap',jet(255));
        
        end
        
        m = roipoly(I,x,y);
        m1 = imresize(m, 1/factor);
        inROI = I(m);
        inROI = I1(m1);
        %figure(1)
        
        inf = dicominfo(fdir);
        stat(1) = mean(double(inROI))* inf.Private_0077_1001;
        stat(2) = median(double(inROI))* inf.Private_0077_1001;
        stat(3) = std(double(inROI))* inf.Private_0077_1001;
        stat(4) = max(double(inROI))* inf.Private_0077_1001;
        stat(5) = min(double(inROI))* inf.Private_0077_1001;
        stat(6) = sum(sum(m1))*inf.PixelSpacing(1)*inf.PixelSpacing(1);
        stats = [stats; stat];
        
        %%%%%%%%testing to see if NordicIce was somehow registered
%         a = logical(I1);
%         figure(96)
%         imshow(a);
%         b = logical(perfusion_rCBV_im2)
%         figure(97)
%         imshow(b)
%         max(max(a))
%         min(min(a))
%         max(max(b))
%         min(min(b))
%         figure(98)
%         imshow(double(a - b))
        
        
    end
    
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

