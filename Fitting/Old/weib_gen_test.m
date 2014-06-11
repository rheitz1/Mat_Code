% generate a set of numbers sampled from a Weibull distribution

% n = number of trials.  Needed to create predicted frequency distribution.
n = 100000;

scale = .2;
shape = 2;


y = wblrnd(scale,shape,1,n);

% make 10 frequency bins for testing
[obs,bins] = hist(y,10);

obs_CDF = cumsum(obs) ./ length(y);

% obs_freq = hist(y,bins);
% 
% obs_cum_freq = cumsum(obs_freq);

obs_cum_freq = obs_CDF*n;
% This is our 'empirical' distribution.  Now lets try to fit a Weibull to it.

% First lets generate a weibull with an initial guess.


scale_initGuess = .2;
shape_initGuess = 2;

%send initial guesses to WeibFitTest and minimize chi-square
solution = fminsearch(@(param_input) WeibFitTest(param_input,obs_cum_freq,bins,n),[scale_initGuess ; shape_initGuess],['Display','iter'])






%Final = wblcdf(bins,solution(1),solution(2));
Final = wblcdf(bins,scale_initGuess,shape_initGuess)*n;

%generate plot.
%make circles represent the quantiles of the fake observed distribution and the lines the best fit
%weibull


plot(bins,obs_cum_freq,'or',bins,Final,'r')