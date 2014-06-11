function y=gampdfrt(x,alpha,beta,xi);
%
% Y = GAMPDFRT(X,ALPHA,BETA,XI);
% GAMPDFRT Returns the probability density of the gamma function for the
% values in x, given the parameters alpha, beta, and xi.  
%   alpha = scale  (this is B in gampdf)
%    beta = shape  (this is A in gampdf)
%      xi = shift  (this is not in gampdf)

% Formula for gamma function comes from: Dolan, van der Maas & Molenaar
% (2002).  
%
% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu


i=find(x>xi);
y(i) = ((x(i)-xi).^(beta-1) .* exp(-1.*((x(i)-xi)./alpha))) ./ ((alpha.^beta) .* exp(gammaln(beta)));
i=find(x<=xi);
y(i)=0;     % where (xi<x)
