% correct.stim.left = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]));
% correct.stim.right = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]));
% all_stim_left = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]));
% all_stim_right = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]));
% 
% acc.stim_left = length(correct.stim.left) / length(all_stim_left);
% acc.stim_right = length(correct.stim.right) / length(all_stim_right);
% 
% correct.nostim.left = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]));
% correct.nostim.right = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]));
% all_nostim_left = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]));
% all_nostim_right = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]));
% 
% acc.nostim_left = length(correct.nostim.left) / length(all_nostim_left);
% acc.nostim_right = length(correct.nostim.right) / length(all_nostim_right);


% allstim = find(~isnan(MStim_(:,1)) & ~ismember(Target_(:,2),[2 6]));
% allnostim = find(isnan(MStim_(:,1)) & ~ismember(Target_(:,2),[2 6]));

% 
% acc.left_subset_stim = length(correct.stim.left) / length(allstim);
% acc.right_subset_stim = length(correct.stim.right) / length(allstim);
% 
% acc.left_subset_nostim = length(correct.nostim.left) / length(allnostim);
% acc.right_subset_nostim = length(correct.nostim.right) / length(allnostim);
% 
% 
% 
% acc.left_full_stim = length(correct.stim.left) / length(~ismember(Target_(:,2),[2 6]));
% acc.right_full_stim = length(correct.stim.right) / length(~ismember(Target_(:,2),[2 6]));
% 
% acc.left_full_nostim = length(correct.nostim.left) / length(~ismember(Target_(:,2),[2 6]));
% acc.right_full_nostim = length(correct.nostim.right) / length(~ismember(Target_(:,2),[2 6]));


% Find accuracy rates by screen position and stim/nostim

trls.correct0 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),0));
trls.correct1 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),1));
trls.correct2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),2));
trls.correct3 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),3));
trls.correct4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),4));
trls.correct5 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),5));
trls.correct6 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),6));
trls.correct7 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),7));

trls.all0 = find(ismember(Target_(:,2),0));
trls.all1 = find(ismember(Target_(:,2),1));
trls.all2 = find(ismember(Target_(:,2),2));
trls.all3 = find(ismember(Target_(:,2),3));
trls.all4 = find(ismember(Target_(:,2),4));
trls.all5 = find(ismember(Target_(:,2),5));
trls.all6 = find(ismember(Target_(:,2),6));
trls.all7 = find(ismember(Target_(:,2),7));

trls.stim = find(~isnan(MStim_(:,1)));
trls.nostim = find(isnan(MStim_(:,1)));


acc.all(1) = length(trls.correct0) / length(trls.all0);
acc.all(2) = length(trls.correct1) / length(trls.all1);
acc.all(3) = length(trls.correct2) / length(trls.all2);
acc.all(4) = length(trls.correct3) / length(trls.all3);
acc.all(5) = length(trls.correct4) / length(trls.all4);
acc.all(6) = length(trls.correct5) / length(trls.all5);
acc.all(7) = length(trls.correct6) / length(trls.all6);
acc.all(8) = length(trls.correct7) / length(trls.all7);

acc.stim(1) = length(intersect(trls.correct0,trls.stim)) / length(intersect(trls.all0,trls.stim));
acc.stim(2) = length(intersect(trls.correct1,trls.stim)) / length(intersect(trls.all1,trls.stim));
acc.stim(3) = length(intersect(trls.correct2,trls.stim)) / length(intersect(trls.all2,trls.stim));
acc.stim(4) = length(intersect(trls.correct3,trls.stim)) / length(intersect(trls.all3,trls.stim));
acc.stim(5) = length(intersect(trls.correct4,trls.stim)) / length(intersect(trls.all4,trls.stim));
acc.stim(6) = length(intersect(trls.correct5,trls.stim)) / length(intersect(trls.all5,trls.stim));
acc.stim(7) = length(intersect(trls.correct6,trls.stim)) / length(intersect(trls.all6,trls.stim));
acc.stim(8) = length(intersect(trls.correct7,trls.stim)) / length(intersect(trls.all7,trls.stim));

