%makes bar plot for threshold slow - threshold fast, separated by significant or not significant within
%any one file
%

barwidth = .09;

x = nanmean(allwf_targ.in.slow_correct_made_dead(:,200:225),2);
y = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,200:225),2);

sig = find(sigAct_100_125.slow_vs_fast == 1);
ns = find(sigAct_100_125.slow_vs_fast == 0);

dif = y - x;
lgth = length(find(~isnan(dif)));

x = dif(sig);
y = dif(ns);

[a b] = histc(x,-1.5:barwidth:1.5);
[c d] = histc(y,-1.5:barwidth:1.5);

fig
bar(-1.5:barwidth:1.5,[a c],'stacked','barwidth',1)
xlim([-1.5 1.5])
box off
title('100 - 125 ms')

disp(['% sig positive = ' mat2str(round(length(intersect(find(sigAct_100_125.slow_vs_fast == 1),find(dif > 0)))/lgth*1000)/1000)])
disp(['% sig neg = ' mat2str(round(length(intersect(find(sigAct_100_125.slow_vs_fast == 1),find(dif < 0)))/lgth*1000)/1000)])
disp(['% not sig = ' mat2str(round(length(find(sigAct_100_125.slow_vs_fast == 0))/lgth*1000)/1000)])



barwidth = .09;

x = nanmean(allwf_targ.in.slow_correct_made_dead(:,350:400),2);
y = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,350:400),2);

sig = find(sigAct_250_300.slow_vs_fast == 1);
ns = find(sigAct_250_300.slow_vs_fast == 0);

dif = y - x;
lgth = length(find(~isnan(dif)));

x = dif(sig);
y = dif(ns);

[a b] = histc(x,-1.5:barwidth:1.5);
[c d] = histc(y,-1.5:barwidth:1.5);

fig
bar(-1.5:barwidth:1.5,[a c],'stacked','barwidth',1)
xlim([-1.5 1.5])
box off
title('250 - 300 ms')

disp(['% sig positive = ' mat2str(round(length(intersect(find(sigAct_250_300.slow_vs_fast == 1),find(dif > 0)))/lgth*1000)/1000)])
disp(['% sig neg = ' mat2str(round(length(intersect(find(sigAct_250_300.slow_vs_fast == 1),find(dif < 0)))/lgth*1000)/1000)])
disp(['% not sig = ' mat2str(round(length(find(sigAct_250_300.slow_vs_fast == 0))/lgth*1000)/1000)])