% CDF of the linear ballistic accumulator model
% from Brown & Heathcote (2008) p.159
%
% t is vector of x-values
% A is upper limit on starting point of evidence accumulation. 
% b is threshold
% v is the drift rate.  
% s is s.d. of the drift rate

function [F] = linearballisticCDF(t,A,b,v,s)


% %CDF
F = 1 ...
    + ( (b-A-(t.*v)) ./ A ) .* (normcdf( (b-A-(t.*v)) ./ (t.*s) )) ...
    - ( (b-(t.*v)) ./ A ) .* (normcdf( (b-(t.*v)) ./ (t.*s) )) ...
    + ( (t.*s) ./ A ) .* (normpdf( (b-A-(t.*v)) ./ (t.*s) )) ...
    - ( (t.*s) ./ A ) .* (normpdf( (b-(t.*v)) ./ (t.*s) ));

