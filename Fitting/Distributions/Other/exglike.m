function logL=exglike(params,data)
%EXGLIKE Negative log-likelihood for the Exgaussian distribution.
%    LOGL = EXGLIKE(PARAMS,DATA) returns the minus log-likelihood value 
%    that the DATA came from the Exgaussian specified by the parameters 
%    in PARAMS.
%
%    PARAMS = [MU,SIGMA,TAU]
%    DATA is a row or column vector of numbers to be evaluated 
%
%    MU    = Mean of Gaussian component
%    SIGMA = S.D. of Gaussian component
%    TAU   = Mean of Exponential component
%
%   See also EXGCDF, EXGPDF, EXGFIT, EXGRND and EXGINV.

% Version 2.1 12/09/04
% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu
%
% Version 2.0 01/21/03
% (c) Yves Lacouture, Université Laval

[n,m]=size(data);
if n == 1                      % case of a row vector
   data = data';
   n = m;
end

y=exgpdf(data,params(1),params(2),params(3))+eps;

logL=-sum(log(y)); 
