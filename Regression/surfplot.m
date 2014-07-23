function surfplot(IN)

close all
cd ~/Documents/workspace/SIMR/Regression/DATA

ax = 10.^[-5:5];

[X,Y] = meshgrid(ax);


surf(X,Y,IN)
set(gca,'Yscale','log','Ydir','normal');
set(gca,'Xscale','log','Xdir','normal');
set(gca,'ZTick',[.25 .5 .75 1]);
set(gca,'ZTickLabel',[25 50 75 100]);

grid off
set(gca,'ZGrid','on')
set(gca,'YGrid','on')
set(gca,'XGrid','on')
set(gca,'ZMinorGrid','off')
set(gca,'YMinorGrid','off')
set(gca,'XMinorGrid','off')
zlim([0,1])



xlabel('C')
ylabel('Sigma')
zlabel('Accuracy')
title('Test Set Accuracy for Clinical Features Alone')



cd ..

end