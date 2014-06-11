cd /volumes/Dump/Analyses/SAT/N2pc/

ws quit

load Q_SAT_n2pc_OL

renvar allwf_targ allwf_targ1

ws 2
load Q_SAT_n2pc_OR
renvar allwf_targ allwf_targ2

ws 3
load S_SAT_n2pc_OR
renvar allwf_targ allwf_targ3

ws send [1] allwf_targ3

ws 2
ws send [1] allwf_targ2

ws 1
ws quit




allslow = [allwf_targ1.all.slow_all ; allwf_targ2.all.slow_all ; allwf_targ3.all.slow_all];
allfast = [allwf_targ1.all.fast_all_withCleared ; allwf_targ2.all.fast_all_withCleared ; allwf_targ3.all.fast_all_withCleared];
inslow = [allwf_targ1.in.slow_correct_made_dead ; allwf_targ2.in.slow_correct_made_dead ; allwf_targ3.in.slow_correct_made_dead];
outslow = [allwf_targ1.out.slow_correct_made_dead ; allwf_targ2.out.slow_correct_made_dead ; allwf_targ3.out.slow_correct_made_dead];
infast = [allwf_targ1.in.fast_correct_made_dead_withCleared ; allwf_targ2.in.fast_correct_made_dead_withCleared ; allwf_targ3.in.fast_correct_made_dead_withCleared];
outfast = [allwf_targ1.out.fast_correct_made_dead_withCleared ; allwf_targ2.out.fast_correct_made_dead_withCleared ; allwf_targ3.out.fast_correct_made_dead_withCleared];


%NaN out the sessions with missing signals (will all be 0.  messes with variability and SEMs)
allslow(find(~allslow(:,1)),:) = NaN;
allfast(find(~allfast(:,1)),:) = NaN;
inslow(find(~inslow(:,1)),:) = NaN;
outslow(find(~outslow(:,1)),:) = NaN;
infast(find(~infast(:,1)),:) = NaN;
outfast(find(~outfast(:,1)),:) = NaN;


% allslow_filt = filtSig(nanmean(allslow),50,'lowpass');
% allfast_filt = filtSig(nanmean(allfast),50,'lowpass');
% inslow_filt = filtSig(nanmean(inslow),50,'lowpass');
% outslow_filt = filtSig(nanmean(outslow),50,'lowpass');
% infast_filt = filtSig(nanmean(infast),50,'lowpass');
% outfast_filt = filtSig(nanmean(outfast),50,'lowpass');
% 


%get Jack-Knifed TDTs

[TDT t_obt p_obt ci df] = getJackKnife_TDT(0:1000,inslow(:,3500:4500),outslow(:,3500:4500),infast(:,3500:4500),outfast(:,3500:4500),.05,0);
axis ij


% % % %for N2pcs that have NaN values, use only a subset of the time points for which we know we have data.
% % % %Doesn't matter anyway because the onset time is very early
% % % allslow_trunc = allslow(:,3530:3700);
% % % allfast_trunc = allfast(:,3530:3700);
% % % 
% % % %re-baseline correct for most accurate measurement
% % % allslow_trunc = baseline_correct(allslow_trunc,[1 3]);
% % % allfast_trunc = baseline_correct(allfast_trunc,[1 3]);
% % % [onset_time t_obt p_obt ci] = getJackKnife_onset(30:200,allslow_trunc,allfast_trunc,'wilcoxon',.05)

%for N2pcs that have NaN values, use only a subset of the time points for which we know we have data.
%Doesn't matter anyway because the onset time is very early
allslow_trunc = allslow(:,3400:3700);
allfast_trunc = allfast(:,3400:3700);

%re-baseline correct for most accurate measurement
allslow_trunc = baseline_correct(allslow_trunc,[1 3]);
allfast_trunc = baseline_correct(allfast_trunc,[1 3]);
[onset_time t_obt p_obt ci] = getJackKnife_onset(-100:200,allslow_trunc,allfast_trunc,'wilcoxon',.05,0)


% DO ROC




%compute SEMs manually because helper function removes NaNs
sems.allslow = nanstd(allslow) ./ sqrt(size(allslow,1));
sems.allfast = nanstd(allfast) ./ sqrt(size(allfast,1));
sems.inslow = nanstd(inslow) ./ sqrt(size(inslow,1));
sems.outslow = nanstd(outslow) ./ sqrt(size(outslow,1));
sems.infast = nanstd(infast) ./ sqrt(size(infast,1));
sems.outfast = nanstd(outfast) ./ sqrt(size(outfast,1));


%re-baseline correct again for plotting
allslow = baseline_correct(allslow,[3530 3532]);
allfast = baseline_correct(allfast,[3530 3532]);
inslow = baseline_correct(inslow,[3530 3532]);
outslow = baseline_correct(outslow,[3530 3532]);
infast = baseline_correct(infast,[3530 3532]);
outfast = baseline_correct(outfast,[3530 3532]);


fig1
plot(-3500:2500,nanmean(inslow),'r',-3500:2500,nanmean(outslow),'m', ...
    -3500:2500,nanmean(infast),'g',-3500:2500,nanmean(outfast),'c', ...
    -3500:2500,nanmean(inslow)-sems.inslow,'--r',-3500:2500,nanmean(inslow)+sems.inslow,'--r', ...
    -3500:2500,nanmean(outslow)-sems.outslow,'--m',-3500:2500,nanmean(outslow)+sems.outslow,'--m', ...
    -3500:2500,nanmean(infast)-sems.infast,'--g',-3500:2500,nanmean(infast)+sems.infast,'--g', ...
    -3500:2500,nanmean(outfast)-sems.outfast,'--c',-3500:2500,nanmean(outfast)+sems.outfast,'--c')
axis ij
xlim([-50 300])
box off
vline(TDT(1),'r')
vline(TDT(2),'g')
vline(onset_time.dat1,'r')
vline(onset_time.dat2,'g')
title(['Onset = ' mat2str(onset_time.dat1) '   ' mat2str(onset_time.dat2) 'TDT = ' mat2str(TDT(1)) '  ' mat2str(TDT(2))])

%mark mean RTs to cut off at
vline(614,'-.r')
vline(271,'-.g')


parfor t = 1:size(allslow,2)
    [h(t) p(t)] = ttest(allslow(:,t),allfast(:,t));
end

newax
plot(-3500:2500,h,'k')
ylim([0 20])
xlim([-50 300])





%test magnitude in 2 time intervals
x = nanmean(inslow(:,3550:3555),2);
y = nanmean(infast(:,3550:3555),2);
[a b c d] = ttest(x,y)

fig4
hist(x-y,45)

x = nanmean(inslow(:,3560:3570),2);
y = nanmean(infast(:,3560:3570),2);
[a b c d] = ttest(x,y)

%find times of significant differences between overall ACC and FAST conditions
