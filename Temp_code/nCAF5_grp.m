%function to generate Conditional Accuracy Functions (CAFs) based on some
%criteria determined prior to function call (relevant_trials should hold
%this information).  For neurons (use 'CAF' for behavior)

%Richard P. Heitz
%Vanderbilt
%4/18/08


function [accs,RTs] = nCAF5_grp(relevant_trials,Correct_,SRT,TrialStart_,Target_,Spike,RF)

plotFlag = 1;
Align_ = 's';

if Align_ == 's'
    Align_Time(1:length(SRT),1) = 500;
    Plot_Time = [-200 800];
elseif Align_ == 'r'
    Align_Time = SRT(relevant_trials,1) + 500;
    Plot_Time = [-400 200];
end

anti_RF = getAntiRF(RF);

relevant_trials = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100));
relevant_trials_in = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF)))';
relevant_trials_out = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF)))';


relevant_trials_in_correct = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF) & Correct_(relevant_trials,2) == 1))';
relevant_trials_out_correct = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF) & Correct_(relevant_trials,2) == 1))';
relevant_trials_in_incorrect = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),RF) & Correct_(relevant_trials,2) == 0))';
relevant_trials_out_incorrect = relevant_trials(find(SRT(relevant_trials,1) < 2000 & SRT(relevant_trials,1) >= 100 & ismember(Target_(relevant_trials,2),anti_RF) & Correct_(relevant_trials,2) == 0))';

RTs = SRT(relevant_trials,1);
%[RTs,index] = sort(RTs);

RTs_correct = SRT(find(Correct_(relevant_trials,2) == 1),1);
RTs_incorrect = SRT(find(Correct_(relevant_trials,2) == 0),1);


j = 1;
for i = 20:20:100
    %5/6/08 changed to calculate percentiles off of entire RT distribution,
    %regardless of correct/incorrect.  Thus we can ensure that we create
    %SDFs that occur close in time.
    percentile_array(j) = prctile(RTs,i);
%     percentile_array_correct(j) = percentile(RTs_correct,i);
%     percentile_array_incorrect(j) = percentile(RTs_incorrect,i);    
    percentile_array_correct(j) = prctile(RTs,i);
    percentile_array_incorrect(j) = prctile(RTs,i);  
    j = j + 1;
end



%initialize SDF array
SDF_array_in(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;
SDF_array_out(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;

SDF_array_in_correct(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;
SDF_array_out_correct(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;
SDF_array_in_incorrect(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;
SDF_array_out_incorrect(1:length(Plot_Time(1):Plot_Time(2)),1:5) = NaN;


SDF_in_correct = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct, TrialStart_);
SDF_out_correct = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct, TrialStart_);
SDF_in_incorrect = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect, TrialStart_);
SDF_out_incorrect = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect, TrialStart_);


%==== SDFs for in vs. out, collapsed over correct/incorrect ==========
SDF_array_in(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in(find(SRT(relevant_trials_in,1) <= percentile_array(1))), TrialStart_);
SDF_array_in(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in(find(SRT(relevant_trials_in,1) > percentile_array(1) & SRT(relevant_trials_in,1) <= percentile_array(2))), TrialStart_);
SDF_array_in(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in(find(SRT(relevant_trials_in,1) > percentile_array(2) & SRT(relevant_trials_in,1) <= percentile_array(3))), TrialStart_);
SDF_array_in(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in(find(SRT(relevant_trials_in,1) > percentile_array(3) & SRT(relevant_trials_in,1) <= percentile_array(4))), TrialStart_);
SDF_array_in(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in(find(SRT(relevant_trials_in,1) > percentile_array(4))), TrialStart_);


SDF_array_out(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out(find(SRT(relevant_trials_out,1) <= percentile_array(1))), TrialStart_);
SDF_array_out(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out(find(SRT(relevant_trials_out,1) > percentile_array(1) & SRT(relevant_trials_out,1) <= percentile_array(2))), TrialStart_);
SDF_array_out(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out(find(SRT(relevant_trials_out,1) > percentile_array(2) & SRT(relevant_trials_out,1) <= percentile_array(3))), TrialStart_);
SDF_array_out(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out(find(SRT(relevant_trials_out,1) > percentile_array(3) & SRT(relevant_trials_out,1) <= percentile_array(4))), TrialStart_);
SDF_array_out(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out(find(SRT(relevant_trials_out,1) > percentile_array(4))), TrialStart_);


%==== SDFs for in vs. out, correct only ============
SDF_array_in_correct(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct(find(SRT(relevant_trials_in_correct,1) <= percentile_array_correct(1))), TrialStart_);
SDF_array_in_correct(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct(find(SRT(relevant_trials_in_correct,1) > percentile_array_correct(1) & SRT(relevant_trials_in_correct,1) <= percentile_array_correct(2))), TrialStart_);
SDF_array_in_correct(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct(find(SRT(relevant_trials_in_correct,1) > percentile_array_correct(2) & SRT(relevant_trials_in_correct,1) <= percentile_array_correct(3))), TrialStart_);
SDF_array_in_correct(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct(find(SRT(relevant_trials_in_correct,1) > percentile_array_correct(3) & SRT(relevant_trials_in_correct,1) <= percentile_array_correct(4))), TrialStart_);
SDF_array_in_correct(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct(find(SRT(relevant_trials_in_correct,1) > percentile_array_correct(4))), TrialStart_);
%test_in = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_correct, TrialStart_);

