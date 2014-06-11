%compares SDFs computed on a trial-by-trial basis, averaged, versus a
%single histogram convolved with the PSP filter.

%hard-coded spike channels

Align_Time = Target_(:,1);
Plot_Time = [-200 800];
spike = DSP04a;


for n = 1:size(spike,1)
    temp = spikeDensityfunction_singletrial(spike(n,:), 500, Plot_Time);
    SDF_singletrial(n,1:length(temp)) = temp;
    temp = [];
end

triallist = 1:size(spike,1);
SDF_all = spikedensityfunct_lgn_old(spike, Align_Time, Plot_Time, triallist, TrialStart_);