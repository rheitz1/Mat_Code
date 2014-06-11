% Plot movement integrators for varying level of leakage k

k = leak(:);

threshwin = 980:990;
accumulator_time = -1000:200;

% threshwin = 1980:1990;
% accumulator_time = -2000:200;

ex_leak = 10;
av_win = threshwin;

for whichLeak = 1:length(k)
    
    triggerVal_made.correct_slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead(:,threshwin,whichLeak),2);
    triggerVal_made.correct_med(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.med_correct(:,threshwin,whichLeak),2);
    triggerVal_made.correct_fast(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead(:,threshwin,whichLeak),2);
    
    triggerVal_missed.correct_slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.slow_correct_missed_dead(:,threshwin,whichLeak),2);
    triggerVal_missed.correct_med(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.med_correct(:,threshwin,whichLeak),2);
    triggerVal_missed.correct_fast(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.fast_correct_missed_dead(:,threshwin,whichLeak),2);
    
    
    [h(whichLeak) p(whichLeak)] = ttest(triggerVal_made.correct_slow(:,whichLeak),triggerVal_made.correct_fast(:,whichLeak));
%     triggerVal_made.errors_slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.slow_errors_made_dead(:,threshwin,whichLeak),2);
%     triggerVal_made.errors_med(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.med_errors(:,threshwin,whichLeak),2);
%     triggerVal_made.errors_fast(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.fast_errors_made_dead(:,threshwin,whichLeak),2);
%     
%     triggerVal_missed.errors_slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.slow_errors_missed_dead(:,threshwin,whichLeak),2);
%     triggerVal_missed.errors_med(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.med_errors(:,threshwin,whichLeak),2);
%     triggerVal_missed.errors_fast(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_out.fast_errors_missed_dead(:,threshwin,whichLeak),2);
%     
    %[h(whichLeak,1) p(whichLeak,1)] = ttest(triggerVal.slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak),triggerVal.fast(1:84,whichLeak));
end




%compute trigger vals for stat tests

