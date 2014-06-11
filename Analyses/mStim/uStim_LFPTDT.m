%returns TDT for stim and nostim, given spike channel
function [TDT_stim TDT_nostim] = uStim_LFPTDT(AD,Hemi,plotFlag)


Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
MStim_ = evalin('caller','MStim_');
TrialStart_ = evalin('caller','TrialStart_');

if nargin < 3; plotFlag = 0; end


if Hemi == 'L'
    RF = [7 0 1];
    antiRF = [3 4 5];
elseif Hemi == 'R'
    RF = [3 4 5];
    antiRF = [7 0 1];
end

%baseline correct
AD = baseline_correct(AD,[400 500]);

%remove clipped trials
AD = fixClipped(AD);


intrials_stim = find(~isnan(AD(:,1)) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),RF) & ~isnan(MStim_(:,1)));
intrials_nostim = find(~isnan(AD(:,1)) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),RF) & isnan(MStim_(:,1)));
outtrials_stim = find(~isnan(AD(:,1)) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),antiRF) & ~isnan(MStim_(:,1)));
outtrials_nostim = find(~isnan(AD(:,1)) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),antiRF) & isnan(MStim_(:,1)));


AD_in_stim = nanmean(AD(intrials_stim,:));
AD_in_nostim = nanmean(AD(intrials_nostim,:));
AD_out_stim = nanmean(AD(outtrials_stim,:));
AD_out_nostim = nanmean(AD(outtrials_nostim,:));


for time = 600:size(AD,2) %600 == 100 ms post stimulus onset
    [p_stim(time) h_stim(time)] = ranksum(AD(intrials_stim,time),AD(outtrials_stim,time),'alpha',.05);
    [p_nostim(time) h_nostim(time)] = ranksum(AD(intrials_nostim,time),AD(outtrials_nostim,time),'alpha',.05);
end

TDT_stim = min(findRuns(h_stim(600:end),5)) + 100;
TDT_nostim = min(findRuns(h_nostim(600:end),5)) + 100;

if plotFlag == 1
    fig
    plot(-500:2500,AD_in_nostim,'b',-500:2500,AD_out_nostim,'--b',-500:2500,AD_in_stim,'r',-500:2500,AD_out_stim,'--r','linewidth',2)
    legend('InTrials No Stim','OutTrials No Stim','InTrials uStim','OutTrials uStim')
    xlim([-100 500])
    axis ij
    vline(TDT_stim,'r')
    vline(TDT_nostim,'b')
    title(['NoStim TDT = ' mat2str(TDT_nostim) '    uStim TDT = ' mat2str(TDT_stim)])
end