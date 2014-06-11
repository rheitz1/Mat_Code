function [ellipse_x,ellipse_y,params] = plotEllipse(x,y)
%from Batschelet, 1981, p. 132 & p.264

%NaN Handling.
Z = [x y];
Z = removeNaN(Z);
x = Z(:,1);
y = Z(:,2);

A = var(y);
C = var(x);

B_temp = -1*cov(x,y);
B = B_temp(2,1); %covariance from covariance matrix is below diagonal in 2x2

r = corr(x,y);
D = (1 - r^2) * (var(x)*var(y)); %size of the ellipse (holding all other 
                                 %params constant describes family of ellipses


%mean of the points is the centroid of the ellipse
xbar = mean(x);
ybar = mean(y);

%====================
R = (  (A-C)^2 + 4*(B^2)    )^.5;
a = (  (2*D) / (A + C - R)  )^.5;
b = (  (2*D) / (A + C + R)  )^.5;

%theta is angle of ellipse in radians
theta = atan(  (2*B) / (A - C - R) );

%controlls number of points used to create the ellipse
psi = 0:1:360;

ellipse_x = xbar + ( a*cos(theta)*cos(psi) ) - ( b*sin(theta)*sin(psi) );
ellipse_y = ybar + ( a*sin(theta)*cos(psi) ) + ( b*cos(theta)*sin(psi) );

params.A = A;
params.B = B;
params.C = C;
params.D = D;
params.R = R;
params.theta = theta;