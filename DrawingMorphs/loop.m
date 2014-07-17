function allMeans = loop()
    cd NordicIce_data;
    list = dir;
    list = list(4:end);
    %list = list(end-4:end);
    cd ..
    for i = 1:length(list)
        computePerfusion(list(i).name);
        i
    end
    %save('allMeans.txt','allMeans','-ascii');


end