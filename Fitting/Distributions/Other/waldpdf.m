function y=waldpdf(x,mu,sigma,a)
% Density function of the Wald distribution.
%
% USAGE: Y=WALDPDF(X,MU,SIGMA,A)
%  
% Parameters:
%      mu = Drift Rate (The mean gain of information per unit of time)
%   sigma = Standard Deviation of Drift Rate.
%       a = Evidence Criterion (Location of absorbing boundary)
%
% See also WALDCDF, EXWALDPDF, EXWALDCDF, EXWALDFIT, EXWALDINV, EXWALDLIKE,
%          EXWALDCORR, EXWALDSSQ

% Adapted from the equations presented in:
%   Schwarz, W. (2001). The ex-Wald distribution as a descriptive model of
%   response time. Behavior Research Methods, Instruments, & Computers,
%   33(4), 457-469.
%
% Original Code from:
%   Wolf Schwarz
%   Dept. of Psychology
%   University of Potsdam
%   wschwarz@rz.uni-potsdam.de
%
% Adapted for MATLAB by: 
%   Evan McHughes Palmer
%   BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu


% ERROR CHECKING 
if sum(x<0)>0
    error('x-values cannot be negative.');
elseif mu<0
    error('mu must be greater than 0');
elseif a<0
    error('a must be greater than 0');
elseif sigma<0
    error('sigma must be greater than 0');
end


warning off;

v=sigma^2;

part1=exp(-((a - mu .* x(find(x>0))) .^ 2) ./ (2 .* v .* x(find(x>0))));
part2=sigma .* sqrt((2 .* pi .* x(find(x>0)) .^3));

y(find(x>0))= a .* part1 ./ part2;

y(find(x==0))=0;

warning on;

return