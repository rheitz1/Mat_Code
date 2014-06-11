function y=wblpdfrt(x,alpha,gamma,xi);
% WBLPDFRT Returns the probability density of the weibull function for the
% values in x, given the parameters alpha, gamma, and xi.  
%   alpha = scale
%   gamma = shape
%      xi = shift

% Formula for gamma function comes from: Dolan, van der Maas & Molenaar
% (2002).  
%
% Revised version by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu

i=find(x>xi);
y(i) = (gamma/alpha) .* ((x(i)-xi)./alpha).^(gamma-1) .* exp(-((x(i)-xi)./alpha).^gamma);
i=find(x<=xi);
y(i)=0;     % where (xi<x)