% On occassion, the integrators will have the same value repeated across time.  This is probably an
% error, and I now remove those trials. I have spot-checked each example to find out when this occurrs,
% and selectively do the removal.
remove = find(min(leaky_integrated_in.slow_correct_made_dead(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_made_dead(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_made_dead(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_made_dead_binSlow(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_made_dead_binMed(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_made_dead_binFast(remove,:,ex_leak) = NaN; end


remove = find(min(leaky_integrated_in.slow_correct_missed_dead(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_missed_dead(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_missed_dead(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_missed_dead_binSlow(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.slow_correct_missed_dead_binMed(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_missed_dead_binMed(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_missed_dead_binMed(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.slow_correct_missed_dead_binFast(:,:,ex_leak),[],2) == max(leaky_integrated_in.slow_correct_missed_dead_binFast(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.slow_correct_missed_dead_binFast(remove,:,ex_leak) = NaN; end


remove = find(min(leaky_integrated_in.med_correct(:,:,ex_leak),[],2) == max(leaky_integrated_in.med_correct(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.med_correct(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),[],2) == max(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.med_correct_binSlow(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),[],2) == max(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.med_correct_binMed(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),[],2) == max(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.med_correct_binFast(remove,:,ex_leak) = NaN; end

remove = find(min(leaky_integrated_in.fast_correct_made_dead(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_made_dead(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_made_dead(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_made_dead_binSlow(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_made_dead_binMed(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_made_dead_binFast(remove,:,ex_leak) = NaN; end
 
 
remove = find(min(leaky_integrated_in.fast_correct_missed_dead(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_missed_dead(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_missed_dead(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_missed_dead_binSlow(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_missed_dead_binMed(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_missed_dead_binMed(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_missed_dead_binMed(remove,:,ex_leak) = NaN; end
 
remove = find(min(leaky_integrated_in.fast_correct_missed_dead_binFast(:,:,ex_leak),[],2) == max(leaky_integrated_in.fast_correct_missed_dead_binFast(:,:,ex_leak),[],2));
if ~isempty(remove); leaky_integrated_in.fast_correct_missed_dead_binFast(remove,:,ex_leak) = NaN; end



% alltrig.slow_correct_made = nanmean(leaky_integrated_in.slow_correct_made_dead(:,av_win,ex_leak),2);
% alltrig.med_correct = nanmean(leaky_integrated_in.med_correct(:,av_win,ex_leak),2);
% alltrig.fast_correct_made = nanmean(leaky_integrated_in.fast_correct_made_dead(:,av_win,ex_leak),2);
% 
% alltrig.slow_correct_missed = nanmean(leaky_integrated_in.slow_correct_missed_dead(:,av_win,ex_leak),2);
% alltrig.fast_correct_missed = nanmean(leaky_integrated_in.fast_correct_missed_dead(:,av_win,ex_leak),2);
% 
% alltrig.slow_errors_made = nanmean(leaky_integrated_in.slow_errors_made_dead(:,av_win,ex_leak),2);
% alltrig.med_errors = nanmean(leaky_integrated_in.med_errors(:,av_win,ex_leak),2);
% alltrig.fast_errors_made = nanmean(leaky_integrated_in.fast_errors_made_dead(:,av_win,ex_leak),2);
% 

% 
% figure
% subplot(2,2,1)
% scatter(alltrig.med_errors,alltrig.med_correct,'k')
% hold on
% scatter(alltrig.slow_errors_made,alltrig.slow_correct_made,'r')
% scatter(alltrig.fast_errors_made,alltrig.fast_correct_made,'g')
% dline
% title('Trigger Values')
% xlabel('Errors made dead')
% ylabel('Correct made dead')
% 
% subplot(2,2,2)
% %scatter(alltrig.med_errors,alltrig.med_correct,'k')
% hold on
% scatter(alltrig.slow_correct_made,alltrig.slow_correct_missed,'r')
% scatter(alltrig.fast_correct_made,alltrig.fast_correct_missed,'g')
% dline
% title('Trigger Values')
% xlabel('Correct made dead')
% ylabel('Correct missed dead')
% 
% 
% subplot(2,2,3)
% scatter(alltrig.fast_correct_made,alltrig.slow_correct_made,'r')
% hold on
% scatter(alltrig.fast_correct_made,alltrig.med_correct,'k')
% dline
% title('Trigger Values')
% xlabel('Trigger Fast')
% ylabel('Trigger Slow / Neutral')



trig.slow_correct_made = nanmean(nanmean(leaky_integrated_in.slow_correct_made_dead(:,av_win,10),2));
trig.med_correct = nanmean(nanmean(leaky_integrated_in.med_correct(:,av_win,10),2));
trig.fast_correct_made = nanmean(nanmean(leaky_integrated_in.fast_correct_made_dead(:,av_win,10),2));

trig.slow_correct_missed = nanmean(nanmean(leaky_integrated_in.slow_correct_missed_dead(:,av_win,10),2));
trig.fast_correct_missed = nanmean(nanmean(leaky_integrated_in.fast_correct_missed_dead(:,av_win,10),2));

trig.slow_errors_made = nanmean(nanmean(leaky_integrated_in.slow_errors_made_dead(:,av_win,10),2));
trig.med_errors = nanmean(nanmean(leaky_integrated_in.med_errors(:,av_win,10),2));
trig.fast_errors_made = nanmean(nanmean(leaky_integrated_in.fast_errors_made_dead(:,av_win,10),2));






allThresh.slow_correct_made_dead = nanmean(leaky_integrated_in.slow_correct_made_dead(:,av_win,ex_leak),2);
allThresh.slow_correct_made_dead_binFast = nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,av_win,ex_leak),2);
allThresh.slow_correct_made_dead_binMed = nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,av_win,ex_leak),2);
allThresh.slow_correct_made_dead_binSlow = nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,av_win,ex_leak),2);

allThresh.slow_correct_missed_dead = nanmean(leaky_integrated_in.slow_correct_missed_dead(:,av_win,ex_leak),2);
allThresh.slow_correct_missed_dead_binFast = nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,av_win,ex_leak),2);
allThresh.slow_correct_missed_dead_binMed = nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,av_win,ex_leak),2);
allThresh.slow_correct_missed_dead_binSlow = nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,av_win,ex_leak),2);

allThresh.med_correct = nanmean(leaky_integrated_in.med_correct(:,av_win,ex_leak),2);
allThresh.med_correct_binFast = nanmean(leaky_integrated_in.med_correct_binFast(:,av_win,ex_leak),2);
allThresh.med_correct_binMed = nanmean(leaky_integrated_in.med_correct_binMed(:,av_win,ex_leak),2);
allThresh.med_correct_binSlow = nanmean(leaky_integrated_in.med_correct_binSlow(:,av_win,ex_leak),2);

allThresh.fast_correct_made_dead = nanmean(leaky_integrated_in.fast_correct_made_dead(:,av_win,ex_leak),2);
allThresh.fast_correct_made_dead_binFast = nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,av_win,ex_leak),2);
allThresh.fast_correct_made_dead_binMed = nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,av_win,ex_leak),2);
allThresh.fast_correct_made_dead_binSlow = nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,av_win,ex_leak),2);
 
allThresh.fast_correct_missed_dead = nanmean(leaky_integrated_in.fast_correct_missed_dead(:,av_win,ex_leak),2);
allThresh.fast_correct_missed_dead_binFast = nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,av_win,ex_leak),2);
allThresh.fast_correct_missed_dead_binMed = nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,av_win,ex_leak),2);
allThresh.fast_correct_missed_dead_binSlow = nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,av_win,ex_leak),2);


sems.slow_correct_made_dead = sem(allThresh.slow_correct_made_dead);
sems.slow_correct_made_dead_binFast = sem(allThresh.slow_correct_made_dead_binFast);
sems.slow_correct_made_dead_binMed = sem(allThresh.slow_correct_made_dead_binMed);
sems.slow_correct_made_dead_binSlow = sem(allThresh.slow_correct_made_dead_binSlow);

sems.slow_correct_missed_dead = sem(allThresh.slow_correct_missed_dead);
sems.slow_correct_missed_dead_binFast = sem(allThresh.slow_correct_missed_dead_binFast);
sems.slow_correct_missed_dead_binMed = sem(allThresh.slow_correct_missed_dead_binMed);
sems.slow_correct_missed_dead_binSlow = sem(allThresh.slow_correct_missed_dead_binSlow);

sems.med_correct = sem(allThresh.med_correct);
sems.med_correct_binFast = sem(allThresh.med_correct_binFast);
sems.med_correct_binMed = sem(allThresh.med_correct_binMed);
sems.med_correct_binSlow = sem(allThresh.med_correct_binSlow);

sems.fast_correct_made_dead = sem(allThresh.fast_correct_made_dead);
sems.fast_correct_made_dead_binFast = sem(allThresh.fast_correct_made_dead_binFast);
sems.fast_correct_made_dead_binMed = sem(allThresh.fast_correct_made_dead_binMed);
sems.fast_correct_made_dead_binSlow = sem(allThresh.fast_correct_made_dead_binSlow);

sems.fast_correct_missed_dead = sem(allThresh.fast_correct_missed_dead);
sems.fast_correct_missed_dead_binFast = sem(allThresh.fast_correct_missed_dead_binFast);
sems.fast_correct_missed_dead_binMed = sem(allThresh.fast_correct_missed_dead_binMed);
sems.fast_correct_missed_dead_binSlow = sem(allThresh.fast_correct_missed_dead_binSlow);

cis.slow_correct_made_dead = ci(allThresh.slow_correct_made_dead);
cis.slow_correct_made_dead_binFast = ci(allThresh.slow_correct_made_dead_binFast);
cis.slow_correct_made_dead_binMed = ci(allThresh.slow_correct_made_dead_binMed);
cis.slow_correct_made_dead_binSlow = ci(allThresh.slow_correct_made_dead_binSlow);
 
cis.slow_correct_missed_dead = ci(allThresh.slow_correct_missed_dead);
cis.slow_correct_missed_dead_binFast = ci(allThresh.slow_correct_missed_dead_binFast);
cis.slow_correct_missed_dead_binMed = ci(allThresh.slow_correct_missed_dead_binMed);
cis.slow_correct_missed_dead_binSlow = ci(allThresh.slow_correct_missed_dead_binSlow);
 
cis.med_correct = ci(allThresh.med_correct);
cis.med_correct_binFast = ci(allThresh.med_correct_binFast);
cis.med_correct_binMed = ci(allThresh.med_correct_binMed);
cis.med_correct_binSlow = ci(allThresh.med_correct_binSlow);
 
cis.fast_correct_made_dead = ci(allThresh.fast_correct_made_dead);
cis.fast_correct_made_dead_binFast = ci(allThresh.fast_correct_made_dead_binFast);
cis.fast_correct_made_dead_binMed = ci(allThresh.fast_correct_made_dead_binMed);
cis.fast_correct_made_dead_binSlow = ci(allThresh.fast_correct_made_dead_binSlow);
 
cis.fast_correct_missed_dead = ci(allThresh.fast_correct_missed_dead);
cis.fast_correct_missed_dead_binFast = ci(allThresh.fast_correct_missed_dead_binFast);
cis.fast_correct_missed_dead_binMed = ci(allThresh.fast_correct_missed_dead_binMed);
cis.fast_correct_missed_dead_binSlow = ci(allThresh.fast_correct_missed_dead_binSlow);







%% Scatter Plots
figure
subplot(2,2,1)
hold on
scatter(nanmean(triggerVal_made.correct_fast,1),nanmean(triggerVal_made.correct_slow,1),'r')
scatter(nanmean(triggerVal_made.correct_fast,1),nanmean(triggerVal_made.correct_med,1),'k')
xlabel('Movement Trigger Fast')
ylabel('Movement Trigger Accurate / Medium')


cf1 = fit(nanmean(triggerVal_made.correct_fast,1)',nanmean(triggerVal_made.correct_slow,1)','cubicinterp');
cf2 = fit(nanmean(triggerVal_made.correct_fast,1)',nanmean(triggerVal_made.correct_med,1)','cubicinterp');
%cf1 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_slow,1)','poly2');
%cf2 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_med,1)','poly2');
p1 = plot(cf1,'fit');
p2 = plot(cf2,'fit');
xlim([-20 300])
ylim([-20 300])
dline


%put in example point
mS = nanmean(triggerVal_made.correct_slow,1);
mM = nanmean(triggerVal_made.correct_med,1);
mF = nanmean(triggerVal_made.correct_fast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')
title('Correct Made Deadlines')


subplot(2,2,2)
hold on
scatter(nanmean(triggerVal_missed.correct_fast,1),nanmean(triggerVal_missed.correct_slow,1),'r')
scatter(nanmean(triggerVal_missed.correct_fast,1),nanmean(triggerVal_missed.correct_med,1),'k')
xlabel('Movement Trigger Fast')
ylabel('Movement Trigger Accurate / Medium')

xlim([-20 300])
ylim([-20 300])
dline


%put in example point
mS = nanmean(triggerVal_missed.correct_slow,1);
mM = nanmean(triggerVal_missed.correct_med,1);
mF = nanmean(triggerVal_missed.correct_fast,1);
scatter(mF(ex_leak),mS(ex_leak),'m')
scatter(mF(ex_leak),mM(ex_leak),'m')
title('Correct Missed Deadlines')
% 
% subplot(2,2,3)
% %cf1 = fit(nanmean(triggerVal_made.correct_fast,1)',nanmean(triggerVal_made.correct_slow,1)','cubicinterp');
% %cf2 = fit(nanmean(triggerVal_made.correct_fast,1)',nanmean(triggerVal_made.correct_med,1)','cubicinterp');
% %cf1 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_slow,1)','cubicinterp');
% %cf2 = fit(nanmean(triggerVal_missed.correct_fast,1)',nanmean(triggerVal_missed.correct_med,1)','cubicinterp');
% hold on
% % plot(cf1,'fit')
% % plot(cf2,'fit')
% 
% scatter(nanmean(triggerVal_made.errors_fast,1),nanmean(triggerVal_made.errors_slow,1),'r')
% scatter(nanmean(triggerVal_made.errors_fast,1),nanmean(triggerVal_made.errors_med,1),'k')
% xlabel('Movement Trigger Fast')
% ylabel('Movement Trigger Accurate / Medium')
% 
% xlim([-20 300])
% ylim([-20 300])
% dline
% 
% 
% %put in example point
% mS = nanmean(triggerVal_missed.errors_slow,1);
% mM = nanmean(triggerVal_missed.errors_med,1);
% mF = nanmean(triggerVal_missed.errors_fast,1);
% scatter(mF(ex_leak),mS(ex_leak),'m')
% scatter(mF(ex_leak),mM(ex_leak),'m')
% title('Errors Made Deadlines')
% 
% 
% subplot(2,2,4)
% hold on
% scatter(nanmean(triggerVal_missed.errors_fast,1),nanmean(triggerVal_missed.errors_slow,1),'r')
% scatter(nanmean(triggerVal_missed.errors_fast,1),nanmean(triggerVal_missed.errors_med,1),'k')
% xlabel('Movement Trigger Fast')
% ylabel('Movement Trigger Accurate / Medium')
% 
% xlim([-20 300])
% ylim([-20 300])
% dline
% 
% 
% %put in example point
% mS = nanmean(triggerVal_missed.errors_slow,1);
% mM = nanmean(triggerVal_missed.errors_med,1);
% mF = nanmean(triggerVal_missed.errors_fast,1);
% scatter(mF(ex_leak),mS(ex_leak),'m')
% scatter(mF(ex_leak),mM(ex_leak),'m')
% title('Errors Missed Deadlines')
% %%
% 


%% Mean accumulator trajectories for example neurons (1 leakage value)
figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead(:,:,ex_leak),1),'r', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead(:,:,ex_leak),1),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Correct Made Dead')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead(:,:,ex_leak),1),'r', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead(:,:,ex_leak),1),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Correct Missed Dead')
set(gca,'yaxislocation','right')
%set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_out.slow_errors_made_dead(:,:,ex_leak),1),'--r', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors(:,:,ex_leak),1),'--k', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_made_dead(:,:,ex_leak),1),'--g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Errors Made Dead')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,4)
plot(accumulator_time,nanmean(leaky_integrated_out.slow_errors_missed_dead(:,:,ex_leak),1),'r', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_missed_dead(:,:,ex_leak),1),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
title('Errors Missed Dead')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')
%%


figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead(:,:,ex_leak)),'r', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead(:,:,ex_leak)),'--r', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct(:,:,ex_leak)),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead(:,:,ex_leak)),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead(:,:,ex_leak)),'--g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
title('Made + missed deadlines')


