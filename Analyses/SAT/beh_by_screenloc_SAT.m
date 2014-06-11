% plot accuracy rate by screen location separately for each SAT condition
% writing it as a null function to keep workspace clean
% RPH

function [] = beh_by_screenloc_SAT()
Target_ = evalin('caller','Target_');
SAT_ = evalin('caller','SAT_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');

try
    SRT = evalin('caller','SRT');
end

%Version 1: made deadlines only
if ~exist('SRT')
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
end

getTrials_SAT

pos0 = find(Target_(:,2) == 0);
pos1 = find(Target_(:,2) == 1);
pos2 = find(Target_(:,2) == 2);
pos3 = find(Target_(:,2) == 3);
pos4 = find(Target_(:,2) == 4);
pos5 = find(Target_(:,2) == 5);
pos6 = find(Target_(:,2) == 6);
pos7 = find(Target_(:,2) == 7);
ctch_slow = find(SAT_(:,1) == 1 & Target_(:,2) == 255);
ctch_med = find(SAT_(:,1) == 2 & Target_(:,2) == 255);
ctch_fast = find(SAT_(:,1) == 3 & Target_(:,2) == 255);


acc0_slow = length(intersect(slow_correct_made_dead,pos0)) / length(intersect(slow_all_made_dead,pos0));
acc1_slow = length(intersect(slow_correct_made_dead,pos1)) / length(intersect(slow_all_made_dead,pos1));
acc2_slow = length(intersect(slow_correct_made_dead,pos2)) / length(intersect(slow_all_made_dead,pos2));
acc3_slow = length(intersect(slow_correct_made_dead,pos3)) / length(intersect(slow_all_made_dead,pos3));
acc4_slow = length(intersect(slow_correct_made_dead,pos4)) / length(intersect(slow_all_made_dead,pos4));
acc5_slow = length(intersect(slow_correct_made_dead,pos5)) / length(intersect(slow_all_made_dead,pos5));
acc6_slow = length(intersect(slow_correct_made_dead,pos6)) / length(intersect(slow_all_made_dead,pos6));
acc7_slow = length(intersect(slow_correct_made_dead,pos7)) / length(intersect(slow_all_made_dead,pos7));
acc_catch_slow = nanmean(Correct_(ctch_slow,2));

acc0_med = length(intersect(med_correct,pos0)) / length(intersect(med_all,pos0));
acc1_med = length(intersect(med_correct,pos1)) / length(intersect(med_all,pos1));
acc2_med = length(intersect(med_correct,pos2)) / length(intersect(med_all,pos2));
acc3_med = length(intersect(med_correct,pos3)) / length(intersect(med_all,pos3));
acc4_med = length(intersect(med_correct,pos4)) / length(intersect(med_all,pos4));
acc5_med = length(intersect(med_correct,pos5)) / length(intersect(med_all,pos5));
acc6_med = length(intersect(med_correct,pos6)) / length(intersect(med_all,pos6));
acc7_med = length(intersect(med_correct,pos7)) / length(intersect(med_all,pos7));
acc_catch_med = nanmean(Correct_(ctch_med,2));


acc0_fast = length(intersect(fast_correct_made_dead_withCleared,pos0)) / length(intersect(fast_all_made_dead_withCleared,pos0));
acc1_fast = length(intersect(fast_correct_made_dead_withCleared,pos1)) / length(intersect(fast_all_made_dead_withCleared,pos1));
acc2_fast = length(intersect(fast_correct_made_dead_withCleared,pos2)) / length(intersect(fast_all_made_dead_withCleared,pos2));
acc3_fast = length(intersect(fast_correct_made_dead_withCleared,pos3)) / length(intersect(fast_all_made_dead_withCleared,pos3));
acc4_fast = length(intersect(fast_correct_made_dead_withCleared,pos4)) / length(intersect(fast_all_made_dead_withCleared,pos4));
acc5_fast = length(intersect(fast_correct_made_dead_withCleared,pos5)) / length(intersect(fast_all_made_dead_withCleared,pos5));
acc6_fast = length(intersect(fast_correct_made_dead_withCleared,pos6)) / length(intersect(fast_all_made_dead_withCleared,pos6));
acc7_fast = length(intersect(fast_correct_made_dead_withCleared,pos7)) / length(intersect(fast_all_made_dead_withCleared,pos7));
acc_catch_fast = nanmean(Correct_(ctch_fast,2));


diff0 = acc0_slow - acc0_fast;
diff1 = acc1_slow - acc1_fast;
diff2 = acc2_slow - acc2_fast;
diff3 = acc3_slow - acc3_fast;
diff4 = acc4_slow - acc4_fast;
diff5 = acc5_slow - acc5_fast;
diff6 = acc6_slow - acc6_fast;
diff7 = acc7_slow - acc7_fast;

ff = figure;
bar(0:7,[diff0 diff1 diff2 diff3 diff4 diff5 diff6 diff7],'facecolor','b')
ylim([-1 1])
title('ACCurate - FAST % correct')
box off

