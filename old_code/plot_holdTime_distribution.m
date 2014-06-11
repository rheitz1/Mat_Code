%plot distribution of hold times.
%Based on FixSpotOn_

HoldTimes = Target_(:,1) - FixSpotOn_(:,1);

%Find min and max holdtimes for plotting purposes.  Use 25ms bins.
x = nanmin(HoldTimes):25:nanmax(HoldTimes);

HoldTimes_mean = nanmean(HoldTimes);

%Find quartiles

sorted_holdtimes = sort(HoldTimes);
Q1_cut = nanmedian(sorted_holdtimes(find(sorted_holdtimes < nanmedian(sorted_holdtimes))));
Q2_cut = nanmedian(sorted_holdtimes);
Q3_cut = nanmedian(sorted_holdtimes(find(sorted_holdtimes > nanmedian(sorted_holdtimes))));

Q1 = nanmean(sorted_holdtimes(find(sorted_holdtimes < Q1_cut)));
Q2 = nanmean(sorted_holdtimes(find(sorted_holdtimes >= Q1_cut & sorted_holdtimes < Q2_cut)));
Q3 = nanmean(sorted_holdtimes(find(sorted_holdtimes >= Q2_cut & sorted_holdtimes < Q3_cut)));
Q4 = nanmean(sorted_holdtimes(find(sorted_holdtimes >= Q3_cut)));

Q1_trialnums = find(sorted_holdtimes < Q1_cut);
Q2_trialnums = find(sorted_holdtimes >= Q1_cut & sorted_holdtimes < Q2_cut);
Q3_trialnums = find(sorted_holdtimes >= Q2_cut & sorted_holdtimes < Q3_cut);
Q4_trialnums = find(sorted_holdtimes >= Q3_cut);


hist(sorted_holdtimes,x)

text(50,60,['Grand mean is ' num2str(HoldTimes_mean)])
text(50,47,['Quartile 1 mean: ' num2str(Q1)])
text(50,44,['Quartile 2 mean: ' num2str(Q2)])
text(50,41,['Quartile 3 mean: ' num2str(Q3)])
text(50,38,['Quartile 4 mean: ' num2str(Q4)])