function StanfordVisual()

    addpath('~/Documents/MATLAB/exportfig')
    cd ~/Documents/workspace/SIMR/Regression/StanfordImages
    list = dir;
    list = list(4:end);
    for i = 1:size(list,1)
        
        cd ~/Documents/workspace/SIMR/Regression/StanfordImages
        close all
        I = dicomread(list(i).name);
        imagesc(I)
        set(gca,'Visible','off')
        cd ~/Documents/workspace/SIMR/Regression/StanfordVisual
        export_fig(I,strrep(list(i).name,'dcm','jpg'))
        
    end
        

end