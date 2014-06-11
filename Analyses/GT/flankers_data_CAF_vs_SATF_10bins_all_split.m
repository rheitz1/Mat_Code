cd /Volumes/Dump/Flankers_Data_GT/
load Flankers_5050_8020_all.mat


%============================
% DAT variable column legend:
%
% 1: Accuracy
% 2: RT
% 3: SAT Deadline condition
% 4: Congruent (1) Incongruent (0)
% 5: Low Working Memory Span (1)  High Working Memory Span (2)
% 6: Porportion Congruent (50/50) or (80/20)

dat(find(dat(:,2) < 150),2) = NaN;

%=============
% Deadlines
d200.LS.compat = find(dat(:,3) == 200 & dat(:,4) == 1 & dat(:,5) == 1);
d300.LS.compat = find(dat(:,3) == 300 & dat(:,4) == 1 & dat(:,5) == 1);
d400.LS.compat = find(dat(:,3) == 400 & dat(:,4) == 1 & dat(:,5) == 1);
d500.LS.compat = find(dat(:,3) == 500 & dat(:,4) == 1 & dat(:,5) == 1);
d600.LS.compat = find(dat(:,3) == 600 & dat(:,4) == 1 & dat(:,5) == 1);
d700.LS.compat = find(dat(:,3) == 700 & dat(:,4) == 1 & dat(:,5) == 1);

d200.HS.compat = find(dat(:,3) == 200 & dat(:,4) == 1 & dat(:,5) == 2);
d300.HS.compat = find(dat(:,3) == 300 & dat(:,4) == 1 & dat(:,5) == 2);
d400.HS.compat = find(dat(:,3) == 400 & dat(:,4) == 1 & dat(:,5) == 2);
d500.HS.compat = find(dat(:,3) == 500 & dat(:,4) == 1 & dat(:,5) == 2);
d600.HS.compat = find(dat(:,3) == 600 & dat(:,4) == 1 & dat(:,5) == 2);
d700.HS.compat = find(dat(:,3) == 700 & dat(:,4) == 1 & dat(:,5) == 2);



d200_rt.LS.compat = nanmean(dat(d200.LS.compat,2));
d300_rt.LS.compat = nanmean(dat(d300.LS.compat,2));
d400_rt.LS.compat = nanmean(dat(d400.LS.compat,2));
d500_rt.LS.compat = nanmean(dat(d500.LS.compat,2));
d600_rt.LS.compat = nanmean(dat(d600.LS.compat,2));
d700_rt.LS.compat = nanmean(dat(d700.LS.compat,2));

d200_rt.HS.compat = nanmean(dat(d200.HS.compat,2));
d300_rt.HS.compat = nanmean(dat(d300.HS.compat,2));
d400_rt.HS.compat = nanmean(dat(d400.HS.compat,2));
d500_rt.HS.compat = nanmean(dat(d500.HS.compat,2));
d600_rt.HS.compat = nanmean(dat(d600.HS.compat,2));
d700_rt.HS.compat = nanmean(dat(d700.HS.compat,2));

d200_acc.LS.compat = nanmean(dat(d200.LS.compat,1));
d300_acc.LS.compat = nanmean(dat(d300.LS.compat,1));
d400_acc.LS.compat = nanmean(dat(d400.LS.compat,1));
d500_acc.LS.compat = nanmean(dat(d500.LS.compat,1));
d600_acc.LS.compat = nanmean(dat(d600.LS.compat,1));
d700_acc.LS.compat = nanmean(dat(d700.LS.compat,1));

d200_acc.HS.compat = nanmean(dat(d200.HS.compat,1));
d300_acc.HS.compat = nanmean(dat(d300.HS.compat,1));
d400_acc.HS.compat = nanmean(dat(d400.HS.compat,1));
d500_acc.HS.compat = nanmean(dat(d500.HS.compat,1));
d600_acc.HS.compat = nanmean(dat(d600.HS.compat,1));
d700_acc.HS.compat = nanmean(dat(d700.HS.compat,1));


n_correct.LS.compat(1) = length(find(dat(d200.LS.compat,1) == 1));
n_correct.LS.compat(2) = length(find(dat(d300.LS.compat,1) == 1));
n_correct.LS.compat(3) = length(find(dat(d400.LS.compat,1) == 1));
n_correct.LS.compat(4) = length(find(dat(d500.LS.compat,1) == 1));
n_correct.LS.compat(5) = length(find(dat(d600.LS.compat,1) == 1));
n_correct.LS.compat(6) = length(find(dat(d700.LS.compat,1) == 1));

n_correct.HS.compat(1) = length(find(dat(d200.HS.compat,1) == 1));
n_correct.HS.compat(2) = length(find(dat(d300.HS.compat,1) == 1));
n_correct.HS.compat(3) = length(find(dat(d400.HS.compat,1) == 1));
n_correct.HS.compat(4) = length(find(dat(d500.HS.compat,1) == 1));
n_correct.HS.compat(5) = length(find(dat(d600.HS.compat,1) == 1));
n_correct.HS.compat(6) = length(find(dat(d700.HS.compat,1) == 1));

