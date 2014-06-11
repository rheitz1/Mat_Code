
%%%%%
% WITH BASELINE CORRECTION
%%%%%%
load S_overlap_SameElectrode
%load S_overlap_DifferentElectrode
%load S_nooverlap_SameElectrode
%load S_nooverlap_DifferentElectrode

%call script
plot_grand_average_coh


sem.corr = nanstd(alldif_bc,1,2) / sqrt(sum(~isnan(alldif_bc(1,:))));
sem.err = nanstd(errdif_bc,1,2) / sqrt(sum(~isnan(errdif_bc(1,:))));
sem.ss2 = nanstd(s2dif_bc,1,2) / sqrt(sum(~isnan(s2dif_bc(1,:))));
sem.ss4 = nanstd(s4dif_bc,1,2) / sqrt(sum(~isnan(s4dif_bc(1,:))));
sem.ss8 = nanstd(s8dif_bc,1,2) / sqrt(sum(~isnan(s8dif_bc(1,:))));
sem.fast = nanstd(fsdif_bc,1,2) / sqrt(sum(~isnan(fsdif_bc(1,:))));
sem.slow = nanstd(sldif_bc,1,2) / sqrt(sum(~isnan(sldif_bc(1,:))));


sempos.corr = nanmean(alldif_bc,2) + sem.corr;
sempos.err = nanmean(errdif_bc,2) + sem.err;
sempos.s2 = nanmean(s2dif_bc,2) + sem.ss2;
sempos.s4 = nanmean(s4dif_bc,2) + sem.ss4;
sempos.s8 = nanmean(s8dif_bc,2) + sem.ss8;
sempos.fast = nanmean(fsdif_bc,2) + sem.fast;
sempos.slow = nanmean(sldif_bc,2) + sem.slow;


semneg.corr = nanmean(alldif_bc,2) - sem.corr;
semneg.err = nanmean(errdif_bc,2) - sem.err;
semneg.s2 = nanmean(s2dif_bc,2) - sem.ss2;
semneg.s4 = nanmean(s4dif_bc,2) - sem.ss4;
semneg.s8 = nanmean(s8dif_bc,2) - sem.ss8;
semneg.fast = nanmean(fsdif_bc,2) - sem.fast;
semneg.slow = nanmean(sldif_bc,2) - sem.slow;

figure
plot(tout,nanmean(s2dif_bc,2),'b',tout,nanmean(s4dif_bc,2),'r',tout,nanmean(s8dif_bc,2),'g')
hold on
plot(tout,sempos.s2,'--b',tout,sempos.s4,'--r',tout,sempos.s8,'--g')
plot(tout,semneg.s2,'--b',tout,semneg.s4,'--r',tout,semneg.s8,'--g')
xlim([-50 500])
hline(0,'k')
title('S Tin - Din Full Baseline Correction')
z.setsize = get(gca,'ylim');

figure
plot(tout,nanmean(fsdif_bc,2),'r',tout,nanmean(sldif_bc,2),'b')
hold on
plot(tout,sempos.fast,'--r',tout,sempos.slow,'--b')
plot(tout,semneg.fast,'--r',tout,semneg.slow,'--b')
vline(time_fast_bc,'r')
vline(time_slow_bc,'b')
xlim([-50 500])
hline(0,'k')
title('S Baseline corrected, full data set')
z.fast_slow = get(gca,'ylim');

figure
plot(tout,nanmean(alldif_bc,2),'k',tout,nanmean(errdif_bc,2),'r')
hold on
plot(tout,sempos.corr,'--k',tout,sempos.err,'--r')
plot(tout,semneg.corr,'--k',tout,semneg.err,'--r')
xlim([-50 500])
hline(0,'k')
title('S Errors Full Baseline Correction')
z.corr_err = get(gca,'ylim');




keep z

load Q_overlap_SameElectrode
%load Q_overlap_DifferentElectrode
%load Q_nooverlap_SameElectrode
%load Q_nooveralp_DifferentElectrode

plot_grand_average_coh


sem.corr = nanstd(alldif_bc,1,2) / sqrt(sum(nsig.all));
sem.err = nanstd(errdif_bc,1,2) / sqrt(sum(nsig.all));
sem.ss2 = nanstd(s2dif_bc,1,2) / sqrt(sum(nsig.all));
sem.ss4 = nanstd(s4dif_bc,1,2) / sqrt(sum(nsig.all));
sem.ss8 = nanstd(s8dif_bc,1,2) / sqrt(sum(nsig.all));
sem.fast = nanstd(fsdif_bc,1,2) / sqrt(sum(nsig.all));
sem.slow = nanstd(sldif_bc,1,2) / sqrt(sum(nsig.all));


sempos.corr = nanmean(alldif_bc,2) + sem.corr;
sempos.err = nanmean(errdif_bc,2) + sem.err;
sempos.s2 = nanmean(s2dif_bc,2) + sem.ss2;
sempos.s4 = nanmean(s4dif_bc,2) + sem.ss4;
sempos.s8 = nanmean(s8dif_bc,2) + sem.ss8;
sempos.fast = nanmean(fsdif_bc,2) + sem.fast;
sempos.slow = nanmean(sldif_bc,2) + sem.slow;


semneg.corr = nanmean(alldif_bc,2) - sem.corr;
semneg.err = nanmean(errdif_bc,2) - sem.err;
semneg.s2 = nanmean(s2dif_bc,2) - sem.ss2;
semneg.s4 = nanmean(s4dif_bc,2) - sem.ss4;
semneg.s8 = nanmean(s8dif_bc,2) - sem.ss8;
semneg.fast = nanmean(fsdif_bc,2) - sem.fast;
semneg.slow = nanmean(sldif_bc,2) - sem.slow;

figure
plot(tout,nanmean(s2dif_bc,2),'b',tout,nanmean(s4dif_bc,2),'r',tout,nanmean(s8dif_bc,2),'g')
hold on
plot(tout,sempos.s2,'--b',tout,sempos.s4,'--r',tout,sempos.s8,'--g')
plot(tout,semneg.s2,'--b',tout,semneg.s4,'--r',tout,semneg.s8,'--g')
xlim([-200 500])
hline(0,'k')
title('Q Tin - Din Full Baseline Correction')
ylim(z.setsize)

figure
plot(tout,nanmean(fsdif_bc,2),'r',tout,nanmean(sldif_bc,2),'b')
hold on
plot(tout,sempos.fast,'--r',tout,sempos.slow,'--b')
plot(tout,semneg.fast,'--r',tout,semneg.slow,'--b')
vline(time_fast_bc,'r')
vline(time_slow_bc,'b')
xlim([-200 500])
hline(0,'k')
title('Q Baseline corrected, full data set')
ylim(z.fast_slow)


figure
plot(tout,nanmean(alldif_bc,2),'k',tout,nanmean(allsubdif_bc,2),'--k',tout,nanmean(errdif_bc,2),'r')
hold on
plot(tout,sempos.corr,'--k',tout,sempos.err,'--r')
plot(tout,semneg.corr,'--k',tout,semneg.err,'--r')
xlim([-200 500])
hline(0,'k')
title('Q Errors Full Baseline Correction')
ylim(z.corr_err)