% PDF of the ex-gaussian
% from VanZandt (2000) p.464
%
% t is a vector of x-values
% mu is the mean of the gaussian portion
% sigma is the variance of the gaussian portion
% tau is the mean and variance of the exponential tail
%
% RPH

function [f] = exGaussPDF(t,mu,sigma,tau)

f =(1/tau) * exp((-t./tau)+(mu/tau)+(sigma^2/(2*(tau^2)))) ...
    .* normcdf( (t-mu- (sigma^2 / tau) ) / sigma  );