n_error.LS.compat(1) = length(find(dat(d200.LS.compat,1) == 0));
n_error.LS.compat(2) = length(find(dat(d300.LS.compat,1) == 0));
n_error.LS.compat(3) = length(find(dat(d400.LS.compat,1) == 0));
n_error.LS.compat(4) = length(find(dat(d500.LS.compat,1) == 0));
n_error.LS.compat(5) = length(find(dat(d600.LS.compat,1) == 0));
n_error.LS.compat(6) = length(find(dat(d700.LS.compat,1) == 0));

n_error.HS.compat(1) = length(find(dat(d200.HS.compat,1) == 0));
n_error.HS.compat(2) = length(find(dat(d300.HS.compat,1) == 0));
n_error.HS.compat(3) = length(find(dat(d400.HS.compat,1) == 0));
n_error.HS.compat(4) = length(find(dat(d500.HS.compat,1) == 0));
n_error.HS.compat(5) = length(find(dat(d600.HS.compat,1) == 0));
n_error.HS.compat(6) = length(find(dat(d700.HS.compat,1) == 0));


deadlines = [200:100:700];
rts.LS.compat = [d200_rt.LS.compat d300_rt.LS.compat d400_rt.LS.compat d500_rt.LS.compat d600_rt.LS.compat d700_rt.LS.compat];
accs.LS.compat = [d200_acc.LS.compat d300_acc.LS.compat d400_acc.LS.compat d500_acc.LS.compat d600_acc.LS.compat d700_acc.LS.compat];
rts.HS.compat = [d200_rt.HS.compat d300_rt.HS.compat d400_rt.HS.compat d500_rt.HS.compat d600_rt.HS.compat d700_rt.HS.compat];
accs.HS.compat = [d200_acc.HS.compat d300_acc.HS.compat d400_acc.HS.compat d500_acc.HS.compat d600_acc.HS.compat d700_acc.HS.compat];





d200.LS.incompat = find(dat(:,3) == 200 & dat(:,4) == 0 & dat(:,5) == 1);
d300.LS.incompat = find(dat(:,3) == 300 & dat(:,4) == 0 & dat(:,5) == 1);
d400.LS.incompat = find(dat(:,3) == 400 & dat(:,4) == 0 & dat(:,5) == 1);
d500.LS.incompat = find(dat(:,3) == 500 & dat(:,4) == 0 & dat(:,5) == 1);
d600.LS.incompat = find(dat(:,3) == 600 & dat(:,4) == 0 & dat(:,5) == 1);
d700.LS.incompat = find(dat(:,3) == 700 & dat(:,4) == 0 & dat(:,5) == 1);
 
d200.HS.incompat = find(dat(:,3) == 200 & dat(:,4) == 0 & dat(:,5) == 2);
d300.HS.incompat = find(dat(:,3) == 300 & dat(:,4) == 0 & dat(:,5) == 2);
d400.HS.incompat = find(dat(:,3) == 400 & dat(:,4) == 0 & dat(:,5) == 2);
d500.HS.incompat = find(dat(:,3) == 500 & dat(:,4) == 0 & dat(:,5) == 2);
d600.HS.incompat = find(dat(:,3) == 600 & dat(:,4) == 0 & dat(:,5) == 2);
d700.HS.incompat = find(dat(:,3) == 700 & dat(:,4) == 0 & dat(:,5) == 2);
 
 
 
d200_rt.LS.incompat = nanmean(dat(d200.LS.incompat,2));
d300_rt.LS.incompat = nanmean(dat(d300.LS.incompat,2));
d400_rt.LS.incompat = nanmean(dat(d400.LS.incompat,2));
d500_rt.LS.incompat = nanmean(dat(d500.LS.incompat,2));
d600_rt.LS.incompat = nanmean(dat(d600.LS.incompat,2));
d700_rt.LS.incompat = nanmean(dat(d700.LS.incompat,2));
 
d200_rt.HS.incompat = nanmean(dat(d200.HS.incompat,2));
d300_rt.HS.incompat = nanmean(dat(d300.HS.incompat,2));
d400_rt.HS.incompat = nanmean(dat(d400.HS.incompat,2));
d500_rt.HS.incompat = nanmean(dat(d500.HS.incompat,2));
d600_rt.HS.incompat = nanmean(dat(d600.HS.incompat,2));
d700_rt.HS.incompat = nanmean(dat(d700.HS.incompat,2));
 
d200_acc.LS.incompat = nanmean(dat(d200.LS.incompat,1));
d300_acc.LS.incompat = nanmean(dat(d300.LS.incompat,1));
d400_acc.LS.incompat = nanmean(dat(d400.LS.incompat,1));
d500_acc.LS.incompat = nanmean(dat(d500.LS.incompat,1));
d600_acc.LS.incompat = nanmean(dat(d600.LS.incompat,1));
d700_acc.LS.incompat = nanmean(dat(d700.LS.incompat,1));
 
d200_acc.HS.incompat = nanmean(dat(d200.HS.incompat,1));
d300_acc.HS.incompat = nanmean(dat(d300.HS.incompat,1));
d400_acc.HS.incompat = nanmean(dat(d400.HS.incompat,1));
d500_acc.HS.incompat = nanmean(dat(d500.HS.incompat,1));
d600_acc.HS.incompat = nanmean(dat(d600.HS.incompat,1));
d700_acc.HS.incompat = nanmean(dat(d700.HS.incompat,1));
 
 
n_correct.LS.incompat(1) = length(find(dat(d200.LS.incompat,1) == 1));
n_correct.LS.incompat(2) = length(find(dat(d300.LS.incompat,1) == 1));
n_correct.LS.incompat(3) = length(find(dat(d400.LS.incompat,1) == 1));
n_correct.LS.incompat(4) = length(find(dat(d500.LS.incompat,1) == 1));
n_correct.LS.incompat(5) = length(find(dat(d600.LS.incompat,1) == 1));
n_correct.LS.incompat(6) = length(find(dat(d700.LS.incompat,1) == 1));
 
