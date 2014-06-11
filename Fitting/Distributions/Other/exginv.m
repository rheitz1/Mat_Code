function x=exginv(y,mu,sigma,tau)
%
%EXGINV Approximated inverse of the exgaussian cumulative distribution 
%       function (cdf).
%
%    X = EXGINV(Y,MU,SIGMA,TAU) returns the inverse cdf of an exgaussian 
%    distribution with the normal having mean MU and standard deviation 
%    SIGMA, and exponential having mean TAU, evaluated at the
%    values in Y.  
%
%    MU    = Mean of Gaussian component
%    SIGMA = S.D. of Gaussian component
%    TAU   = Mean of Exponential component
%
%   See also EXGCDF, EXGPDF, EXGFITRT, EXGRND, and EXGLIKE.

% Version 1.1 12/09/04
% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu
%
% This code originally from Van Zandt (2002) "Analysis of Response Time
% Distributions"

% Note that this is an approximation of the inverse ex-Guassian function to
% within .1 units. For data going over values of 10001, you will need to
% change the range of the variable 'potx'.

oney=find(y==1);

if length(oney)>0, y(oney)=1-1/length(y)/2; end

potx=1:.1:10001;
poty=exgcdf(potx,mu,sigma,tau);

for n=1:length(y)
    diffy=abs(y(n)-poty);
    x(n)=potx(find(diffy==min(diffy)));
end

