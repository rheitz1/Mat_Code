function [RFs] = Contrast_sensitivity(filename,CellID,CellName,Target_,Errors_,Correct_,TrialStart_)

%This will run along with SDF_screenloc_raster.
%User will be shown a display and will enter the RF locations
%Program will then calculate SDFs for low, med, and high contrast
%based off the range of contrasts used that day

%6/27/07 Richard P. Heitz

%FLAGS
printflag = 0;
saveflag = 1;

if exist('RFs') == 0
    disp('No RFs found')
    pause
    return
end



% if saveflag == 1
% save(filename,'RFs','-append');
% disp('RFs saved');
% end

%Save chosen RFs to file
% yn = input('Would you like to save these RF locations to file? [y/n]  ')
%
% if yn = 'y'
% eval(['save (',q,[file_path, outfile],qcq, RFs,qcq,'-append',q,')'])
% end

%if no RF's, return
if isempty(RFs)
    return
end


%Find range of luminances used (higher numbers = LESS bright) and divide by
%3 to create a low, med, and high group
%this is calculated disregarding the actual distribution of luminances
%presented (so there will be different numbers of observations in each, as
%opposed to

lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);
cut1 = min(Target_(find(Target_(:,3) > 1),3)) + lum_spacing;
cut2 = max(Target_(find(Target_(:,3) > 1),3)) - lum_spacing;

%Plot range of luminances
lum(1) = min(Target_(find(Target_(:,3) > 1),3));
lum(2) = max(Target_(find(Target_(:,3) > 1),3));

%Keep a running count so that when we plot ranges, they do not overwrite
%each other
persistent linecall;
persistent h
if isempty(linecall);
    linecall = 1;
    %if figure doesn't exist yet, keep a record of what the figure handle
    %is so we can keep re-calling it.
    h = figure;
end
figure(h)
orient landscape
hold on
xlim([0 255]);
ylim([0 100]);
line([lum(1) lum(2)],[linecall linecall],'marker','o');
linecall = linecall + 1;
set(gcf,'Color','white')

Lows = find(ismember(Target_(:,2),RFs) & Target_(:,3) < cut1 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Target_(:,3) > 1);
Mids = find(ismember(Target_(:,2),RFs) & Target_(:,3) >= cut1 & Target_(:,3) < cut2 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Target_(:,3) > 1);
Highs = find(ismember(Target_(:,2),RFs) & Target_(:,3) >= cut2 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Target_(:,3) > 1);
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
ylim([0 100]);
xlim(Plot_Time);

[SDF_Low] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Lows, TrialStart_);
[SDF_Mid] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Mids, TrialStart_);
[SDF_High] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, Highs, TrialStart_);

%Find max firing rate so we can structure figures appropriately
max1 = max(max(SDF_Low,SDF_Mid));
max2 = max(SDF_High);
maxFire = max(max1,max2);

subplot(2,3,1)
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_Low,'r')
title(strcat('Low Contrast       N = ',mat2str(length(Lows))),'FontWeight','bold')
trl = (maxFire/size(SDF_Low,1))/3;
stepsz = (maxFire/size(SDF_Low,1))/3;
for t = 1:length(Lows)
    if ~isempty(nonzeros(CellName(Lows(t),find(CellName(Lows(t),:)-500 <= Plot_Time(2) & CellName(Lows(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Lows(t),find(CellName(Lows(t),:)-500 <= Plot_Time(2) & CellName(Lows(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim([-200 1000])
ylim([0 maxFire])

subplot(2,3,2)
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_Mid,'b')
title(strcat('Medium Contrast       N = ',mat2str(length(Mids))),'FontWeight','bold')
trl = (maxFire/size(SDF_Mid,1))/4;
stepsz = (maxFire/size(SDF_Mid,1))/4;
for t = 1:length(Mids)
    if ~isempty(nonzeros(CellName(Mids(t),find(CellName(Mids(t),:)-500 <= Plot_Time(2) & CellName(Mids(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Mids(t),find(CellName(Mids(t),:)-500 <= Plot_Time(2) & CellName(Mids(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim([-200 1000])
ylim([0 maxFire])

subplot(2,3,3)
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_High,'k')
title(strcat('High Contrast       N = ',mat2str(length(Highs))),'FontWeight','bold')
trl = (maxFire/size(SDF_High,1))/4;
stepsz = (maxFire/size(SDF_High,1))/4;
for t = 1:length(Highs)
    if ~isempty(nonzeros(CellName(Highs(t),find(CellName(Highs(t),:)-500 <= Plot_Time(2) & CellName(Highs(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Highs(t),find(CellName(Highs(t),:)-500 <= Plot_Time(2) & CellName(Highs(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim([-200 1000])
ylim([0 maxFire])

subplot(2,3,[4:5])
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_Low,'r',Plot_Time(1):Plot_Time(2),SDF_Mid,'b',Plot_Time(1):Plot_Time(2),SDF_High,'k')
xlim([-200 1000])
ylim([0 maxFire])

%Get Acc Rates
for j = 1:3
    if j == 1
        AccRate(j) = mean(Correct_(find(Target_(:,3) < cut1 & Target_(:,3) > 1),2));
    elseif j == 2
        AccRate(j) = mean(Correct_(find(Target_(:,3) >= cut1 & Target_(:,3) < cut2 & Target_(:,3) > 1),2));
    elseif j == 3
        AccRate(j) = mean(Correct_(find(Target_(:,3) >= cut2 & Target_(:,3) > 1),2));
    end
end

% %Plot Acc Rates
subplot(2,3,6)
bar(AccRate,.5)
ylim([0 1])
ylabel('Proportion Correct','FontWeight','bold');
title('Accuracy Rates','FontWeight','bold')
set(gca,'XTickLabel',{'Low';'Medium';'High'},'FontWeight','bold')
set(gcf,'Color','white')

[ax,h1] = suplabel('Time from target');
set(h1,'FontSize',15)
[ax,h2] = suplabel('spikes/sec', 'y');
set(h2,'FontSize',15)
[ax,h3] = suplabel(strcat('RFs used: ',mat2str(RFs),'   Filename: ',filename,'   CellID:',mat2str(cell2mat(CellID)),'  Generated: ',date),'t');
set(h3,'FontSize',8)

%SAVING AND PRINTING
if saveflag == 1
    eval(['print -dpdf ',filename,'_',cell2mat(CellID),'_2.pdf']);
end

if printflag == 1
    gcf;
    print;
end