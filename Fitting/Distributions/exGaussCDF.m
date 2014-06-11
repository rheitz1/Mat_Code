% CDF of the ex-gaussian
% from VanZandt (2000) p.464
%
% t is a vector of x-values
% mu is the mean of the gaussian portion
% sigma is the variance of the gaussian portion
% tau is the mean and variance of the exponential tail
%
%
% The below equation is from VanZandt (2000) p.464, however
% ***there is an error in her paper***.  The first argument is printed as t/tau
% when it should be -t/tau, as it is for the PDF.
%
% RPH

function [F] = exGaussCDF(t,mu,sigma,tau)

F = -exp( (-t./tau) + (mu / tau) + (sigma^2 / (2*tau^2)) ) ...
    .* normcdf( (t - mu - (sigma^2 / tau)) / sigma) ...
    + exp( (mu/tau) + (sigma^2 / (2*tau^2))) ...
    .* normcdf( (-mu - (sigma^2 / tau)) / sigma)...
    + normcdf( (t - mu) / sigma) ...
    - normcdf(-mu/sigma);