% 
% %Now do it again, but set Target Hold Errors to being correct to see the
% %difference
% 
% Correct_withHoldErrors = Correct_;
% Correct_withHoldErrors(find(Errors_(:,4) == 1),2) = 1;
% 
% acc0_withHoldErrors = nansum(Correct_withHoldErrors(pos0,2)) / length(pos0);
% acc1_withHoldErrors = nansum(Correct_withHoldErrors(pos1,2)) / length(pos1);
% acc2_withHoldErrors = nansum(Correct_withHoldErrors(pos2,2)) / length(pos2);
% acc3_withHoldErrors = nansum(Correct_withHoldErrors(pos3,2)) / length(pos3);
% acc4_withHoldErrors = nansum(Correct_withHoldErrors(pos4,2)) / length(pos4);
% acc5_withHoldErrors = nansum(Correct_withHoldErrors(pos5,2)) / length(pos5);
% acc6_withHoldErrors = nansum(Correct_withHoldErrors(pos6,2)) / length(pos6);
% acc7_withHoldErrors = nansum(Correct_withHoldErrors(pos7,2)) / length(pos7);

%acc_catch = nansum(Correct_(ctch,2)) / length(ctch);

all_ACC_slow = [acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow];
all_ACC_med = [acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med];
all_ACC_fast = [acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast];

bias_ACC_slow = max(all_ACC_slow) - min(all_ACC_slow);
bias_ACC_med = max(all_ACC_med) - min(all_ACC_med);
bias_ACC_fast = max(all_ACC_fast) - min(all_ACC_fast);

f = figure;
set(f,'color','white')
set(f,'position',[379 171 1033 635])

subplot(231)
hold on

%First make bar plot of 'withHoldErrors' because this will always be
%greater
%bar(0:8,[acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors acc_catch],'facecolor','r')

%then plot regular accuracy rate
bar(0:8,[acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow acc_catch_slow],'facecolor','r')

%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_slow],'facecolor','b')

xlim([-.5 8.5])
% set(gca,'xticklabel',['pos0' ; 'pos1' ; 'pos2' ; 'pos3' ; 'pos4' ; 'pos5' ; 'pos6' ; 'pos7' ; 'ctch'])
%legend('With Targ Hold Errors','No Targ Hold Errors','Catch Trials')
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_slow*100)/100)])


subplot(232)
hold on
bar(0:8,[acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med acc_catch_med],'facecolor','k')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_med],'facecolor','b')

xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_med*100)/100)])

subplot(233)
hold on
bar(0:8,[acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast acc_catch_fast],'facecolor','g')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_fast],'facecolor','b')

xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_fast*100)/100)])

% %write in text to specify how many trials recorded
% text(0,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos0,2))) ';   N=' mat2str(length(pos0))],'color','white','rotation',90,'fontsize',14)
% text(1,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos1,2))) ';   N=' mat2str(length(pos1))],'color','white','rotation',90,'fontsize',14)
% text(2,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos2,2))) ';   N=' mat2str(length(pos2))],'color','white','rotation',90,'fontsize',14)
% text(3,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos3,2))) ';   N=' mat2str(length(pos3))],'color','white','rotation',90,'fontsize',14)
% text(4,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos4,2))) ';   N=' mat2str(length(pos4))],'color','white','rotation',90,'fontsize',14)
% text(5,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos5,2))) ';   N=' mat2str(length(pos5))],'color','white','rotation',90,'fontsize',14)
% text(6,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos6,2))) ';   N=' mat2str(length(pos6))],'color','white','rotation',90,'fontsize',14)
% text(7,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos7,2))) ';   N=' mat2str(length(pos7))],'color','white','rotation',90,'fontsize',14)
% text(8,.1,['N Correct =' mat2str(nansum(Correct_(ctch,2))) ';   N=' mat2str(length(ctch))],'color','k','rotation',90,'fontsize',14)
% %set(gca,'color',[.8 .8 .8]) %set background to gray so can see characters
% clear pos* acc* Correct_withHoldErrors
% 


%plot RT by screen location


% %if is memory guided task, subtract Target Hold Time
% if Target_(1,10) > 0
%     disp('Correcting SRT by HOLD TIME')
%     %make a backup
%     SRT_backup = SRT;
%     SRT = SRT(:,1) - MG_Hold_;
% end

pos0_slow = intersect(slow_correct_made_dead,pos0);
pos1_slow = intersect(slow_correct_made_dead,pos1);
pos2_slow = intersect(slow_correct_made_dead,pos2);
pos3_slow = intersect(slow_correct_made_dead,pos3);
pos4_slow = intersect(slow_correct_made_dead,pos4);
pos5_slow = intersect(slow_correct_made_dead,pos5);
pos6_slow = intersect(slow_correct_made_dead,pos6);
pos7_slow = intersect(slow_correct_made_dead,pos7);

pos0_med = intersect(med_correct,pos0);
pos1_med = intersect(med_correct,pos1);
pos2_med = intersect(med_correct,pos2);
pos3_med = intersect(med_correct,pos3);
pos4_med = intersect(med_correct,pos4);
pos5_med = intersect(med_correct,pos5);
pos6_med = intersect(med_correct,pos6);
pos7_med = intersect(med_correct,pos7);

pos0_fast = intersect(fast_correct_made_dead_withCleared,pos0);
pos1_fast = intersect(fast_correct_made_dead_withCleared,pos1);
pos2_fast = intersect(fast_correct_made_dead_withCleared,pos2);
pos3_fast = intersect(fast_correct_made_dead_withCleared,pos3);
pos4_fast = intersect(fast_correct_made_dead_withCleared,pos4);
pos5_fast = intersect(fast_correct_made_dead_withCleared,pos5);
pos6_fast = intersect(fast_correct_made_dead_withCleared,pos6);
pos7_fast = intersect(fast_correct_made_dead_withCleared,pos7);


