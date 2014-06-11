% Plots movement integrator time-averages w/ CI's.  Can also quickly change 'cis' to 'sems' for different
% approach.  Must be run AFTER script 'movement_integration_leakage'

figure
subplot(2,2,1)

plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead(:,:,ex_leak),1),'r', ...
-1000:200,nanmean(leaky_integrated_in.med_correct(:,:,ex_leak),1),'k', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead(:,:,ex_leak),1),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Correct Made Dead')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hold
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead(:,:,ex_leak),1),'--r', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead(:,:,ex_leak),1),'--g')

line([-15 -15],[nanmean(allThresh.slow_correct_made_dead) - cis.slow_correct_made_dead ...
    nanmean(allThresh.slow_correct_made_dead) + cis.slow_correct_made_dead],'color','r')
line([-15 -15],[nanmean(allThresh.med_correct) - cis.med_correct ...
    nanmean(allThresh.med_correct) + cis.med_correct],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead) - cis.fast_correct_made_dead ...
    nanmean(allThresh.fast_correct_made_dead) + cis.fast_correct_made_dead],'color','g')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead) - cis.slow_correct_missed_dead ...
    nanmean(allThresh.slow_correct_missed_dead) + cis.slow_correct_missed_dead],'color','r')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead) - cis.fast_correct_missed_dead ...
    nanmean(allThresh.fast_correct_missed_dead) + cis.fast_correct_missed_dead],'color','g')

[h p] = ttest(allThresh.slow_correct_made_dead,allThresh.fast_correct_made_dead)
[h p] = ttest(allThresh.slow_correct_made_dead,allThresh.med_correct)
[h p] = ttest(allThresh.med_correct,allThresh.fast_correct_made_dead)

[h p] = ttest(allThresh.slow_correct_missed_dead,allThresh.fast_correct_missed_dead)
[h p] = ttest(allThresh.slow_correct_missed_dead,allThresh.med_correct)
[h p] = ttest(allThresh.med_correct,allThresh.fast_correct_missed_dead)




figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_leak),1),'r')
 

xlim([-1000 0])
ylim([0 100])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
 
hold on
 
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,:,ex_leak),1),'--g', ...
-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,:,ex_leak),1),'--k', ...
-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,:,ex_leak),1),'--r')
 
 
line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binSlow) - cis.slow_correct_made_dead_binSlow ...
    nanmean(allThresh.slow_correct_made_dead_binSlow) + cis.slow_correct_made_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binMed) - cis.slow_correct_made_dead_binMed ...
    nanmean(allThresh.slow_correct_made_dead_binMed) + cis.slow_correct_made_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binFast) - cis.slow_correct_made_dead_binFast ...
    nanmean(allThresh.slow_correct_made_dead_binFast) + cis.slow_correct_made_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binSlow) - cis.slow_correct_missed_dead_binSlow ...
    nanmean(allThresh.slow_correct_missed_dead_binSlow) + cis.slow_correct_missed_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binMed) - cis.slow_correct_missed_dead_binMed ...
    nanmean(allThresh.slow_correct_missed_dead_binMed) + cis.slow_correct_missed_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binFast) - cis.slow_correct_missed_dead_binFast ...
    nanmean(allThresh.slow_correct_missed_dead_binFast) + cis.slow_correct_missed_dead_binFast],'color','g')



subplot(2,2,2)
plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),1),'g', ...
-1000:200,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),1),'k', ...
-1000:200,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),1),'r')

line([-15 -15],[nanmean(allThresh.med_correct_binSlow) - cis.med_correct_binSlow ...
    nanmean(allThresh.med_correct_binSlow) + cis.med_correct_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.med_correct_binMed) - cis.med_correct_binMed ...
    nanmean(allThresh.med_correct_binMed) + cis.med_correct_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.med_correct_binFast) - cis.med_correct_binFast ...
    nanmean(allThresh.med_correct_binFast) + cis.med_correct_binFast],'color','g')

xlim([-1000 0])
ylim([0 100])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')



subplot(2,2,3)
plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_leak),1),'r')


xlim([-1000 0])
ylim([0 100])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')

hold on

plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,:,ex_leak),1),'--g', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,:,ex_leak),1),'--k', ...
-1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,:,ex_leak),1),'--r')


line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binSlow) - cis.fast_correct_made_dead_binSlow ...
    nanmean(allThresh.fast_correct_made_dead_binSlow) + cis.fast_correct_made_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binMed) - cis.fast_correct_made_dead_binMed ...
    nanmean(allThresh.fast_correct_made_dead_binMed) + cis.fast_correct_made_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binFast) - cis.fast_correct_made_dead_binFast ...
    nanmean(allThresh.fast_correct_made_dead_binFast) + cis.fast_correct_made_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binSlow) - cis.fast_correct_missed_dead_binSlow ...
    nanmean(allThresh.fast_correct_missed_dead_binSlow) + cis.fast_correct_missed_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binMed) - cis.fast_correct_missed_dead_binMed ...
    nanmean(allThresh.fast_correct_missed_dead_binMed) + cis.fast_correct_missed_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binFast) - cis.fast_correct_missed_dead_binFast ...
    nanmean(allThresh.fast_correct_missed_dead_binFast) + cis.fast_correct_missed_dead_binFast],'color','g')



%ALL t-Tests

% WITHIN SAT CONDITION
%---------SLOW----------%
%made
[h p] = ttest(allThresh.slow_correct_made_dead_binSlow,allThresh.slow_correct_made_dead_binFast)
[h p] = ttest(allThresh.slow_correct_made_dead_binSlow,allThresh.slow_correct_made_dead_binMed)
[h p] = ttest(allThresh.slow_correct_made_dead_binMed,allThresh.slow_correct_made_dead_binFast)

%missed
[h p] = ttest(allThresh.slow_correct_missed_dead_binSlow,allThresh.slow_correct_missed_dead_binFast)
[h p] = ttest(allThresh.slow_correct_missed_dead_binSlow,allThresh.slow_correct_missed_dead_binMed)
[h p] = ttest(allThresh.slow_correct_missed_dead_binMed,allThresh.slow_correct_missed_dead_binFast)


%---------NEUTRAL--------%
[h p] = ttest(allThresh.med_correct_binSlow,allThresh.med_correct_binFast)
[h p] = ttest(allThresh.med_correct_binSlow,allThresh.med_correct_binMed)
[h p] = ttest(allThresh.med_correct_binMed,allThresh.med_correct_binFast)

%----------FAST----------%
%made
[h p] = ttest(allThresh.fast_correct_made_dead_binSlow,allThresh.slow_correct_made_dead_binFast)
[h p] = ttest(allThresh.fast_correct_made_dead_binSlow,allThresh.slow_correct_made_dead_binMed)
[h p] = ttest(allThresh.fast_correct_made_dead_binMed,allThresh.slow_correct_made_dead_binFast)

%missed
[h p] = ttest(allThresh.fast_correct_missed_dead_binSlow,allThresh.fast_correct_missed_dead_binFast)
[h p] = ttest(allThresh.fast_correct_missed_dead_binSlow,allThresh.fast_correct_missed_dead_binMed)
[h p] = ttest(allThresh.fast_correct_missed_dead_binMed,allThresh.fast_correct_missed_dead_binFast)