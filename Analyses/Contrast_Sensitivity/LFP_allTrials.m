function [] = LFP_allTrials(LFPchan,RFs,filename,CellID,CellName,Target_,Correct_,Errors_,ValidTrials,TrialStart_)

%AllTrials version will run Contrast Sensitivity analysis on all trials,
%regardless of correct/incorrect. However, accuracy rates and CDFs will be
%caluclated only from correct trials.  Idea is that neural visual responses
%will be indifferent with regards to correct/incorrect

%Called by 'Contrast_sensitivity_batch_allTrials'

%10/29/07 Richard P. Heitz



%FLAGS
printflag = 0;
saveflag = 0;
editRFflag = 0;

LFP_Plot_Time = (1:size(LFPchan,2))*4-3;
LFP_Plot_Time = LFP_Plot_Time - 500;

%if no RF's, return
if isempty(RFs)
    return
end

lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);

%MANUALLY CHANGED 12/1/2007
%also needs to be set in Contrast_sensitivity_new_allTrials
% cut1 = .32;
% cut2 = 1.7;
% cut1 = .32;
% cut2 = 1.4;
% cut1 = 2;
% cut2 = 6;
% cut1 = min(Target_(find(Target_(:,3) > 1),3)) + lum_spacing;
% cut2 = max(Target_(find(Target_(:,3) > 1),3)) - lum_spacing;
cut1 = 1.5;
cut2 = 2.5;

lum(1) = min(Target_(find(Target_(:,3) > 1),3));
lum(2) = max(Target_(find(Target_(:,3) > 1),3));


%%%%%%%%% DON'T USE RFs FOR LFPs!!!!!!!!!!!!!!!!!!!!!!!!









%EDITED 10/29/2007 to include ALL trials, not just correct
Lows = find(ismember(Target_(:,2),RFs) & Target_(:,13) < cut1 & Target_(:,3) > 1);
Mids = find(ismember(Target_(:,2),RFs) & Target_(:,13) >= cut1 & Target_(:,13) < cut2 & Target_(:,3) > 1);
Highs = find(ismember(Target_(:,2),RFs) & Target_(:,13) >= cut2 & Target_(:,3) > 1);
%create a list of all variables in workspace


%Set SDF parameters
Align_Time_=Target_(:,1);
%Align_Time_ = SaccBegin(:,1) + 500
Plot_Time=[-200 1000];



%Draw SDFs 3 times (one for each contrast level)
figure
orient landscape
set(gcf,'Color','white')
hold on

[SDF_Low] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Lows, TrialStart_);
[SDF_Mid] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Mids, TrialStart_);
[SDF_High] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Highs, TrialStart_);

[LFP_Low] = nanmean(LFPchan(Lows,:));
[LFP_Mid] = nanmean(LFPchan(Mids,:));
[LFP_High] = nanmean(LFPchan(Highs,:));


%Find max firing rate so we can structure figures appropriately
max1 = max(max(SDF_Low,SDF_Mid));
max2 = max(SDF_High);
maxFire = max(max1,max2);

max1_LFP = max(max(abs(LFP_Low),abs(LFP_Mid)));
max2_LFP = max(abs(LFP_High));
maxLFP = max(max1_LFP,max2_LFP);




%SDF Low Contrast
subplot(4,3,1)
plot(Plot_Time(1):Plot_Time(2),SDF_Low,'r')
xlim(Plot_Time)
if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end
title('Low Contrast SDF','FontWeight','bold')

%LFP Low Contrast
subplot(4,3,4)
plot(LFP_Plot_Time,LFP_Low,'r')
xlim([-200 1000])
if maxLFP > 0
    ylim([-maxLFP maxLFP])
else
    ylim([0 1])
end
title('Low Contrast LFP','FontWeight','bold')

%SDF Med Contrast
subplot(4,3,2)
plot(Plot_Time(1):Plot_Time(2),SDF_Mid,'b')
xlim(Plot_Time)
if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end
title('Medium Contrast SDF','FontWeight','bold')

%LFP Med Contrast
subplot(4,3,5)
plot(LFP_Plot_Time,LFP_Mid,'b')
xlim([-200 1000])
if maxLFP > 0
    ylim([-maxLFP maxLFP])
else
    ylim([0 1])
end
title('Medium Contrast LFP','FontWeight','bold')

%SDF High Contrast
subplot(4,3,3)
plot(Plot_Time(1):Plot_Time(2),SDF_High,'k')
xlim(Plot_Time)
if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end
title('High Contrast SDF','FontWeight','bold')

%LFP Med Contrast
subplot(4,3,6)
plot(LFP_Plot_Time,LFP_High,'k')
xlim([-200 1000])
if maxLFP > 0
    ylim([-maxLFP maxLFP])
else
    ylim([0 1])
end
title('High Contrast LFP','FontWeight','bold')


%Superimpose LFP for Low, Med, High Contrast
subplot(4,3,[7:8 10:11])
hold on
plot(LFP_Plot_Time,LFP_Low,'r',LFP_Plot_Time,LFP_Mid,'b',LFP_Plot_Time,LFP_High,'k')
xlim([-200 1000])
if maxLFP > 0
    ylim([-maxLFP maxLFP])
else
    ylim([0 1])
end
title(['Eccentricity = ' mat2str(Target_(1,12)) ' degrees'])


%Get Acc Rates
for j = 1:3
    if j == 1
        AccRate(j) = mean(Correct_(find(Target_(:,13) < cut1 & Target_(:,3) > 1),2));
    elseif j == 2
        AccRate(j) = mean(Correct_(find(Target_(:,13) >= cut1 & Target_(:,13) < cut2 & Target_(:,3) > 1),2));
    elseif j == 3
        AccRate(j) = mean(Correct_(find(Target_(:,13) >= cut2 & Target_(:,3) > 1),2));
    end
end

% %Plot Acc Rates & Contrast Range
subplot(4,3,[9 12])
bar(AccRate,.5)
ylim([0 1])
ylabel('Proportion Correct','FontWeight','bold');
set(gca,'XTickLabel',{'Low';'Medium';'High'},'FontWeight','bold')
set(gcf,'Color','white')
%Plot contrast range on secondary axis
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
hold on
ylim([0 1])
xlim([90 250])
xlabel('CLUT index [higher = brighter]','FontWeight','bold')
set(gca,'ytick',[])

line([lum(1) lum(2)],[1 1],'marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',3,'Color','r')  



[ax,h1] = suplabel('Time from target');
set(h1,'FontSize',15)
[ax,h2] = suplabel('spikes/sec / LFP amplitude (\muV)', 'y');
set(h2,'FontSize',15)
[ax,h3] = suplabel(strcat('RFs used: ',mat2str(RFs),'   Filename: ',filename,'   CellID:',mat2str(cell2mat(CellID)),'   Generated: ',date),'t');
set(h3,'FontSize',8)

%SAVING AND PRINTING
if saveflag == 1
    eval(['print -dpdf ',filename,'_',cell2mat(CellID),'_3.pdf']);
end

if printflag == 1
    gcf;
    print;
end