

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate
Align_Time = Target_(:,1);
Plot_Time = [-200 2000];
%initiate SDF_all
SDF_all(1:length(DSP10b),1:(abs(SDFPlot_Time(1)) + abs(SDFPlot_Time(2)))) = 0;
%calculate SDF matrix, trial-by-trial
for n = 1:length(DSP10b)
    curr_SDF = spikeDensityfunction_singletrial(DSP10b(n,:),Align_Time(n,1),Plot_Time);
    SDF_all(n,1:length(curr_SDF)) = curr_SDF;
end

