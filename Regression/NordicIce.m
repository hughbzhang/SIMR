%This function converted all the DCM images into tiffs so that they are more easily used and viewed.

function NordicIce()
    cd '~/Documents/workspace/SIMR/Regression/NordicIce_data';
    list = dir;
    num = size(list,1);
    
    for i = 1:num
        list(i).name
        if(strcmp(list(i).name,'TCGA-06-0149')) continue; end
        cd '~/Documents/workspace/SIMR/Regression/NordicIce_data';
        if(size(strfind(list(i).name,'TCGA'),1)==0) continue; end
        cd(strcat(list(i).name,'/processed CBV leakage corrected maps'));
        lib = dir;
        for a = 1:size(lib,1)
            if(size(strfind(lib(a).name,'.dcm'),1)==0) continue; end
            I = dicomread(lib(a).name);
            name = strrep(lib(a).name,'Image#0','');
            name = strrep(name,'dcm','tif');
            cd ~/Documents/workspace/SIMR/Regression/ALLIMAGES/;
            imwrite(I,strcat(list(i).name,'LAYER',name),'Compression','none');
            cd(strcat('~/Documents/workspace/SIMR/Regression/NordicIce_data/',list(i).name,'/processed CBV leakage corrected maps'));
        end
    end
    cd '~/Documents/workspace/SIMR/Regression';
    

end
