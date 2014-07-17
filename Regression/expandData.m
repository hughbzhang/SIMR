%This function enables me to use all the layers of each patient as a separate data case. I expand my data so I can use more of it.




function Y = expandData(imageID,ALLDATA)
    Y = [];
    for LOOP = 1:size(imageID,1)
        LOOP
        id = imageID{LOOP};
        avails = dir(strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/ROI CEL/ROI_CEL_Slice *.roi'));
        avails_ids = zeros(1,length(avails));
        for i = 1:length(avails)
            avail_id = avails(i).name(14: (strfind(avails(1).name, '.roi')-1)); %CEL = 10
            avails_ids(i) = str2double(avail_id);
        end
        for k = 1:length(avails_ids)
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
                    a = str2double(tline(1, 1:3));
                    b = str2double(tline(1, 5:7));
                    x = [x a];
                    y = [y b];   
                end
            end
            ROI = [x;y];
            fdir = strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/processed CBV leakage corrected maps/Image#', num2str(sprintf('%03d',sn)), '.dcm');
            I1 = dicomread(fdir);
            I = imresize(I1, factor, 'nearest');
            
            %{
            cd Original
            next = uint16(I1);
            imwrite(next,strcat(id,'LAYER',num2str(k),'ORIGINAL.tif'),'Compression','none');
            cd ..
            cd ROI
            ROI = ROI./factor;
             
            save(strcat(id,'LAYER',num2str(k),'ROI','.mat'),'ROI');
            cd ..
            
            %}
            
            cd Visual
            imagesc(I);
            set(gca,'Visible','off');
            colormap(gray(255));
            export_fig(strcat(id,'LAYER',num2str(k),'ORIGINAL.jpg'));
            colormap(jet(255));
            hold on;
            plot(x,y,'LineWidth',2,'Color','Red');
            Y = [Y;ALLDATA(LOOP,:)];
            
            export_fig(strcat(id,'LAYER',num2str(k),'.jpg'));
            save(strcat(id,'LAYER',num2str(k),'ROI','.mat'),'ROI');
            
            
            cd ..
            
            close all;
            
            
            
        end
    end
end