rt0_slow = nanmean(SRT(pos0_slow,1));
rt1_slow = nanmean(SRT(pos1_slow,1));
rt2_slow = nanmean(SRT(pos2_slow,1));
rt3_slow = nanmean(SRT(pos3_slow,1));
rt4_slow = nanmean(SRT(pos4_slow,1));
rt5_slow = nanmean(SRT(pos5_slow,1));
rt6_slow = nanmean(SRT(pos6_slow,1));
rt7_slow = nanmean(SRT(pos7_slow,1));

rt0_med = nanmean(SRT(pos0_med,1));
rt1_med = nanmean(SRT(pos1_med,1));
rt2_med = nanmean(SRT(pos2_med,1));
rt3_med = nanmean(SRT(pos3_med,1));
rt4_med = nanmean(SRT(pos4_med,1));
rt5_med = nanmean(SRT(pos5_med,1));
rt6_med = nanmean(SRT(pos6_med,1));
rt7_med = nanmean(SRT(pos7_med,1));

rt0_fast = nanmean(SRT(pos0_fast,1));
rt1_fast = nanmean(SRT(pos1_fast,1));
rt2_fast = nanmean(SRT(pos2_fast,1));
rt3_fast = nanmean(SRT(pos3_fast,1));
rt4_fast = nanmean(SRT(pos4_fast,1));
rt5_fast = nanmean(SRT(pos5_fast,1));
rt6_fast = nanmean(SRT(pos6_fast,1));
rt7_fast = nanmean(SRT(pos7_fast,1));

sd0_slow = nanstd(SRT(pos0_slow,1));
sd1_slow = nanstd(SRT(pos1_slow,1));
sd2_slow = nanstd(SRT(pos2_slow,1));
sd3_slow = nanstd(SRT(pos3_slow,1));
sd4_slow = nanstd(SRT(pos4_slow,1));
sd5_slow = nanstd(SRT(pos5_slow,1));
sd6_slow = nanstd(SRT(pos6_slow,1));
sd7_slow = nanstd(SRT(pos7_slow,1));

sd0_med = nanstd(SRT(pos0_med,1));
sd1_med = nanstd(SRT(pos1_med,1));
sd2_med = nanstd(SRT(pos2_med,1));
sd3_med = nanstd(SRT(pos3_med,1));
sd4_med = nanstd(SRT(pos4_med,1));
sd5_med = nanstd(SRT(pos5_med,1));
sd6_med = nanstd(SRT(pos6_med,1));
sd7_med = nanstd(SRT(pos7_med,1));

sd0_fast = nanstd(SRT(pos0_fast,1));
sd1_fast = nanstd(SRT(pos1_fast,1));
sd2_fast = nanstd(SRT(pos2_fast,1));
sd3_fast = nanstd(SRT(pos3_fast,1));
sd4_fast = nanstd(SRT(pos4_fast,1));
sd5_fast = nanstd(SRT(pos5_fast,1));
sd6_fast = nanstd(SRT(pos6_fast,1));
sd7_fast = nanstd(SRT(pos7_fast,1));

all_RT_slow = [rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow];
all_RT_med = [rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med];
all_RT_fast = [rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast];

bias_RT_slow = max(all_RT_slow) - min(all_RT_slow);
bias_RT_med = max(all_RT_med) - min(all_RT_med);
bias_RT_fast = max(all_RT_fast) - min(all_RT_fast);

subplot(234)

errorbar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],[sd0_slow sd1_slow sd2_slow sd3_slow sd4_slow sd5_slow sd6_slow sd7_slow 0],'r','linestyle','none','linewidth',2)
hold on

bar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],'facecolor','r')

box off
xlim([-.5 8.5])
y = ylim;
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('RT (ms)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_slow*100)/100)])

subplot(235)
errorbar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],[sd0_med sd1_med sd2_med sd3_med sd4_med sd5_med sd6_med sd7_med 0],'k','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],'facecolor','k')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_med*100)/100)])

subplot(236)
errorbar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],[sd0_fast sd1_fast sd2_fast sd3_fast sd4_fast sd5_fast sd6_fast sd7_fast 0],'g','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],'facecolor','g')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_fast*100)/100)])

[ax h] = suplabel('MADE DEADLINES','t');
set(h,'fontsize',12)












 
 
% VERSION 2: Made + missed deadlines (no Target Hold Errors)
%====================================
getTrials_SAT %re-do to make sure we're not messing with trial vectors
acc0_slow = length(intersect(slow_correct_made_missed,pos0)) / length(intersect(slow_all,pos0));
acc1_slow = length(intersect(slow_correct_made_missed,pos1)) / length(intersect(slow_all,pos1));
acc2_slow = length(intersect(slow_correct_made_missed,pos2)) / length(intersect(slow_all,pos2));
acc3_slow = length(intersect(slow_correct_made_missed,pos3)) / length(intersect(slow_all,pos3));
acc4_slow = length(intersect(slow_correct_made_missed,pos4)) / length(intersect(slow_all,pos4));
acc5_slow = length(intersect(slow_correct_made_missed,pos5)) / length(intersect(slow_all,pos5));
acc6_slow = length(intersect(slow_correct_made_missed,pos6)) / length(intersect(slow_all,pos6));
acc7_slow = length(intersect(slow_correct_made_missed,pos7)) / length(intersect(slow_all,pos7));
acc_catch_slow = nanmean(Correct_(ctch_slow,2));
 
