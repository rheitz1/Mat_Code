%plot catch trials against target in and distractor in for a given unit
function [trls] = plotCatchSDF(SpikeName)

%get global variables
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
RFs = evalin('caller','RFs');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
newfile = evalin('caller','newfile');
Spike = evalin('caller',SpikeName);

%if saccLoc does not exist in calling workspace, create variable and put it
%there to speed up future calls
try
    saccLoc = evalin('caller','saccLoc');
catch
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end

RF = RFs.(SpikeName);
antiRF = mod((RF+4),8);

SDF = sSDF(Spike,Target_(:,1),[-100 500]);
SDF_resp = sSDF(Spike,SRT(:,1)+500,[-400 200]);

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

% black = correct  blue = late catch responses into RF  red = early catch
% errors into RF
%getVec(EyeX_,EyeY_,SRT,1,0,in_correct,catch_correct_in,catch_errors_in);

figure
subplot(1,2,1)
plot(-100:500,nanmean(SDF(in_correct,:)),'k',-100:500,nanmean(SDF(out_correct,:)),'--k', ...
    -100:500,nanmean(SDF(catch_errors_in,:)),'r',-100:500,nanmean(SDF(catch_errors_out,:)),'--r', ...
    -100:500,nanmean(SDF(catch_correct_in,:)),'b', -100:500,nanmean(SDF(catch_correct_out,:)),'--b', ...
    -100:500,nanmean(SDF(catch_correct_nosacc,:)),'g')
xlim([-100 500])

subplot(1,2,2)
plot(-400:200,nanmean(SDF_resp(in_correct,:)),'k',-400:200,nanmean(SDF_resp(out_correct,:)),'--k', ...
    -400:200,nanmean(SDF_resp(catch_errors_in,:)),'r',-400:200,nanmean(SDF_resp(catch_errors_out,:)),'--r', ...
    -400:200,nanmean(SDF_resp(catch_correct_in,:)),'b', -400:200,nanmean(SDF_resp(catch_correct_out,:)),'--b', ...
    -400:200,nanmean(SDF_resp(catch_correct_nosacc,:)),'g')
xlim([-400 200])

tileFigs