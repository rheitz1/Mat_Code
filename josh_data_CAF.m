cd /Volumes/Dump/Search_Data_TL_Human/Speeded_unstructured_landolt
load josh_data

cur_ntiles = prctile(dat(:,2),[10 20 30 40 50 60 70 80 90]);

n1 = find(dat(:,2) <= cur_ntiles(1));
n2 = find(dat(:,2) > cur_ntiles(1) & dat(:,2) <= cur_ntiles(2));
n3 = find(dat(:,2) > cur_ntiles(2) & dat(:,2) <= cur_ntiles(3));
n4 = find(dat(:,2) > cur_ntiles(3) & dat(:,2) <= cur_ntiles(4));
n5 = find(dat(:,2) > cur_ntiles(4) & dat(:,2) <= cur_ntiles(5));
n6 = find(dat(:,2) > cur_ntiles(5) & dat(:,2) <= cur_ntiles(6));
n7 = find(dat(:,2) > cur_ntiles(6) & dat(:,2) <= cur_ntiles(7));
n8 = find(dat(:,2) > cur_ntiles(7) & dat(:,2) <= cur_ntiles(8));
n9 = find(dat(:,2) > cur_ntiles(8) & dat(:,2) <= cur_ntiles(9));
n10 = find(dat(:,2) > cur_ntiles(9));

dex = 1;

dCAF_rts(dex,1) = nanmean(dat(n1,2));
dCAF_rts(dex,2) = nanmean(dat(n2,2));
dCAF_rts(dex,3) = nanmean(dat(n3,2));
dCAF_rts(dex,4) = nanmean(dat(n4,2));
dCAF_rts(dex,5) = nanmean(dat(n5,2));
dCAF_rts(dex,6) = nanmean(dat(n6,2));
dCAF_rts(dex,7) = nanmean(dat(n7,2));
dCAF_rts(dex,8) = nanmean(dat(n8,2));
dCAF_rts(dex,9) = nanmean(dat(n9,2));
dCAF_rts(dex,10) = nanmean(dat(n10,2));

dCAF_accs(dex,1) = nanmean(dat(n1,5));
dCAF_accs(dex,2) = nanmean(dat(n2,5));
dCAF_accs(dex,3) = nanmean(dat(n3,5));
dCAF_accs(dex,4) = nanmean(dat(n4,5));
dCAF_accs(dex,5) = nanmean(dat(n5,5));
dCAF_accs(dex,6) = nanmean(dat(n6,5));
dCAF_accs(dex,7) = nanmean(dat(n7,5));
dCAF_accs(dex,8) = nanmean(dat(n8,5));
dCAF_accs(dex,9) = nanmean(dat(n9,5));
dCAF_accs(dex,10) = nanmean(dat(n10,5));

dCAF_correct(dex,1) = length(find(dat(n1,5) == 1));
dCAF_correct(dex,2) = length(find(dat(n2,5) == 1));
dCAF_correct(dex,3) = length(find(dat(n3,5) == 1));
dCAF_correct(dex,4) = length(find(dat(n4,5) == 1));
dCAF_correct(dex,5) = length(find(dat(n5,5) == 1));
dCAF_correct(dex,6) = length(find(dat(n6,5) == 1));
dCAF_correct(dex,7) = length(find(dat(n7,5) == 1));
dCAF_correct(dex,8) = length(find(dat(n8,5) == 1));
dCAF_correct(dex,9) = length(find(dat(n9,5) == 1));
dCAF_correct(dex,10) = length(find(dat(n10,5) == 1));

dCAF_error(dex,1) = length(find(dat(n1,5) == 0));
dCAF_error(dex,2) = length(find(dat(n2,5) == 0));
dCAF_error(dex,3) = length(find(dat(n3,5) == 0));
dCAF_error(dex,4) = length(find(dat(n4,5) == 0));
dCAF_error(dex,5) = length(find(dat(n5,5) == 0));
dCAF_error(dex,6) = length(find(dat(n6,5) == 0));
dCAF_error(dex,7) = length(find(dat(n7,5) == 0));
dCAF_error(dex,8) = length(find(dat(n8,5) == 0));
dCAF_error(dex,9) = length(find(dat(n9,5) == 0));
dCAF_error(dex,10) = length(find(dat(n10,5) == 0));

figure
plot(dCAF_rts,dCAF_accs)
box off

figure
plot(dCAF_rts,Acc2Dprime(dCAF_accs))
box off
title('D-prime')

figure
semilogy(dCAF_rts,(dCAF_correct./dCAF_error))
box off
title('log odds')