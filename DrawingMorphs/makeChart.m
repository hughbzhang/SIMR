%This is a helper function to help me make graphs and charts.

function makeChart(allMeans,labels)

    EQUAL = 0:0.1:7;
    Y = allMeans(:,6);
    for i = 1:5
        h = figure(i);
        X = allMeans(:,i);
        
        
        
        P = polyfit(X,Y,1);
        sprintf('Y = %f X + %f',P(1),P(2));
        YHAT = polyval(P,EQUAL);
        SSRESID = sum((polyval(P,X)-Y).^2);
        SSTOTAL = (length(Y)-1)*var(Y);
        1-SSRESID/SSTOTAL;
        plot(EQUAL,YHAT,X,Y,'o');
        xlabel(labels(i));
        ylabel(labels(6));
        title(strcat(labels(i),' RCBV Changes'));
        name = strcat(labels(i),'vs',labels(6),'.tiff');
        saveas(h,sprintf('%s',char(name)));
    end


end