SDF_array_out_correct(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct(find(SRT(relevant_trials_out_correct,1) <= percentile_array_correct(1))), TrialStart_);
SDF_array_out_correct(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct(find(SRT(relevant_trials_out_correct,1) > percentile_array_correct(1) & SRT(relevant_trials_out_correct,1) <= percentile_array_correct(2))), TrialStart_);
SDF_array_out_correct(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct(find(SRT(relevant_trials_out_correct,1) > percentile_array_correct(2) & SRT(relevant_trials_out_correct,1) <= percentile_array_correct(3))), TrialStart_);
SDF_array_out_correct(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct(find(SRT(relevant_trials_out_correct,1) > percentile_array_correct(3) & SRT(relevant_trials_out_correct,1) <= percentile_array_correct(4))), TrialStart_);
SDF_array_out_correct(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct(find(SRT(relevant_trials_out_correct,1) > percentile_array_correct(4))), TrialStart_);
%test_out = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_correct, TrialStart_);

%=== SDFs for in vs. out, incorrect only =============
SDF_array_in_incorrect(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect(find(SRT(relevant_trials_in_incorrect,1) <= percentile_array_incorrect(1))), TrialStart_);
SDF_array_in_incorrect(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect(find(SRT(relevant_trials_in_incorrect,1) > percentile_array_incorrect(1) & SRT(relevant_trials_in_incorrect,1) <= percentile_array_incorrect(2))), TrialStart_);
SDF_array_in_incorrect(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect(find(SRT(relevant_trials_in_incorrect,1) > percentile_array_incorrect(2) & SRT(relevant_trials_in_incorrect,1) <= percentile_array_incorrect(3))), TrialStart_);
SDF_array_in_incorrect(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect(find(SRT(relevant_trials_in_incorrect,1) > percentile_array_incorrect(3) & SRT(relevant_trials_in_incorrect,1) <= percentile_array_incorrect(4))), TrialStart_);
SDF_array_in_incorrect(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_in_incorrect(find(SRT(relevant_trials_in_incorrect,1) > percentile_array_incorrect(4))), TrialStart_);

SDF_array_out_incorrect(:,1) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect(find(SRT(relevant_trials_out_incorrect,1) <= percentile_array_incorrect(1))), TrialStart_);
SDF_array_out_incorrect(:,2) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect(find(SRT(relevant_trials_out_incorrect,1) > percentile_array_incorrect(1) & SRT(relevant_trials_out_incorrect,1) <= percentile_array_incorrect(2))), TrialStart_);
SDF_array_out_incorrect(:,3) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect(find(SRT(relevant_trials_out_incorrect,1) > percentile_array_incorrect(2) & SRT(relevant_trials_out_incorrect,1) <= percentile_array_incorrect(3))), TrialStart_);
SDF_array_out_incorrect(:,4) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect(find(SRT(relevant_trials_out_incorrect,1) > percentile_array_incorrect(3) & SRT(relevant_trials_out_incorrect,1) <= percentile_array_incorrect(4))), TrialStart_);
SDF_array_out_incorrect(:,5) = spikedensityfunct(Spike, Align_Time, Plot_Time, relevant_trials_out_incorrect(find(SRT(relevant_trials_out_incorrect,1) > percentile_array_incorrect(4))), TrialStart_);



%plot in vs. out, collapsing across RT bin for correct trials only
if plotFlag == 1
    figure
    set(gcf,'Color','white')
    subplot(1,2,1)
    plot(Plot_Time(1):Plot_Time(2),SDF_in_correct,'b',Plot_Time(1):Plot_Time(2),SDF_out_correct,'r')
    title('Correct Only')
    subplot(1,2,2)
    plot(Plot_Time(1):Plot_Time(2),SDF_in_incorrect,'b',Plot_Time(1):Plot_Time(2),SDF_out_incorrect,'r')
    title('Incorrect Only')
    maximize
end


%plot in vs. out, collapsing over correct/incorrect
% if plotFlag == 1
%     figure
%     set(gcf,'Color','white')
%     for j = 1:5
%         subplot(3,4,j)
%         plot(Plot_Time(1):Plot_Time(2),SDF_array_in(:,j),'b',Plot_Time(1):Plot_Time(2),SDF_array_out(:,j),'r')
%         xlim(Plot_Time)
%         maximize
%     end
% end

%plot in vs. out, correct only
if plotFlag == 1
    figure
    set(gcf,'Color','white')
    for j = 1:5
        subplot(3,4,j)
        plot(Plot_Time(1):Plot_Time(2),SDF_array_in_correct(:,j),'b',Plot_Time(1):Plot_Time(2),SDF_array_out_correct(:,j),'r')
        xlim(Plot_Time)
        maximize
    end
end


%plot in vs. out, incorrect only
if plotFlag == 1
    figure
    set(gcf,'Color','white')
    for j = 1:5
        subplot(3,4,j)
        plot(Plot_Time(1):Plot_Time(2),SDF_array_in_incorrect(:,j),'b',Plot_Time(1):Plot_Time(2),SDF_array_out_incorrect(:,j),'r')
        xlim(Plot_Time)
        maximize
    end
end