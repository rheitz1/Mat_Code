%makes bar plot for threshold slow - threshold fast, separated by significant or not significant within
%any one file
%

cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_Vis_VisMove_targ.mat

barwidth = 47.5;

x = allTDT.slow_correct_made_dead;
y = allTDT.fast_correct_made_dead_withCleared;


dif = y - x;

[a b] = histc(dif,-500:barwidth:500);


fig
bar(-500:barwidth:500,a,'barwidth',1)
box off

[bins.slow cdf.slow] = getCDF(allTDT.slow_correct_made_dead);
[bins.med cdf.med] = getCDF(allTDT.med_correct);
[bins.fast cdf.fast] = getCDF(allTDT.fast_correct_made_dead_withCleared);

[binsRT.slow cdfRT.slow] = getCDF(RTs.slow_correct_made_dead);
[binsRT.med cdfRT.med] = getCDF(RTs.med_correct);
[binsRT.fast cdfRT.fast] = getCDF(RTs.fast_correct_made_dead_withCleared);

figure
subplot(2,2,1)
plot(bins.slow,cdf.slow,'-or',bins.med,cdf.med,'-ok',bins.fast,cdf.fast,'-og','markersize',5)
box off
% title('TDT CDFs')
xlim([150 525])
set(gca,'xminortick','on')