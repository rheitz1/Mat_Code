% Plot movement integrators for varying level of leakage k

k = leak(:);

threshwin = 980:990;
accumulator_time = -1000:200;

% threshwin = 1980:1990;
% accumulator_time = -2000:200;

ex_leak = 10;
av_win = threshwin;

for whichLeak = 1:length(k)
    
    triggerVal.ss2_correct(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_in.ss2_correct(:,threshwin,whichLeak),2);
    triggerVal.ss4_correct(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_in.ss4_correct(:,threshwin,whichLeak),2);
    triggerVal.ss8_correct(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_in.ss8_correct(:,threshwin,whichLeak),2);
    
    
%     triggerVal_made.errors_slow(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.slow_errors_made_dead(:,threshwin,whichLeak),2);
%     triggerVal_made.errors_med(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.med_errors(:,threshwin,whichLeak),2);
%     triggerVal_made.errors_fast(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.fast_errors_made_dead(:,threshwin,whichLeak),2);
%     
%     triggerVal_missed.errors_slow(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.slow_errors_missed_dead(:,threshwin,whichLeak),2);
%     triggerVal_missed.errors_med(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.med_errors(:,threshwin,whichLeak),2);
%     triggerVal_missed.errors_fast(1:size(leaky_integrated_in.ss2_correct,1),whichLeak) = nanmean(leaky_integrated_out.fast_errors_missed_dead(:,threshwin,whichLeak),2);
%     
    %[h(whichLeak,1) p(whichLeak,1)] = ttest(triggerVal.slow(1:size(leaky_integrated_in.ss2_correct,1),whichLeak),triggerVal.fast(1:84,whichLeak));
end




%compute trigger vals for stat tests

% On occassion, the integrators will have the same value repeated across time.  This is probably an
% error, and I now remove those trials. I have spot-checked each example to find out when this occurrs,
% and selectively do the removal.
remove = find(min(leaky_integrated_in.ss2_correct(:,:,ex_leak),[],2) == max(leaky_integrated_in.ss2_correct(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.ss2_correct(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.ss4_correct(:,:,ex_leak),[],2) == max(leaky_integrated_in.ss4_correct(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.ss4_correct(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.ss8_correct(:,:,ex_leak),[],2) == max(leaky_integrated_in.ss8_correct(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.ss8_correct(remove,:,ex_leak) = NaN; end
 


alltrig.ss2_correct = nanmean(leaky_integrated_in.ss2_correct(:,av_win,ex_leak),2);
alltrig.ss4_correct = nanmean(leaky_integrated_in.ss4_correct(:,av_win,ex_leak),2);
alltrig.ss8_correct = nanmean(leaky_integrated_in.ss8_correct(:,av_win,ex_leak),2);


trig.ss2_correct = nanmean(nanmean(leaky_integrated_in.ss2_correct(:,av_win,10),2));
trig.ss4_correct = nanmean(nanmean(leaky_integrated_in.ss4_correct(:,av_win,10),2));
trig.ss8_correct = nanmean(nanmean(leaky_integrated_in.ss8_correct(:,av_win,10),2));




allThresh.ss2_correct = nanmean(leaky_integrated_in.ss2_correct(:,av_win,ex_leak),2);
allThresh.ss4_correct = nanmean(leaky_integrated_in.ss4_correct(:,av_win,ex_leak),2);
allThresh.ss8_correct = nanmean(leaky_integrated_in.ss8_correct(:,av_win,ex_leak),2);
 


sems.ss2_correct = sem(allThresh.ss2_correct);
sems.ss4_correct = sem(allThresh.ss4_correct);
sems.ss8_correct = sem(allThresh.ss8_correct);

cis.ss2_correct = ci(allThresh.ss2_correct);
cis.ss4_correct = ci(allThresh.ss4_correct);
cis.ss8_correct = ci(allThresh.ss8_correct);




%% Scatter Plots
figure
subplot(2,2,1)
hold on
scatter(nanmean(triggerVal.ss8_correct,1),nanmean(triggerVal.ss2_correct,1),'k')
scatter(nanmean(triggerVal.ss8_correct,1),nanmean(triggerVal.ss4_correct,1),'r')
xlabel('Movement Trigger SS8')
ylabel('Movement Trigger SS2/SS4')


 cf1 = fit(nanmean(triggerVal.ss8_correct,1)',nanmean(triggerVal.ss2_correct,1)','cubicinterp');
 cf2 = fit(nanmean(triggerVal.ss8_correct,1)',nanmean(triggerVal.ss4_correct,1)','cubicinterp');
 %cf1 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_slow,1)','poly2');
 %cf2 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_med,1)','poly2');
 p1 = plot(cf1,'fit');
 p2 = plot(cf2,'fit');
 xlim([-20 300])
 ylim([-20 300])
 dline


%put in example point
mS = nanmean(triggerVal.ss2_correct,1);
mM = nanmean(triggerVal.ss4_correct,1);
mF = nanmean(triggerVal.ss8_correct,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')
title('Correct Made Deadlines')



%% Mean accumulator trajectories for example neurons (1 leakage value)
figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.ss2_correct(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.ss4_correct(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.ss8_correct(:,:,ex_leak),1),'r')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Correct Made Dead')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')


