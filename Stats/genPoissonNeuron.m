%Generate Poisson neuron with n trials and given spike rate.  From
%Shadlen's CHSL demonstration code

function [poissNeuron] = genPoissonNeuron(nTrials,max_spike_time,spike_rate)

if nargin < 3; spike_rate = 100; end
if nargin < 2; max_spike_time = 1000; end
if nargin < 1; nTrials = 100; end

nSpikes = 1000; %number of spikes/trial before lopping off values larger than of interest

meanint = 1000 / spike_rate;     % mean interspike interval (ms)
intervals = exprnd(meanint,nTrials,nSpikes);  %use ceil to avoid intervals of 0

% Now we add up the interspike intervals to find the arrival time
% of each spike.  
arrivals = round(cumsum(intervals,2));
arrivals(arrivals>max_spike_time) = NaN;


poissNeuron = arrivals;


