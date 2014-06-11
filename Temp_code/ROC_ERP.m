function [ROCarea, TDT] = ROC(ERP,RF,Target_,Correct_,TrialStart_)

%COMPUTES ROC CURVE USING CORRECT TRIALS ONLY!!

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate


plotFlag = 1;

Align_Time = Target_(:,1);

%for SDFs that are target aligned, try to use small window; will
%drastically cut down on processing time
Plot_Time = [0 400];
Plot_Time_all = [-500 2500];


%get anti-RFs
anti_RF = getAntiRF(RF);




%find T_in and T_out trials for each set size

inTrials = find(ismember(Target_(:,2),RF) == 1 & Correct_(:,2) == 1);

outTrials = find(ismember(Target_(:,2),anti_RF) == 1 & Correct_(:,2) == 1);

%find max firing rate for all relevant (T_in or D_in) trials
%for ERPs, cannot simply take maximum values because of saturation.  Will
%use max values of average waveforms instead

ERP_in = nanmean(ERP(inTrials,:));
max_in = max(ERP_in);
ERP_out = nanmean(ERP(outTrials,:));
max_out = max(ERP_out);
maxFire = max(max_in,max_out);
clear max_in max_out

disp('Calculating ROC area...')
crit = linspace(0,maxFire);

for ms = 500:900%1:size(ERP,2) %300 ms search window, beginning at 0 (500 ms shift)
    index = 1;
    for criterion = 1:length(crit);%0:var(ERP(:,ms)):maxFire
         num_Tin_greater(index,ms-499) = length(find(abs(ERP(inTrials,ms)) >= crit(criterion))) / length(inTrials);
        num_Din_greater(index,ms-499) = length(find(abs(ERP(outTrials,ms)) >= crit(criterion))) / length(outTrials);
        index = index + 1;
    end
    ROCarea(ms-499) = polyarea([1 num_Din_greater(:,ms-499)'],[0 num_Tin_greater(:,ms-499)']);
end

clear num_Tin_greater num_Din_greater ms criterion

%TDT will be time of half-width between max ROC area value, and the min
%falling prior to the max value
[maxArea, maxIndex] = max(ROCarea); %400 ms search window

%search for minimum value falling before maxIndex
minArea = min(ROCarea(1:maxIndex));

ROC_criterion = .5*(maxArea - minArea) + minArea;

%find where half width occurs, 
if ~isempty(find(ROCarea >= ROC_criterion,1));
    TDT = (find(ROCarea >= ROC_criterion,1)) + 500
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
   
   subplot(2,2,3:4)
   plot(ROCarea,'LineWidth',3)
   xlim(Plot_Time)
   line([TDT TDT],[0 ROC_criterion],'LineWidth',2)

      
end