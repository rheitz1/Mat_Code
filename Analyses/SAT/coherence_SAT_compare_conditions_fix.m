sigOnly_freqrange = [30 60];
sigOnly_timerange = [0 750];

targFreq = find(f>=sigOnly_freqrange(1) & f<=sigOnly_freqrange(2));

targFreq5 = find(f <= 5);
targFreq10 = find(f > 5 & f <= 10);
targFreq15 = find(f > 10 & f <= 15);
targFreq20 = find(f > 15 & f <= 20);
targFreq25 = find(f > 20 & f <= 25);
targFreq30 = find(f > 25 & f <= 30);
targFreq35 = find(f > 30 & f <= 35);
targFreq40 = find(f > 35 & f <= 40);
targFreq45 = find(f > 40 & f <= 45);
targFreq50 = find(f > 45 & f <= 50);
targFreq55 = find(f > 50 & f <= 55);
targFreq60 = find(f > 55 & f <= 60);
targFreq65 = find(f > 60 & f <= 65);
targFreq70 = find(f > 65 & f <= 70);
targFreq75 = find(f > 70 & f <= 75);
targFreq80 = find(f > 75 & f <= 80);

targTime = find(tout_fix>=sigOnly_timerange(1) & tout_fix<=sigOnly_timerange(2));

% targFreq_shuff = find(f_shuff>=sigOnly_freqrange(1) & f_shuff<=sigOnly_freqrange(2));
% targTime_shuff = find(tout_fix_shuff>=sigOnly_timerange(1) & tout_fix_shuff<=sigOnly_timerange(2));

d = abs(coh_all_fix.fast) - abs(coh_all_fix.slow);
d = nanmean(d,3);

sl = nanmean(abs(coh_all_fix.slow(:,targFreq,:)),2);
sl = squeeze(sl);

fs = nanmean(abs(coh_all_fix.fast(:,targFreq,:)),2);
fs = squeeze(fs);


sl = nanmean(sl(targTime,:),1);
fs = nanmean(fs(targTime,:),1);

%[a b] = ttest(d,0)

[a b] = ttest(sl,fs)

fig
scatter(sl,fs)
dline