acc0_med = length(intersect(med_correct,pos0)) / length(intersect(med_all,pos0));
acc1_med = length(intersect(med_correct,pos1)) / length(intersect(med_all,pos1));
acc2_med = length(intersect(med_correct,pos2)) / length(intersect(med_all,pos2));
acc3_med = length(intersect(med_correct,pos3)) / length(intersect(med_all,pos3));
acc4_med = length(intersect(med_correct,pos4)) / length(intersect(med_all,pos4));
acc5_med = length(intersect(med_correct,pos5)) / length(intersect(med_all,pos5));
acc6_med = length(intersect(med_correct,pos6)) / length(intersect(med_all,pos6));
acc7_med = length(intersect(med_correct,pos7)) / length(intersect(med_all,pos7));
acc_catch_med = nanmean(Correct_(ctch_med,2));
 
 
acc0_fast = length(intersect(fast_correct_made_missed_withCleared,pos0)) / length(intersect(fast_all_withCleared,pos0));
acc1_fast = length(intersect(fast_correct_made_missed_withCleared,pos1)) / length(intersect(fast_all_withCleared,pos1));
acc2_fast = length(intersect(fast_correct_made_missed_withCleared,pos2)) / length(intersect(fast_all_withCleared,pos2));
acc3_fast = length(intersect(fast_correct_made_missed_withCleared,pos3)) / length(intersect(fast_all_withCleared,pos3));
acc4_fast = length(intersect(fast_correct_made_missed_withCleared,pos4)) / length(intersect(fast_all_withCleared,pos4));
acc5_fast = length(intersect(fast_correct_made_missed_withCleared,pos5)) / length(intersect(fast_all_withCleared,pos5));
acc6_fast = length(intersect(fast_correct_made_missed_withCleared,pos6)) / length(intersect(fast_all_withCleared,pos6));
acc7_fast = length(intersect(fast_correct_made_missed_withCleared,pos7)) / length(intersect(fast_all_withCleared,pos7));
acc_catch_fast = nanmean(Correct_(ctch_fast,2));
 
% 
% %Now do it again, but set Target Hold Errors to being correct to see the
% %difference
% 
% Correct_withHoldErrors = Correct_;
% Correct_withHoldErrors(find(Errors_(:,4) == 1),2) = 1;
% 
% acc0_withHoldErrors = nansum(Correct_withHoldErrors(pos0,2)) / length(pos0);
% acc1_withHoldErrors = nansum(Correct_withHoldErrors(pos1,2)) / length(pos1);
% acc2_withHoldErrors = nansum(Correct_withHoldErrors(pos2,2)) / length(pos2);
% acc3_withHoldErrors = nansum(Correct_withHoldErrors(pos3,2)) / length(pos3);
% acc4_withHoldErrors = nansum(Correct_withHoldErrors(pos4,2)) / length(pos4);
% acc5_withHoldErrors = nansum(Correct_withHoldErrors(pos5,2)) / length(pos5);
% acc6_withHoldErrors = nansum(Correct_withHoldErrors(pos6,2)) / length(pos6);
% acc7_withHoldErrors = nansum(Correct_withHoldErrors(pos7,2)) / length(pos7);
 
%acc_catch = nansum(Correct_(ctch,2)) / length(ctch);
 
all_ACC_slow = [acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow];
all_ACC_med = [acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med];
all_ACC_fast = [acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast];
 
bias_ACC_slow = max(all_ACC_slow) - min(all_ACC_slow);
bias_ACC_med = max(all_ACC_med) - min(all_ACC_med);
bias_ACC_fast = max(all_ACC_fast) - min(all_ACC_fast);
 
f = figure;
set(f,'color','white')
set(f,'position',[379 171 1033 635])
 
subplot(231)
hold on
 
%First make bar plot of 'withHoldErrors' because this will always be
%greater
%bar(0:8,[acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors acc_catch],'facecolor','r')
 
%then plot regular accuracy rate
bar(0:8,[acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow acc_catch_slow],'facecolor','r')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_slow],'facecolor','b')
 
xlim([-.5 8.5])
% set(gca,'xticklabel',['pos0' ; 'pos1' ; 'pos2' ; 'pos3' ; 'pos4' ; 'pos5' ; 'pos6' ; 'pos7' ; 'ctch'])
%legend('With Targ Hold Errors','No Targ Hold Errors','Catch Trials')
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_slow*100)/100)])
 
 
subplot(232)
hold on
bar(0:8,[acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med acc_catch_med],'facecolor','k')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_med],'facecolor','b')
 
xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_med*100)/100)])
 
subplot(233)
hold on
bar(0:8,[acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast acc_catch_fast],'facecolor','g')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_fast],'facecolor','b')
 
xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_fast*100)/100)])
 