line([-15 -15],[nanmean(allThresh.slow_correct_made_dead)-cis.slow_correct_made_dead ...
    nanmean(allThresh.slow_correct_made_dead)+cis.slow_correct_made_dead],'color','r')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead)-cis.slow_correct_missed_dead ...
    nanmean(allThresh.slow_correct_missed_dead)+cis.slow_correct_missed_dead],'color','r')
line([-15 -15],[nanmean(allThresh.med_correct)-cis.med_correct ...
    nanmean(allThresh.med_correct)+cis.med_correct],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead)-cis.fast_correct_made_dead ...
    nanmean(allThresh.fast_correct_made_dead)+cis.fast_correct_made_dead],'color','g')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead)-cis.fast_correct_missed_dead ...
    nanmean(allThresh.fast_correct_missed_dead)+cis.fast_correct_missed_dead],'color','g')


%% Accumulators separated by nTiles
figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_leak),1),'r')
title('Correct Slow Made')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')


subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),1),'r')
title('Correct Medium')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_leak),1),'r')
title('Correct Fast Made')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,:,ex_leak),1),'r')
title('Correct Slow Missed')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')


subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),1),'r')
title('Correct Medium')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,:,ex_leak),1),'r')
title('Correct Fast Missed')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_out.slow_errors_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.slow_errors_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.slow_errors_made_dead_binSlow(:,:,ex_leak),1),'r')
title('Errors Slow Made')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')



subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_out.med_errors_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors_binSlow(:,:,ex_leak),1),'r')
title('Errors Medium')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_out.fast_errors_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_made_dead_binSlow(:,:,ex_leak),1),'r')
title('Errors Fast Made')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_out.slow_errors_missed_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.slow_errors_missed_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.slow_errors_missed_dead_binSlow(:,:,ex_leak),1),'r')
title('Errors Slow Missed')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')


subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_out.med_errors_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.med_errors_binSlow(:,:,ex_leak),1),'r')
title('Errors Medium')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')

subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_out.fast_errors_missed_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_missed_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_out.fast_errors_missed_dead_binSlow(:,:,ex_leak),1),'r')
title('Errors Fast Missed')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')
hline(77.5,'k')






%===============================================
% MADE + MISSED nTiles on one plot w/ 95% C.I.'s
figure
subplot(2,2,1)
plot(accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_leak),1),'r', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,:,ex_leak),1),'--g', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,:,ex_leak),1),'--k', ...
    accumulator_time,nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,:,ex_leak),1),'--r')
title('Correct Slow Made + Missed')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')

line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binFast)-cis.slow_correct_made_dead_binFast ...
    nanmean(allThresh.slow_correct_made_dead_binFast)+cis.slow_correct_made_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binMed)-cis.slow_correct_made_dead_binMed ...
    nanmean(allThresh.slow_correct_made_dead_binMed)+cis.slow_correct_made_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.slow_correct_made_dead_binSlow)-cis.slow_correct_made_dead_binSlow ...
    nanmean(allThresh.slow_correct_made_dead_binSlow)+cis.slow_correct_made_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binFast)-cis.slow_correct_missed_dead_binFast ...
    nanmean(allThresh.slow_correct_missed_dead_binFast)+cis.slow_correct_missed_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binMed)-cis.slow_correct_missed_dead_binMed ...
    nanmean(allThresh.slow_correct_missed_dead_binMed)+cis.slow_correct_missed_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.slow_correct_missed_dead_binSlow)-cis.slow_correct_missed_dead_binSlow ...
    nanmean(allThresh.slow_correct_missed_dead_binSlow)+cis.slow_correct_missed_dead_binSlow],'color','r')



