% Hazard function is defined as the probability of observing a value at time
% t given that the value has not occured yet.
% You take the instantaneous probability / cumulative probability of the
% tail of the distribution that has not occurred yet.  i.e., 1-CDF.

% The exponential has a flat hazard function because as you move further out
% on the PDF (less likely values), there is less of the distribution left
% from the CDF, and these are perfectly in balance.
%
% RPH


%make distribution
t = 0:1:2000;
mean_int = 1000;
st_dev = 300; %for use when distribution requires a standard dev

%Exponential
dist.exp = exppdf(t,mean_int);
hazard.exp = exppdf(t,mean_int)./(1-expcdf(t,mean_int));

%Gaussian
dist.norm = normpdf(t,mean_int,st_dev);
hazard.norm = normpdf(t,mean_int,st_dev)./(1-normcdf(t,mean_int,st_dev));

%Uniform
dist.uniform = unifpdf(t,t(1),t(end));
hazard.uniform = unifpdf(t,t(1),t(end)) ./(1-unifcdf(t,t(1),t(end)));

% 
% dist.lognorm = lognpdf(t,mean_int,st_dev);
% hazard.lognorm =
% lognpdf(t,mean_int,st_dev)./(1-logncdf(t,mean_int,st_dev));


figure
subplot(4,3,1)
plot(t,dist.norm,'linewidth',2)
title('Gaussian PDF')

subplot(4,3,2)
plot(t,normcdf(t,mean_int,st_dev),'linewidth',2);
title('Gaussian CDF')

subplot(4,3,3)
plot(t,hazard.norm,'linewidth',2)
title('Gaussian Hazard')

subplot(4,3,4)
plot(t,dist.exp,'linewidth',2)
title('Exponential PDF')

subplot(4,3,5)
plot(t,expcdf(t,mean_int),'linewidth',2)
title('Exponential CDF')

subplot(4,3,6)
plot(t,hazard.exp,'linewidth',2)
title('Exponential Hazard')

subplot(4,3,7)
plot(t,dist.uniform,'linewidth',2)
title('Uniform PDF')

subplot(4,3,8)
plot(t,unifcdf(t,t(1),t(end)),'linewidth',2)
title('Uniform CDF')

subplot(4,3,9)
plot(t,hazard.uniform,'linewidth',2)
title('Uniform Hazard')