fig1
imagesc(tout_fix,f,d')
axis xy
colorbar
set(gca,'clim',[-.03 .03])
xlim(sigOnly_timerange)


% pos = find(issig_all.dir == 1);
% neg = find(issig_all.dir == -1);
% not = find(issig_all.dir == 0);
% 
% sl_sigpos = coh_all_fix.slow(:,:,pos);
% sl_sigpos_av = nanmean(abs(sl_sigpos(:,targFreq,:)),2);
% sl_sigpos_av = squeeze(sl_sigpos_av);
% sl_sigpos_av = nanmean(sl_sigpos_av(targTime,:),1);
% 
% fs_sigpos = coh_all_fix.fast(:,:,pos);
% fs_sigpos_av = nanmean(abs(fs_sigpos(:,targFreq,:)),2);
% fs_sigpos_av = squeeze(fs_sigpos_av);
% fs_sigpos_av = nanmean(fs_sigpos_av(targTime,:),1);
% 
% sl_signeg = coh_all_fix.slow(:,:,neg);
% sl_signeg_av = nanmean(abs(sl_signeg(:,targFreq,:)),2);
% sl_signeg_av = squeeze(sl_signeg_av);
% sl_signeg_av = nanmean(sl_signeg_av(targTime,:),1);
% 
% fs_signeg = coh_all_fix.fast(:,:,neg);
% fs_signeg_av = nanmean(abs(fs_signeg(:,targFreq,:)),2);
% fs_signeg_av = squeeze(fs_signeg_av);
% fs_signeg_av = nanmean(fs_signeg_av(targTime,:),1);
% 
% sl_signot = coh_all_fix.slow(:,:,not);
% sl_signot_av = nanmean(abs(sl_signot(:,targFreq,:)),2);
% sl_signot_av = squeeze(sl_signot_av);
% sl_signot_av = nanmean(sl_signot_av(targTime,:),1);
% 
% fs_signot = coh_all_fix.fast(:,:,not);
% fs_signot_av = nanmean(abs(fs_signot(:,targFreq,:)),2);
% fs_signot_av = squeeze(fs_signot_av);
% fs_signot_av = nanmean(fs_signot_av(targTime,:),1);
% 
% d_pos = nanmean(fs_sigpos,3) - nanmean(sl_sigpos,3);
% d_neg = nanmean(fs_signeg,3) - nanmean(sl_signeg,3);
% d_not = nanmean(fs_signot,3) - nanmean(sl_signot,3);
% 


sl_5 = nanmean(abs(coh_all_fix.slow(:,targFreq5,:)),2);
sl_5 = (nanmean(sl_5(targTime,:),1));

sl_10 = nanmean(abs(coh_all_fix.slow(:,targFreq10,:)),2);
sl_10 = (nanmean(sl_10(targTime,:),1));

sl_15 = nanmean(abs(coh_all_fix.slow(:,targFreq15,:)),2);
sl_15 = (nanmean(sl_15(targTime,:),1));

sl_20 = nanmean(abs(coh_all_fix.slow(:,targFreq20,:)),2);
sl_20 = (nanmean(sl_20(targTime,:),1));

sl_25 = nanmean(abs(coh_all_fix.slow(:,targFreq25,:)),2);
sl_25 = (nanmean(sl_25(targTime,:),1));

sl_30 = nanmean(abs(coh_all_fix.slow(:,targFreq30,:)),2);
sl_30 = (nanmean(sl_30(targTime,:),1));

sl_35 = nanmean(abs(coh_all_fix.slow(:,targFreq35,:)),2);
sl_35 = (nanmean(sl_35(targTime,:),1));

sl_40 = nanmean(abs(coh_all_fix.slow(:,targFreq40,:)),2);
sl_40 = (nanmean(sl_40(targTime,:),1));

sl_45 = nanmean(abs(coh_all_fix.slow(:,targFreq45,:)),2);
sl_45 = (nanmean(sl_45(targTime,:),1));

sl_50 = nanmean(abs(coh_all_fix.slow(:,targFreq50,:)),2);
sl_50 = (nanmean(sl_50(targTime,:),1));

sl_55 = nanmean(abs(coh_all_fix.slow(:,targFreq55,:)),2);
sl_55 = (nanmean(sl_55(targTime,:),1));

sl_60 = nanmean(abs(coh_all_fix.slow(:,targFreq60,:)),2);
sl_60 = (nanmean(sl_60(targTime,:),1));

sl_65 = nanmean(abs(coh_all_fix.slow(:,targFreq65,:)),2);
sl_65 = (nanmean(sl_65(targTime,:),1));

sl_70 = nanmean(abs(coh_all_fix.slow(:,targFreq70,:)),2);
sl_70 = (nanmean(sl_70(targTime,:),1));

sl_75 = nanmean(abs(coh_all_fix.slow(:,targFreq75,:)),2);
sl_75 = (nanmean(sl_75(targTime,:),1));

sl_80 = nanmean(abs(coh_all_fix.slow(:,targFreq80,:)),2);
sl_80 = (nanmean(sl_80(targTime,:),1));


fs_5 = nanmean(abs(coh_all_fix.fast(:,targFreq5,:)),2);
fs_5 = (nanmean(fs_5(targTime,:),1));
 
fs_10 = nanmean(abs(coh_all_fix.fast(:,targFreq10,:)),2);
fs_10 = (nanmean(fs_10(targTime,:),1));
 
fs_15 = nanmean(abs(coh_all_fix.fast(:,targFreq15,:)),2);
fs_15 = (nanmean(fs_15(targTime,:),1));
 
fs_20 = nanmean(abs(coh_all_fix.fast(:,targFreq20,:)),2);
fs_20 = (nanmean(fs_20(targTime,:),1));
 
fs_25 = nanmean(abs(coh_all_fix.fast(:,targFreq25,:)),2);
fs_25 = (nanmean(fs_25(targTime,:),1));
 
fs_30 = nanmean(abs(coh_all_fix.fast(:,targFreq30,:)),2);
fs_30 = (nanmean(fs_30(targTime,:),1));
 
fs_35 = nanmean(abs(coh_all_fix.fast(:,targFreq35,:)),2);
fs_35 = (nanmean(fs_35(targTime,:),1));
 
fs_40 = nanmean(abs(coh_all_fix.fast(:,targFreq40,:)),2);
fs_40 = (nanmean(fs_40(targTime,:),1));
 
fs_45 = nanmean(abs(coh_all_fix.fast(:,targFreq45,:)),2);
fs_45 = (nanmean(fs_45(targTime,:),1));
 
fs_50 = nanmean(abs(coh_all_fix.fast(:,targFreq50,:)),2);
fs_50 = (nanmean(fs_50(targTime,:),1));
 
fs_55 = nanmean(abs(coh_all_fix.fast(:,targFreq55,:)),2);
fs_55 = (nanmean(fs_55(targTime,:),1));
 
fs_60 = nanmean(abs(coh_all_fix.fast(:,targFreq60,:)),2);
fs_60 = (nanmean(fs_60(targTime,:),1));
 
fs_65 = nanmean(abs(coh_all_fix.fast(:,targFreq65,:)),2);
fs_65 = (nanmean(fs_65(targTime,:),1));
 
fs_70 = nanmean(abs(coh_all_fix.fast(:,targFreq70,:)),2);
fs_70 = (nanmean(fs_70(targTime,:),1));
 
fs_75 = nanmean(abs(coh_all_fix.fast(:,targFreq75,:)),2);
fs_75 = (nanmean(fs_75(targTime,:),1));
 
fs_80 = nanmean(abs(coh_all_fix.fast(:,targFreq80,:)),2);
fs_80 = (nanmean(fs_80(targTime,:),1));


fig4
plot([5:5:80],[nanmean(sl_5) nanmean(sl_10) nanmean(sl_15) nanmean(sl_20) nanmean(sl_25) nanmean(sl_30) nanmean(sl_35) nanmean(sl_40) nanmean(sl_45) nanmean(sl_50) nanmean(sl_55) nanmean(sl_60) nanmean(sl_65) nanmean(sl_70) nanmean(sl_75) nanmean(sl_80)],'r', ...
    [5:5:80],[nanmean(fs_5) nanmean(fs_10) nanmean(fs_15) nanmean(fs_20) nanmean(fs_25) nanmean(fs_30) nanmean(fs_35) nanmean(fs_40) nanmean(fs_45) nanmean(fs_50) nanmean(fs_55) nanmean(fs_60) nanmean(fs_65) nanmean(fs_70) nanmean(fs_75) nanmean(fs_80)],'g', 'linewidth',2)

xlabel('Frequency (Hz)')
ylabel('Coherence Magnitude')
box off













d_5 = fs_5 - sl_5;
d_10 = fs_10 - sl_10;
d_15 = fs_15 - sl_15;
d_20 = fs_20 - sl_20;
d_25 = fs_25 - sl_25;
d_30 = fs_30 - sl_30;
d_35 = fs_35 - sl_35;
d_40 = fs_40 - sl_40;
d_45 = fs_45 - sl_45;
d_50 = fs_50 - sl_50;
d_55 = fs_55 - sl_55;
d_60 = fs_60 - sl_60;
d_65 = fs_65 - sl_65;
d_70 = fs_70 - sl_70;
d_75 = fs_75 - sl_75;
d_80 = fs_80 - sl_80;


fig3
%plot(5:5:80,[nanmean(d_5) nanmean(d_10) nanmean(d_15) nanmean(d_20) nanmean(d_25) nanmean(d_30) nanmean(d_35) nanmean(d_40) nanmean(d_45) nanmean(d_50) nanmean(d_55) nanmean(d_60) nanmean(d_65) nanmean(d_70) nanmean(d_75) nanmean(d_80)],'k','linewidth',2)
plot([5 20:10:80],[nanmean(d_5) nanmean(d_20) nanmean(d_30) nanmean(d_40) nanmean(d_50) nanmean(d_60) nanmean(d_70) nanmean(d_80)],'k','linewidth',2)

xlabel('Frequency (Hz)')
ylabel('Coherence Magnitude Difference')
hline(0,'--k')
box off