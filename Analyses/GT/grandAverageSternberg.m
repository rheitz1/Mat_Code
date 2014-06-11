%Loads Sternberg data and then computes grand averages for HS and LS
%subjects (LS == sessions 1 - 8;  HS == sessions 9 - 20)

load('/volumes/Dump/GT_EEG_Data/Sternberg_All.mat','-mat')

VEP_Oz.LS = baseline_correct(nanmean(VEP_Oz_all(1:8,:)),[250 300]);
SS1_Oz.LS = baseline_correct(nanmean(SS1_Oz_all(1:8,:)),[250 300]);
SS2_Oz.LS = baseline_correct(nanmean(SS2_Oz_all(1:8,:)),[250 300]);
SS3_Oz.LS = baseline_correct(nanmean(SS3_Oz_all(1:8,:)),[250 300]);
SS4_Oz.LS = baseline_correct(nanmean(SS4_Oz_all(1:8,:)),[250 300]);
SS5_Oz.LS = baseline_correct(nanmean(SS5_Oz_all(1:8,:)),[250 300]);
SS6_Oz.LS = baseline_correct(nanmean(SS6_Oz_all(1:8,:)),[250 300]);
SS7_Oz.LS = baseline_correct(nanmean(SS7_Oz_all(1:8,:)),[250 300]);

VEP_Oz.HS = baseline_correct(nanmean(VEP_Oz_all(9:end,:)),[250 300]);
SS1_Oz.HS = baseline_correct(nanmean(SS1_Oz_all(9:end,:)),[250 300]);
SS2_Oz.HS = baseline_correct(nanmean(SS2_Oz_all(9:end,:)),[250 300]);
SS3_Oz.HS = baseline_correct(nanmean(SS3_Oz_all(9:end,:)),[250 300]);
SS4_Oz.HS = baseline_correct(nanmean(SS4_Oz_all(9:end,:)),[250 300]);
SS5_Oz.HS = baseline_correct(nanmean(SS5_Oz_all(9:end,:)),[250 300]);
SS6_Oz.HS = baseline_correct(nanmean(SS6_Oz_all(9:end,:)),[250 300]);
SS7_Oz.HS = baseline_correct(nanmean(SS7_Oz_all(9:end,:)),[250 300]);

VEP_O1.LS = baseline_correct(nanmean(VEP_O1_all(1:8,:)),[250 300]);
SS1_O1.LS = baseline_correct(nanmean(SS1_O1_all(1:8,:)),[250 300]);
SS2_O1.LS = baseline_correct(nanmean(SS2_O1_all(1:8,:)),[250 300]);
SS3_O1.LS = baseline_correct(nanmean(SS3_O1_all(1:8,:)),[250 300]);
SS4_O1.LS = baseline_correct(nanmean(SS4_O1_all(1:8,:)),[250 300]);
SS5_O1.LS = baseline_correct(nanmean(SS5_O1_all(1:8,:)),[250 300]);
SS6_O1.LS = baseline_correct(nanmean(SS6_O1_all(1:8,:)),[250 300]);
SS7_O1.LS = baseline_correct(nanmean(SS7_O1_all(1:8,:)),[250 300]);

VEP_O1.HS = baseline_correct(nanmean(VEP_O1_all(9:end,:)),[250 300]);
SS1_O1.HS = baseline_correct(nanmean(SS1_O1_all(9:end,:)),[250 300]);
SS2_O1.HS = baseline_correct(nanmean(SS2_O1_all(9:end,:)),[250 300]);
SS3_O1.HS = baseline_correct(nanmean(SS3_O1_all(9:end,:)),[250 300]);
SS4_O1.HS = baseline_correct(nanmean(SS4_O1_all(9:end,:)),[250 300]);
SS5_O1.HS = baseline_correct(nanmean(SS5_O1_all(9:end,:)),[250 300]);
SS6_O1.HS = baseline_correct(nanmean(SS6_O1_all(9:end,:)),[250 300]);
SS7_O1.HS = baseline_correct(nanmean(SS7_O1_all(9:end,:)),[250 300]);

