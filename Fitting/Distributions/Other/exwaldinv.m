function x=exwaldinv(y,mu,sigma,a,gamma)
% Finds the corresponding x value for a given y value for the EXWALD 
% function. Finds the value to the nearest integer, within the range of 
% 1 to 10,001, which is the range of probable reaction times.
%
% USAGE: X=EXWALDINV(Y,MU,SIGMA,A,GAMMA)
%  
% Parameters:
%      mu = Drift Rate (The mean gain of information per unit of time)
%   sigma = Standard Deviation of Drift Rate.
%       a = Evidence Criterion (Location of absorbing boundary)
%   gamma = Mean/StDev of Exponential
%
% See also WALDCDF, WALDPDF, WALDRND, EXWALDPDF, EXWALDCDF, EXWALDFIT,  
%          EXWALDINV, EXWALDLIKE, EXWALDCORR, EXWALDSSQ

% Written by:
%   Evan McHughes Palmer
%   Visual Attention Laboratory
%   Harvard Medical School
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu

oney=find(y==1);

if length(oney)>0, y(oney)=1-1/length(y)/2; end

potx=1:1:10001;
poty=exwaldcdf(potx,mu,sigma,a,gamma);

for n=1:length(y)
    diffy=abs(y(n)-poty);
    x(n)=potx(find(diffy==min(diffy)));
end

