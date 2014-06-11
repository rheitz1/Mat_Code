% Create Two Dimensional Gaussian Distribution
% Kathryn Ferguson April 2009


% Equation:
%  f(x,y) = A*e^-(((x-x_0)/(2*psi_x^2))^2+((y-y_0)/(2*psi_y^2))^2);
% A = amplitude
% psi_x/psi_y = spread
% x_0/y_0 = center

function [fgauss] = Two_Dimension_Gaussian(deltax, deltay)


A = 1;

x_0 = mean(deltax);
y_0 = mean(deltay);


% Spread will be measured by range

absolutex = abs(deltax);
absolutey = abs(deltay);

psi_x = max(absolutex);
psi_y = max(absolutey);


fgauss(deltax,deltay) = expm^(-(((deltax-x_0)/(2*psi_x^2)).^2+((deltay-y_0)/(2*psi_y^2)).^2));


end