% %write in text to specify how many trials recorded
% text(0,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos0,2))) ';   N=' mat2str(length(pos0))],'color','white','rotation',90,'fontsize',14)
% text(1,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos1,2))) ';   N=' mat2str(length(pos1))],'color','white','rotation',90,'fontsize',14)
% text(2,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos2,2))) ';   N=' mat2str(length(pos2))],'color','white','rotation',90,'fontsize',14)
% text(3,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos3,2))) ';   N=' mat2str(length(pos3))],'color','white','rotation',90,'fontsize',14)
% text(4,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos4,2))) ';   N=' mat2str(length(pos4))],'color','white','rotation',90,'fontsize',14)
% text(5,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos5,2))) ';   N=' mat2str(length(pos5))],'color','white','rotation',90,'fontsize',14)
% text(6,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos6,2))) ';   N=' mat2str(length(pos6))],'color','white','rotation',90,'fontsize',14)
% text(7,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos7,2))) ';   N=' mat2str(length(pos7))],'color','white','rotation',90,'fontsize',14)
% text(8,.1,['N Correct =' mat2str(nansum(Correct_(ctch,2))) ';   N=' mat2str(length(ctch))],'color','k','rotation',90,'fontsize',14)
% %set(gca,'color',[.8 .8 .8]) %set background to gray so can see characters
% clear pos* acc* Correct_withHoldErrors
% 
 
 
%plot RT by screen location
 
 
% %if is memory guided task, subtract Target Hold Time
% if Target_(1,10) > 0
%     disp('Correcting SRT by HOLD TIME')
%     %make a backup
%     SRT_backup = SRT;
%     SRT = SRT(:,1) - MG_Hold_;
% end
 
pos0_slow = intersect(slow_correct_made_missed,pos0);
pos1_slow = intersect(slow_correct_made_missed,pos1);
pos2_slow = intersect(slow_correct_made_missed,pos2);
pos3_slow = intersect(slow_correct_made_missed,pos3);
pos4_slow = intersect(slow_correct_made_missed,pos4);
pos5_slow = intersect(slow_correct_made_missed,pos5);
pos6_slow = intersect(slow_correct_made_missed,pos6);
pos7_slow = intersect(slow_correct_made_missed,pos7);
 
pos0_med = intersect(med_correct,pos0);
pos1_med = intersect(med_correct,pos1);
pos2_med = intersect(med_correct,pos2);
pos3_med = intersect(med_correct,pos3);
pos4_med = intersect(med_correct,pos4);
pos5_med = intersect(med_correct,pos5);
pos6_med = intersect(med_correct,pos6);
pos7_med = intersect(med_correct,pos7);
 
pos0_fast = intersect(fast_correct_made_missed_withCleared,pos0);
pos1_fast = intersect(fast_correct_made_missed_withCleared,pos1);
pos2_fast = intersect(fast_correct_made_missed_withCleared,pos2);
pos3_fast = intersect(fast_correct_made_missed_withCleared,pos3);
pos4_fast = intersect(fast_correct_made_missed_withCleared,pos4);
pos5_fast = intersect(fast_correct_made_missed_withCleared,pos5);
pos6_fast = intersect(fast_correct_made_missed_withCleared,pos6);
pos7_fast = intersect(fast_correct_made_missed_withCleared,pos7);
 
 
rt0_slow = nanmean(SRT(pos0_slow,1));
rt1_slow = nanmean(SRT(pos1_slow,1));
rt2_slow = nanmean(SRT(pos2_slow,1));
rt3_slow = nanmean(SRT(pos3_slow,1));
rt4_slow = nanmean(SRT(pos4_slow,1));
rt5_slow = nanmean(SRT(pos5_slow,1));
rt6_slow = nanmean(SRT(pos6_slow,1));
rt7_slow = nanmean(SRT(pos7_slow,1));
 
rt0_med = nanmean(SRT(pos0_med,1));
rt1_med = nanmean(SRT(pos1_med,1));
rt2_med = nanmean(SRT(pos2_med,1));
rt3_med = nanmean(SRT(pos3_med,1));
rt4_med = nanmean(SRT(pos4_med,1));
rt5_med = nanmean(SRT(pos5_med,1));
rt6_med = nanmean(SRT(pos6_med,1));
rt7_med = nanmean(SRT(pos7_med,1));
 
rt0_fast = nanmean(SRT(pos0_fast,1));
rt1_fast = nanmean(SRT(pos1_fast,1));
rt2_fast = nanmean(SRT(pos2_fast,1));
rt3_fast = nanmean(SRT(pos3_fast,1));
rt4_fast = nanmean(SRT(pos4_fast,1));
rt5_fast = nanmean(SRT(pos5_fast,1));
rt6_fast = nanmean(SRT(pos6_fast,1));
rt7_fast = nanmean(SRT(pos7_fast,1));
 
sd0_slow = nanstd(SRT(pos0_slow,1));
sd1_slow = nanstd(SRT(pos1_slow,1));
sd2_slow = nanstd(SRT(pos2_slow,1));
sd3_slow = nanstd(SRT(pos3_slow,1));
sd4_slow = nanstd(SRT(pos4_slow,1));
sd5_slow = nanstd(SRT(pos5_slow,1));
sd6_slow = nanstd(SRT(pos6_slow,1));
sd7_slow = nanstd(SRT(pos7_slow,1));
 
