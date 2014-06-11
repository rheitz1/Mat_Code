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


figure

errorbar(0:7,[rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7],[sd0 sd1 sd2 sd3 sd4 sd5 sd6 sd7],'k','linestyle','none','linewidth',2)
hold on

bar(0:7,[rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7],'facecolor','k')

box off
xlim([-.7 7.5])
xlabel('Screen Location','fontsize',18,'fontweight','bold')
ylabel('RT (ms)','fontsize',18,'fontweight','bold')

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

if ~isempty(strfind(newfile,'SEARCH'))
    ylim([0 1000])
elseif ~isempty(strfind(newfile,'MG'))
    ylim([0 1500])
else
    error('Filename not found')
end

clear pos* rt* sd* y

disp(['RT bias = ' mat2str(round(bias_RT*100)/100)])

%return SRT to original variable if MG task
if Target_(1,10) > 0
    SRT = SRT_backup;
    clear SRT_backup
end

% if printFlag
%     orient landscape
%     eval(['print -dpdf ' newfile '_RT.pdf'])
% end