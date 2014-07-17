function getStanford()
    cd ~/Documents/workspace/SIMR/Regression
    list = dir('StanfordROI/CEL');
    m = java.util.HashMap;
    
    for i = 1:size(list,1)
        
        if(isempty(strfind(list(i).name,'.tif'))) continue; end
        cur = list(i).name;
        name = cur(1:12);
        if(~exist(strcat('NordicIce_data/',name),'dir'))
            name
            delete(strcat('StanfordROI/CEL/',list(i).name));
            delete(strcat('StanfordROI/NEC/',list(i).name));
            continue;
        end
       if(~isempty(m.get(name))) continue; end
       m.put(name,1);
       cd(strcat('NordicIce_data/',name,'/processed CBV leakage corrected maps'))
       images = dir;
       cnt = 1;
       for a = 1:size(images,1)
           if(isempty(strfind(images(a).name,'.dcm'))) continue; end
           I = dicomread(images(a).name);
           cd ~/Documents/workspace/SIMR/Regression/StanfordImages
           dicomwrite(I,strcat(name,'LAYER',num2str(cnt),'.dcm'));
           cnt = cnt+1;
           cd(strcat('../NordicIce_data/',name,'/processed CBV leakage corrected maps'))
       end
       
       cd ~/Documents/workspace/SIMR/Regression
    end

end