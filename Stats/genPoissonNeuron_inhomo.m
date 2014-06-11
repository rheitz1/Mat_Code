% Generate inhomogeneous Poisson neuron with n trials and given spike rate.  
% Should produce a Fano Factor > 1
function [poissNeuron] = genPoissonNeuron_inhomo(nTrials,max_spike_time,spike_rate,spike_rate_sd)

if nargin < 4; spike_rate_sd = 10; end
if nargin < 3; spike_rate = 100; end
if nargin < 2; max_spike_time = 1000; end
if nargin < 1; nTrials = 100; end

nSpikes = 1000; %number of spikes/trial before lopping off values larger than of interest

meanint = 1000 / spike_rate;     % mean interspike interval (ms)



rates = 1000 ./ normrnd(spike_rate,spike_rate_sd,nTrials,nSpikes);

intervals = exprnd(rates);

% intervals = exprnd(meanint,ntrials,nSpikes);
% 
% % Now we add up the interspike intervals to find the arrival time
% % of each spike.  
arrivals = round(cumsum(intervals,2));
arrivals(arrivals>max_spike_time) = NaN;
% 
% 
poissNeuron = arrivals;