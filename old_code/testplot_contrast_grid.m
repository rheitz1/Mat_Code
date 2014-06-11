% for x = 0:7
%     subplot(3,3,x+1)
%     lowspikes_a = DSP04a(find(Target_(:,3) < lowQ & Target_(:,2) == x),:);
%     triallist_a_low = length(lowspikes_a(:,1));
%     [SDF_a_low] = spikedensityfunct_contrast(lowspikes_a, Align_Time_, Plot_Time, triallist_a_low, TrialStart_);
%     plot(SDF_a_low)
% end

for x = 0:7
    subplot(3,3,x+1)
    lowspikes_a = DSP04a(find(Target_(:,2) == x),:);
    triallist_a_low = length(DSP04c(:,1));
    [SDF_a_low] = spikedensityfunct_contrast(DSP04c, Align_Time_, Plot_Time, triallist_a_low, TrialStart_);
    plot(SDF_a_low)

end