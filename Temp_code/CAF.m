% function to generate Conditional Accuracy Functions (CAFs) based on some
% criteria determined prior to function call (relevant_trials should hold
% this information)

% RPH


function [RT_bins,acc_bins] = CAF(relevant_trials,nBins,plotFlag)

if nargin < 2; plotFlag = 0; end

SRT = evalin('caller','SRT');
Correct_ = evalin('caller','Correct_');

relevant_trials = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100))';


RTs = SRT(relevant_trials,1);
accs = Correct_(relevant_trials,2);

%[RTs,index] = sort(RTs);

%compute intervals
%NOTE: this is a dirty way of accomplishing binning, and the last bin will
%not have the same number of observations as all the preceding bins!!!!
bin_step = 100 / nBins-1; %need to subtract 1 because the last bin is always the max value, which has an n of 1. So if you want 5 bins, you actually need 4 percentile scores

j = 1;
for i = bin_step:bin_step:100
    percentile_array(j) = prctile(RTs,i);
    j = j + 1;
end

%set up trials
RT_bins(1) = nanmean(RTs(find(RTs <= percentile_array(1)),1)); %do first bin manually
acc_bins(1) = nanmean(accs(find(RTs <= percentile_array(1)),1));
n_bins(1) = length(RTs(find(RTs <= percentile_array(1)),1));

for bin = 2:nBins-1
    RT_bins(bin) = nanmean(RTs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
    acc_bins(bin) = nanmean(accs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
    n_bins(bin) = length(RTs(find(RTs > percentile_array(bin-1) & RTs <= percentile_array(bin)),1));
    
end

RT_bins(nBins) = nanmean(RTs(find(RTs >= percentile_array(nBins-1)),1)); %do last bin manually
acc_bins(nBins) = nanmean(accs(find(RTs >= percentile_array(nBins-1)),1));
n_bins(nBins) = length(RTs(find(RTs >= percentile_array(nBins-1)),1));


if plotFlag == 1
    figure
    plot(RT_bins,acc_bins,'-ok')
    ylim([.5 1])
    box off
end