sd0_med = nanstd(SRT(pos0_med,1));
sd1_med = nanstd(SRT(pos1_med,1));
sd2_med = nanstd(SRT(pos2_med,1));
sd3_med = nanstd(SRT(pos3_med,1));
sd4_med = nanstd(SRT(pos4_med,1));
sd5_med = nanstd(SRT(pos5_med,1));
sd6_med = nanstd(SRT(pos6_med,1));
sd7_med = nanstd(SRT(pos7_med,1));
 
sd0_fast = nanstd(SRT(pos0_fast,1));
sd1_fast = nanstd(SRT(pos1_fast,1));
sd2_fast = nanstd(SRT(pos2_fast,1));
sd3_fast = nanstd(SRT(pos3_fast,1));
sd4_fast = nanstd(SRT(pos4_fast,1));
sd5_fast = nanstd(SRT(pos5_fast,1));
sd6_fast = nanstd(SRT(pos6_fast,1));
sd7_fast = nanstd(SRT(pos7_fast,1));
 
all_RT_slow = [rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow];
all_RT_med = [rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med];
all_RT_fast = [rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast];
 
bias_RT_slow = max(all_RT_slow) - min(all_RT_slow);
bias_RT_med = max(all_RT_med) - min(all_RT_med);
bias_RT_fast = max(all_RT_fast) - min(all_RT_fast);
 
subplot(234)
 
errorbar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],[sd0_slow sd1_slow sd2_slow sd3_slow sd4_slow sd5_slow sd6_slow sd7_slow 0],'r','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],'facecolor','r')
 
box off
xlim([-.5 8.5])
y = ylim;
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('RT (ms)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_slow*100)/100)])
 
subplot(235)
errorbar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],[sd0_med sd1_med sd2_med sd3_med sd4_med sd5_med sd6_med sd7_med 0],'k','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],'facecolor','k')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_med*100)/100)])
 
subplot(236)
errorbar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],[sd0_fast sd1_fast sd2_fast sd3_fast sd4_fast sd5_fast sd6_fast sd7_fast 0],'g','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],'facecolor','g')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_fast*100)/100)])
 
[ax h] = suplabel('MADE + MISSED DEADLINES (no tHold Errors)','t');
set(h,'fontsize',12)








%====================================
% VERSION 3: Made + missed deadlines (WITH Target Hold Errors)
%====================================
getTrials_SAT %re-do to make sure we're not screwing up trial vectors.

acc0_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos0)) / length(intersect(slow_all_withTargHold,pos0));
acc1_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos1)) / length(intersect(slow_all_withTargHold,pos1));
acc2_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos2)) / length(intersect(slow_all_withTargHold,pos2));
acc3_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos3)) / length(intersect(slow_all_withTargHold,pos3));
acc4_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos4)) / length(intersect(slow_all_withTargHold,pos4));
acc5_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos5)) / length(intersect(slow_all_withTargHold,pos5));
acc6_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos6)) / length(intersect(slow_all_withTargHold,pos6));
acc7_slow = length(intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos7)) / length(intersect(slow_all_withTargHold,pos7));
acc_catch_slow = nanmean(Correct_(ctch_slow,2));
 
acc0_med = length(intersect([med_correct ; med_errors_targHold],pos0)) / length(intersect(med_all_withTargHold,pos0));
acc1_med = length(intersect([med_correct ; med_errors_targHold],pos1)) / length(intersect(med_all_withTargHold,pos1));
acc2_med = length(intersect([med_correct ; med_errors_targHold],pos2)) / length(intersect(med_all_withTargHold,pos2));
acc3_med = length(intersect([med_correct ; med_errors_targHold],pos3)) / length(intersect(med_all_withTargHold,pos3));
acc4_med = length(intersect([med_correct ; med_errors_targHold],pos4)) / length(intersect(med_all_withTargHold,pos4));
acc5_med = length(intersect([med_correct ; med_errors_targHold],pos5)) / length(intersect(med_all_withTargHold,pos5));
acc6_med = length(intersect([med_correct ; med_errors_targHold],pos6)) / length(intersect(med_all_withTargHold,pos6));
acc7_med = length(intersect([med_correct ; med_errors_targHold],pos7)) / length(intersect(med_all_withTargHold,pos7));
acc_catch_med = nanmean(Correct_(ctch_med,2));
 
 
acc0_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos0)) / length(intersect(fast_all_withCleared_withTargHold,pos0));
acc1_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos1)) / length(intersect(fast_all_withCleared_withTargHold,pos1));
acc2_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos2)) / length(intersect(fast_all_withCleared_withTargHold,pos2));
acc3_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos3)) / length(intersect(fast_all_withCleared_withTargHold,pos3));
acc4_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos4)) / length(intersect(fast_all_withCleared_withTargHold,pos4));
acc5_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos5)) / length(intersect(fast_all_withCleared_withTargHold,pos5));
acc6_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos6)) / length(intersect(fast_all_withCleared_withTargHold,pos6));
acc7_fast = length(intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos7)) / length(intersect(fast_all_withCleared_withTargHold,pos7));
acc_catch_fast = nanmean(Correct_(ctch_fast,2));
 
