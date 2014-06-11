function logL=gamlikert(params,data)
% Returns the negative log likelihood of the data, given the parameters.
%
% Parameter order for gamma is alpha, beta, xi.
%   alpha = scale
%    beta = shape
%      xi = shift

% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
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

y=gampdfrt(data,params(1),params(2),params(3))+eps;

logL=-sum(log(y)); 