%creates bar chart for threshold values between and within conditions for MOVEMENT CELLS only

%cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
%load compileSAT_Med_NoMed_Move_resp_longBase


sl.all = nanmean(allwf_move.in.slow_correct_made_dead(:,2480:2490),2);
sl.binSLOW = nanmean(allwf_move.in.slow_correct_made_dead_binSLOW(:,2480:2490),2);
sl.binMED = nanmean(allwf_move.in.slow_correct_made_dead_binMED(:,2480:2490),2);
sl.binFAST = nanmean(allwf_move.in.slow_correct_made_dead_binFAST(:,2480:2490),2);

md.all = nanmean(allwf_move.in.med_correct(:,2480:2490),2);
md.binSLOW = nanmean(allwf_move.in.med_correct_binSLOW(:,2480:2490),2);
md.binMED = nanmean(allwf_move.in.med_correct_binMED(:,2480:2490),2);
md.binFAST = nanmean(allwf_move.in.med_correct_binFAST(:,2480:2490),2);

fs.all = nanmean(allwf_move.in.fast_correct_made_dead_withCleared(:,2480:2490),2);
fs.binSLOW = nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binSLOW(:,2480:2490),2);
fs.binMED = nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binMED(:,2480:2490),2);
fs.binFAST = nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binFAST(:,2480:2490),2);


sems.sl.all = sem(sl.all);
sems.sl.binSLOW = sem(sl.binSLOW);
sems.sl.binMED = sem(sl.binMED);
sems.sl.binFAST = sem(sl.binFAST);

sems.md.all = sem(md.all);
sems.md.binSLOW = sem(md.binSLOW);
sems.md.binMED = sem(md.binMED);
sems.md.binFAST = sem(md.binFAST);

sems.fs.all = sem(fs.all);
sems.fs.binSLOW = sem(fs.binSLOW);
sems.fs.binMED = sem(fs.binMED);
sems.fs.binFAST = sem(fs.binFAST);


figure
subplot(221)
errorbar(1:4,[nanmean(sl.binSLOW) nanmean(sl.binMED) nanmean(sl.binFAST) nanmean(sl.all)], ...
    [sems.sl.binSLOW sems.sl.binMED sems.sl.binFAST sems.sl.all],'-sr')

hold on
errorbar(1:4,[nanmean(md.binSLOW) nanmean(md.binMED) nanmean(md.binFAST) nanmean(md.all)], ...
    [sems.md.binSLOW sems.md.binMED sems.md.binFAST sems.md.all],'-sk')

errorbar(1:4,[nanmean(fs.binSLOW) nanmean(fs.binMED) nanmean(fs.binFAST) nanmean(fs.all)], ...
    [sems.fs.binSLOW sems.fs.binMED sems.fs.binFAST sems.fs.all],'-sg')
    

ylim([.4 1.4])
box off