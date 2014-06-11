function [] = plotSAT_errors(name)


% NOTE: SHOULD NOT BE ADDING UNIDENTIFIED TRIALS BACK IN FOR THIS
% ANALYSIS!

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');

try
    saccLoc = evalin('caller','saccLoc');
catch
    
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    newfile = evalin('caller','newfile');
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end


getTrials_SAT

sig = evalin('caller',name);

SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-400 1000]);

RF = RFs.(name);

MF = RF;

%Compare saccades into RF when reward was given versus when 
%reward was not given.
%
% These can be sub-divided into two types:
%   Otherwise correct trials (saccade to target, but deadline missed)
%   Incorrect saccades to distractor items in the RF
ACC_saccin.CorrectSaccade_WrongRT = intersect(find(ismember(saccLoc,MF)),slow_correct_missed_dead);
ACC_saccin.CorrectSaccade_CorrectRT = intersect(find(ismember(saccLoc,MF)),slow_correct_made_dead);
ACC_saccin.ErrorSaccade_WrongRT = intersect(find(ismember(saccLoc,MF)),slow_errors_missed_dead);
ACC_saccin.ErrorSaccade_CorrectRT = intersect(find(ismember(saccLoc,MF)),slow_errors_made_dead);


%NOTE:  WHAT ABOUT CLEARED ARRAYS? THIS MAY HAVE AN EFFECT ON POST-SACCADIC RESPONSES
FAST_saccin.CorrectSaccade_WrongRT = intersect(find(ismember(saccLoc,MF)),fast_correct_missed_dead_withCleared);
FAST_saccin.CorrectSaccade_CorrectRT = intersect(find(ismember(saccLoc,MF)),fast_correct_made_dead_withCleared);
FAST_saccin.ErrorSaccade_WrongRT = intersect(find(ismember(saccLoc,MF)),fast_errors_missed_dead_withCleared);
FAST_saccin.ErrorSaccade_CorrectRT = intersect(find(ismember(saccLoc,MF)),fast_errors_made_dead_withCleared);




figure
set(gcf,'position', [1127         660        1220         652])
subplot(121)
plot(-400:1000,nanmean(SDF_r(ACC_saccin.CorrectSaccade_WrongRT,:)),'r',-400:1000,nanmean(SDF_r(ACC_saccin.CorrectSaccade_CorrectRT,:)),'k', ...
    -400:1000,nanmean(SDF_r(ACC_saccin.ErrorSaccade_WrongRT,:)),'m',-400:1000,nanmean(SDF_r(ACC_saccin.ErrorSaccade_CorrectRT,:)),'b')
xlim([-400 1000])
vline(0,'k')
title('ACCURACY')

subplot(122)
plot(-400:1000,nanmean(SDF_r(FAST_saccin.CorrectSaccade_WrongRT,:)),'r',-400:1000,nanmean(SDF_r(FAST_saccin.CorrectSaccade_CorrectRT,:)),'k', ...
    -400:1000,nanmean(SDF_r(FAST_saccin.ErrorSaccade_WrongRT,:)),'m',-400:1000,nanmean(SDF_r(FAST_saccin.ErrorSaccade_CorrectRT,:)),'b')
%legend('Correct, missed deadline','Totally Correct','Wrong saccade, missed deadline','Wrong saccade, made deadline')
xlim([-400 1000])
vline(0,'k')
title('SPEED')

equate_y
legend('Correct, missed deadline','Totally Correct','Wrong saccade, missed deadline','Wrong saccade, made deadline')
[ax h] = suplabel('ALL SACCADES INTO RF','t');
set(h,'fontsize',12,'fontweight','bold')