cd /volumes/Dump/Analyses/SAT/LFP/

ws quit

load LFP_vis_Q

renvar allwf_targ allwf_targ1

ws 2
load LFP_vis_S
renvar allwf_targ allwf_targ2

ws send [1] allwf_targ2

ws 1
ws quit




allslow = [allwf_targ1.all.slow_all ; allwf_targ2.all.slow_all];
allfast = [allwf_targ1.all.fast_all_withCleared ; allwf_targ2.all.fast_all_withCleared];
inslow = [allwf_targ1.in.slow_correct_made_dead ; allwf_targ2.in.slow_correct_made_dead];
outslow = [allwf_targ1.out.slow_correct_made_dead ; allwf_targ2.out.slow_correct_made_dead];
infast = [allwf_targ1.in.fast_correct_made_dead_withCleared ; allwf_targ2.in.fast_correct_made_dead_withCleared];
outfast = [allwf_targ1.out.fast_correct_made_dead_withCleared ; allwf_targ2.out.fast_correct_made_dead_withCleared];



%get Jack-Knifed TDTs
% using subset of time points so will run faster
[TDT t_obt p_obt ci df] = getJackKnife_TDT(0:1000,inslow(:,3500:4500),outslow(:,3500:4500),infast(:,3500:4500),outfast(:,3500:4500),.0005,0);



%for N2pcs that have NaN values, use only a subset of the time points for which we know we have data.
%Doesn't matter anyway because the onset time is very early
% Do the same thing here for LFPs for consistency; this will also make onset detection run faster. Also
% includes re-baseline correction
allslow_trunc = allslow(:,3400:3700);
allfast_trunc = allfast(:,3400:3700);

%re-baseline correct for most accurate measurement
allslow_trunc = baseline_correct(allslow_trunc,[1 3]);
allfast_trunc = baseline_correct(allfast_trunc,[1 3]);
[onset_time t_obt p_obt ci] = getJackKnife_onset(-100:200,allslow_trunc,allfast_trunc,'wilcoxon',.0001,0)



sems.allslow = sem(allslow);
sems.allfast = sem(allfast);
sems.inslow = sem(inslow);
sems.outslow = sem(outslow);
sems.infast = sem(infast);
sems.outfast = sem(outfast);


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

%mark mean RTs to cut off at
vline(614,'-.r')
vline(271,'-.g')

title(['Onset = ' mat2str(onset_time.dat1) '   ' mat2str(onset_time.dat2) 'TDT = ' mat2str(TDT(1)) '  ' mat2str(TDT(2))])

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

