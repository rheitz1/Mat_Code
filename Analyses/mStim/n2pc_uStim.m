%n2pc for uStim study
OL = AD03;
OR = AD02;

%remove trials with saturation
OL = fixClipped(OL);
OR = fixClipped(OR);

%baseline correct.  Window == [-100:0]
OL = baseline_correct(OL,[Target_(1,1)-100 Target_(1,1)]);
OR = baseline_correct(OR,[Target_(1,1)-100 Target_(1,1)]);



%truncate 20 ms before saccade
% OL = truncateAD_targ(OL,SRT,20);
% OR = truncateAD_targ(OR,SRT,20);

%use all left and right screen positions (i.e., not limiting to just
%positions 0 and 4)
contraCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);

contraCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);

contraCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);

contraCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);


% try set size 2 only
% contraCorrectOL_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% ipsiCorrectOL_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% 
% contraCorrectOR_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% ipsiCorrectOR_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% 
% contraCorrectOL_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% ipsiCorrectOL_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% 
% contraCorrectOR_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
% ipsiCorrectOR_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);



TDT.OL.stim = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
TDT.OR.stim = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
TDT.OL.nostim = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
TDT.OR.nostim = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);

%===============
% Plotting
fig
subplot(2,2,1)
plot(-3500:2500,nanmean(OL(contraCorrectOL_nostim,:)),'b',-3500:2500,nanmean(OL(ipsiCorrectOL_nostim,:)),'--b')
legend('Contra','Ipsi','location','northwest')
axis ij
xlim([-50 300])
vline(TDT.OL.nostim,'b')
fon
title(['OL No uStim TDT = ' mat2str(TDT.OL.nostim)])

subplot(2,2,2)
plot(-3500:2500,nanmean(OR(contraCorrectOR_nostim,:)),'b',-3500:2500,nanmean(OR(ipsiCorrectOR_nostim,:)),'--b')
axis ij
xlim([-50 300])
vline(TDT.OR.nostim,'b')
fon
title(['OR No uStim TDT = ' mat2str(TDT.OR.nostim)])

subplot(2,2,3)
plot(-3500:2500,nanmean(OL(contraCorrectOL_stim,:)),'r',-3500:2500,nanmean(OL(ipsiCorrectOL_stim,:)),'--r')
axis ij
xlim([-50 300])
vline(TDT.OL.stim,'r')
fon
title(['OL uStim TDT = ' mat2str(TDT.OL.stim)])

subplot(2,2,4)
plot(-3500:2500,nanmean(OR(contraCorrectOR_stim,:)),'r',-3500:2500,nanmean(OR(ipsiCorrectOR_stim,:)),'--r')
axis ij
xlim([-50 300])
vline(TDT.OR.stim,'r')
fon
title(['OR uStim TDT = ' mat2str(TDT.OR.stim)])