% 
% %Now do it again, but set Target Hold Errors to being correct to see the
% %difference
% 
% Correct_withHoldErrors = Correct_;
% Correct_withHoldErrors(find(Errors_(:,4) == 1),2) = 1;
% 
% acc0_withHoldErrors = nansum(Correct_withHoldErrors(pos0,2)) / length(pos0);
% acc1_withHoldErrors = nansum(Correct_withHoldErrors(pos1,2)) / length(pos1);
% acc2_withHoldErrors = nansum(Correct_withHoldErrors(pos2,2)) / length(pos2);
% acc3_withHoldErrors = nansum(Correct_withHoldErrors(pos3,2)) / length(pos3);
% acc4_withHoldErrors = nansum(Correct_withHoldErrors(pos4,2)) / length(pos4);
% acc5_withHoldErrors = nansum(Correct_withHoldErrors(pos5,2)) / length(pos5);
% acc6_withHoldErrors = nansum(Correct_withHoldErrors(pos6,2)) / length(pos6);
% acc7_withHoldErrors = nansum(Correct_withHoldErrors(pos7,2)) / length(pos7);
 
%acc_catch = nansum(Correct_(ctch,2)) / length(ctch);
 
all_ACC_slow = [acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow];
all_ACC_med = [acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med];
all_ACC_fast = [acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast];
 
bias_ACC_slow = max(all_ACC_slow) - min(all_ACC_slow);
bias_ACC_med = max(all_ACC_med) - min(all_ACC_med);
bias_ACC_fast = max(all_ACC_fast) - min(all_ACC_fast);
 
f = figure;
set(f,'color','white')
set(f,'position',[379 171 1033 635])
 
subplot(231)
hold on
 
%First make bar plot of 'withHoldErrors' because this will always be
%greater
%bar(0:8,[acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors acc_catch],'facecolor','r')
 
%then plot regular accuracy rate
bar(0:8,[acc0_slow acc1_slow acc2_slow acc3_slow acc4_slow acc5_slow acc6_slow acc7_slow acc_catch_slow],'facecolor','r')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_slow],'facecolor','b')
 
xlim([-.5 8.5])
% set(gca,'xticklabel',['pos0' ; 'pos1' ; 'pos2' ; 'pos3' ; 'pos4' ; 'pos5' ; 'pos6' ; 'pos7' ; 'ctch'])
%legend('With Targ Hold Errors','No Targ Hold Errors','Catch Trials')
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_slow*100)/100)])
 
 
subplot(232)
hold on
bar(0:8,[acc0_med acc1_med acc2_med acc3_med acc4_med acc5_med acc6_med acc7_med acc_catch_med],'facecolor','k')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_med],'facecolor','b')
 
xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_med*100)/100)])
 
subplot(233)
hold on
bar(0:8,[acc0_fast acc1_fast acc2_fast acc3_fast acc4_fast acc5_fast acc6_fast acc7_fast acc_catch_fast],'facecolor','g')
 
%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch_fast],'facecolor','b')
 
xlim([-.5 8.5])
ylim([0 1.05])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_ACC_fast*100)/100)])
 
% %write in text to specify how many trials recorded
% text(0,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos0,2))) ';   N=' mat2str(length(pos0))],'color','white','rotation',90,'fontsize',14)
% text(1,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos1,2))) ';   N=' mat2str(length(pos1))],'color','white','rotation',90,'fontsize',14)
% text(2,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos2,2))) ';   N=' mat2str(length(pos2))],'color','white','rotation',90,'fontsize',14)
% text(3,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos3,2))) ';   N=' mat2str(length(pos3))],'color','white','rotation',90,'fontsize',14)
% text(4,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos4,2))) ';   N=' mat2str(length(pos4))],'color','white','rotation',90,'fontsize',14)
% text(5,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos5,2))) ';   N=' mat2str(length(pos5))],'color','white','rotation',90,'fontsize',14)
% text(6,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos6,2))) ';   N=' mat2str(length(pos6))],'color','white','rotation',90,'fontsize',14)
% text(7,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos7,2))) ';   N=' mat2str(length(pos7))],'color','white','rotation',90,'fontsize',14)
% text(8,.1,['N Correct =' mat2str(nansum(Correct_(ctch,2))) ';   N=' mat2str(length(ctch))],'color','k','rotation',90,'fontsize',14)
% %set(gca,'color',[.8 .8 .8]) %set background to gray so can see characters
% clear pos* acc* Correct_withHoldErrors
% 
 
 
%plot RT by screen location
 
 
% %if is memory guided task, subtract Target Hold Time
% if Target_(1,10) > 0
%     disp('Correcting SRT by HOLD TIME')
%     %make a backup
%     SRT_backup = SRT;
%     SRT = SRT(:,1) - MG_Hold_;
% end
 
pos0_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos0);
pos1_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos1);
pos2_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos2);
pos3_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos3);
pos4_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos4);
pos5_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos5);
pos6_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos6);
pos7_slow = intersect([slow_correct_made_missed ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold],pos7);
 
pos0_med = intersect([med_correct ; med_errors_targHold],pos0);
pos1_med = intersect([med_correct ; med_errors_targHold],pos1);
pos2_med = intersect([med_correct ; med_errors_targHold],pos2);
pos3_med = intersect([med_correct ; med_errors_targHold],pos3);
pos4_med = intersect([med_correct ; med_errors_targHold],pos4);
pos5_med = intersect([med_correct ; med_errors_targHold],pos5);
pos6_med = intersect([med_correct ; med_errors_targHold],pos6);
pos7_med = intersect([med_correct ; med_errors_targHold],pos7);
 