n_correct.HS.incompat(1) = length(find(dat(d200.HS.incompat,1) == 1));
n_correct.HS.incompat(2) = length(find(dat(d300.HS.incompat,1) == 1));
n_correct.HS.incompat(3) = length(find(dat(d400.HS.incompat,1) == 1));
n_correct.HS.incompat(4) = length(find(dat(d500.HS.incompat,1) == 1));
n_correct.HS.incompat(5) = length(find(dat(d600.HS.incompat,1) == 1));
n_correct.HS.incompat(6) = length(find(dat(d700.HS.incompat,1) == 1));
 
n_error.LS.incompat(1) = length(find(dat(d200.LS.incompat,1) == 0));
n_error.LS.incompat(2) = length(find(dat(d300.LS.incompat,1) == 0));
n_error.LS.incompat(3) = length(find(dat(d400.LS.incompat,1) == 0));
n_error.LS.incompat(4) = length(find(dat(d500.LS.incompat,1) == 0));
n_error.LS.incompat(5) = length(find(dat(d600.LS.incompat,1) == 0));
n_error.LS.incompat(6) = length(find(dat(d700.LS.incompat,1) == 0));
 
n_error.HS.incompat(1) = length(find(dat(d200.HS.incompat,1) == 0));
n_error.HS.incompat(2) = length(find(dat(d300.HS.incompat,1) == 0));
n_error.HS.incompat(3) = length(find(dat(d400.HS.incompat,1) == 0));
n_error.HS.incompat(4) = length(find(dat(d500.HS.incompat,1) == 0));
n_error.HS.incompat(5) = length(find(dat(d600.HS.incompat,1) == 0));
n_error.HS.incompat(6) = length(find(dat(d700.HS.incompat,1) == 0));
 
 
deadlines = [200:100:700];
rts.LS.incompat = [d200_rt.LS.incompat d300_rt.LS.incompat d400_rt.LS.incompat d500_rt.LS.incompat d600_rt.LS.incompat d700_rt.LS.incompat];
accs.LS.incompat = [d200_acc.LS.incompat d300_acc.LS.incompat d400_acc.LS.incompat d500_acc.LS.incompat d600_acc.LS.incompat d700_acc.LS.incompat];
rts.HS.incompat = [d200_rt.HS.incompat d300_rt.HS.incompat d400_rt.HS.incompat d500_rt.HS.incompat d600_rt.HS.incompat d700_rt.HS.incompat];
accs.HS.incompat = [d200_acc.HS.incompat d300_acc.HS.incompat d400_acc.HS.incompat d500_acc.HS.incompat d600_acc.HS.incompat d700_acc.HS.incompat];
 






%===========
% Overall CAF
LS_compat = find(dat(:,4) == 1 & dat(:,5) == 1);
HS_compat = find(dat(:,4) == 1 & dat(:,5) == 2);
LS_incompat = find(dat(:,4) == 0 & dat(:,5) == 1);
HS_incompat = find(dat(:,4) == 0 & dat(:,5) == 2);

ntiles = prctile(dat(LS_compat,2),[10 20 30 40 50 60 70 80 90]);
trls1.LS.compat = find(dat(:,2) <= ntiles(1) & dat(:,4) == 1 & dat(:,5) == 1);
trls2.LS.compat = find(dat(:,2) > ntiles(1) & dat(:,2) <= ntiles(2) & dat(:,4) == 1 & dat(:,5) == 1);
trls3.LS.compat = find(dat(:,2) > ntiles(2) & dat(:,2) <= ntiles(3) & dat(:,4) == 1 & dat(:,5) == 1);
trls4.LS.compat = find(dat(:,2) > ntiles(3) & dat(:,2) <= ntiles(4) & dat(:,4) == 1 & dat(:,5) == 1);
trls5.LS.compat = find(dat(:,2) > ntiles(4) & dat(:,2) <= ntiles(5) & dat(:,4) == 1 & dat(:,5) == 1);
trls6.LS.compat = find(dat(:,2) > ntiles(5) & dat(:,2) <= ntiles(6) & dat(:,4) == 1 & dat(:,5) == 1);
trls7.LS.compat = find(dat(:,2) > ntiles(6) & dat(:,2) <= ntiles(7) & dat(:,4) == 1 & dat(:,5) == 1);
trls8.LS.compat = find(dat(:,2) > ntiles(7) & dat(:,2) <= ntiles(8) & dat(:,4) == 1 & dat(:,5) == 1);
trls9.LS.compat = find(dat(:,2) > ntiles(8) & dat(:,2) <= ntiles(9) & dat(:,4) == 1 & dat(:,5) == 1);
trls10.LS.compat = find(dat(:,2) > ntiles(9) & dat(:,4) == 1 & dat(:,5) == 1);

