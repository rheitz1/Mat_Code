%Weibull fminsearch test
function [xi] = WeibFitTest(param_input,obs_cum_freq,bins,n)%,intensity,responses)
%param1 = scale
%param2 = shape


%decode parameters
scale_initGuess = param_input(1)
shape_initGuess = param_input(2)


%get the variables we need to calculate chi-square.  I suppose there is a way to avoid this problem.
pred_cum_freq = wblcdf(bins,scale_initGuess,shape_initGuess) * n;

%compute chi-square

xi = sum( ((obs_cum_freq - pred_cum_freq).^2) ./pred_cum_freq )








% 
% results.response = evalin('base','results.response');
% results.intensity = evalin('base','results.intensity');
% 
% params.t = param_input(1);
% params.b = param_input(2);
% y = Weibull(params,results.intensity);
% 
% 
% 
% li = prod(y.^results.response .* ((1-y).^(1-results.response)));
% 
% y2 = y*.99 + .005;
% lli = -sum(results.response.* log(y2) + ((1-results.response).* log(1-y2)));
% 
