function y=exwaldpdf(x,mu,sigma,a,gamma)
% Density function of the ex-Wald distribution.
%
% USAGE: Y=EXWALDPDF(X,MU,SIGMA,A,GAMMA)
%  
% Parameters:
%      mu = Drift Rate (The mean gain of information per unit of time)
%   sigma = Standard Deviation of Drift Rate (Typically set to 1)
%       a = Evidence Criterion (Location of absorbing boundary)
%   gamma = Mean/StDev of Exponential
%
% See also WALDPDF, WALDCDF, EXWALDCDF, EXWALDFIT, EXWALDINV, EXWALDLIKE,
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
elseif gamma<0
    error('gamma must be greater than 0');
end

[n,m]=size(x);
if m == 1                      % case of a column vector
   x = x';
end


warning off;

disk=mu^2-2*gamma*sigma^2;
v=sigma^2;

if disk>=0
    h=disk^0.5;
    y=waldcdf(x,h,v,a).*gamma.*exp(-gamma.*x+a.*(mu-h)./v);
else
    h=((a-mu.*x).^2)./(2.*v.*x);
    arg_x=sqrt(-disk);
    arg_x=arg_x.*sqrt(x)./(sigma.*sqrt(2));
    arg_y=a./(sigma.*sqrt(2.*x));
    y=gamma.*exp(-h).*re_w(arg_x,arg_y);
end

y(find(x==0))=0;

warning on;

return