ntiles = prctile(dat(HS_compat,2),[10 20 30 40 50 60 70 80 90]);
trls1.HS.compat = find(dat(:,2) <= ntiles(1) & dat(:,4) == 1 & dat(:,5) == 2);
trls2.HS.compat = find(dat(:,2) > ntiles(1) & dat(:,2) <= ntiles(2) & dat(:,4) == 1 & dat(:,5) == 2);
trls3.HS.compat = find(dat(:,2) > ntiles(2) & dat(:,2) <= ntiles(3) & dat(:,4) == 1 & dat(:,5) == 2);
trls4.HS.compat = find(dat(:,2) > ntiles(3) & dat(:,2) <= ntiles(4) & dat(:,4) == 1 & dat(:,5) == 2);
trls5.HS.compat = find(dat(:,2) > ntiles(4) & dat(:,2) <= ntiles(5) & dat(:,4) == 1 & dat(:,5) == 2);
trls6.HS.compat = find(dat(:,2) > ntiles(5) & dat(:,2) <= ntiles(6) & dat(:,4) == 1 & dat(:,5) == 2);
trls7.HS.compat = find(dat(:,2) > ntiles(6) & dat(:,2) <= ntiles(7) & dat(:,4) == 1 & dat(:,5) == 2);
trls8.HS.compat = find(dat(:,2) > ntiles(7) & dat(:,2) <= ntiles(8) & dat(:,4) == 1 & dat(:,5) == 2);
trls9.HS.compat = find(dat(:,2) > ntiles(8) & dat(:,2) <= ntiles(9) & dat(:,4) == 1 & dat(:,5) == 2);
trls10.HS.compat = find(dat(:,2) > ntiles(9) & dat(:,4) == 1 & dat(:,5) == 2);

ntiles = prctile(dat(LS_incompat,2),[10 20 30 40 50 60 70 80 90]);
trls1.LS.incompat = find(dat(:,2) <= ntiles(1) & dat(:,4) == 0 & dat(:,5) == 1);
trls2.LS.incompat = find(dat(:,2) > ntiles(1) & dat(:,2) <= ntiles(2) & dat(:,4) == 0 & dat(:,5) == 1);
trls3.LS.incompat = find(dat(:,2) > ntiles(2) & dat(:,2) <= ntiles(3) & dat(:,4) == 0 & dat(:,5) == 1);
trls4.LS.incompat = find(dat(:,2) > ntiles(3) & dat(:,2) <= ntiles(4) & dat(:,4) == 0 & dat(:,5) == 1);
trls5.LS.incompat = find(dat(:,2) > ntiles(4) & dat(:,2) <= ntiles(5) & dat(:,4) == 0 & dat(:,5) == 1);
trls6.LS.incompat = find(dat(:,2) > ntiles(5) & dat(:,2) <= ntiles(6) & dat(:,4) == 0 & dat(:,5) == 1);
trls7.LS.incompat = find(dat(:,2) > ntiles(6) & dat(:,2) <= ntiles(7) & dat(:,4) == 0 & dat(:,5) == 1);
trls8.LS.incompat = find(dat(:,2) > ntiles(7) & dat(:,2) <= ntiles(8) & dat(:,4) == 0 & dat(:,5) == 1);
trls9.LS.incompat = find(dat(:,2) > ntiles(8) & dat(:,2) <= ntiles(9) & dat(:,4) == 0 & dat(:,5) == 1);
trls10.LS.incompat = find(dat(:,2) > ntiles(9) & dat(:,4) == 0 & dat(:,5) == 1);
 
ntiles = prctile(dat(HS_incompat,2),[10 20 30 40 50 60 70 80 90]);
trls1.HS.incompat = find(dat(:,2) <= ntiles(1) & dat(:,4) == 0 & dat(:,5) == 2);
trls2.HS.incompat = find(dat(:,2) > ntiles(1) & dat(:,2) <= ntiles(2) & dat(:,4) == 0 & dat(:,5) == 2);
trls3.HS.incompat = find(dat(:,2) > ntiles(2) & dat(:,2) <= ntiles(3) & dat(:,4) == 0 & dat(:,5) == 2);
trls4.HS.incompat = find(dat(:,2) > ntiles(3) & dat(:,2) <= ntiles(4) & dat(:,4) == 0 & dat(:,5) == 2);
trls5.HS.incompat = find(dat(:,2) > ntiles(4) & dat(:,2) <= ntiles(5) & dat(:,4) == 0 & dat(:,5) == 2);
trls6.HS.incompat = find(dat(:,2) > ntiles(5) & dat(:,2) <= ntiles(6) & dat(:,4) == 0 & dat(:,5) == 2);
trls7.HS.incompat = find(dat(:,2) > ntiles(6) & dat(:,2) <= ntiles(7) & dat(:,4) == 0 & dat(:,5) == 2);
trls8.HS.incompat = find(dat(:,2) > ntiles(7) & dat(:,2) <= ntiles(8) & dat(:,4) == 0 & dat(:,5) == 2);
trls9.HS.incompat = find(dat(:,2) > ntiles(8) & dat(:,2) <= ntiles(9) & dat(:,4) == 0 & dat(:,5) == 2);
trls10.HS.incompat = find(dat(:,2) > ntiles(9) & dat(:,4) == 0 & dat(:,5) == 2);






