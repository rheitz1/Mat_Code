function [RFs] = Contrast_sensitivity(RFs,filename,CellID,CellName,Target_,Correct_,Errors_,ValidTrials,TrialStart_,BurstStartTimes)

%AllTrials version will run Contrast Sensitivity analysis on all trials,
%regardless of correct/incorrect. However, accuracy rates and CDFs will be
%caluclated only from correct trials.  Idea is that neural visual responses
%will be indifferent with regards to correct/incorrect

%10/29/07 Richard P. Heitz

%FLAGS
printflag = 0;
saveflag = 0;
editRFflag = 0;

%Get Receptive Fields from user


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


%Find range of luminances used (lower numbers = LESS bright [double checked 10/29/07: CLUT value of 101 was barely visible]) and divide by
%3 to create a low, med, and high group
%this is calculated disregarding the actual distribution of luminances
%presented (so there will be different numbers of observations in each, as
%opposed to

lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);

%12/1/07 RPH
%cut points arbitrarily grouped to provide good dispersion throughout
%actual luminance values (cd/m^2).  See spreadsheet "CLUT to
%Luminance.xlsx".  Estimated from entire range of luminances that could
%actually be measured (some were clearly visible,but could not be measured
%due to sensitivity of the measuring equipment.  Breakdown:

% 0:.32 = low
% .33 -  1.5 = med
%1.7 - 8.1 = high

%THIS IS SKEWED - function is positively accelerated exponential.  
%TO DO: change to log scale and re-group

%also needs to be changed in 'LFP_allTrials' script
%based on linear equal grouping
% cut1 = .32;
% cut2 = 1.7;

%based on linear equal grouping, but changed one value so that we would
%have HIGH CONTRAST functions for low-range files.  Thus, MED CONTRAST has
% a few less trials than it originally did.
% cut1 = .32;
% cut2 = 1.4;


%Disregard actual gunned luminance values and include lowest CLUT values
%that *I* could personally see.
cut1 = 1.5;
cut2 = 2.5;

%based on luminance plot: function has noticible "bend".  Low luminance =
%all values prior to bend, then i divided the bend in half and called one
%medium and the other high. number of medium + high values = 5,
%unfortunately.  gave medium 3 and high 2, but could also do other way.
% cut1 = 2;
% cut2 = 6;

% cut1 = min(Target_(find(Target_(:,3) > 1),3)) + lum_spacing;
% cut2 = max(Target_(find(Target_(:,3) > 1),3)) - lum_spacing;

%Plot range of luminances
lum(1) = min(Target_(find(Target_(:,3) > 1),3));
lum(2) = max(Target_(find(Target_(:,3) > 1),3));


 Lows = find(ismember(Target_(:,2),RFs) & Target_(:,13) < cut1 & Target_(:,3) > 1);
 Mids = find(ismember(Target_(:,2),RFs) & Target_(:,13) >= cut1 & Target_(:,13) < cut2 & Target_(:,3) > 1);
 Highs = find(ismember(Target_(:,2),RFs) & Target_(:,13) >= cut2 & Target_(:,3) > 1);


%Set SDF parameters
Align_Time_=Target_(:,1);
%Align_Time_ = SaccBegin(:,1) + 500
Plot_Time=[-200 1000];


%=======function call REDUCE_BURSTS ===============================
%Reduce set of Burst Onsets and contrast values by taking medians
if ~(nargin < 10)
    [Burst_Contrast_all,Burst_Contrast_3grp] = reduceBursts(RFs,Target_,BurstStartTimes);
end
%==================================================================



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


%11/6/07 make sure we don't get a divide by zero if there so are few trials
%that Cellname(x) has no size
if size(CellName(Lows),1) == 0
    trl = 1;
else
    trl = (maxFire/size(CellName(Lows),1))/3;
    stepsz = (maxFire/size(CellName(Lows),1))/3;
end


for t = 1:length(Lows)
    if ~isempty(nonzeros(CellName(Lows(t),find(CellName(Lows(t),:)-500 <= Plot_Time(2) & CellName(Lows(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Lows(t),find(CellName(Lows(t),:)-500 <= Plot_Time(2) & CellName(Lows(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim(Plot_Time)

if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end

subplot(2,3,2)
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_Mid,'b')
title(strcat('Medium Contrast       N = ',mat2str(length(Mids))),'FontWeight','bold')

if size(CellName(Mids),1) == 0
    trl = 1;
else
    trl = (maxFire/size(CellName(Mids),1))/3;
    stepsz = (maxFire/size(CellName(Mids),1))/3;
end

for t = 1:length(Mids)
    if ~isempty(nonzeros(CellName(Mids(t),find(CellName(Mids(t),:)-500 <= Plot_Time(2) & CellName(Mids(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Mids(t),find(CellName(Mids(t),:)-500 <= Plot_Time(2) & CellName(Mids(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim(Plot_Time)

if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end

subplot(2,3,3)
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_High,'k')
title(strcat('High Contrast       N = ',mat2str(length(Highs))),'FontWeight','bold')

if size(CellName(Highs),1) == 0
    trl = 1;
else
    trl = (maxFire/size(CellName(Highs),1))/3;
    stepsz = (maxFire/size(CellName(Highs),1))/3;
end


for t = 1:length(Highs)
    if ~isempty(nonzeros(CellName(Highs(t),find(CellName(Highs(t),:)-500 <= Plot_Time(2) & CellName(Highs(t),:)-500 >= Plot_Time(1))))-500)
        plot(nonzeros(CellName(Highs(t),find(CellName(Highs(t),:)-500 <= Plot_Time(2) & CellName(Highs(t),:)-500 >= Plot_Time(1))))-500,trl,'k')
    end
    trl = trl + stepsz;
end
xlim([-200 1000])

if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end


%Superimpose SDFs for low, med, & high contrast
subplot(2,3,[4:5])
hold on
plot(Plot_Time(1):Plot_Time(2),SDF_Low,'r',Plot_Time(1):Plot_Time(2),SDF_Mid,'b',Plot_Time(1):Plot_Time(2),SDF_High,'k')
xlim(Plot_Time)
%xlim([0 300])
title(['Eccentricity = ' mat2str(Target_(1,12)) ' degrees'])

if maxFire > 0
    ylim([0 maxFire])
else
    ylim([0 1])
end

if nargin == 10
    %Indicate median visual response onset latency with a line
    line([Burst_Contrast_3grp(1) Burst_Contrast_3grp(1)],[0 maxFire],'Color','r')
    line([Burst_Contrast_3grp(2) Burst_Contrast_3grp(2)],[0 maxFire],'Color','b')
    line([Burst_Contrast_3grp(3) Burst_Contrast_3grp(3)],[0 maxFire],'Color','k')

    %Set any NaN's in parametric burst-contrast to 0.  NaN's result when there
    %are too few observations
    Burst_Contrast_all(find(isnan(Burst_Contrast_all(:,2))),2) = 0;
    %Plot Relationship between Burst time and Contrast level
    subplot(2,3,6)
    Burst_Contrast_all = Burst_Contrast_all';
    plot(Burst_Contrast_all(1,:),Burst_Contrast_all(2,:),'-ro','MarkerFaceColor','r')
    ylim([0 max(abs(Burst_Contrast_all(2,:))) + 5])
    xlim([lum(1)-5 lum(2) + 5])
    xlabel('Contrast','FontWeight','bold')
    ylabel('Burst Onset Time (ms)','FontWeight','bold')
end

[ax,h1] = suplabel('Time from target');
set(h1,'FontSize',15)
[ax,h2] = suplabel('spikes/sec', 'y');
set(h2,'FontSize',15)
[ax,h3] = suplabel(strcat('RFs used: ',mat2str(RFs),'   Filename: ',filename,'   CellID:',mat2str(cell2mat(CellID)),'   Generated: ',date),'t');
set(h3,'FontSize',8)

%SAVING AND PRINTING
if saveflag == 1
    eval(['print -dpdf ',filename,'_',cell2mat(CellID),'_2zoom.pdf']);
end

if printflag == 1
    gcf;
    print;
end