%This function normalizes all my data to a mean of 0 and a standard
%deviation of 1

%It also replaces any missing values with the average for the set

%After this, the data should be ready to regress upon.






function NORM = normalize(NORM)
    replace = nanmean(NORM);
    for i = 1:size(NORM,2)
        NORM(isnan(NORM(:,i)),i) = replace(i);
    end
    
    NORM = (NORM-kron(mean(NORM),ones(size(NORM,1),1)))./(kron(std(NORM),ones(size(NORM,1),1)));
end
