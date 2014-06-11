cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_Vis_VisMove_targ



allslow = [allwf_targ.in.slow_correct_made_dead ; allwf_targ.out.slow_correct_made_dead];
allfast = [allwf_targ.in.fast_correct_made_dead_withCleared ; allwf_targ.out.fast_correct_made_dead_withCleared];
inslow = [allwf_targ.in.slow_correct_made_dead];
outslow = [allwf_targ.out.slow_correct_made_dead];
infast = [allwf_targ.in.fast_correct_made_dead_withCleared];
outfast = [allwf_targ.out.fast_correct_made_dead_withCleared];



%get Jack-Knifed TDTs
% using subset of time points so will run faster
[TDT t_obt p_obt ci df] = getJackKnife_TDT(0:300,inslow(:,100:400),outslow(:,100:400),infast(:,100:400),outfast(:,100:400),.05,0);



%for N2pcs that have NaN values, use only a subset of the time points for which we know we have data.
%Doesn't matter anyway because the onset time is very early
% Do the same thing here for LFPs for consistency; this will also make onset detection run faster. Also
% includes re-baseline correction
allslow_trunc = allslow(:,1:301);
allfast_trunc = allfast(:,1:301);

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
allslow = baseline_correct(allslow,[130 140]);
allfast = baseline_correct(allfast,[130 140]);
inslow = baseline_correct(inslow,[130 140]);
outslow = baseline_correct(outslow,[130 140]);
infast = baseline_correct(infast,[130 140]);
outfast = baseline_correct(outfast,[130 140]);

fig1
plot(-100:900,nanmean(inslow),'r',-100:900,nanmean(outslow),'m', ...
    -100:900,nanmean(infast),'g',-100:900,nanmean(outfast),'c', ...
    -100:900,nanmean(inslow)-sems.inslow,'--r',-100:900,nanmean(inslow)+sems.inslow,'--r', ...
    -100:900,nanmean(outslow)-sems.outslow,'--m',-100:900,nanmean(outslow)+sems.outslow,'--m', ...
    -100:900,nanmean(infast)-sems.infast,'--g',-100:900,nanmean(infast)+sems.infast,'--g', ...
    -100:900,nanmean(outfast)-sems.outfast,'--c',-100:900,nanmean(outfast)+sems.outfast,'--c')
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

%find times of significant differences between overall ACC and FAST conditions
parfor t = 1:size(allslow,2)
    [h(t) p(t)] = ttest(allslow(:,t),allfast(:,t));
end

newax
plot(-100:900,h,'k')
ylim([0 20])
xlim([-50 300])


%test magnitude in 2 time intervals
x = nanmean(inslow(:,150:155),2);
y = nanmean(infast(:,150:155),2);
[a b c d] = ttest(x,y)

fig4
hist(x-y,45)


x = nanmean(inslow(:,160:170),2);
y = nanmean(infast(:,160:170),2);
[a b c d] = ttest(x,y)