CAF_rts.LS.compat(1) = nanmean(dat(trls1.LS.compat,2));
CAF_rts.LS.compat(2) = nanmean(dat(trls2.LS.compat,2));
CAF_rts.LS.compat(3) = nanmean(dat(trls3.LS.compat,2));
CAF_rts.LS.compat(4) = nanmean(dat(trls4.LS.compat,2));
CAF_rts.LS.compat(5) = nanmean(dat(trls5.LS.compat,2));
CAF_rts.LS.compat(6) = nanmean(dat(trls6.LS.compat,2));
CAF_rts.LS.compat(7) = nanmean(dat(trls7.LS.compat,2));
CAF_rts.LS.compat(8) = nanmean(dat(trls8.LS.compat,2));
CAF_rts.LS.compat(9) = nanmean(dat(trls9.LS.compat,2));
CAF_rts.LS.compat(10) = nanmean(dat(trls10.LS.compat,2));

CAFaccs.LS.compat(1) = nanmean(dat(trls1.LS.compat,1));
CAFaccs.LS.compat(2) = nanmean(dat(trls2.LS.compat,1));
CAFaccs.LS.compat(3) = nanmean(dat(trls3.LS.compat,1));
CAFaccs.LS.compat(4) = nanmean(dat(trls4.LS.compat,1));
CAFaccs.LS.compat(5) = nanmean(dat(trls5.LS.compat,1));
CAFaccs.LS.compat(6) = nanmean(dat(trls6.LS.compat,1));
CAFaccs.LS.compat(7) = nanmean(dat(trls7.LS.compat,1));
CAFaccs.LS.compat(8) = nanmean(dat(trls8.LS.compat,1));
CAFaccs.LS.compat(9) = nanmean(dat(trls9.LS.compat,1));
CAFaccs.LS.compat(10) = nanmean(dat(trls10.LS.compat,1));

CAF_rts.HS.compat(1) = nanmean(dat(trls1.HS.compat,2));
CAF_rts.HS.compat(2) = nanmean(dat(trls2.HS.compat,2));
CAF_rts.HS.compat(3) = nanmean(dat(trls3.HS.compat,2));
CAF_rts.HS.compat(4) = nanmean(dat(trls4.HS.compat,2));
CAF_rts.HS.compat(5) = nanmean(dat(trls5.HS.compat,2));
CAF_rts.HS.compat(6) = nanmean(dat(trls6.HS.compat,2));
CAF_rts.HS.compat(7) = nanmean(dat(trls7.HS.compat,2));
CAF_rts.HS.compat(8) = nanmean(dat(trls8.HS.compat,2));
CAF_rts.HS.compat(9) = nanmean(dat(trls9.HS.compat,2));
CAF_rts.HS.compat(10) = nanmean(dat(trls10.HS.compat,2));
 
CAFaccs.HS.compat(1) = nanmean(dat(trls1.HS.compat,1));
CAFaccs.HS.compat(2) = nanmean(dat(trls2.HS.compat,1));
CAFaccs.HS.compat(3) = nanmean(dat(trls3.HS.compat,1));
CAFaccs.HS.compat(4) = nanmean(dat(trls4.HS.compat,1));
CAFaccs.HS.compat(5) = nanmean(dat(trls5.HS.compat,1));
CAFaccs.HS.compat(6) = nanmean(dat(trls6.HS.compat,1));
CAFaccs.HS.compat(7) = nanmean(dat(trls7.HS.compat,1));
CAFaccs.HS.compat(8) = nanmean(dat(trls8.HS.compat,1));
CAFaccs.HS.compat(9) = nanmean(dat(trls9.HS.compat,1));
CAFaccs.HS.compat(10) = nanmean(dat(trls10.HS.compat,1));

CAF_rts.LS.incompat(1) = nanmean(dat(trls1.LS.incompat,2));
CAF_rts.LS.incompat(2) = nanmean(dat(trls2.LS.incompat,2));
CAF_rts.LS.incompat(3) = nanmean(dat(trls3.LS.incompat,2));
CAF_rts.LS.incompat(4) = nanmean(dat(trls4.LS.incompat,2));
CAF_rts.LS.incompat(5) = nanmean(dat(trls5.LS.incompat,2));
CAF_rts.LS.incompat(6) = nanmean(dat(trls6.LS.incompat,2));
CAF_rts.LS.incompat(7) = nanmean(dat(trls7.LS.incompat,2));
CAF_rts.LS.incompat(8) = nanmean(dat(trls8.LS.incompat,2));
CAF_rts.LS.incompat(9) = nanmean(dat(trls9.LS.incompat,2));
CAF_rts.LS.incompat(10) = nanmean(dat(trls10.LS.incompat,2));
 
CAFaccs.LS.incompat(1) = nanmean(dat(trls1.LS.incompat,1));
CAFaccs.LS.incompat(2) = nanmean(dat(trls2.LS.incompat,1));
CAFaccs.LS.incompat(3) = nanmean(dat(trls3.LS.incompat,1));
CAFaccs.LS.incompat(4) = nanmean(dat(trls4.LS.incompat,1));
CAFaccs.LS.incompat(5) = nanmean(dat(trls5.LS.incompat,1));
CAFaccs.LS.incompat(6) = nanmean(dat(trls6.LS.incompat,1));
CAFaccs.LS.incompat(7) = nanmean(dat(trls7.LS.incompat,1));
CAFaccs.LS.incompat(8) = nanmean(dat(trls8.LS.incompat,1));
CAFaccs.LS.incompat(9) = nanmean(dat(trls9.LS.incompat,1));
CAFaccs.LS.incompat(10) = nanmean(dat(trls10.LS.incompat,1));
 
