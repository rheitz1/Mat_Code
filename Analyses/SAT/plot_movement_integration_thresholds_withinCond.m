k = leak(:);


for whichLeak = 1:length(k)
    triggerVal_made.slow_correct_binSlow(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,threshwin,whichLeak),2);
    triggerVal_made.slow_correct_binMed(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,threshwin,whichLeak),2);
    triggerVal_made.slow_correct_binFast(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,threshwin,whichLeak),2);
    
    triggerVal_missed.slow_correct_binSlow(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,threshwin,whichLeak),2);
    triggerVal_missed.slow_correct_binMed(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,threshwin,whichLeak),2);
    triggerVal_missed.slow_correct_binFast(1:84,whichLeak) = nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,threshwin,whichLeak),2);
    
    
    triggerVal_made.med_correct_binSlow(1:84,whichLeak) = nanmean(leaky_integrated_in.med_correct_binSlow(:,threshwin,whichLeak),2);
    triggerVal_made.med_correct_binMed(1:84,whichLeak) = nanmean(leaky_integrated_in.med_correct_binMed(:,threshwin,whichLeak),2);
    triggerVal_made.med_correct_binFast(1:84,whichLeak) = nanmean(leaky_integrated_in.med_correct_binFast(:,threshwin,whichLeak),2);
    
    
    triggerVal_made.fast_correct_binSlow(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,threshwin,whichLeak),2);
    triggerVal_made.fast_correct_binMed(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,threshwin,whichLeak),2);
    triggerVal_made.fast_correct_binFast(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,threshwin,whichLeak),2);
    
    triggerVal_missed.fast_correct_binSlow(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,threshwin,whichLeak),2);
    triggerVal_missed.fast_correct_binMed(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,threshwin,whichLeak),2);
    triggerVal_missed.fast_correct_binFast(1:84,whichLeak) = nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,threshwin,whichLeak),2);

    
end

figure

subplot(2,2,1)
hold on
scatter(nanmean(triggerVal_made.slow_correct_binFast,1),nanmean(triggerVal_made.slow_correct_binSlow,1),'r')
scatter(nanmean(triggerVal_made.slow_correct_binFast,1),nanmean(triggerVal_made.slow_correct_binMed,1),'g')
scatter(nanmean(triggerVal_missed.slow_correct_binFast,1),nanmean(triggerVal_missed.slow_correct_binSlow,1),'b')
scatter(nanmean(triggerVal_missed.slow_correct_binFast,1),nanmean(triggerVal_missed.slow_correct_binMed,1),'y')
xlabel('Movement Trigger FastBins')
ylabel('Movement Trigger SlowBins / MedBins')

%put in example point
mS = nanmean(triggerVal_made.slow_correct_binSlow,1);
mM = nanmean(triggerVal_made.slow_correct_binMed,1);
mF = nanmean(triggerVal_made.slow_correct_binFast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')

mS = nanmean(triggerVal_missed.slow_correct_binSlow,1);
mM = nanmean(triggerVal_missed.slow_correct_binMed,1);
mF = nanmean(triggerVal_missed.slow_correct_binFast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')


cf1 = fit(nanmean(triggerVal_made.slow_correct_binFast,1)',nanmean(triggerVal_made.slow_correct_binSlow,1)','cubicinterp');
cf2 = fit(nanmean(triggerVal_made.slow_correct_binFast,1)',nanmean(triggerVal_made.slow_correct_binMed,1)','cubicinterp');
cf3 = fit(nanmean(triggerVal_missed.slow_correct_binFast,1)',nanmean(triggerVal_missed.slow_correct_binSlow,1)','cubicinterp');
cf4 = fit(nanmean(triggerVal_missed.slow_correct_binFast,1)',nanmean(triggerVal_missed.slow_correct_binMed,1)','cubicinterp');

h1 = plot(cf1,'fit');
h2 = plot(cf2,'fit');
h3 = plot(cf3,'fit');
h4 = plot(cf4,'fit');

set(h1,'color','r')
set(h2,'color','g')
set(h3,'color','b','linestyle','--')
set(h4,'color','y','linestyle','--')

xlim([-20 350])
ylim([-20 350])
dline
legend off
title('Accurate Condition')


subplot(2,2,2)
hold on
scatter(nanmean(triggerVal_made.med_correct_binFast,1),nanmean(triggerVal_made.med_correct_binSlow,1),'r')
scatter(nanmean(triggerVal_made.med_correct_binFast,1),nanmean(triggerVal_made.med_correct_binMed,1),'k')
xlabel('Movement Trigger FastBins')
ylabel('Movement Trigger SlowBins / MedBins')

%put in example point
mS = nanmean(triggerVal_made.med_correct_binSlow,1);
mM = nanmean(triggerVal_made.med_correct_binMed,1);
mF = nanmean(triggerVal_made.med_correct_binFast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')


cf1 = fit(nanmean(triggerVal_made.med_correct_binFast,1)',nanmean(triggerVal_made.med_correct_binSlow,1)','cubicinterp');
cf2 = fit(nanmean(triggerVal_made.med_correct_binFast,1)',nanmean(triggerVal_made.med_correct_binMed,1)','cubicinterp');

h1 = plot(cf1,'fit');
h2 = plot(cf2,'fit');

set(h1,'color','r')
set(h2,'color','k')

xlim([-20 350])
ylim([-20 350])
dline
legend off
title('Neutral Condition')



subplot(2,2,3)
hold on
scatter(nanmean(triggerVal_made.fast_correct_binFast,1),nanmean(triggerVal_made.fast_correct_binSlow,1),'r')
scatter(nanmean(triggerVal_made.fast_correct_binFast,1),nanmean(triggerVal_made.fast_correct_binMed,1),'g')
scatter(nanmean(triggerVal_missed.fast_correct_binFast,1),nanmean(triggerVal_missed.fast_correct_binSlow,1),'b')
scatter(nanmean(triggerVal_missed.fast_correct_binFast,1),nanmean(triggerVal_missed.fast_correct_binMed,1),'y')
xlabel('Movement Trigger FastBins')
ylabel('Movement Trigger SlowBins / MedBins')

%put in example point
mS = nanmean(triggerVal_made.fast_correct_binSlow,1);
mM = nanmean(triggerVal_made.fast_correct_binMed,1);
mF = nanmean(triggerVal_made.fast_correct_binFast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')

mS = nanmean(triggerVal_missed.fast_correct_binSlow,1);
mM = nanmean(triggerVal_missed.fast_correct_binMed,1);
mF = nanmean(triggerVal_missed.fast_correct_binFast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')

cf1 = fit(nanmean(triggerVal_made.fast_correct_binFast,1)',nanmean(triggerVal_made.fast_correct_binSlow,1)','cubicinterp');
cf2 = fit(nanmean(triggerVal_made.fast_correct_binFast,1)',nanmean(triggerVal_made.fast_correct_binMed,1)','cubicinterp');
cf3 = fit(nanmean(triggerVal_missed.fast_correct_binFast,1)',nanmean(triggerVal_missed.fast_correct_binSlow,1)','cubicinterp');
cf4 = fit(nanmean(triggerVal_missed.fast_correct_binFast,1)',nanmean(triggerVal_missed.fast_correct_binMed,1)','cubicinterp');

h1 = plot(cf1,'fit');
h2 = plot(cf2,'fit');
h3 = plot(cf3,'fit');
h4 = plot(cf4,'fit');

set(h1,'color','r')
set(h2,'color','g')
set(h3,'color','b','linestyle','--')
set(h4,'color','y','linestyle','--')

xlim([-20 350])
ylim([-20 350])
dline
legend off
title('Fast Condition')