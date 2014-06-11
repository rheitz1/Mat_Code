function [TDT,ROCarea] = ROC(Spike,triallist,TrialStart_)

%COMPUTES ROC CURVE USING CORRECT TRIALS ONLY!!

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate


plotFlag = 1;

Align_Time = Target_(:,1);

%for SDFs that are target aligned, try to use small window; will
%drastically cut down on processing time
Plot_Time = [0 400];
Plot_Time_all = [-200 800];


%get anti-RFs
anti_RF = getAntiRF(RF);


%initiate SDF_all
SDF_all(1:size(Spike,1),1:(abs(Plot_Time(1)) + abs(Plot_Time(2)))) = 0;
%calculate SDF matrix, trial-by-trial

disp('Creating trial-by-trial SDFs...')
for n = 1:size(Spike,1)
    curr_SDF = spikeDensityfunction_singletrial(Spike(n,:),Align_Time(n,1),Plot_Time);
    SDF_all(n,1:length(curr_SDF)) = curr_SDF;
end

clear curr_SDF n

%Vector of Target_in and Distractor_in trials
%NOTE: currently, using ALL distractor locations.  Should limit later.

%max criterion is maximum firing rate obtained on a single trial (Thompson
%et al., 1996, p. 4043.

inTrials = find(ismember(Target_(:,2),RF) == 1 & Correct_(:,2) == 1);
maxFire_in = max(max(SDF_all(inTrials,:)));

outTrials = find(ismember(Target_(:,2),anti_RF) == 1 & Correct_(:,2) == 1);
maxFire_out = max(max(SDF_all(outTrials,:)));

%find max firing rate for all relevant (T_in or D_in) trials
maxFire = max(maxFire_in,maxFire_out);
clear maxFire_in maxFire_out

%calculate SDFs with larger time window for plotting purposes
SDF_all_in = spikedensityfunct(Spike,Align_Time,Plot_Time_all,inTrials,TrialStart_);
SDF_all_out = spikedensityfunct(Spike,Align_Time,Plot_Time_all,outTrials,TrialStart_);


disp('Calculating ROC area...')
for ms = 1:size(SDF_all,2)
    for criterion = 0:maxFire
        % [ms criterion]
        num_Tin_greater(criterion + 1,ms) = length(find(SDF_all(inTrials,ms) >= criterion)) / length(inTrials);
        %num_Din_greater(criterion + 1,ms) = length(find(SDF_all(outTrials_2,ms) >= criterion)) / length(outTrials_2);
        num_Din_greater(criterion + 1,ms) = length(find(SDF_all(outTrials,ms) >= criterion)) / length(outTrials);
    end
    ROCarea(ms) = polyarea([1 num_Din_greater(:,ms)'],[0 num_Tin_greater(:,ms)']);
end

clear num_Tin_greater num_Din_greater ms criterion

%TDT will be time of half-width between max ROC area value, and the min
%falling prior to the max value
[maxArea, maxIndex] = max(ROCarea);

%search for minimum value falling before maxIndex
minArea = min(ROCarea(1:maxIndex));

ROC_criterion = .5*(maxArea - minArea) + minArea;

%find where half width occurs, 
if ~isempty(find(ROCarea >= ROC_criterion,1));
    TDT = (find(ROCarea >= ROC_criterion,1))
else
    TDT = 0
end



if plotFlag == 1
    figure
    orient landscape
    set(gcf,'Color','white')
  
       
   subplot(2,2,1)
   plot(Plot_Time_all(1):Plot_Time_all(2),SDF_all_in,Plot_Time_all(1):Plot_Time_all(2),SDF_all_out,'r','LineWidth',3)
   legend('Target in','Distractor in')
   line([TDT TDT],[0 SDF_all_in(TDT + abs(Plot_Time_all(1)))])
   xlim(Plot_Time_all)
   
    subplot(2,2,2)
   plot(Plot_Time(1):Plot_Time(2),nanmean(SDF_all(inTrials,:)),Plot_Time(1):Plot_Time(2),nanmean(SDF_all(outTrials,:)),'r','LineWidth',3)
   line([TDT TDT],[0 nanmean(SDF_all(inTrials,TDT))],'LineWidth',2)
   legend('Target in','Distractor in')
   
   subplot(2,2,3)
   plot(ROCarea,'LineWidth',3)
   xlim(Plot_Time)
   line([TDT TDT],[0 ROC_criterion],'LineWidth',2)
end
maximize