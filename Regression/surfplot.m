function surfplot(IN)

close all
cd ~/Documents/workspace/SIMR/Regression/DATA

ax = 2.^[-5:5];
labels = ['2^-5 2^-4 2^-3 2^-2 2^-1 2^0 2^1 2^2 2^3 2^4 2^5'];


[X Y] = meshgrid(ax);


surf(X,Y,IN)
set(gca,'Yscale','log','Ydir','normal');
set(gca,'Xscale','log','Xdir','normal');
grid minor




cd ..

end