function [Burst_Contrast_all,Burst_Contrast_3grp] = reduceBursts(RFs,Target_,BurstStartTimes,BurstStartTimes_SI)

%function to pair and average burst onset times and contrast (CLUT color)
%values.  Runs on ALL TRIALS

%Called by 'LFP_allTrials'

%get range of contrast values
lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);
lum(1) = min(Target_(find(Target_(:,3) > 1),3));
lum(2) = max(Target_(find(Target_(:,3) > 1),3));
cut1 = min(Target_(find(Target_(:,3) > 1),3)) + lum_spacing;
cut2 = max(Target_(find(Target_(:,3) > 1),3)) - lum_spacing;

%EDITED 10/29/2007 to include ALL trials, not just correct
Lows = find(ismember(Target_(:,2),RFs) & Target_(:,3) < cut1 & Target_(:,3) > 1);
Mids = find(ismember(Target_(:,2),RFs) & Target_(:,3) >= cut1 & Target_(:,3) < cut2 & Target_(:,3) > 1);
Highs = find(ismember(Target_(:,2),RFs) & Target_(:,3) >= cut2 & Target_(:,3) > 1);




for n = 1:size(BurstStartTimes,1)
    %Get Vis Latencies by finding one with largest Surprise Index (SI)
    %VisLatency(n,1:length(find(BurstStartTimes_SI(n,:) == max(BurstStartTimes_SI(n,:))))) = BurstStartTimes(n,find(BurstStartTimes_SI(n,:) == max(BurstStartTimes_SI(n,:))));
    
    %Disregard highest SI; instead, just find first significant burst
    VisLatency(n,1) = BurstStartTimes(n,1);
end

Burst_Contrast = [];
index = 1;
for lum_val = lum(1):lum(2)
    if ~isempty(find(Target_(:,3) == lum_val & ismember(Target_(:,2),RFs)))
        Burst_Contrast_all(index,1) = lum_val;
        
        %Save median of burst onset times; Median probably more appropriate
        %than the mode here because of lower numbers of observations
        %INCLUDE ALL TRIALS, BUT LIMIT ONLY TO RF POSITIONS!
        
        %note: 'nanmedian' will still return NaN if there is nothing but
        %NaN's in the indexed arrays
        %Burst_Contrast(index,2) = nanmedian(BurstStartTimes(find(Target_(:,3) == lum_val & ismember(Target_(:,2),RFs)),1));
        Burst_Contrast_all(index,2) = nanmedian(nonzeros(VisLatency(find(Target_(:,3) == lum_val & ismember(Target_(:,2),RFs)),1)));
        index = index + 1;
    end
end

%Calculate mean burst onset times broken into low, med, and high contrast.
%This should be used to compare to the plotted SDFs to see how good a job
%we are doing at predicting onset latency.
Burst_Contrast_3grp(1,1) = nanmedian(nonzeros(VisLatency(Lows,1)));
Burst_Contrast_3grp(2,1) = nanmedian(nonzeros(VisLatency(Mids,1)));
Burst_Contrast_3grp(3,1) = nanmedian(nonzeros(VisLatency(Highs,1)));
