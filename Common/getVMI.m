%gets Visuo-Movement Index (VMI) as (vis - move) / (vis + move)
%where vis = peak activity around stim onset
%where move = peak activity w/i +/- 40 ms of saccade initiation

%Spike is unmodified DSP channel
%RFs & MFs self explanatory.  Because movement field and receptive field
%are not always exactly concordant, I compute their max activity
%separately unless a RF or MF is missing, in which case I use whatever is not missing for both.

%Note: this should technically be run only on MG trials because vis and
%vis-move during search are sufficiently overlapping to cause very few to
%be around +1.  Most will fall around 0.  May work for pure movement cells
%during search, however, because few of these have significant activity
%0:100 ms relative to target onset.

%RPH 8/11/09

function [VMI] = getVMI(SpikeName,plotFlag)

if nargin < 2; plotFlag = 0; end

Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
TrialStart_ = evalin('caller','TrialStart_');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
Spike = evalin('caller',SpikeName);

RF = RFs.(SpikeName);
MF = MFs.(SpikeName);

if isempty(RF); RF = MF; end
if isempty(MF); MF = RF; end

inTrials_targ = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
inTrials_resp = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

SDF_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_targ,TrialStart_);
SDF_in_resp = spikedensityfunct(Spike,SRT(:,1)+Target_(1,1),[-400 200],inTrials_resp,TrialStart_);

%maximum of activity relative to target onset minutes baseline activity
maxVis = max(SDF_in(100:200)) - mean(SDF_in(1:100));

%maximum of activity relative to saccade onset
maxMove = max(SDF_in_resp(360:440)) - mean(SDF_in_resp(1:100));

if maxMove < 0; error('Max of Move activity is negative'); end

VMI = (maxVis - maxMove) / (maxVis + maxMove);


if plotFlag == 1
    figure
    subplot(1,2,1)
    plot(-100:500,SDF_in)
    xlim([-100 500])
    box off
    
    subplot(1,2,2)
    plot(-400:200,SDF_in_resp)
    xlim([-400 200])
    box off
    
    equate_y
    
    title(['VMI = ' mat2str(round(VMI*100)/100)])
end