function [] = plotSAT_error(name)

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
Hemi = evalin('caller','Hemi');
%TrialStart_ = evalin('caller','TrialStart_');

try
    saccLoc = evalin('caller','saccLoc');
catch
    
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    newfile = evalin('caller','newfile');
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end

calcTDT = 0;
trunc_RT = 2000;
plotBaselineBlocks = 0;
separate_cleared_nocleared = 0;
within_condition_RT_bins = 0; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
match_variability = 0;
plot_integrals = 1;
basewin = [Target_(1,1)-100 Target_(1,1)]; %baseline correction window for AD channels
normalize = 1;
%============
% FIND TRIALS
%===================================================================


%======
% To try:  play back FAST trials where deadline missed and display cleared.
% Make sure that this catches the 'juke' trials


getTrials_SAT

sig = evalin('caller',name);


%switch for AD channels
if size(sig,2) == 3001 || size(sig,2) == 6001
    isAD = 1;
    sig = fixClipped(sig,[400 900]);
    sig = baseline_correct(sig,basewin);
    %sig = truncateAD_targ(sig,SRT);
    
    %sig = filtSig(sig,[60],'notch');
    
    Plot_Time = -Target_(1,1):2500;
    
    SDF = sig;
    SDF_r = response_align(sig,SRT,[-800 200]);
    
    if Hemi.(name) == 'L'
        RF = [7 0 1];
        antiRF = [3 4 5];
        MF = [7 0 1];
        antiMF = [3 4 5];
    elseif Hemi.(name) == 'R'
        RF = [3 4 5];
        antiRF = [7 0 1];
        MF = [3 4 5];
        antiMF = [7 0 1];
    end
    
    inRF = find(ismember(Target_(:,2),RF));
    outRF = find(ismember(Target_(:,2),antiRF));
    
    inRF_err = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
    outRF_err = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
    
    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    
    inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
    outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
    
else
    isAD = 0;
    SDF = sSDF(sig,Target_(:,1),[-400 900]);
    SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-800 200]);
    
    %normalize?
    if normalize == 1
        SDF = normalize_SP(SDF);
        SDF_r = normalize_SP(SDF_r,[300 500]);
    end
    
    Plot_Time = -400:900;
    
    
    RF = RFs.(name);
    
    if isempty(RF)
        disp('Empty RF')
    end
    
    antiRF = mod((RF+4),8);
    inRF = find(ismember(Target_(:,2),RF));
    outRF = find(ismember(Target_(:,2),antiRF));
    
    
    
    MF = MFs.(name);
    if isempty(MF)
        disp('Empty MF')
    end
    
    antiMF = mod((MF+4),8);
    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    
    inRF_err = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
    outRF_err = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
    
    inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
    outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
end



%======================
% Target-Aligned RF
%==============
% CORRECT
%made dead only
in.slow_correct_made_dead_RF = intersect(inRF,slow_correct_made_dead);
out.slow_correct_made_dead_RF = intersect(outRF,slow_correct_made_dead);

in.fast_correct_made_dead_withCleared_RF = intersect(inRF,fast_correct_made_dead_withCleared);
out.fast_correct_made_dead_withCleared_RF = intersect(outRF,fast_correct_made_dead_withCleared);

in.fast_correct_made_dead_noCleared_RF = intersect(inRF,fast_correct_made_dead_noCleared);
out.fast_correct_made_dead_noCleared_RF = intersect(outRF,fast_correct_made_dead_noCleared);

in.med_correct_RF = intersect(inRF,med_correct);
out.med_correct_RF = intersect(outRF,med_correct);



in.slow_correct_made_dead_MF = intersect(inMF,slow_correct_made_dead);
out.slow_correct_made_dead_MF = intersect(outMF,slow_correct_made_dead);

in.fast_correct_made_dead_withCleared_MF = intersect(inMF,fast_correct_made_dead_withCleared);
out.fast_correct_made_dead_withCleared_MF = intersect(outMF,fast_correct_made_dead_withCleared);

in.fast_correct_made_dead_noCleared_MF = intersect(inMF,fast_correct_made_dead_noCleared);
out.fast_correct_made_dead_noCleared_MF = intersect(outMF,fast_correct_made_dead_noCleared);

in.med_correct_MF = intersect(inMF,med_correct);
out.med_correct_MF = intersect(outMF,med_correct);



%==========
% Errors
in.slow_errors_made_dead_RF = intersect(inRF,slow_errors_made_dead);
out.slow_errors_made_dead_RF = intersect(outRF,slow_errors_made_dead);

in.fast_errors_made_dead_RF = intersect(inRF,fast_errors_made_dead_withCleared);
out.fast_errors_made_dead_RF = intersect(outRF,fast_errors_made_dead_withCleared);

in.med_errors_RF = intersect(inRF,med_errors);
out.med_errors_RF = intersect(outRF,med_errors);

in.slow_errors_made_dead_MF = intersect(inRF,slow_errors_made_dead);
out.slow_errors_made_dead_MF = intersect(outRF,slow_errors_made_dead);

in.fast_errors_made_dead_MF = intersect(inRF,fast_errors_made_dead_withCleared);
out.fast_errors_made_dead_MF = intersect(outRF,fast_errors_made_dead_withCleared);

in.med_errors_MF = intersect(inMF,med_errors);
out.med_errors_MF = intersect(outMF,med_errors);


fig
subplot(2,2,1)
plot(-400:900,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r',-400:900,nanmean(SDF(out.slow_errors_made_dead_RF,:)),'--r', ...
    -400:900,nanmean(SDF(in.med_correct_RF,:)),'k',-400:900,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
    -400:900,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g',-400:900,nanmean(SDF(out.fast_errors_made_dead_RF,:)),'--g')

subplot(2,2,2)
plot(-800:200,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r',-800:200,nanmean(SDF_r(out.slow_errors_made_dead_MF,:)),'--r', ...
    -800:200,nanmean(SDF_r(in.med_correct_MF,:)),'k',-800:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
    -800:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g',-800:200,nanmean(SDF_r(out.fast_errors_made_dead_MF,:)),'--g')
vline(0,'k')
