%simulates spike train using a PSTH generated from a real spike train.
%RPH

function [sSpike] = simSpike(Spike)

Target_ = evalin('caller','Target_');

Plot_Time = [-500 2500];

%correct Spike times for Search data with 500 ms baseline.  Necessary for
%Spike = Spike channel
%Plot_Time = window to calculate PSTH on

%change 0's to NaN
Spike(find(Spike == 0)) = NaN;

%Spike = Spike - 500;

%keep Spike values within desired window
Spikevec = Spike(find(Spike >= Plot_Time(1)+Target_(1,1) & Spike <= Plot_Time(2)+Target_(1,1)));


%generate PSTH
BinCenters = Plot_Time(1)+Target_(1,1):Plot_Time(2)+Target_(1,1);
[spCount spTime] = hist(Spikevec,BinCenters);

%probability for each bin is probability of finding a spike there out of
%total number of trials where a spike could have occurred
spikeProb = spCount / size(Spike,1);

%Binomial correction
%looking for 1 success out of 1 sample with base rate probability p
%Thus binomial reduces from nCr*p^r*(1-p)^(1-r)
% essentially this reduces to just p because:
%1 * p^1 * (1-p)^n-r  ==  1 * p * 1

%generate same number of trials as Spikes sent in
%sSpike(1:size(Spike,1),1:length(Plot_Time(1):Plot_Time(2))) = NaN;

%generate matrix of random numbers same size as sSpike
randmat = rand(size(Spike,1),length(Plot_Time(1):Plot_Time(2)));

%fill in prob matrix
spikeProb = repmat(spikeProb,size(Spike,1),1);

%create logical matrix if random number less than or equal to base rate
%probability

spikemat = randmat <= spikeProb;

%convert to times

sSpike = zeros(size(Spike,1),length(Plot_Time(1):Plot_Time(2)));

for trl = 1:size(spikemat,1)
    sSpike(trl,1:length(find(spikemat(trl,:)))) = find(spikemat(trl,:));
end