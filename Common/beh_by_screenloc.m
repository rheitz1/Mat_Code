printFlag = 0;
plot_pos_move_avg = 1;
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

if plot_pos_move_avg
    posMvAvgWin = 20;
    
    try %tsmovavg will fail if not enough trials per location. Suppress on failure
        mvavg.pos0 = tsmovavg(Correct_(pos0,2)','s',posMvAvgWin);
        mvavg.pos1 = tsmovavg(Correct_(pos1,2)','s',posMvAvgWin);
        mvavg.pos2 = tsmovavg(Correct_(pos2,2)','s',posMvAvgWin);
        mvavg.pos3 = tsmovavg(Correct_(pos3,2)','s',posMvAvgWin);
        mvavg.pos4 = tsmovavg(Correct_(pos4,2)','s',posMvAvgWin);
        mvavg.pos5 = tsmovavg(Correct_(pos5,2)','s',posMvAvgWin);
        mvavg.pos6 = tsmovavg(Correct_(pos6,2)','s',posMvAvgWin);
        mvavg.pos7 = tsmovavg(Correct_(pos7,2)','s',posMvAvgWin);
        
        ff = figure;
        set(gcf,'position',[2    43   464   284])
        subplot(331)
        plot(mvavg.pos3)
        
        subplot(332)
        plot(mvavg.pos2)
        
        subplot(333)
        plot(mvavg.pos1)
        
        subplot(334)
        plot(mvavg.pos4)
        
        subplot(336)
        plot(mvavg.pos0)
        
        subplot(337)
        plot(mvavg.pos5)
        
        subplot(338)
        plot(mvavg.pos6)
        
        subplot(339)
        plot(mvavg.pos7)
        
        %scale all subplots
        xlims =[0 max([length(mvavg.pos0) length(mvavg.pos1) length(mvavg.pos2) ...
            length(mvavg.pos3) length(mvavg.pos4) length(mvavg.pos5) ...
            length(mvavg.pos6) length(mvavg.pos7)])];
        
        for s = 1:9
            subplot(3,3,s)
            ylim([0 1])
            xlim(xlims)
            box off
            hline(1/8,'--r')
        end
        
    catch
        disp('Suppressing position moving average')
        plot_pos_move_avg = 0;
    end
    
end


% std0 = sqrt(acc0 * (1-acc0)); %variance of bernoulli experiment is p(1-p)
% std1 = sqrt(acc1 * (1-acc1));
% std2 = sqrt(acc2 * (1-acc2));
% std3 = sqrt(acc3 * (1-acc3));
% std4 = sqrt(acc4 * (1-acc4));
% std5 = sqrt(acc5 * (1-acc5));
% std6 = sqrt(acc6 * (1-acc6));
% std7 = sqrt(acc7 * (1-acc7));

ACC = nanmean(Correct_(find(Target_(:,2) ~=255),2));


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

% acc_catch = nansum(Correct_(ctch,2)) / length(ctch);
acc_catch = nanmean(Correct_(ctch,2));

all_ACC = [acc0_withHoldErrors acc1_withHoldErrors acc2_withHoldErrors acc3_withHoldErrors acc4_withHoldErrors acc5_withHoldErrors acc6_withHoldErrors acc7_withHoldErrors];
bias_ACC = max(all_ACC) - min(all_ACC);

f = figure;
set(f,'color','white')
set(f,'position',[379 171 1033 635])

subplot(221)
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
%set(gca,'xticklabel',['pos0' ; 'pos2' ; 'pos4' ; 'pos6' ; 'ctch'])
legend('With Targ Hold Errors','No Targ Hold Errors','Catch Trials')
legend('With Targ Hold Errors')
ylim([0 1.2])   %make room for the legend
hline(1,'k')    %remind me where ceiling is
hline(1/7,'--r')
box off
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
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



%plot RT by screen location

if exist('SRT') == 0
    SRT = getSRT(EyeX_,EyeY_);
end

%if is memory guided task, subtract Target Hold Time
if Target_(1,10) > 0
    disp('Correcting SRT by HOLD TIME')
    %make a backup
    SRT_backup = SRT;
    SRT = SRT(:,1) - MG_Hold_;
end

pos0 = find(Correct_(:,2) == 1 & Target_(:,2) == 0);
pos1 = find(Correct_(:,2) == 1 & Target_(:,2) == 1);
pos2 = find(Correct_(:,2) == 1 & Target_(:,2) == 2);
pos3 = find(Correct_(:,2) == 1 & Target_(:,2) == 3);
pos4 = find(Correct_(:,2) == 1 & Target_(:,2) == 4);
pos5 = find(Correct_(:,2) == 1 & Target_(:,2) == 5);
pos6 = find(Correct_(:,2) == 1 & Target_(:,2) == 6);
pos7 = find(Correct_(:,2) == 1 & Target_(:,2) == 7);


rt0 = nanmean(SRT(pos0,1));
rt1 = nanmean(SRT(pos1,1));
rt2 = nanmean(SRT(pos2,1));
rt3 = nanmean(SRT(pos3,1));
rt4 = nanmean(SRT(pos4,1));
rt5 = nanmean(SRT(pos5,1));
rt6 = nanmean(SRT(pos6,1));
rt7 = nanmean(SRT(pos7,1));

sd0 = nanstd(SRT(pos0,1));
sd1 = nanstd(SRT(pos1,1));
sd2 = nanstd(SRT(pos2,1));
sd3 = nanstd(SRT(pos3,1));
sd4 = nanstd(SRT(pos4,1));
sd5 = nanstd(SRT(pos5,1));
sd6 = nanstd(SRT(pos6,1));
sd7 = nanstd(SRT(pos7,1));

all_RT = [rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7];
bias_RT = max(all_RT) - min(all_RT);

subplot(222)

errorbar(0:7,[rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7],[sd0 sd1 sd2 sd3 sd4 sd5 sd6 sd7],'k','linestyle','none','linewidth',2)
hold on

bar(0:7,[rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7],'facecolor','k')

box off
xlim([-.7 7.5])
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('RT (ms)','fontsize',18,'fontweight','bold')
set(gca,'color',[.6 .6 .6])
title('RT by screen position for all CORRECT Trials','fontsize',14,'fontweight','bold')


%Note how many trials goes into calculation
text(0,50,['N =' mat2str(length(pos0))],'color','white','rotation',90,'fontsize',14)
text(1,50,['N =' mat2str(length(pos1))],'color','white','rotation',90,'fontsize',14)
text(2,50,['N =' mat2str(length(pos2))],'color','white','rotation',90,'fontsize',14)
text(3,50,['N =' mat2str(length(pos3))],'color','white','rotation',90,'fontsize',14)
text(4,50,['N =' mat2str(length(pos4))],'color','white','rotation',90,'fontsize',14)
text(5,50,['N =' mat2str(length(pos5))],'color','white','rotation',90,'fontsize',14)
text(6,50,['N =' mat2str(length(pos6))],'color','white','rotation',90,'fontsize',14)
text(7,50,['N =' mat2str(length(pos7))],'color','white','rotation',90,'fontsize',14)

ylim([0 1000])

clear pos* rt* sd* y f

move_avg_win = 20;

subplot(223)
plot(tsmovavg(Correct_(:,2)','s',move_avg_win),'b','linewidth',2)
box off
text(.30,1.0,[mat2str(move_avg_win) ' trial moving average'],'units','normalized','fontsize',14)
xlabel('Trial # bin','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
%ylim([.15 1.1])
ylim([0 1.1])
hline(1,'k')
hline(1/8,'--r')
xl = xlim;

% newax
% plot(tsmovavg(SRT(:,1)','s',20),'r','linewidth',2)
% ylabel('RT (ms)','fontsize',18,'fontweight','bold')
% xlim(xl)
% y = ylim;
% ylim([0 y(2)])
% set(gca,'xticklabel',[])


%=======
% Calculate accuracy rates for different distractor ID's (THIS ASSUMES
% HOMOGENEOUS DISTRACTORS
IDs = unique(Stimuli_);
for n = 1:length(IDs)
    Ns(n) = length(find(Stimuli_ == IDs(n)));
end

%The target item will be the one with the fewest total observations
[~,remove] = min(Ns);
IDs(remove) = [];

ACCs(1:4) = 0; %set accuracy rates all to 0 for 4 potential distractors so bar chart will always show 4
nIDs_all(1:4) = 0;
nIDs_correct(1:4) = 0;
for n = 1:length(IDs)
    %find trials that were not catch trials but had current distractor ID
    %(again, this works only for homogeneous distractor conditions!)
    cur = sum(Stimuli_ == IDs(n),2);
    
    %relevant trials will have *7* instances; 8 if catch trial
    cur_trls = find(cur == 7);
    nIDs_all(n) = length(cur_trls);
    nIDs_correct(n) = length(find(Correct_(cur_trls,2) == 1));
    ACCs(n) = nanmean(Correct_(cur_trls,2));
end

%Set up IDs for x-tick label. Loop b/c we don't know how many
Xlabel_IDs = [0 0 0 0];
for n = 1:length(IDs)
    Xlabel_IDs(n) = IDs(n);
end

subplot(224)
bar(1:length(ACCs),ACCs,'facecolor','k')
box off
ylim([0 1])
set(gca,'xticklabel',Xlabel_IDs)
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
xlabel('Distractor ID (if homogeneous)','fontsize',18,'fontweight','bold')
text(1,.1,['N Correct =' mat2str(nIDs_correct(1)) ' N = ' mat2str(nIDs_all(1))],'color','white','rotation',90,'fontsize',14)
text(2,.1,['N Correct =' mat2str(nIDs_correct(2)) ' N = ' mat2str(nIDs_all(2))],'color','white','rotation',90,'fontsize',14)
text(3,.1,['N Correct =' mat2str(nIDs_correct(3)) ' N = ' mat2str(nIDs_all(3))],'color','white','rotation',90,'fontsize',14)
text(4,.1,['N Correct =' mat2str(nIDs_correct(4)) ' N = ' mat2str(nIDs_all(4))],'color','white','rotation',90,'fontsize',14)
set(gca,'color',[.6 .6 .6])



disp(['Accuracy Rate bias = ' mat2str(round(bias_ACC*100)/100)])
disp(['RT bias = ' mat2str(round(bias_RT*100)/100)])
disp(['Overall Accuracy = ' mat2str(round(nanmean(Correct_(:,2))*100)/100)])
[ax h] = suplabel(['ACC bias = ' mat2str(round(bias_ACC*100)/100)  '     RT Bias = ' mat2str(round(bias_RT*100)/100)],'t');
set(h,'fontsize',16,'fontweight','bold')
[ax h] = suplabel(newfile);
set(h,'fontsize',16,'fontweight','bold','interpreter','none'); %interpreter switch removes influence of '_'


if printFlag
    orient landscape
    eval(['print -dpdf ' pwd '/Plots/' newfile '_beh.pdf'])
end

%return SRT to original variable if MG task
if Target_(1,10) > 0
    SRT = SRT_backup;
    clear SRT_backup
end

%call Figure 1 forward 
if plot_pos_move_avg; figure(ff); end

clear ax h Xlabel_IDs n IDs nIDs* y xl f