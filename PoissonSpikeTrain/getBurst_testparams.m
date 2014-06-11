function [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst(TotalSpikes,minSpks,anchor,sig)
%Poisson Burst test script
%Calls P_BURST
%Called by Contrast_sensitivity_batch_allTrials

%Richard P. Heitz
%10/31/07

maxBurstSearchWindow = 200;

BurstBegin(1:size(TotalSpikes,1),1:1000) = NaN;
BurstEnd(1:size(TotalSpikes,1),1:1000) = NaN;
BurstSurprise(1:size(TotalSpikes,1),1:1000) = NaN;

%Edit down spikes to eliminate spikes after a cutoff time.  Excessive
%spikes leads to Matlab hanging, and we're only interested in the first
%burst anyway.  11/13/07 RPH
% set spike times over 5000 ms to 0.

%BUT, this will affect measure of MU, so maybe not good idea
%TotalSpikes(find(TotalSpikes > 5000)) = 0;


for n = 1:size(TotalSpikes,1)
    %Note: sending min and max of entire spike train per Hanes et al.
    %(1995); want to calculate MU from entire train
    [BOB,EOB,SOB] = P_BURST_testparams(nonzeros(TotalSpikes(n,:)),min(nonzeros(TotalSpikes(n,:))),max(nonzeros(TotalSpikes(n,:))),minSpks,anchor,sig);
    n
    BurstBegin(n,1:length(BOB)) = BOB;
    BurstEnd(n,1:length(EOB)) = EOB;
    BurstSurprise(n,1:length(SOB)) = SOB;
end

for n = 1:size(TotalSpikes,1)
    if ~isnan(BurstBegin(n,1))
        temp = TotalSpikes(n,BurstBegin(n,~isnan(BurstBegin(n,:)))) - 500;
        if ~isempty(find(temp > 0 & temp <= maxBurstSearchWindow))
            BurstStartTimes(n,1:length(find(temp > 0 & temp <= maxBurstSearchWindow))) = temp(find(temp > 0 & temp <= maxBurstSearchWindow));
        else
            BurstStartTimes(n,1) = NaN;

        end
    else
        %correction for low firing rate cells: final index will fail
        if n == size(TotalSpikes,1)
            BurstStartTimes(n,1) = NaN;
        end
    end
end
