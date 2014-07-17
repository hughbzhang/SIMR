function inside = findBrain(I)
    


    sz = size(I,1);
    stack = zeros(sz*sz,1);
    vis = logical(zeros(sz));
    inside = zeros(sz);
    stack(1) = sz/2*sz+sz/2;
    index = 1;
    %In the stack the coodinate that it is representing is this
    % y = 1+floor(value/size)
    % x = 1+ value%size
    %so the upper left corner is represented as 0 in the stack
    
    while(index>0)
       
       y = 1+floor(stack(index)/sz);
       x = 1+mod(stack(index),sz);
       index = index - 1;
       if(y<1||y>sz||x<1||x>sz) continue; end
       if(vis(y,x)) continue; end
       if(I(y,x)<10) continue; end
       inside(y,x) = 1;
       vis(y,x) = 1;
       index = index+1;
       stack(index) = (y-2)*sz+x-1;
       index = index+1;
       stack(index) = y*sz+x-1;
       index = index+1;
       stack(index) = (y-1)*sz+x;
       index = index+1;
       stack(index) = (y-1)*sz+x-2;
       
       
    end
    inside = imfill(inside);
    
    



end