pos0_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos0);
pos1_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos1);
pos2_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos2);
pos3_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos3);
pos4_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos4);
pos5_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos5);
pos6_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos6);
pos7_fast = intersect([fast_correct_made_missed_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold],pos7);
 
 
rt0_slow = nanmean(SRT(pos0_slow,1));
rt1_slow = nanmean(SRT(pos1_slow,1));
rt2_slow = nanmean(SRT(pos2_slow,1));
rt3_slow = nanmean(SRT(pos3_slow,1));
rt4_slow = nanmean(SRT(pos4_slow,1));
rt5_slow = nanmean(SRT(pos5_slow,1));
rt6_slow = nanmean(SRT(pos6_slow,1));
rt7_slow = nanmean(SRT(pos7_slow,1));
 
rt0_med = nanmean(SRT(pos0_med,1));
rt1_med = nanmean(SRT(pos1_med,1));
rt2_med = nanmean(SRT(pos2_med,1));
rt3_med = nanmean(SRT(pos3_med,1));
rt4_med = nanmean(SRT(pos4_med,1));
rt5_med = nanmean(SRT(pos5_med,1));
rt6_med = nanmean(SRT(pos6_med,1));
rt7_med = nanmean(SRT(pos7_med,1));
 
rt0_fast = nanmean(SRT(pos0_fast,1));
rt1_fast = nanmean(SRT(pos1_fast,1));
rt2_fast = nanmean(SRT(pos2_fast,1));
rt3_fast = nanmean(SRT(pos3_fast,1));
rt4_fast = nanmean(SRT(pos4_fast,1));
rt5_fast = nanmean(SRT(pos5_fast,1));
rt6_fast = nanmean(SRT(pos6_fast,1));
rt7_fast = nanmean(SRT(pos7_fast,1));
 
sd0_slow = nanstd(SRT(pos0_slow,1));
sd1_slow = nanstd(SRT(pos1_slow,1));
sd2_slow = nanstd(SRT(pos2_slow,1));
sd3_slow = nanstd(SRT(pos3_slow,1));
sd4_slow = nanstd(SRT(pos4_slow,1));
sd5_slow = nanstd(SRT(pos5_slow,1));
sd6_slow = nanstd(SRT(pos6_slow,1));
sd7_slow = nanstd(SRT(pos7_slow,1));
 
sd0_med = nanstd(SRT(pos0_med,1));
sd1_med = nanstd(SRT(pos1_med,1));
sd2_med = nanstd(SRT(pos2_med,1));
sd3_med = nanstd(SRT(pos3_med,1));
sd4_med = nanstd(SRT(pos4_med,1));
sd5_med = nanstd(SRT(pos5_med,1));
sd6_med = nanstd(SRT(pos6_med,1));
sd7_med = nanstd(SRT(pos7_med,1));
 
sd0_fast = nanstd(SRT(pos0_fast,1));
sd1_fast = nanstd(SRT(pos1_fast,1));
sd2_fast = nanstd(SRT(pos2_fast,1));
sd3_fast = nanstd(SRT(pos3_fast,1));
sd4_fast = nanstd(SRT(pos4_fast,1));
sd5_fast = nanstd(SRT(pos5_fast,1));
sd6_fast = nanstd(SRT(pos6_fast,1));
sd7_fast = nanstd(SRT(pos7_fast,1));
 
all_RT_slow = [rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow];
all_RT_med = [rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med];
all_RT_fast = [rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast];
 
bias_RT_slow = max(all_RT_slow) - min(all_RT_slow);
bias_RT_med = max(all_RT_med) - min(all_RT_med);
bias_RT_fast = max(all_RT_fast) - min(all_RT_fast);
 
subplot(234)
 
errorbar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],[sd0_slow sd1_slow sd2_slow sd3_slow sd4_slow sd5_slow sd6_slow sd7_slow 0],'r','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_slow rt1_slow rt2_slow rt3_slow rt4_slow rt5_slow rt6_slow rt7_slow 0],'facecolor','r')
 
box off
xlim([-.5 8.5])
y = ylim;
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('RT (ms)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_slow*100)/100)])
 
subplot(235)
errorbar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],[sd0_med sd1_med sd2_med sd3_med sd4_med sd5_med sd6_med sd7_med 0],'k','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_med rt1_med rt2_med rt3_med rt4_med rt5_med rt6_med rt7_med 0],'facecolor','k')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_med*100)/100)])
 
subplot(236)
errorbar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],[sd0_fast sd1_fast sd2_fast sd3_fast sd4_fast sd5_fast sd6_fast sd7_fast 0],'g','linestyle','none','linewidth',2)
hold on
 
bar(0:8,[rt0_fast rt1_fast rt2_fast rt3_fast rt4_fast rt5_fast rt6_fast rt7_fast 0],'facecolor','g')
 
box off
xlim([-.5 8.5])
ylim(y)
set(gca,'color',[.6 .6 .6])
title(['Bias: ' mat2str(round(bias_RT_fast*100)/100)])
 
[ax h] = suplabel('MADE + MISSED DEADLINES (WITH tHold Errors)','t');
set(h,'fontsize',12)



figure(ff) %bring important figure to foreground
