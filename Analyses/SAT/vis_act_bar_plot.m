%creates bar chart for vis activity and within conditions for visually-responsive cells

%cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
%load('/Volumes/Dump/Analyses/SAT/compileSAT_Med_NoMed_Vis_VisMove_targ.mat')

%_1 = 100:125 post array onset
%_2 = 250:300 post array onset

sl_1 = nanmean(allwf_targ.in.slow_correct_made_dead(:,200:225),2);
md_1 = nanmean(allwf_targ.in.med_correct(:,200:225),2);
fs_1 = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,200:225),2);
sl_2 = nanmean(allwf_targ.in.slow_correct_made_dead(:,350:400),2);
md_2 = nanmean(allwf_targ.in.med_correct(:,350:400),2);
fs_2 = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,350:400),2);

sems.sl_1 = sem(sl_1);
sems.md_1 = sem(md_1);
sems.fs_1 = sem(fs_1);

sems.sl_2 = sem(sl_2);
sems.md_2 = sem(md_2);
sems.fs_2 = sem(fs_2);


figure
subplot(221)
errorbar(1:3,[nanmean(sl_1) nanmean(md_1) nanmean(fs_1)],[sems.sl_1 sems.md_1 sems.fs_1])
box off
ylim([.4 1.1])

subplot(222)
errorbar(1:3,[nanmean(sl_2) nanmean(md_2) nanmean(fs_2)],[sems.sl_2 sems.md_2 sems.fs_2])
ylim([.4 1.1])

box off