subplot(2,2,2)
plot(accumulator_time,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_leak),1),'r')
title('Correct Medium')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')

line([-15 -15],[nanmean(allThresh.med_correct_binFast)-cis.med_correct_binFast ...
    nanmean(allThresh.med_correct_binFast)+cis.med_correct_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.med_correct_binMed)-cis.med_correct_binMed ...
    nanmean(allThresh.med_correct_binMed)+cis.med_correct_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.med_correct_binSlow)-cis.med_correct_binSlow ...
    nanmean(allThresh.med_correct_binSlow)+cis.med_correct_binSlow],'color','r')





subplot(2,2,3)
plot(accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_leak),1),'g', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_leak),1),'k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_leak),1),'r', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,:,ex_leak),1),'--g', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,:,ex_leak),1),'--k', ...
    accumulator_time,nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,:,ex_leak),1),'--r')
title('Correct Fast Made')
xlim([-1000 0])
box off
set(gca,'xminortick','on')
set(gca,'yaxislocation','right')
set(gca,'tickdir','out')

line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binFast)-cis.fast_correct_made_dead_binFast ...
    nanmean(allThresh.fast_correct_made_dead_binFast)+cis.fast_correct_made_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binMed)-cis.fast_correct_made_dead_binMed ...
    nanmean(allThresh.fast_correct_made_dead_binMed)+cis.fast_correct_made_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_made_dead_binSlow)-cis.fast_correct_made_dead_binSlow ...
    nanmean(allThresh.fast_correct_made_dead_binSlow)+cis.fast_correct_made_dead_binSlow],'color','r')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binFast)-cis.fast_correct_missed_dead_binFast ...
    nanmean(allThresh.fast_correct_missed_dead_binFast)+cis.fast_correct_missed_dead_binFast],'color','g')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binMed)-cis.fast_correct_missed_dead_binMed ...
    nanmean(allThresh.fast_correct_missed_dead_binMed)+cis.fast_correct_missed_dead_binMed],'color','k')
