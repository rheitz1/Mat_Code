%function to generate Conditional Accuracy Functions (CAFs) based on some
%criteria determined prior to function call (relevant_trials should hold
%this information).  For neurons (use 'CAF' for behavior)

%Richard P. Heitz
%Vanderbilt
%4/18/08


function [accs,RTs] = nCAF(relevant_trials,SRT,TrialStart_,Target_,Correct_,Spike,RF)

plotFlag = 1;

Align_Time(1:length(SRT),1) = 500;
Plot_Time = [-200 800];

anti_RF = getAntiRF(RF);

relevant_trials = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100));
relevant_trials_in = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF)))';
relevant_trials_out = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF)))';


relevant_trials_in_correct = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF) & Correct_(relevant_trials,2) == 1))';
relevant_trials_out_correct = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF) & Correct_(relevant_trials,2) == 1))';
relevant_trials_in_incorrect = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF) & Correct_(relevant_trials,2) == 0))';
relevant_trials_out_incorrect = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF) & Correct_(relevant_trials,2) == 0))';

%although SDFs will be based only on trials with Target in or Distractor
%in, distribution will be split by entire set of relevant trials
RTs = SRT(relevant_trials,1);
[RTs,index] = sort(RTs);

%compute intervals
%NOTE: this is a dirty way of accomplishing binning, and the last bin will
%not have the same number of observations as all the preceding bins!!!!

j = 1;
for i = 10:10:100
    percentile_array(j) = prctile(RTs,i);
    j = j + 1;
end



%initialize SDF array
SDF_array_in(1:length(Plot_Time(1):Plot_Time(2)),1:10) = NaN;
SDF_array_out(1:length(Plot_Time(1):Plot_Time(2)),1:10) = NaN;

SDF_array_in(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) <= percentile_array(1)), TrialStart_);
SDF_array_in(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(1) & SRT(relevant_trials_in,1) <= percentile_array(2)), TrialStart_);
SDF_array_in(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(2) & SRT(relevant_trials_in,1) <= percentile_array(3)), TrialStart_);
SDF_array_in(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(3) & SRT(relevant_trials_in,1) <= percentile_array(4)), TrialStart_);
SDF_array_in(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(4) & SRT(relevant_trials_in,1) <= percentile_array(5)), TrialStart_);
SDF_array_in(:,6) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(5) & SRT(relevant_trials_in,1) <= percentile_array(6)), TrialStart_);
SDF_array_in(:,7) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(6) & SRT(relevant_trials_in,1) <= percentile_array(7)), TrialStart_);
SDF_array_in(:,8) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(7) & SRT(relevant_trials_in,1) <= percentile_array(8)), TrialStart_);
SDF_array_in(:,9) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(8) & SRT(relevant_trials_in,1) <= percentile_array(9)), TrialStart_);
SDF_array_in(:,10) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_in,1) > percentile_array(9)), TrialStart_);

SDF_array_out(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) <= percentile_array(1)), TrialStart_);
SDF_array_out(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(1) & SRT(relevant_trials_out,1) <= percentile_array(2)), TrialStart_);
SDF_array_out(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(2) & SRT(relevant_trials_out,1) <= percentile_array(3)), TrialStart_);
SDF_array_out(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(3) & SRT(relevant_trials_out,1) <= percentile_array(4)), TrialStart_);
SDF_array_out(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(4) & SRT(relevant_trials_out,1) <= percentile_array(5)), TrialStart_);
SDF_array_out(:,6) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(5) & SRT(relevant_trials_out,1) <= percentile_array(6)), TrialStart_);
SDF_array_out(:,7) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(6) & SRT(relevant_trials_out,1) <= percentile_array(7)), TrialStart_);
SDF_array_out(:,8) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(7) & SRT(relevant_trials_out,1) <= percentile_array(8)), TrialStart_);
SDF_array_out(:,9) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(8) & SRT(relevant_trials_out,1) <= percentile_array(9)), TrialStart_);
SDF_array_out(:,10) = spikedensityfunct(Spike, Align_Time, Plot_Time, find(SRT(relevant_trials_out,1) > percentile_array(9)), TrialStart_);


if plotFlag == 1
    figure
    set(gcf,'Color','white')
    for j = 1:10
        subplot(3,4,j)
        plot(Plot_Time(1):Plot_Time(2),SDF_array_in(:,j),'b',Plot_Time(1):Plot_Time(2),SDF_array_out(:,j),'r')
        xlim(Plot_Time)
        maximize
    end
end