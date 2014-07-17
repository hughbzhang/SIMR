%This function takes the Region of Interest (ROI) and applies a morph to it. It simulates the differences in the ways that different radiologists draw their outline of the tumors.

function [SROIX,SROIY] = s_pertube_roi(X,Y,mode,I)

% dilation/erosion/translation by 10% of the ROI diameter
rim = min(1, (min(max(X)-min(X), max(Y)-min(Y)) / 5));
    



     m = roipoly(I,X,Y);
    measurements = regionprops(m,'Area', 'EquivDiameter', 'MajorAxisLength');
    area = [measurements.Area];
    a = [measurements.MajorAxisLength];
    b = sqrt(((pi*((a/2).^2)) - area)/pi)*2;
    Rmax = a-b;
    Rmax = [measurements.EquivDiameter];
    if(length(area)>1)
        dilation_erosion = 0.1 * Rmax(1);
    else
        dilation_erosion = 0.1 * Rmax;
    end

% 10 degree rotation
rotation = 10;



 % 1) Dilation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         TEST_TRANS(t,:) = [0, 0];
%         TEST_ROT(t, :)  = 0;
%         TEST_RND(t, :)  = [0, 0];
%         TEST_PUSH(t, :) = dialation_erosion;
%         morphType = '_Dilation';
%         %Pushing and Pulling 
%         %Convert to Polar
%         center_of_circle_x = mean(lesion.roi.x);
%         center_of_circle_y = mean(lesion.roi.y);
%         centx = lesion.roi.x - center_of_circle_x;
%         centy = lesion.roi.y - center_of_circle_y;
%         [theta, rho] = cart2pol(centx, centy);
%         rho = rho + TEST_PUSH(t);
%         [newx, newy] = pol2cart(theta, rho);
%         sroi.x = newx + center_of_circle_x;
%         sroi.y = newy + center_of_circle_y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%         % 2) Erosion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         TEST_TRANS(t,:) = [0, 0];
%         TEST_ROT(t, :)  = 0;
%         TEST_RND(t, :)  = [0, 0];
%         TEST_PUSH(t, :) = - dialation_erosion;
%         morphType = '_Erosion';
%         %Pushing and Pulling 
%         %Convert to Polar
%         center_of_circle_x = mean(lesion.roi.x);
%         center_of_circle_y = mean(lesion.roi.y);
%         centx = lesion.roi.x - center_of_circle_x;
%         centy = lesion.roi.y - center_of_circle_y;
%         [theta, rho] = cart2pol(centx, centy);
%         rho = rho + TEST_PUSH(t);
%         [newx, newy] = pol2cart(theta, rho);
%         sroi.x = newx + center_of_circle_x;
%         sroi.y = newy + center_of_circle_y;


switch(mode)
    case 1 % dilation
        
         %Pushing and Pulling 
         %Convert to Polar
         center_of_circle_x = mean(X);
         center_of_circle_y = mean(Y);
         centx = X - center_of_circle_x;
         centy = Y - center_of_circle_y;
         [theta, rho] = cart2pol(centx, centy);
         rho = rho + dilation_erosion;
         [newx, newy] = pol2cart(theta, rho);
         SROIX = newx + center_of_circle_x;
         SROIY = newy + center_of_circle_y;
        
        
        %cx = 0.5 * (min(X) + max(X));
        %cy = 0.5 * (min(Y) + max(Y));
        %theta = atan(abs((Y-cy) ./ (X - cx)));
        %SROIX = cos(theta) * dilation_erosion .* sign(X-cx) + X;
        %SROIY = sin(theta) * dilation_erosion .* sign(Y-cy) + Y;
    case 2 % erosion
        
        
         % 2) Erosion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         TEST_TRANS(t,:) = [0, 0];
%         TEST_ROT(t, :)  = 0;
%         TEST_RND(t, :)  = [0, 0];
%         TEST_PUSH(t, :) = - dialation_erosion;
%         morphType = '_Erosion';
%         %Pushing and Pulling 
%         %Convert to Polar
%         center_of_circle_x = mean(lesion.roi.x);
%         center_of_circle_y = mean(lesion.roi.y);
%         centx = lesion.roi.x - center_of_circle_x;
%         centy = lesion.roi.y - center_of_circle_y;
%         [theta, rho] = cart2pol(centx, centy);
%         rho = rho + TEST_PUSH(t);
%         [newx, newy] = pol2cart(theta, rho);
%         sroi.x = newx + center_of_circle_x;
%         sroi.y = newy + center_of_circle_y;
        
        
        center_of_circle_x = mean(X);
         center_of_circle_y = mean(Y);
         centx = X - center_of_circle_x;
         centy = Y - center_of_circle_y;
         [theta, rho] = cart2pol(centx, centy);
         rho = rho - dilation_erosion;
         [newx, newy] = pol2cart(theta, rho);
         SROIX = newx + center_of_circle_x;
         SROIY = newy + center_of_circle_y;
        
        
        
        
        %cx = 0.5 * (min(X) + max(X));
        %cy = 0.5 * (min(Y) + max(Y));
        %theta = atan(abs((Y-cy) ./ (X - cx)));
        %SROIX = -cos(theta) * dilation_erosion .* sign(X-cx) + X;
        %SROIY = -sin(theta) * dilation_erosion .* sign(Y-cy) + Y;
    case 3 % translating
        deltax = 2*rand()-1;
        deltay = 2*rand()-1;    % in random direction
        SROIX = X + deltax * dilation_erosion;
        SROIY = Y + deltay * dilation_erosion;
    case 4 % rotation
        oz = rotation / 360*2*pi;
        A = [ cos(oz) sin(oz);
            -sin(oz) cos(oz)] ;
        if size(X,1)==1, X = X';Y = Y'; end
        cx = mean(X); cy = mean(Y);
        tmp = [X-cx  Y-cy]*A;
        SROIX = tmp(:,1) + cx;
        SROIY = tmp(:,2) + cy;
    case 5  % random drag (30% of ROI points)
        SROIX = X;
        SROIY = Y;
        p = randperm( length(SROIX) );
        CONVX = [];
        CONVY = [];
        for j = 1:length(p)/3
            ii = p(j);
            r = (1+rand()) * 0.5*dilation_erosion;
            theta = 2*pi * rand();
            SROIX(ii) = SROIX(ii) + r*cos(theta);
            SROIY(ii) = SROIY(ii) + r*sin(theta);
        end
    case 6
        SROIX = X;
        SROIY = Y;
        %K = convhull(SROIX,SROIY);
        %for i = 1:length(K)
        %    CONVX = [CONVX SROIX(K(i))];
        %    CONVY = [CONVY SROIY(K(i))];
        %end
        %SROIX = CONVX;
        %SROIY = CONVY;
        
        
end