line([-15 -15],[nanmean(allThresh.fast_correct_missed_dead_binSlow)-cis.fast_correct_missed_dead_binSlow ...
    nanmean(allThresh.fast_correct_missed_dead_binSlow)+cis.fast_correct_missed_dead_binSlow],'color','r')







%============
% Bar plot of threshold values (-20:-10 prior to saccade)

figure
msize = 15; %marker size
errorbar([1:4],[nanmean(allThresh.slow_correct_made_dead) nanmean(allThresh.slow_correct_made_dead_binSlow) nanmean(allThresh.slow_correct_made_dead_binMed) nanmean(allThresh.slow_correct_made_dead_binFast)], ...
    [sems.slow_correct_made_dead sems.slow_correct_made_dead_binSlow sems.slow_correct_made_dead_binMed sems.slow_correct_made_dead_binFast],'-sr','markersize',msize)
hold on
errorbar([1:4],[nanmean(allThresh.slow_correct_missed_dead) nanmean(allThresh.slow_correct_missed_dead_binSlow) nanmean(allThresh.slow_correct_missed_dead_binMed) nanmean(allThresh.slow_correct_missed_dead_binFast)], ...
    [sems.slow_correct_missed_dead sems.slow_correct_missed_dead_binSlow sems.slow_correct_missed_dead_binMed sems.slow_correct_missed_dead_binFast],'--sr','markersize',msize)
errorbar([1:4],[nanmean(allThresh.med_correct) nanmean(allThresh.med_correct_binSlow) nanmean(allThresh.med_correct_binMed) nanmean(allThresh.med_correct_binFast)], ...
    [sems.med_correct sems.med_correct_binSlow sems.med_correct_binMed sems.med_correct_binFast],'-sk','markersize',msize)
errorbar([1:4],[nanmean(allThresh.fast_correct_made_dead) nanmean(allThresh.fast_correct_made_dead_binSlow) nanmean(allThresh.fast_correct_made_dead_binMed) nanmean(allThresh.fast_correct_made_dead_binFast)], ...
    [sems.fast_correct_made_dead sems.fast_correct_made_dead_binSlow sems.fast_correct_made_dead_binMed sems.fast_correct_made_dead_binFast],'-sg','markersize',msize)
