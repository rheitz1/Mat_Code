%plots ERN by screen location
%Errors are when errant saccade made into screen location
%flag turns on/off detection of ERN onset
function [] = ERN_AD(ADname)

Plot_Time = [-100 300];

AD = evalin('caller',ADname);
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
newfile = evalin('caller','newfile');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Hemi = evalin('caller','Hemi');

try
    saccLoc = evalin('caller','saccLoc');
catch
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end


fixErrors

if Hemi.(ADname) == 'L'
    RF = [7 0 1];
elseif Hemi.(ADname) == 'R'
    RF = [3 4 5];
end


%Median SRT of correct trials
% cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
% eMed = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
in.all_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & ismember(Target_(:,2),RF));
in.all_err = find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & ismember(saccLoc,RF));

%response align, DO truncate at 2nd saccade
AD_resp = response_align(AD,SRT,[Plot_Time(1) Plot_Time(2)],1);

%baseline correct
AD_resp = baseline_correct(AD_resp,[1 100]);


fig
plot(Plot_Time(1):Plot_Time(2),nanmean(AD_resp(in.all_corr,:)),'k', ...
    Plot_Time(1):Plot_Time(2),nanmean(AD_resp(in.all_err,:)),'r');
xlim([Plot_Time(1) Plot_Time(2)])
axis ij