acc.nostim(1) = length(intersect(trls.correct0,trls.nostim)) / length(intersect(trls.all0,trls.nostim));
acc.nostim(2) = length(intersect(trls.correct1,trls.nostim)) / length(intersect(trls.all1,trls.nostim));
acc.nostim(3) = length(intersect(trls.correct2,trls.nostim)) / length(intersect(trls.all2,trls.nostim));
acc.nostim(4) = length(intersect(trls.correct3,trls.nostim)) / length(intersect(trls.all3,trls.nostim));
acc.nostim(5) = length(intersect(trls.correct4,trls.nostim)) / length(intersect(trls.all4,trls.nostim));
acc.nostim(6) = length(intersect(trls.correct5,trls.nostim)) / length(intersect(trls.all5,trls.nostim));
acc.nostim(7) = length(intersect(trls.correct6,trls.nostim)) / length(intersect(trls.all6,trls.nostim));
acc.nostim(8) = length(intersect(trls.correct7,trls.nostim)) / length(intersect(trls.all7,trls.nostim));

rt.correct.all(1) = nanmean(SRT(trls.correct0,1));
rt.correct.all(2) = nanmean(SRT(trls.correct1,1));
rt.correct.all(3) = nanmean(SRT(trls.correct2,1));
rt.correct.all(4) = nanmean(SRT(trls.correct3,1));
rt.correct.all(5) = nanmean(SRT(trls.correct4,1));
rt.correct.all(6) = nanmean(SRT(trls.correct5,1));
rt.correct.all(7) = nanmean(SRT(trls.correct6,1));
rt.correct.all(8) = nanmean(SRT(trls.correct7,1));

rt.correct.stim(1) = nanmean(SRT(intersect(trls.correct0,trls.stim),1));
rt.correct.stim(2) = nanmean(SRT(intersect(trls.correct1,trls.stim),1));
rt.correct.stim(3) = nanmean(SRT(intersect(trls.correct2,trls.stim),1));
rt.correct.stim(4) = nanmean(SRT(intersect(trls.correct3,trls.stim),1));
rt.correct.stim(5) = nanmean(SRT(intersect(trls.correct4,trls.stim),1));
rt.correct.stim(6) = nanmean(SRT(intersect(trls.correct5,trls.stim),1));
rt.correct.stim(7) = nanmean(SRT(intersect(trls.correct6,trls.stim),1));
rt.correct.stim(8) = nanmean(SRT(intersect(trls.correct7,trls.stim),1));

rt.correct.nostim(1) = nanmean(SRT(intersect(trls.correct0,trls.nostim),1));
rt.correct.nostim(2) = nanmean(SRT(intersect(trls.correct1,trls.nostim),1));
rt.correct.nostim(3) = nanmean(SRT(intersect(trls.correct2,trls.nostim),1));
rt.correct.nostim(4) = nanmean(SRT(intersect(trls.correct3,trls.nostim),1));
rt.correct.nostim(5) = nanmean(SRT(intersect(trls.correct4,trls.nostim),1));
rt.correct.nostim(6) = nanmean(SRT(intersect(trls.correct5,trls.nostim),1));
rt.correct.nostim(7) = nanmean(SRT(intersect(trls.correct6,trls.nostim),1));
rt.correct.nostim(8) = nanmean(SRT(intersect(trls.correct7,trls.nostim),1));


figure
subplot(2,1,1)
plot(0:7,acc.all,'k',0:7,acc.stim,'r',0:7,acc.nostim,'b')
box off
xlim([-.8 7.3])
title('Accuracy Rates')


subplot(2,1,2)
plot(0:7,rt.correct.all,'k',0:7,rt.correct.stim,'r',0:7,rt.correct.nostim,'b')
box off
xlim([-.8 7.3])
title('Correct RTs')