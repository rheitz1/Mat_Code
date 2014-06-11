%makes bar plot for threshold slow - threshold fast, separated by significant or not significant within
%any one file
%

if size(allwf_move.in.slow_correct_made_dead,2) == 601
    test_time = 380:390;
elseif size(allwf_move.in.slow_correct_made_dead,2) == 2701
    test_time = 2480:2490;
end



barwidth = .266;

x = nanmean(allwf_move.in.slow_correct_made_dead(:,test_time),2);
y = nanmean(allwf_move.in.fast_correct_made_dead_withCleared(:,test_time),2);

sig = find(sigThresh.slow_vs_fast == 1);
ns = find(sigThresh.slow_vs_fast == 0);

dif = y - x;
lgth = length(find(~isnan(dif)));

x = dif(sig);
y = dif(ns);

[a b] = histc(x,-1.5:barwidth:1.5);
[c d] = histc(y,-1.5:barwidth:1.5);

fig
bar(-1.5:barwidth:1.5,[a(:) c(:)],'stacked','barwidth',1)
xlim([-1.5 1.5])
box off

disp(['% sig positive = ' mat2str(round(length(intersect(find(sigThresh.slow_vs_fast == 1),find(dif > 0)))/lgth*1000)/1000)])
disp(['% sig neg = ' mat2str(round(length(intersect(find(sigThresh.slow_vs_fast == 1),find(dif < 0)))/lgth*1000)/1000)])
disp(['% not sig = ' mat2str(round(length(find(sigThresh.slow_vs_fast == 0))/lgth*1000)/1000)])