VEP_O2.LS = baseline_correct(nanmean(VEP_O2_all(1:8,:)),[250 300]);
SS1_O2.LS = baseline_correct(nanmean(SS1_O2_all(1:8,:)),[250 300]);
SS2_O2.LS = baseline_correct(nanmean(SS2_O2_all(1:8,:)),[250 300]);
SS3_O2.LS = baseline_correct(nanmean(SS3_O2_all(1:8,:)),[250 300]);
SS4_O2.LS = baseline_correct(nanmean(SS4_O2_all(1:8,:)),[250 300]);
SS5_O2.LS = baseline_correct(nanmean(SS5_O2_all(1:8,:)),[250 300]);
SS6_O2.LS = baseline_correct(nanmean(SS6_O2_all(1:8,:)),[250 300]);
SS7_O2.LS = baseline_correct(nanmean(SS7_O2_all(1:8,:)),[250 300]);

VEP_O2.HS = baseline_correct(nanmean(VEP_O2_all(9:end,:)),[250 300]);
SS1_O2.HS = baseline_correct(nanmean(SS1_O2_all(9:end,:)),[250 300]);
SS2_O2.HS = baseline_correct(nanmean(SS2_O2_all(9:end,:)),[250 300]);
SS3_O2.HS = baseline_correct(nanmean(SS3_O2_all(9:end,:)),[250 300]);
SS4_O2.HS = baseline_correct(nanmean(SS4_O2_all(9:end,:)),[250 300]);
SS5_O2.HS = baseline_correct(nanmean(SS5_O2_all(9:end,:)),[250 300]);
SS6_O2.HS = baseline_correct(nanmean(SS6_O2_all(9:end,:)),[250 300]);
SS7_O2.HS = baseline_correct(nanmean(SS7_O2_all(9:end,:)),[250 300]);


figure
subplot(3,2,1)
plot(plottime,SS1_Oz.LS,'r',plottime,SS2_Oz.LS,'g',plottime,SS3_Oz.LS,'b',plottime, ...
    SS4_Oz.LS,'--r',plottime,SS5_Oz.LS,'--g',plottime,SS6_Oz.LS,'--b',plottime,SS7_Oz.LS,'--k')
legend('SS1','SS2','SS3','SS4','SS5','SS6','SS7')
title('Low Span Oz')
axis ij
xlim([-200 500])

subplot(3,2,2)
plot(plottime,SS1_Oz.HS,'r',plottime,SS2_Oz.HS,'g',plottime,SS3_Oz.HS,'b',plottime, ...
    SS4_Oz.HS,'--r',plottime,SS5_Oz.HS,'--g',plottime,SS6_Oz.HS,'--b',plottime,SS7_Oz.HS,'--k')
title('High Span Oz')
axis ij
xlim([-200 500])

subplot(3,2,3)
plot(plottime,SS1_O1.LS,'r',plottime,SS2_O1.LS,'g',plottime,SS3_O1.LS,'b',plottime, ...
    SS4_O1.LS,'--r',plottime,SS5_O1.LS,'--g',plottime,SS6_O1.LS,'--b',plottime,SS7_O1.LS,'--k')
title('Low Span O1')
axis ij
xlim([-200 500])

subplot(3,2,4)
plot(plottime,SS1_O1.HS,'r',plottime,SS2_O1.HS,'g',plottime,SS3_O1.HS,'b',plottime, ...
    SS4_O1.HS,'--r',plottime,SS5_O1.HS,'--g',plottime,SS6_O1.HS,'--b',plottime,SS7_O1.HS,'--k')
title('High Span O1')
axis ij
xlim([-200 500])

subplot(3,2,5)
plot(plottime,SS1_O2.LS,'r',plottime,SS2_O2.LS,'g',plottime,SS3_O2.LS,'b',plottime, ...
    SS4_O2.LS,'--r',plottime,SS5_O2.LS,'--g',plottime,SS6_O2.LS,'--b',plottime,SS7_O2.LS,'--k')
title('Low Span O2')
axis ij
xlim([-200 500])

subplot(3,2,6)
plot(plottime,SS1_O2.HS,'r',plottime,SS2_O2.HS,'g',plottime,SS3_O2.HS,'b',plottime, ...
    SS4_O2.HS,'--r',plottime,SS5_O2.HS,'--g',plottime,SS6_O2.HS,'--b',plottime,SS7_O2.HS,'--k')
title('High Span O2')
axis ij
xlim([-200 500])
