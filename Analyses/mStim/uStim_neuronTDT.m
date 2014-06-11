%returns TDT for stim and nostim, given spike channel
function [TDT_stim TDT_nostim] = uStim_neuronTDT(Spike,RF,plotFlag)

Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
MStim_ = evalin('caller','MStim_');
TrialStart_ = evalin('caller','TrialStart_');


Plot_Time = [-100 500];

if nargin < 3; plotFlag = 0; end

antiRF = mod(RF+4,8);

intrials_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),RF) & ~isnan(MStim_(:,1)));
intrials_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),RF) & isnan(MStim_(:,1)));
outtrials_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),antiRF) & ~isnan(MStim_(:,1)));
outtrials_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),antiRF) & isnan(MStim_(:,1)));


SDF_in_stim = spikedensityfunct(Spike,Target_(:,1),Plot_Time,intrials_stim,TrialStart_);
SDF_in_nostim = spikedensityfunct(Spike,Target_(:,1),Plot_Time,intrials_nostim,TrialStart_);
SDF_out_stim = spikedensityfunct(Spike,Target_(:,1),Plot_Time,outtrials_stim,TrialStart_);
SDF_out_nostim = spikedensityfunct(Spike,Target_(:,1),Plot_Time,outtrials_nostim,TrialStart_);

TDT_stim = getTDT_SP(Spike,intrials_stim,outtrials_stim,0,.05,5);
TDT_nostim = getTDT_SP(Spike,intrials_nostim,outtrials_nostim,0,.05,5);

if plotFlag == 1
    fig
    plot(Plot_Time(1):Plot_Time(2),SDF_in_nostim,'b',Plot_Time(1):Plot_Time(2),SDF_out_nostim,'--b',Plot_Time(1):Plot_Time(2),SDF_in_stim,'r',Plot_Time(1):Plot_Time(2),SDF_out_stim,'--r','linewidth',2)
    vline(TDT_stim,'r')
    vline(TDT_nostim,'b')
    box off
end