errorbar([1:4],[nanmean(allThresh.fast_correct_missed_dead) nanmean(allThresh.fast_correct_missed_dead_binSlow) nanmean(allThresh.fast_correct_missed_dead_binMed) nanmean(allThresh.fast_correct_missed_dead_binFast)], ...
    [sems.fast_correct_missed_dead sems.fast_correct_missed_dead_binSlow sems.fast_correct_missed_dead_binMed sems.fast_correct_missed_dead_binFast],'--sg','markersize',msize)
box off
ylim([0 100])

barmat_made = [nanmean(allThresh.slow_correct_made_dead) nanmean(allThresh.slow_correct_made_dead_binSlow) nanmean(allThresh.slow_correct_made_dead_binMed) nanmean(allThresh.slow_correct_made_dead_binFast) ; ...
    nanmean(allThresh.med_correct) nanmean(allThresh.med_correct_binSlow) nanmean(allThresh.med_correct_binMed) nanmean(allThresh.med_correct_binFast) ; ...
    nanmean(allThresh.fast_correct_made_dead) nanmean(allThresh.fast_correct_made_dead_binSlow) nanmean(allThresh.fast_correct_made_dead_binMed) nanmean(allThresh.fast_correct_made_dead_binFast)];

 
barmat_missed = [nanmean(allThresh.slow_correct_missed_dead) nanmean(allThresh.slow_correct_missed_dead_binSlow) nanmean(allThresh.slow_correct_missed_dead_binMed) nanmean(allThresh.slow_correct_missed_dead_binFast) ; ...
    nanmean(allThresh.med_correct) nanmean(allThresh.med_correct_binSlow) nanmean(allThresh.med_correct_binMed) nanmean(allThresh.med_correct_binFast) ; ...
    nanmean(allThresh.fast_correct_missed_dead) nanmean(allThresh.fast_correct_missed_dead_binSlow) nanmean(allThresh.fast_correct_missed_dead_binMed) nanmean(allThresh.fast_correct_missed_dead_binFast)];

barmat_made_missed = [nanmean(allThresh.slow_correct_made_dead) nanmean(allThresh.slow_correct_made_dead_binSlow) nanmean(allThresh.slow_correct_made_dead_binMed) nanmean(allThresh.slow_correct_made_dead_binFast) ...    
nanmean(allThresh.slow_correct_missed_dead) nanmean(allThresh.slow_correct_missed_dead_binSlow) nanmean(allThresh.slow_correct_missed_dead_binMed) nanmean(allThresh.slow_correct_missed_dead_binFast) ; ...
nanmean(allThresh.med_correct) nanmean(allThresh.med_correct_binSlow) nanmean(allThresh.med_correct_binMed) nanmean(allThresh.med_correct_binFast) ...
nanmean(allThresh.med_correct) nanmean(allThresh.med_correct_binSlow) nanmean(allThresh.med_correct_binMed) nanmean(allThresh.med_correct_binFast) ; ...
nanmean(allThresh.fast_correct_made_dead) nanmean(allThresh.fast_correct_made_dead_binSlow) nanmean(allThresh.fast_correct_made_dead_binMed) nanmean(allThresh.fast_correct_made_dead_binFast) ...
nanmean(allThresh.fast_correct_missed_dead) nanmean(allThresh.fast_correct_missed_dead_binSlow) nanmean(allThresh.fast_correct_missed_dead_binMed) nanmean(allThresh.fast_correct_missed_dead_binFast)];


figure
subplot(2,2,1)
bar(barmat_made); %grouped by row; thus first set is for all ACCURATE trials, each bar is different bin
title('Made Deadlines')
box off

subplot(2,2,2)
bar(barmat_missed); %grouped by row; thus first set is for all ACCURATE trials, each bar is different bin
title('Missed Deadlines')
box off

subplot(2,2,3)
bar(barmat_made_missed);
title('Made / Missed Deadlines')
box off



