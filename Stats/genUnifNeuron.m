%Generate Uniformly distributed neuron with n trials and given spike rate.  

function [UnifNeuron] = genUnifNeuron(ntrials,max_spike_time,spike_rate)

if nargin < 3; spike_rate = 100; end
if nargin < 2; max_spike_time = 1000; end
if nargin < 1; ntrials = 100; end

nSpikes = 1000; %number of spikes/trial before lopping off values larger than of interest

meanint = 1000 / spike_rate;     % mean interspike interval (ms)
intervals = unifrnd(0,meanint,ntrials,nSpikes);

% Now we add up the interspike intervals to find the arrival time
% of each spike.  
arrivals = cumsum(intervals,2);
arrivals(arrivals>max_spike_time) = NaN;


UnifNeuron = round(arrivals);