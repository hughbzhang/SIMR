%This function helped me get rid of the images with no ROI data.

function removeNoROI(list)
    for i = 1:40
        id = list(i).name;
        avails = dir(strcat('~/Documents/workspace/SIMR/DrawingMorphs/NordicIce_data/', id, '/ROI CEL/ROI_CEL_Slice *.roi'));
        if(size(avails,1)==0)
            id
        end;
    end
end
