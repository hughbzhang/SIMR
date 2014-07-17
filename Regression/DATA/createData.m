%This function aggregates the data into one matrix so it is easier to manipulate and work with


function ALLDATA = createData()
    load regression.mat;
    ALLDATA = zeros(length(imageID),7); % Contents in notes
    
    for i = 1:length(names)
        for j = 1:length(imageID)
            if(strcmp(names(i),imageID(j))) %means we have an image on it
                ALLDATA(j,1) = death(i);
                ALLDATA(j,2) = age(i);
                ALLDATA(j,3) = karn(i);
                ALLDATA(j,4) = gender(i);
                if(race(i)==0) ALLDATA(j,5) = 1; end
                if(race(i)==1) ALLDATA(j,6) = 1; end
                if(race(i)==2) ALLDATA(j,7) = 1; end
                
            end
    end


end
