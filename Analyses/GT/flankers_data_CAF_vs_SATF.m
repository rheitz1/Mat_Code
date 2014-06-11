
cd /Volumes/Dump/Flankers_Data_GT/
load Flankers_5050_8020_incompat_only.mat


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
d200 = find(dat(:,3) == 200);
d300 = find(dat(:,3) == 300);
d400 = find(dat(:,3) == 400);
d500 = find(dat(:,3) == 500);
d600 = find(dat(:,3) == 600);
d700 = find(dat(:,3) == 700);


d200_rt = nanmean(dat(d200,2));
d300_rt = nanmean(dat(d300,2));
d400_rt = nanmean(dat(d400,2));
d500_rt = nanmean(dat(d500,2));
d600_rt = nanmean(dat(d600,2));
d700_rt = nanmean(dat(d700,2));

d200_acc = nanmean(dat(d200,1));
d300_acc = nanmean(dat(d300,1));
d400_acc = nanmean(dat(d400,1));
d500_acc = nanmean(dat(d500,1));
d600_acc = nanmean(dat(d600,1));
d700_acc = nanmean(dat(d700,1));

n_correct(1) = length(find(dat(d200,1) == 1));
n_correct(2) = length(find(dat(d300,1) == 1));
n_correct(3) = length(find(dat(d400,1) == 1));
n_correct(4) = length(find(dat(d500,1) == 1));
n_correct(5) = length(find(dat(d600,1) == 1));
n_correct(6) = length(find(dat(d700,1) == 1));


n_error(1) = length(find(dat(d200,1) == 0));
n_error(2) = length(find(dat(d300,1) == 0));
n_error(3) = length(find(dat(d400,1) == 0));
n_error(4) = length(find(dat(d500,1) == 0));
n_error(5) = length(find(dat(d600,1) == 0));
n_error(6) = length(find(dat(d700,1) == 0));



deadlines = [200:100:700];
rts = [d200_rt d300_rt d400_rt d500_rt d600_rt d700_rt];
accs = [d200_acc d300_acc d400_acc d500_acc d600_acc d700_acc];


%===========
% Overall CAF
ntiles = prctile(dat(:,2),[10 20 30 40 50 60 70 80 90]);
trls1 = find(dat(:,2) <= ntiles(1));
trls2 = find(dat(:,2) > ntiles(1) & dat(:,2) <= ntiles(2));
trls3 = find(dat(:,2) > ntiles(2) & dat(:,2) <= ntiles(3));
trls4 = find(dat(:,2) > ntiles(3) & dat(:,2) <= ntiles(4));
trls5 = find(dat(:,2) > ntiles(4) & dat(:,2) <= ntiles(5));
trls6 = find(dat(:,2) > ntiles(5) & dat(:,2) <= ntiles(6));
trls7 = find(dat(:,2) > ntiles(6) & dat(:,2) <= ntiles(7));
trls8 = find(dat(:,2) > ntiles(7) & dat(:,2) <= ntiles(8));
trls9 = find(dat(:,2) > ntiles(8) & dat(:,2) <= ntiles(9));
trls10 = find(dat(:,2) > ntiles(9));


CAF_rts(1) = nanmean(dat(trls1,2));
CAF_rts(2) = nanmean(dat(trls2,2));
CAF_rts(3) = nanmean(dat(trls3,2));
CAF_rts(4) = nanmean(dat(trls4,2));
CAF_rts(5) = nanmean(dat(trls5,2));
CAF_rts(6) = nanmean(dat(trls6,2));
CAF_rts(7) = nanmean(dat(trls7,2));
CAF_rts(8) = nanmean(dat(trls8,2));
CAF_rts(9) = nanmean(dat(trls9,2));
CAF_rts(10) = nanmean(dat(trls10,2));

CAFaccs(1) = nanmean(dat(trls1,1));
CAFaccs(2) = nanmean(dat(trls2,1));
CAFaccs(3) = nanmean(dat(trls3,1));
CAFaccs(4) = nanmean(dat(trls4,1));
CAFaccs(5) = nanmean(dat(trls5,1));
CAFaccs(6) = nanmean(dat(trls6,1));
CAFaccs(7) = nanmean(dat(trls7,1));
CAFaccs(8) = nanmean(dat(trls8,1));
CAFaccs(9) = nanmean(dat(trls9,1));
CAFaccs(10) = nanmean(dat(trls10,1));

n_correctCAF(1) = length(find(dat(trls1,1) == 1));
n_correctCAF(2) = length(find(dat(trls2,1) == 1));
n_correctCAF(3) = length(find(dat(trls3,1) == 1));
n_correctCAF(4) = length(find(dat(trls4,1) == 1));
n_correctCAF(5) = length(find(dat(trls5,1) == 1));
n_correctCAF(6) = length(find(dat(trls6,1) == 1));
n_correctCAF(7) = length(find(dat(trls7,1) == 1));
n_correctCAF(8) = length(find(dat(trls8,1) == 1));
n_correctCAF(9) = length(find(dat(trls9,1) == 1));
n_correctCAF(10) = length(find(dat(trls10,1) == 1));

