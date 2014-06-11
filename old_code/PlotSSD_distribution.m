%Calculate Histogram of SSD's and mean RT within each of 4 quartiles.

%find min and max SSD's for file so can plot in 25ms intervals

x = min(Infos_(:,17)):25:max(Infos_(:,17));

%sort, then find quartiles
sorted_SSDs = sort(Infos_(:,17));
Q1_cut = median(sorted_SSDs(find(sorted_SSDs < median(sorted_SSDs))));
Q2_cut = median(sorted_SSDs);
Q3_cut = median(sorted_SSDs(find(sorted_SSDs > median(sorted_SSDs))));

Q1 = mean(sorted_SSDs(find(sorted_SSDs < Q1_cut)));
Q2 = mean(sorted_SSDs(find(sorted_SSDs >= Q1_cut & sorted_SSDs < Q2_cut)));
Q3 = mean(sorted_SSDs(find(sorted_SSDs >= Q2_cut & sorted_SSDs < Q3_cut)));
Q4 = mean(sorted_SSDs(find(sorted_SSDs >= Q3_cut)));

meanx = mean(x);
hist(sorted_SSDs,x)

text(50,58,['Grand mean is ' num2str(meanx)])
text(50,47,['Quartile 1 mean: ' num2str(Q1)])
text(50,44,['Quartile 2 mean: ' num2str(Q2)])
text(50,41,['Quartile 3 mean: ' num2str(Q3)])
text(50,38,['Quartile 4 mean: ' num2str(Q4)])