CAF_rts.HS.incompat(1) = nanmean(dat(trls1.HS.incompat,2));
CAF_rts.HS.incompat(2) = nanmean(dat(trls2.HS.incompat,2));
CAF_rts.HS.incompat(3) = nanmean(dat(trls3.HS.incompat,2));
CAF_rts.HS.incompat(4) = nanmean(dat(trls4.HS.incompat,2));
CAF_rts.HS.incompat(5) = nanmean(dat(trls5.HS.incompat,2));
CAF_rts.HS.incompat(6) = nanmean(dat(trls6.HS.incompat,2));
CAF_rts.HS.incompat(7) = nanmean(dat(trls7.HS.incompat,2));
CAF_rts.HS.incompat(8) = nanmean(dat(trls8.HS.incompat,2));
CAF_rts.HS.incompat(9) = nanmean(dat(trls9.HS.incompat,2));
CAF_rts.HS.incompat(10) = nanmean(dat(trls10.HS.incompat,2));
 
CAFaccs.HS.incompat(1) = nanmean(dat(trls1.HS.incompat,1));
CAFaccs.HS.incompat(2) = nanmean(dat(trls2.HS.incompat,1));
CAFaccs.HS.incompat(3) = nanmean(dat(trls3.HS.incompat,1));
CAFaccs.HS.incompat(4) = nanmean(dat(trls4.HS.incompat,1));
CAFaccs.HS.incompat(5) = nanmean(dat(trls5.HS.incompat,1));
CAFaccs.HS.incompat(6) = nanmean(dat(trls6.HS.incompat,1));
CAFaccs.HS.incompat(7) = nanmean(dat(trls7.HS.incompat,1));
CAFaccs.HS.incompat(8) = nanmean(dat(trls8.HS.incompat,1));
CAFaccs.HS.incompat(9) = nanmean(dat(trls9.HS.incompat,1));
CAFaccs.HS.incompat(10) = nanmean(dat(trls10.HS.incompat,1));





n_correctCAF.LS.compat(1) = length(find(dat(trls1.LS.compat,1) == 1));
n_correctCAF.LS.compat(2) = length(find(dat(trls2.LS.compat,1) == 1));
n_correctCAF.LS.compat(3) = length(find(dat(trls3.LS.compat,1) == 1));
n_correctCAF.LS.compat(4) = length(find(dat(trls4.LS.compat,1) == 1));
n_correctCAF.LS.compat(5) = length(find(dat(trls5.LS.compat,1) == 1));
n_correctCAF.LS.compat(6) = length(find(dat(trls6.LS.compat,1) == 1));
n_correctCAF.LS.compat(7) = length(find(dat(trls7.LS.compat,1) == 1));
n_correctCAF.LS.compat(8) = length(find(dat(trls8.LS.compat,1) == 1));
n_correctCAF.LS.compat(9) = length(find(dat(trls9.LS.compat,1) == 1));
n_correctCAF.LS.compat(10) = length(find(dat(trls10.LS.compat,1) == 1));

n_errorCAF.LS.compat(1) = length(find(dat(trls1.LS.compat,1) == 0));
n_errorCAF.LS.compat(2) = length(find(dat(trls2.LS.compat,1) == 0));
n_errorCAF.LS.compat(3) = length(find(dat(trls3.LS.compat,1) == 0));
n_errorCAF.LS.compat(4) = length(find(dat(trls4.LS.compat,1) == 0));
n_errorCAF.LS.compat(5) = length(find(dat(trls5.LS.compat,1) == 0));
n_errorCAF.LS.compat(6) = length(find(dat(trls6.LS.compat,1) == 0));
n_errorCAF.LS.compat(7) = length(find(dat(trls7.LS.compat,1) == 0));
n_errorCAF.LS.compat(8) = length(find(dat(trls8.LS.compat,1) == 0));
n_errorCAF.LS.compat(9) = length(find(dat(trls9.LS.compat,1) == 0));
n_errorCAF.LS.compat(10) = length(find(dat(trls10.LS.compat,1) == 0));

 
n_correctCAF.HS.compat(1) = length(find(dat(trls1.HS.compat,1) == 1));
n_correctCAF.HS.compat(2) = length(find(dat(trls2.HS.compat,1) == 1));
n_correctCAF.HS.compat(3) = length(find(dat(trls3.HS.compat,1) == 1));
n_correctCAF.HS.compat(4) = length(find(dat(trls4.HS.compat,1) == 1));
n_correctCAF.HS.compat(5) = length(find(dat(trls5.HS.compat,1) == 1));
n_correctCAF.HS.compat(6) = length(find(dat(trls6.HS.compat,1) == 1));
n_correctCAF.HS.compat(7) = length(find(dat(trls7.HS.compat,1) == 1));
n_correctCAF.HS.compat(8) = length(find(dat(trls8.HS.compat,1) == 1));
n_correctCAF.HS.compat(9) = length(find(dat(trls9.HS.compat,1) == 1));
n_correctCAF.HS.compat(10) = length(find(dat(trls10.HS.compat,1) == 1));
 
