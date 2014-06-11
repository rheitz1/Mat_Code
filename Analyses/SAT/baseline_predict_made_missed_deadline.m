function [acc_r acc_p speed_r speed_p] = baseline_predict_made_missed_deadline(name,win)

% Determine whether or not the baseline spike rate predicts whether or not a deadline was made/missed.
% Plan to later add in an analysis for error trials
%
% win = window of baseline averaging.  Default = -400:0

% RPH

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
RFs = evalin('caller','RFs');
Hemi = evalin('caller','Hemi');
sig = evalin('caller',name);
RFs = evalin('caller','RFs');

if nargin < 2; win = [-50 0]; end



%All correct trials w/ made deadlines
slow_correct_made_dead = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_correct_made_dead_noCleared = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);

%=========================


%All correct trials w/ missed deadlines (too late in FAST/too early in SLOW
slow_correct_missed_dead = find(Errors_(:,6) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
fast_correct_missed_dead_withCleared = find(Errors_(:,7) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_correct_missed_dead_noCleared = find(Errors_(:,7) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);

SDF = sSDF(sig,Target_(:,1),[-400 2500]);
SDF = normalize_SP(SDF);

baseline_SDF = nanmean(SDF(:,400+win(1)+1:400+win(2)+1),2);

%NOTE:  Target-in vs Target-out has no meaning because the baseline occurs before the stimulus array

slow_cond = [baseline_SDF(slow_correct_made_dead) ; baseline_SDF(slow_correct_missed_dead)];
slow_cond(:,2) = 0;
slow_cond(1:length(slow_correct_made_dead),2) = 1;

fast_cond = [baseline_SDF(fast_correct_made_dead_withCleared) ; baseline_SDF(fast_correct_missed_dead_withCleared)];
fast_cond(:,2) = 0;
fast_cond(1:length(fast_correct_made_dead_withCleared),2) = 1;

%remove NaNs and do the correlation
slow_cond = removeNaN(slow_cond);
fast_cond = removeNaN(fast_cond);

[acc_r acc_p] = corr(slow_cond(:,1),slow_cond(:,2));
[speed_r speed_p] = corr(fast_cond(:,1),fast_cond(:,2));

disp(['ACCURACY condition: r = ' mat2str(round(acc_r*100)/100) ' p < ' mat2str(acc_p)])
disp(['SPEED condition: r = ' mat2str(round(speed_r*100)/100) ' p < ' mat2str(speed_p)])