%cd '~/Data/D_Training/'
cd /volumes/Dump/D_Training/

batch_list = dir('*SEARCH.mat');

for file = 1:length(batch_list)
    batch_list(file).name
    load(batch_list(file).name,'SRT','Correct_','Target_')
    
    
    MG_ACC(file,1) = nanmean(Correct_(:,2));
    
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
    
    all_ACC = [acc0 acc1 acc2 acc3 acc4 acc5 acc6 acc7];
    
    bias_ACC(file,1) = max(all_ACC) - min(all_ACC);
    
    
    
    
    
    
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
    
    mean_RTs(file,1) = nanmean(SRT(find(Correct_(:,2) == 1),1));
    
    all_RT = [rt0 rt1 rt2 rt3 rt4 rt5 rt6 rt7];
    bias_RT(file,1) = max(all_RT) - min(all_RT);
    
    
    keep batch_list file MG_ACC bias* mean_RTs
end

figure
scatter(1:length(MG_ACC),MG_ACC,'filled')
h = lsline;
set(h,'color','k','linewidth',2)
hold on
plot(MG_ACC,'linewidth',2)
box off
ylim([0 1])
xlabel('Session #','fontsize',18,'fontweight','bold')
ylabel('p(Correct)','fontsize',18,'fontweight','bold')
title('ACC Rate Over Sessions','fontsize',18,'fontweight','bold')
h = hline(nanmean(MG_ACC),'--r');
set(h,'linewidth',2)


%Do linear regression
[m,b] = linreg(MG_ACC,(1:length(MG_ACC))');
text(1,.95,['Y = ' mat2str(round(m*10000)/10000) 'x + ' mat2str(round(b*100)/100)],'fontsize',18,'fontweight','bold')
clear h