n_errorCAF(1) = length(find(dat(trls1,1) == 0));
n_errorCAF(2) = length(find(dat(trls2,1) == 0));
n_errorCAF(3) = length(find(dat(trls3,1) == 0));
n_errorCAF(4) = length(find(dat(trls4,1) == 0));
n_errorCAF(5) = length(find(dat(trls5,1) == 0));
n_errorCAF(6) = length(find(dat(trls6,1) == 0));
n_errorCAF(7) = length(find(dat(trls7,1) == 0));
n_errorCAF(8) = length(find(dat(trls8,1) == 0));
n_errorCAF(9) = length(find(dat(trls9,1) == 0));
n_errorCAF(10) = length(find(dat(trls10,1) == 0));



figure
plot(rts,accs,'-ob')
hold
plot(CAF_rts,CAFaccs,'-sr')
box off


figure
plot(rts,Acc2Dprime(accs),'-ob')
hold
plot(CAF_rts,Acc2Dprime(CAFaccs).^2,'-sr')
box off
title('d prime squared')

figure
semilogy(rts,(n_correct./n_error),'-ob')
hold
semilogy(CAF_rts,(n_correctCAF./n_errorCAF),'-sr')
box off
title('log(odds)')

%================
% Calculate CAFs for each deadline condition separately
dex = 1;
for dead = 200:100:700
    cur_trls = find(dat(:,3) == dead);
    cur_ntiles = prctile(dat(cur_trls,2),[20 40 60 80]);
    
    n1 = find(dat(cur_trls,2) <= cur_ntiles(1));
    n2 = find(dat(cur_trls,2) > cur_ntiles(1) & dat(cur_trls,2) <= cur_ntiles(2));
    n3 = find(dat(cur_trls,2) > cur_ntiles(2) & dat(cur_trls,2) <= cur_ntiles(3));
    n4 = find(dat(cur_trls,2) > cur_ntiles(3) & dat(cur_trls,2) <= cur_ntiles(4));
    n5 = find(dat(cur_trls,2) > cur_ntiles(4));
    
    dCAF_rts(dex,1) = nanmean(dat(cur_trls(n1),2));
    dCAF_rts(dex,2) = nanmean(dat(cur_trls(n2),2));
    dCAF_rts(dex,3) = nanmean(dat(cur_trls(n3),2));
    dCAF_rts(dex,4) = nanmean(dat(cur_trls(n4),2));
    dCAF_rts(dex,5) = nanmean(dat(cur_trls(n5),2));

    dCAF_accs(dex,1) = nanmean(dat(cur_trls(n1),1));
    dCAF_accs(dex,2) = nanmean(dat(cur_trls(n2),1));
    dCAF_accs(dex,3) = nanmean(dat(cur_trls(n3),1));
    dCAF_accs(dex,4) = nanmean(dat(cur_trls(n4),1));
    dCAF_accs(dex,5) = nanmean(dat(cur_trls(n5),1));
    
    %Count Sums to calculate log(odds)
    dCAF_correct(dex,1) = length(find(dat(cur_trls(n1)) == 1));
    dCAF_correct(dex,2) = length(find(dat(cur_trls(n2)) == 1));
    dCAF_correct(dex,3) = length(find(dat(cur_trls(n3)) == 1));
    dCAF_correct(dex,4) = length(find(dat(cur_trls(n4)) == 1));
    dCAF_correct(dex,5) = length(find(dat(cur_trls(n5)) == 1));
    
    dCAF_error(dex,1) = length(find(dat(cur_trls(n1)) == 0));
    dCAF_error(dex,2) = length(find(dat(cur_trls(n2)) == 0));
    dCAF_error(dex,3) = length(find(dat(cur_trls(n3)) == 0));
    dCAF_error(dex,4) = length(find(dat(cur_trls(n4)) == 0));
    dCAF_error(dex,5) = length(find(dat(cur_trls(n5)) == 0));

    dex = dex + 1;
    
    clear cur_trls cur_ntiles n1 n2 n3 n4 n5
end

figure
plot(dCAF_rts',dCAF_accs','-o')
box off
title('Standard CAFs split by deadline condition')

figure
semilogy(dCAF_rts',(dCAF_correct ./dCAF_error)','-o')
box off
ylim([.5 100])
title('log-odds split by deadline condition')
% 
% 
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)
% [m(1) b(1) R(1)] = log_regression((dCAF_correct(:,1)./dCAF_error(:,1)),dCAF_rts(:,2),1,1)