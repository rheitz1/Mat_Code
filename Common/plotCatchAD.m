%plot catch trials against target in and distractor in for a given unit
function [trls] = plotCatchAD(ADName)

%get global variables
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
newfile = evalin('caller','newfile');
AD = evalin('caller',ADName);
Hemi = evalin('caller','Hemi');

%if saccLoc does not exist in calling workspace, create variable and put it
%there to speed up future calls
try
    saccLoc = evalin('caller','saccLoc');
catch
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end

if Hemi.(ADName) == 'R'
    RF = [3 4 5];
elseif Hemi.(ADName) == 'L'
    RF = [7 0 1];
end

antiRF = mod((RF+4),8);


AD = baseline_correct(AD,[400 500]);
AD = truncateAD_targ(AD,SRT);

in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

catch_errors_in = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
catch_errors_out = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,antiRF) & ~isnan(SRT(:,1)));

%condition where catch trial scored as correct & no saccade
catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));

%condition where catch trial scored as correct but saccade
%still made, late
catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
catch_correct_out = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,antiRF) & ~isnan(SRT(:,1)));

% black = correct  blue = late catch responses into RF  red = early catch
% errors into RF
%getVec(EyeX_,EyeY_,SRT,1,0,in_correct,catch_correct_in,catch_errors_in);


%return trial vectors for use
trls.in_correct = in_correct;
trls.out_correct = out_correct;
trls.in_incorrect = in_incorrect;
trls.out_incorrect = out_incorrect;
trls.catch_errors_in = catch_errors_in;
trls.catch_errors_out = catch_errors_out;
trls.catch_correct_nosacc = catch_correct_nosacc;
trls.catch_correct_in = catch_correct_in;
trls.catch_correct_out = catch_correct_out;


figure
plot(-500:2500,nanmean(AD(in_correct,:)),'k',-500:2500,nanmean(AD(out_correct,:)),'--k', ...
    -500:2500,nanmean(AD(catch_errors_in,:)),'r',-500:2500,nanmean(AD(catch_errors_out,:)),'--r', ...
    -500:2500,nanmean(AD(catch_correct_in,:)),'b',-500:2500,nanmean(AD(catch_correct_out,:)),'--b', ...
    -500:2500,nanmean(AD(catch_correct_nosacc,:)),'g')
axis ij
xlim([-100 500])

tileFigs