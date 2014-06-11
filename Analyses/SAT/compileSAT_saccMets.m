cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1] = textread('SAT_Beh_Med_Q.txt','%s');
% [filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
 [filename3] = textread('SAT_Beh_Med_S.txt','%s');
% [filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
% filename = [filename1 ; filename2 ; filename3 ; filename4];

filename = [filename3 ];



for file = 1:length(filename)
    
    load(filename{file},'EyeX_','EyeY_','Correct_','saccLoc','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_')
    filename{file}
    
    
    getTrials_SAT

    [PeakAmp PeakVel] = getMainSequence;
    
    allAmp.slow(file,1) = nanmean(PeakAmp(slow_all));
    allAmp.med(file,1) = nanmean(PeakAmp(med_all));
    allAmp.fast(file,1) = nanmean(PeakAmp(fast_all_withCleared));
    
    allVel.slow(file,1) = nanmean(PeakVel(slow_all));
    allVel.med(file,1) = nanmean(PeakVel(med_all));
    allVel.fast(file,1) = nanmean(PeakVel(fast_all_withCleared));
    
    file_list{file,1} = filename;
    
    keep filename file file_list all*
    
end


sems.Amp.slow = sem(allAmp.slow);
sems.Amp.med = sem(allAmp.med);
sems.Amp.fast = sem(allAmp.fast);

sems.Vel.slow = sem(allVel.slow);
sems.Vel.med = sem(allVel.med);
sems.Vel.fast = sem(allVel.fast);

figure
subplot(121)
bar(1:3,[nanmean(allAmp.slow) nanmean(allAmp.med) nanmean(allAmp.fast)])
hold on
errorbar(1:3,[nanmean(allAmp.slow) nanmean(allAmp.med) nanmean(allAmp.fast)],[sems.Amp.slow sems.Amp.med sems.Amp.fast],'xr');
set(gca,'fontsize',12,'fontweight','bold')
title('Saccade Amplitude (degrees)')
ylim([5 11])
box off

subplot(122)
bar(1:3,[nanmean(allVel.slow) nanmean(allVel.med) nanmean(allVel.fast)])
hold on
errorbar(1:3,[nanmean(allVel.slow) nanmean(allVel.med) nanmean(allVel.fast)],[sems.Vel.slow sems.Vel.med sems.Vel.fast],'xr');
ylim([300 600])
set(gca,'fontsize',12,'fontweight','bold')
title('Saccade Velocity (degrees/sec)')
box off
