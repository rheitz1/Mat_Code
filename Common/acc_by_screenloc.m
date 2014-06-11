%plot accuracy rate by screen location

pos0 = find(Target_(:,2) == 0);
pos1 = find(Target_(:,2) == 1);
pos2 = find(Target_(:,2) == 2);
pos3 = find(Target_(:,2) == 3);
pos4 = find(Target_(:,2) == 4);
pos5 = find(Target_(:,2) == 5);
pos6 = find(Target_(:,2) == 6);
pos7 = find(Target_(:,2) == 7);
ctch = find(Target_(:,2) == 255);

acc0 = nansum(Correct_(pos0,2)) / length(pos0);
acc1 = nansum(Correct_(pos1,2)) / length(pos1);
acc2 = nansum(Correct_(pos2,2)) / length(pos2);
acc3 = nansum(Correct_(pos3,2)) / length(pos3);
acc4 = nansum(Correct_(pos4,2)) / length(pos4);
acc5 = nansum(Correct_(pos5,2)) / length(pos5);
acc6 = nansum(Correct_(pos6,2)) / length(pos6);
acc7 = nansum(Correct_(pos7,2)) / length(pos7);

ACC = nanmean(Correct_(find(Target_(:,2) ~=255),2));

% bias = [acc0 - ACC acc4-ACC acc1-ACC acc5-ACC acc2-ACC acc6-ACC ...
%     acc3-ACC acc7-ACC];

%Now do it again, but set Target Hold Errors to being correct to see the
%difference

Correct_withHoldErrors = Correct_;
Correct_withHoldErrors(find(Errors_(:,4) == 1),2) = 1;

acc0_withHoldErrors = nansum(Correct_withHoldErrors(pos0,2)) / length(pos0);
acc1_withHoldErrors = nansum(Correct_withHoldErrors(pos1,2)) / length(pos1);
acc2_withHoldErrors = nansum(Correct_withHoldErrors(pos2,2)) / length(pos2);
acc3_withHoldErrors = nansum(Correct_withHoldErrors(pos3,2)) / length(pos3);
acc4_withHoldErrors = nansum(Correct_withHoldErrors(pos4,2)) / length(pos4);
acc5_withHoldErrors = nansum(Correct_withHoldErrors(pos5,2)) / length(pos5);
acc6_withHoldErrors = nansum(Correct_withHoldErrors(pos6,2)) / length(pos6);
acc7_withHoldErrors = nansum(Correct_withHoldErrors(pos7,2)) / length(pos7);

acc_catch = nansum(Correct_(ctch,2)) / length(ctch);

all_ACC = [acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors];
bias_ACC = max(all_ACC) - min(all_ACC);


figure
hold on

%First make bar plot of 'withHoldErrors' because this will always be
%greater
bar(0:8,[acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors acc_catch],'facecolor','r')

%then plot regular accuracy rate
bar(0:8,[acc0 acc1 acc2 acc3 acc4 acc5 acc6 acc7 acc_catch],'facecolor','k')

%finally overwrite last bar with catch trials so can have different color
bar(0:8,[0 0 0 0 0 0 0 0 acc_catch],'facecolor',[0 1 .2])

xlim([-.5 8.5])
set(gca,'xticklabel',['pos0' ; 'pos1' ; 'pos2' ; 'pos3' ; 'pos4' ; 'pos5' ; 'pos6' ; 'pos7' ; 'ctch'])
legend('With Targ Hold Errors','No Targ Hold Errors','Catch Trials')
ylim([0 1.2])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
box off
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')

title('Accuracy rate by screen position','fontsize',14,'fontweight','bold')

%write in text to specify how many trials recorded
text(0,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos0,2))) ';   N=' mat2str(length(pos0))],'color','white','rotation',90,'fontsize',14)
text(1,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos1,2))) ';   N=' mat2str(length(pos1))],'color','white','rotation',90,'fontsize',14)
text(2,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos2,2))) ';   N=' mat2str(length(pos2))],'color','white','rotation',90,'fontsize',14)
text(3,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos3,2))) ';   N=' mat2str(length(pos3))],'color','white','rotation',90,'fontsize',14)
text(4,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos4,2))) ';   N=' mat2str(length(pos4))],'color','white','rotation',90,'fontsize',14)
text(5,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos5,2))) ';   N=' mat2str(length(pos5))],'color','white','rotation',90,'fontsize',14)
text(6,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos6,2))) ';   N=' mat2str(length(pos6))],'color','white','rotation',90,'fontsize',14)
text(7,.1,['N Correct =' mat2str(nansum(Correct_withHoldErrors(pos7,2))) ';   N=' mat2str(length(pos7))],'color','white','rotation',90,'fontsize',14)
text(8,.1,['N Correct =' mat2str(nansum(Correct_(ctch,2))) ';   N=' mat2str(length(ctch))],'color','k','rotation',90,'fontsize',14)
%set(gca,'color',[.8 .8 .8]) %set background to gray so can see characters
clear pos* acc* Correct_withHoldErrors

disp(['Accuracy Rate bias = ' mat2str(round(bias_ACC*100)/100)])