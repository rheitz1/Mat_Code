function y=waldcdf(x,mu,sigma,a)
% Cumulative function of the Wald distribution.
%
% USAGE: Y=WALDCDF(X,MU,SIGMA,A)
%  
% Parameters:
%      mu = Drift Rate (The mean gain of information per unit of time)
%   sigma = Standard Deviation of Drift Rate.
%       a = Evidence Criterion (Location of absorbing boundary)
%
% See also WALDPDF, EXWALDPDF, EXWALDCDF, EXWALDFIT, EXWALDINV, EXWALDLIKE,
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


warning off

v=sigma^2;

hi_ix=find((-(mu.*x+a)./(sigma.*sqrt(x))) >  -5.50);
y1(hi_ix)=normcdf(( (mu.*x(hi_ix)-a)./(sigma.*sqrt(x(hi_ix)))),0,1);
y2(hi_ix)=normcdf((-(mu.*x(hi_ix)+a)./(sigma.*sqrt(x(hi_ix)))),0,1);
 y(hi_ix)=y1(hi_ix)+y2(hi_ix).*exp(2.*mu.*a./v);

lo_ix=find((-(mu.*x+a)./(sigma.*sqrt(x))) <= -5.50);
y1(lo_ix)=normcdf(((mu.*x(lo_ix)-a)./(sigma.*sqrt(x(lo_ix)))),0,1);
q1(lo_ix)=(mu.*x(lo_ix)+a)./(sigma.*sqrt(x(lo_ix)));
q2(lo_ix)=(mu.*x(lo_ix)-a)./(sigma.*sqrt(x(lo_ix)));
y2(lo_ix)=1./(q1(lo_ix).*(2.*pi)^0.5);
y2(lo_ix)=y2(lo_ix).*exp(-0.5.*q2(lo_ix).*q2(lo_ix)-0.94./(q1(lo_ix).*q1(lo_ix)));
 y(lo_ix)=y1(lo_ix)+y2(lo_ix);
    
y(find(x==0))=0;

warning on

return
