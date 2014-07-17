%This function computes the contrast of an image within a given mask m.
%Essentially, it computes how similar a pixel is to its neighbor within the
%tumor


function sum = contrast(I,M)
    sum = 0.0;
    I = double(I);
    
    M = ~M; %Flip so 1 correspondes to something OUTSIDE the tumor.
    for i = 2:size(I,1)-1
        for j = 2:size(I,2)-1
            if(M(i,j)) continue; end
            sum = sum + (I(i,j)-I(i,j+1))^2;
            sum = sum + (I(i,j)-I(i,j-1))^2;
            sum = sum + (I(i,j)-I(i+1,j))^2;
            sum = sum + (I(i,j)-I(i-1,j))^2;
        end
    end
    
    


end