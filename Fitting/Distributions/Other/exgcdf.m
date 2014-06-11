function F=exgcdf(t,mu,sigma,tau)
%EXGCDF Exgaussian cumulative distribution function (cdf).
%    P = EXGCDF(X,MU,SIGMA,TAU) returns the cdf of an exgaussian 
%    distribution with the normal having mean MU and standard deviation 
%    SIGMA, and exponential having mean TAU, evaluated at the
%    values in X.  
%
%    MU    = Mean of Gaussian component
%    SIGMA = S.D. of Gaussian component
%    TAU   = Mean of Exponential component
%
%   See also EXGPDF, EXGFITRT, EXGRND, EXGINV and EXGLIKE.

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

part1=-exp(-t./tau + mu./tau + sigma.^2./2./tau.^2);
part2=normcdf((t-mu-sigma.^2./tau)./sigma);
part3=normcdf((t-mu)/sigma);
F=part1.*part2 + part3;