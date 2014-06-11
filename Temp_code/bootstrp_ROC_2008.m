function [TDT,ROCarea,SDF_in,SDF_out] = bootstrp_ROC(Spike,Plot_Time,Align_Time,inTrials,outTrials,n,t)

%COMPUTES ROC CURVE USING CORRECT TRIALS ONLY!!

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate


plotFlag = 0;

%for SDFs that are target aligned, try to use small window; will
%drastically cut down on processing time
% Plot_Time = [0 400];
% Plot_Time_all = [-200 800];
%
%



%initiate SDF_all
SDF_all(1:size(Spike,1),1:(abs(Plot_Time(1)) + abs(Plot_Time(2)))) = 0;
%calculate SDF matrix, trial-by-trial

disp('Creating trial-by-trial SDFs...')
for trl = 1:size(Spike,1)
    curr_SDF = spikeDensityfunction_singletrial(Spike(trl,:),Align_Time(trl,1),Plot_Time);
    SDF_all(trl,1:length(curr_SDF)) = curr_SDF;
end

clear curr_SDF trl


%bootstrap SDFs
%n = number of draws/'trial'
%t = number of 'trials'
%number of samples/trial = min of actual trial numbers.
% n = min(length(inTrials),length(outTrials))
% t = 1000;

boot_SDF_in = bootSDF(SDF_all(inTrials,:),n,t);
SDF_in = nanmean(boot_SDF_in);
boot_SDF_out = bootSDF(SDF_all(outTrials,:),n,t);
SDF_out = nanmean(boot_SDF_out);

%Vector of Target_in and Distractor_in trials
%NOTE: currently, using ALL distractor locations.  Should limit later.

%max criterion is maximum firing rate obtained on a single trial (Thompson
%et al., 1996, p. 4043.

% inTrials = find(ismember(Target_(:,2),RF) == 1 & Correct_(:,2) == 1);
maxFire_in = max(max(boot_SDF_in));

% outTrials = find(ismember(Target_(:,2),anti_RF) == 1 & Correct_(:,2) == 1);
maxFire_out = max(max(boot_SDF_out));

%find max firing rate for all relevant (T_in or D_in) trials
maxFire = max(maxFire_in,maxFire_out);
clear maxFire_in maxFire_out

%calculate SDFs with larger time window for plotting purposes
% SDF_all_in = spikedensityfunct(Spike,Align_Time,Plot_Time_all,inTrials,TrialStart_);
% SDF_all_out = spikedensityfunct(Spike,Align_Time,Plot_Time_all,outTrials,TrialStart_);




disp('Calculating ROC area...')

if ~isempty(inTrials) & ~isempty(outTrials)
    for ms = 1:size(SDF_all,2)
        for criterion = 0:maxFire
            % [ms criterion]
            num_Tin_greater(criterion + 1,ms) = length(find(boot_SDF_in(:,ms) >= criterion)) / size(boot_SDF_in,1);
            %num_Din_greater(criterion + 1,ms) = length(find(SDF_all(outTrials_2,ms) >= criterion)) / length(outTrials_2);
            num_Din_greater(criterion + 1,ms) = length(find(boot_SDF_out(:,ms) >= criterion)) / size(boot_SDF_out,1);
        end
        ROCarea(ms) = polyarea([1 num_Din_greater(:,ms)'],[0 num_Tin_greater(:,ms)']);
    end
else
    disp('No Trials!')
    TDT = 0;
    ROCarea = 0;
    return
end

clear num_Tin_greater num_Din_greater ms criterion

%TDT will be time of half-width between max ROC area value, and the min
%falling prior to the max value
[maxArea, maxIndex] = max(ROCarea);

%search for minimum value falling before maxIndex
minArea = min(ROCarea(1:maxIndex));

ROC_criterion = .5*(maxArea - minArea) + minArea;

%find where half width occurs,
% if ~isempty(find(ROCarea >= ROC_criterion,1));
if ~isempty(find(ROCarea(100:end) >= .6 | ROCarea(100:end) <= -.6,1));
    %TDT = (find(ROCarea >= ROC_criterion,1))
    TDT = (find(ROCarea(100:end) >= .6 | ROCarea(100:end) <= -.6,1)) + 100 - abs(Plot_Time(1))
else
    TDT = 0
end


if plotFlag == 1
    figure
    orient landscape
    set(gcf,'Color','white')


    subplot(2,2,1)
    %    plot(Plot_Time_all(1):Plot_Time_all(2),SDF_all_in,Plot_Time_all(1):Plot_Time_all(2),SDF_all_out,'r','LineWidth',3)
    plot(Plot_Time(1):Plot_Time(2),SDF_all_in,Plot_Time(1):Plot_Time(2),SDF_all_out,'r','LineWidth',3)
    legend('Target in','Distractor in')
    line([TDT TDT],[0 SDF_all_in(TDT + abs(Plot_Time_all(1)))])
    xlim(Plot_Time_all)

    subplot(2,2,2)
    %    plot(Plot_Time(1):Plot_Time(2),nanmean(SDF_all(inTrials,:)),Plot_Time(1):Plot_Time(2),nanmean(SDF_all(outTrials,:)),'r','LineWidth',3)
    plot(Plot_Time(1):Plot_Time(2),nanmean(SDF_all(inTrials,:)),Plot_Time(1):Plot_Time(2),nanmean(SDF_all(outTrials,:)),'r','LineWidth',3)
    line([TDT TDT],[0 nanmean(SDF_all(inTrials,TDT))],'LineWidth',2)
    legend('Target in','Distractor in')

    subplot(2,2,3)
    plot(ROCarea,'LineWidth',3)
    xlim(Plot_Time)
    line([TDT TDT],[0 ROC_criterion],'LineWidth',2)

    maximize
end