n_errorCAF.HS.compat(1) = length(find(dat(trls1.HS.compat,1) == 0));
n_errorCAF.HS.compat(2) = length(find(dat(trls2.HS.compat,1) == 0));
n_errorCAF.HS.compat(3) = length(find(dat(trls3.HS.compat,1) == 0));
n_errorCAF.HS.compat(4) = length(find(dat(trls4.HS.compat,1) == 0));
n_errorCAF.HS.compat(5) = length(find(dat(trls5.HS.compat,1) == 0));
n_errorCAF.HS.compat(6) = length(find(dat(trls6.HS.compat,1) == 0));
n_errorCAF.HS.compat(7) = length(find(dat(trls7.HS.compat,1) == 0));
n_errorCAF.HS.compat(8) = length(find(dat(trls8.HS.compat,1) == 0));
n_errorCAF.HS.compat(9) = length(find(dat(trls9.HS.compat,1) == 0));
n_errorCAF.HS.compat(10) = length(find(dat(trls10.HS.compat,1) == 0));




n_correctCAF.LS.incompat(1) = length(find(dat(trls1.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(2) = length(find(dat(trls2.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(3) = length(find(dat(trls3.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(4) = length(find(dat(trls4.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(5) = length(find(dat(trls5.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(6) = length(find(dat(trls6.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(7) = length(find(dat(trls7.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(8) = length(find(dat(trls8.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(9) = length(find(dat(trls9.LS.incompat,1) == 1));
n_correctCAF.LS.incompat(10) = length(find(dat(trls10.LS.incompat,1) == 1));
 
n_errorCAF.LS.incompat(1) = length(find(dat(trls1.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(2) = length(find(dat(trls2.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(3) = length(find(dat(trls3.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(4) = length(find(dat(trls4.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(5) = length(find(dat(trls5.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(6) = length(find(dat(trls6.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(7) = length(find(dat(trls7.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(8) = length(find(dat(trls8.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(9) = length(find(dat(trls9.LS.incompat,1) == 0));
n_errorCAF.LS.incompat(10) = length(find(dat(trls10.LS.incompat,1) == 0));
 
 
n_correctCAF.HS.incompat(1) = length(find(dat(trls1.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(2) = length(find(dat(trls2.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(3) = length(find(dat(trls3.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(4) = length(find(dat(trls4.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(5) = length(find(dat(trls5.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(6) = length(find(dat(trls6.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(7) = length(find(dat(trls7.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(8) = length(find(dat(trls8.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(9) = length(find(dat(trls9.HS.incompat,1) == 1));
n_correctCAF.HS.incompat(10) = length(find(dat(trls10.HS.incompat,1) == 1));
 
n_errorCAF.HS.incompat(1) = length(find(dat(trls1.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(2) = length(find(dat(trls2.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(3) = length(find(dat(trls3.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(4) = length(find(dat(trls4.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(5) = length(find(dat(trls5.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(6) = length(find(dat(trls6.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(7) = length(find(dat(trls7.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(8) = length(find(dat(trls8.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(9) = length(find(dat(trls9.HS.incompat,1) == 0));
n_errorCAF.HS.incompat(10) = length(find(dat(trls10.HS.incompat,1) == 0));





figure
plot(rts.LS.compat,accs.LS.compat,'-ob',rts.HS.compat,accs.HS.compat,'-or', ...
    rts.LS.incompat,accs.LS.incompat,'--ob',rts.HS.incompat,accs.HS.incompat,'--or')
hold
plot(CAF_rts.LS.compat,CAFaccs.LS.compat,'-sb',CAF_rts.HS.compat,CAFaccs.HS.compat,'-sr', ...
    CAF_rts.LS.incompat,CAFaccs.LS.incompat,'--sb',CAF_rts.HS.incompat,CAFaccs.HS.incompat,'--sr')
box off

% % % % % 
% % % % % figure
% % % % % plot(rts,Acc2Dprime(accs),'-ob')
% % % % % hold
% % % % % plot(CAF_rts,Acc2Dprime(CAFaccs).^2,'-sr')
% % % % % box off
% % % % % title('d prime squared')
% % % % % 
% % % % % figure
% % % % % semilogy(rts,(n_correct./n_error),'-ob')
% % % % % hold
% % % % % semilogy(CAF_rts,(n_correctCAF./n_errorCAF),'-sr')
% % % % % box off
% % % % % title('log(odds)')
% % % % % 
% % % % % %================
% % % % % % Calculate CAFs for each deadline condition separately
% % % % % dex = 1;
% % % % % for dead = 200:100:700
% % % % %     cur_trls = find(dat(:,3) == dead);
% % % % %     cur_ntiles = prctile(dat(cur_trls,2),[10 20 30 40 50 60 70 80 90]);
% % % % %     
% % % % %     n1 = find(dat(cur_trls,2) <= cur_ntiles(1));
% % % % %     n2 = find(dat(cur_trls,2) > cur_ntiles(1) & dat(cur_trls,2) <= cur_ntiles(2));
% % % % %     n3 = find(dat(cur_trls,2) > cur_ntiles(2) & dat(cur_trls,2) <= cur_ntiles(3));
% % % % %     n4 = find(dat(cur_trls,2) > cur_ntiles(3) & dat(cur_trls,2) <= cur_ntiles(4));
% % % % %     n5 = find(dat(cur_trls,2) > cur_ntiles(4) & dat(cur_trls,2) <= cur_ntiles(5));
% % % % %     n6 = find(dat(cur_trls,2) > cur_ntiles(5) & dat(cur_trls,2) <= cur_ntiles(6));
% % % % %     n7 = find(dat(cur_trls,2) > cur_ntiles(6) & dat(cur_trls,2) <= cur_ntiles(7));
% % % % %     n8 = find(dat(cur_trls,2) > cur_ntiles(7) & dat(cur_trls,2) <= cur_ntiles(8));
% % % % %     n9 = find(dat(cur_trls,2) > cur_ntiles(8) & dat(cur_trls,2) <= cur_ntiles(9));
% % % % %     n10 = find(dat(cur_trls,2) > cur_ntiles(9));    
% % % % %     
% % % % %     dCAF_rts(dex,1) = nanmean(dat(cur_trls(n1),2));
% % % % %     dCAF_rts(dex,2) = nanmean(dat(cur_trls(n2),2));
% % % % %     dCAF_rts(dex,3) = nanmean(dat(cur_trls(n3),2));
% % % % %     dCAF_rts(dex,4) = nanmean(dat(cur_trls(n4),2));
% % % % %     dCAF_rts(dex,5) = nanmean(dat(cur_trls(n5),2));
% % % % %     dCAF_rts(dex,6) = nanmean(dat(cur_trls(n6),2));
% % % % %     dCAF_rts(dex,7) = nanmean(dat(cur_trls(n7),2));
% % % % %     dCAF_rts(dex,8) = nanmean(dat(cur_trls(n8),2));
% % % % %     dCAF_rts(dex,9) = nanmean(dat(cur_trls(n9),2));
% % % % %     dCAF_rts(dex,10) = nanmean(dat(cur_trls(n10),2));
% % % % %     
% % % % %     dCAF_accs(dex,1) = nanmean(dat(cur_trls(n1),1));
% % % % %     dCAF_accs(dex,2) = nanmean(dat(cur_trls(n2),1));
% % % % %     dCAF_accs(dex,3) = nanmean(dat(cur_trls(n3),1));
% % % % %     dCAF_accs(dex,4) = nanmean(dat(cur_trls(n4),1));
% % % % %     dCAF_accs(dex,5) = nanmean(dat(cur_trls(n5),1));
% % % % %     dCAF_accs(dex,6) = nanmean(dat(cur_trls(n6),1));
% % % % %     dCAF_accs(dex,7) = nanmean(dat(cur_trls(n7),1));
% % % % %     dCAF_accs(dex,8) = nanmean(dat(cur_trls(n8),1));
% % % % %     dCAF_accs(dex,9) = nanmean(dat(cur_trls(n9),1));
% % % % %     dCAF_accs(dex,10) = nanmean(dat(cur_trls(n10),1));
% % % % %     
% % % % %     %Count Sums to calculate log(odds)
% % % % %     dCAF_correct(dex,1) = length(find(dat(cur_trls(n1)) == 1));
% % % % %     dCAF_correct(dex,2) = length(find(dat(cur_trls(n2)) == 1));
% % % % %     dCAF_correct(dex,3) = length(find(dat(cur_trls(n3)) == 1));
% % % % %     dCAF_correct(dex,4) = length(find(dat(cur_trls(n4)) == 1));
% % % % %     dCAF_correct(dex,5) = length(find(dat(cur_trls(n5)) == 1));
% % % % %     dCAF_correct(dex,6) = length(find(dat(cur_trls(n6)) == 1));
% % % % %     dCAF_correct(dex,7) = length(find(dat(cur_trls(n7)) == 1));
% % % % %     dCAF_correct(dex,8) = length(find(dat(cur_trls(n8)) == 1));
% % % % %     dCAF_correct(dex,9) = length(find(dat(cur_trls(n9)) == 1));
% % % % %     dCAF_correct(dex,10) = length(find(dat(cur_trls(n10)) == 1));
% % % % %     
% % % % %     dCAF_error(dex,1) = length(find(dat(cur_trls(n1)) == 0));
% % % % %     dCAF_error(dex,2) = length(find(dat(cur_trls(n2)) == 0));
% % % % %     dCAF_error(dex,3) = length(find(dat(cur_trls(n3)) == 0));
% % % % %     dCAF_error(dex,4) = length(find(dat(cur_trls(n4)) == 0));
% % % % %     dCAF_error(dex,5) = length(find(dat(cur_trls(n5)) == 0));
% % % % %     dCAF_error(dex,6) = length(find(dat(cur_trls(n6)) == 0));
% % % % %     dCAF_error(dex,7) = length(find(dat(cur_trls(n7)) == 0));
% % % % %     dCAF_error(dex,8) = length(find(dat(cur_trls(n8)) == 0));
% % % % %     dCAF_error(dex,9) = length(find(dat(cur_trls(n9)) == 0));
% % % % %     dCAF_error(dex,10) = length(find(dat(cur_trls(n10)) == 0));
% % % % %     
% % % % % 
% % % % %     dex = dex + 1;
% % % % %     
% % % % %     clear cur_trls cur_ntiles n1 n2 n3 n4 n5
% % % % % end
% % % % % 
% % % % % figure
% % % % % plot(dCAF_rts',dCAF_accs','-o')
% % % % % box off
% % % % % 
% % % % % figure
% % % % % semilogy(dCAF_rts',(dCAF_correct ./dCAF_error)','-o')
% % % % % box off
% % % % % ylim([.5 100])
% % % % % % 
% % % % % % 
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% % % % % % [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)