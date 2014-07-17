function all = loop()
    cd ~/Documents/workspace/SIMR/Regression/Original;
    list = dir;
    list = list(3:end);
    %list = list(end-4:end);
    cd ..
    all = zeros(128,128,length(list));
    for i = 1:length(list)
        cd Original
        I = imread(list(i).name);
        cd ..
        all(:,:,i) = findBrain(I);
       
    end
    
    
    
    %save('allMeans.txt','allMeans','-ascii');


end