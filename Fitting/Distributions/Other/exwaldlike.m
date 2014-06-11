function logL=exwaldlike(params,data)
%EXWALDLIKE Negative log-likelihood for the ex-Wald distribution.
%    LOGL = EXWALDLIKE(PARAMS,DATA) returns the minus log-likelihood value 
%    that the DATA came from the ex-Wald specified by the parameters 
%    in PARAMS.
%
%    PARAMS = [MU,SIGMA,A,GAMMA]
%    DATA is a row or column vector of numbers to be evaluated 
%
%    MU    = Drift Rate (The mean gain of information per unit of time)
%    SIGMA = Standard Deviation of Drift Rate
%    A     = Evidence Criterion (Location of absorbing boundary)
%    GAMMA = Mean/StDev of Exponential.
%
%   See also EXWALDCDF, EXWALDPDF, **EXWALDRND, EXWALDINV and EXWALDLIKE**.

% By: Evan M. Palmer
%     BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu

[n,m]=size(data);
if n == 1                      % case of a row vector
   data = data';
   n = m;
end

y=exwaldpdf(data,params(1),params(2),params(3),params(4))+eps;
%y=exwaldpdf_fit(data,params(1),params(2),params(3),params(4))+eps;

logL=-sum(log(y)); 
