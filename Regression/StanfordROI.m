%This function extracted Stanford Dr. Achal's ROIs into a form usable by me

function StanfordROI()
    
    addpath(['~/Documents/MATLAB/NIFTY']);
    %Need to add a nifty viewer to your MATLAB path

    cd ~/Documents/workspace/SIMR/Regression/ACHAL
    list = dir;
    list = list(4:end);
    for i = 1:size(list,1)
        CEL = zeros(128,128,50);
        NEC = zeros(128,128,50);
        cd(list(i).name)
        
        if(exist('registeredCELROI.nii'))
            CEL = load_nii('registeredCELROI.nii');
            CEL = CEL.img;
        end
        if(exist('registeredNecrosisROI.nii'))
            NEC = load_nii('registeredNecrosisROI.nii');
            NEC = NEC.img;
        else NEC = zeros(size(CEL));
        end
        
        cd ~/Documents/workspace/SIMR/Regression/StanfordROI
        
        for a = 1:min(size(CEL,3),size(NEC,3))
            
            
            
            rot = CEL(:,:,a);
            rot = rot(128:-1:1,128:-1:1)';
            rot2 = NEC(:,:,a); 
            rot2 = rot2(128:-1:1,128:-1:1)';
            if(sum(sum(rot))==0) continue; end %If there is no tumor
            
            
            cd ~/Documents/workspace/SIMR/Regression/StanfordROI/CEL
            cur = logical(rot~=0);
            imwrite(cur,strcat(list(i).name,'LAYER',num2str(a),'CEL.tif'));
            cd ~/Documents/workspace/SIMR/Regression/StanfordROI/NEC
            
            cur = logical(rot2~=0);
            imwrite(cur,strcat(list(i).name,'LAYER',num2str(a),'NEC.tif'));
            cd ~/Documents/workspace/SIMR/Regression/StanfordROI
            
        end
        
        
        cd ../ACHAL
    end
    cd ..


end
