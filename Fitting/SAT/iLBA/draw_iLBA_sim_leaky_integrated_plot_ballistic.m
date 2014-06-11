sl = round(rt.slow) - T0.slow;
fs = round(rt.fast) - T0.fast;

remove.sl= find(isnan(rt.slow));
remove.fs = find(isnan(rt.fast));

ballistic.slow.correct(remove.sl,:) = [];
ballistic.fast.correct(remove.fs,:) = [];

sl(find(isnan(sl))) = [];
fs(find(isnan(fs))) = [];

for trl = 1:length(sl)
    ballistic.slow.correct(trl,sl(trl):2001) = NaN;
end


for trl = 1:length(fs)
    ballistic.fast.correct(trl,fs(trl):2001) = NaN;
end

figure
plot((1:2001)+T0.slow,ballistic.slow.correct,'r')
hold
%plot((1:2001)+T0.slow,nanmean(ballistic.slow.correct),'k')
plot((1:2001)+T0.fast,ballistic.fast.correct,'g')
%plot((1:2001)+T0.fast,nanmean(ballistic.fast.correct),'k')

vline(nanmean(rt.slow(find(correct.slow == 1))),'r')
vline(nanmean(rt.fast(find(correct.fast == 1))),'g')

xlim([0 800])
ylim([0 500])
set(gca,'xminortick','on')
box off