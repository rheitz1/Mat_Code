t_win = [-1000 0];
f_win = [15 25];

%trls = find(all_RF_overlap.length == 3);
trls = intersect(find(all_sameHemi),find(all_RF_overlap.length >= 2));

sl_time = squeeze(nanmean(abs(Pcoh_all.slow(:,find(f >= f_win(1) & f <= f_win(2)),trls)),2));
md_time = squeeze(nanmean(abs(Pcoh_all.med(:,find(f >= f_win(1) & f <= f_win(2)),trls)),2));
fs_time = squeeze(nanmean(abs(Pcoh_all.fast(:,find(f >= f_win(1) & f <= f_win(2)),trls)),2));

sl = abs(Pcoh_all.slow(find(tout >= t_win(1) & tout <= t_win(2)),find(f >= f_win(1) & f <= f_win(2)),trls));
md = abs(Pcoh_all.med(find(tout >= t_win(1) & tout <= t_win(2)),find(f >= f_win(1) & f <= f_win(2)),trls));
fs = abs(Pcoh_all.fast(find(tout >= t_win(1) & tout <= t_win(2)),find(f >= f_win(1) & f <= f_win(2)),trls));


sl = squeeze(nanmean(nanmean(sl,1),2));
md = squeeze(nanmean(nanmean(md,1),2));
fs = squeeze(nanmean(nanmean(fs,1),2));

figure
subplot(231)
plot(tout,nanmean(sl_time'),'r',tout,nanmean(md_time'),'k',tout,nanmean(fs_time'),'g')
xlim([-2500 500])


subplot(232)
imagesc(tout,f,nanmean(abs(Pcoh_all.slow),3)')
axis xy
xlim([-2500 500])
title('Slow')

subplot(233)
d = nanmean(abs(Pcoh_all.fast),3) - nanmean(abs(Pcoh_all.slow),3);
imagesc(tout,f,d')
axis xy
xlim([-2500 500])
title('Fast - Slow')

subplot(234)
d = nanmean(fs_time') - nanmean(sl_time');
plot(tout,d')
xlim([-2500 500])
title('Fast - Slow')
h = hline(0,'--k');
set(h,'linewidth',2)


subplot(235)
scatter(sl,fs)
dline
xlabel('Slow')
ylabel('Fast')