%CDFs of threshold values
% [bins.slow_correct_made_dead cdf.slow_correct_made_dead] = getCDF(allThresh.slow_correct_made_dead);
% [bins.slow_correct_made_dead_binFast cdf.slow_correct_made_dead_binFast] = getCDF(allThresh.slow_correct_made_dead_binFast);
% [bins.slow_correct_made_dead_binMed cdf.slow_correct_made_dead_binMed] = getCDF(allThresh.slow_correct_made_dead_binMed);
% [bins.slow_correct_made_dead_binSlow cdf.slow_correct_made_dead_binSlow] = getCDF(allThresh.slow_correct_made_dead_binSlow);
% 
% [bins.slow_correct_missed_dead cdf.slow_correct_missed_dead] = getCDF(allThresh.slow_correct_missed_dead);
% [bins.slow_correct_missed_dead_binFast cdf.slow_correct_missed_dead_binFast] = getCDF(allThresh.slow_correct_missed_dead_binFast);
% [bins.slow_correct_missed_dead_binMed cdf.slow_correct_missed_dead_binMed] = getCDF(allThresh.slow_correct_missed_dead_binMed);
% [bins.slow_correct_missed_dead_binSlow cdf.slow_correct_missed_dead_binSlow] = getCDF(allThresh.slow_correct_missed_dead_binSlow);
% 
% 
% [bins.med_correct cdf.med_correct] = getCDF(allThresh.med_correct);
% [bins.med_correct_binFast cdf.med_correct_binFast] = getCDF(allThresh.med_correct_binFast);
% [bins.med_correct_binMed cdf.med_correct_binMed] = getCDF(allThresh.med_correct_binMed);
% [bins.med_correct_binSlow cdf.med_correct_binSlow] = getCDF(allThresh.med_correct_binSlow);
% 
% [bins.fast_correct_made_dead cdf.fast_correct_made_dead] = getCDF(allThresh.fast_correct_made_dead);
% [bins.fast_correct_made_dead_binFast cdf.fast_correct_made_dead_binFast] = getCDF(allThresh.fast_correct_made_dead_binFast);
% [bins.fast_correct_made_dead_binMed cdf.fast_correct_made_dead_binMed] = getCDF(allThresh.fast_correct_made_dead_binMed);
% [bins.fast_correct_made_dead_binSlow cdf.fast_correct_made_dead_binSlow] = getCDF(allThresh.fast_correct_made_dead_binSlow);
%  
% [bins.fast_correct_missed_dead cdf.fast_correct_missed_dead] = getCDF(allThresh.fast_correct_missed_dead);
% [bins.fast_correct_missed_dead_binFast cdf.fast_correct_missed_dead_binFast] = getCDF(allThresh.fast_correct_missed_dead_binFast);
% [bins.fast_correct_missed_dead_binMed cdf.fast_correct_missed_dead_binMed] = getCDF(allThresh.fast_correct_missed_dead_binMed);
% [bins.fast_correct_missed_dead_binSlow cdf.fast_correct_missed_dead_binSlow] = getCDF(allThresh.fast_correct_missed_dead_binSlow);
% 
% figure
% subplot(2,2,1)
% plot(bins.slow_correct_made_dead_binSlow,cdf.slow_correct_made_dead_binSlow,'r', ...
%     bins.slow_correct_made_dead_binMed,cdf.slow_correct_made_dead_binMed, 'k', ...
%     bins.slow_correct_made_dead_binFast,cdf.slow_correct_made_dead_binFast,'g', ...
%     bins.slow_correct_missed_dead_binSlow,cdf.slow_correct_missed_dead_binSlow,'--r', ...
%     bins.slow_correct_missed_dead_binMed,cdf.slow_correct_missed_dead_binMed, '--k', ...
%     bins.slow_correct_missed_dead_binFast,cdf.slow_correct_missed_dead_binFast,'--g')
% box off
% title('Slow made / missed')
% 
% subplot(2,2,2)
% plot(bins.med_correct_binSlow,cdf.med_correct_binSlow,'r', ...
%     bins.med_correct_binMed,cdf.med_correct_binMed,'k', ...
%     bins.med_correct_binFast,cdf.med_correct_binFast,'g')
% box off
% title('Med')
% 
% 
% subplot(2,2,3)
% plot(bins.fast_correct_made_dead_binSlow,cdf.fast_correct_made_dead_binSlow,'r', ...
%     bins.fast_correct_made_dead_binMed,cdf.fast_correct_made_dead_binMed, 'k', ...
%     bins.fast_correct_made_dead_binFast,cdf.fast_correct_made_dead_binFast,'g', ...
%     bins.fast_correct_missed_dead_binSlow,cdf.fast_correct_missed_dead_binSlow,'--r', ...
%     bins.fast_correct_missed_dead_binMed,cdf.fast_correct_missed_dead_binMed, '--k', ...
%     bins.fast_correct_missed_dead_binFast,cdf.fast_correct_missed_dead_binFast,'--g')
% box off
% title('Fast made / missed')
