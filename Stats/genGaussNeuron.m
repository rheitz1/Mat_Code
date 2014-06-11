%Generate Poisson neuron with n trials and given spike rate.  From
%Shadlen's CHSL demonstration code

function [GaussNeuron] = genGaussNeuron(ntrials,max_spike_time,spike_mu,spike_sd)

if nargin < 4; spike_sd = 50; end
if nargin < 3; spike_mu = 100; end
if nargin < 2; max_spike_time = 1000; end
if nargin < 1; ntrials = 100; end

nSpikes = 1000; %number of spikes/trial before lopping off values larger than of interest

meanint = 1000 / spike_mu;     % mean interspike interval (ms)
meansd = 1000 / spike_sd;
intervals = normrnd(meanint,meansd,ntrials,nSpikes);

% Now we add up the interspike intervals to find the arrival time
% of each spike.  
arrivals = cumsum(intervals,2);
arrivals(arrivals>max_spike_time) = NaN;


GaussNeuron = round(arrivals);