
function [in out] = plotSAT_summary(name)

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');

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
normalize = 0;
%============
% FIND TRIALS
%===================================================================


%======
% To try:  play back FAST trials where deadline missed and display cleared.
% Make sure that this catches the 'juke' trials


getTrials_SAT

%====================
% Calculate ACC rates
%percentage of CORRECT trials that missed the deadline
prc_missed_slow_correct = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
prc_missed_fast_correct_withCleared = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
prc_missed_fast_correct_noCleared = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));

%ACC rate for made deadlines
ACC.slow_made_dead = length(slow_correct_made_dead) / length(slow_all_made_dead);
ACC.fast_made_dead_withCleared = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
ACC.fast_made_dead_noCleared = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);


%ACC rate for missed deadlines
ACC.slow_missed_dead = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
ACC.fast_missed_dead_withCleared = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
ACC.fast_missed_dead_noCleared = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);


%overall ACC rate for made + missed deadlines
ACC.slow_made_missed = length(slow_correct_made_missed) / length(slow_all);
ACC.fast_made_missed_withCleared = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
ACC.fast_made_missed_noCleared = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);

ACC.med = length(med_correct) / length(med_all);

% CDFs for correct trials, made deadlines
[bins_correct_slow_made_dead cdf_correct_slow_made_dead] = getCDF(SRT(slow_correct_made_dead,1),50);
[bins_correct_fast_made_dead_withCleared cdf_correct_fast_made_dead_withCleared] = getCDF(SRT(fast_correct_made_dead_withCleared,1),50);
[bins_correct_fast_made_dead_noCleared cdf_correct_fast_made_dead_noCleared] = getCDF(SRT(fast_correct_made_dead_noCleared,1),50);

% CDFs for correct trials, missed deadlines
[bins_correct_slow_missed_dead cdf_correct_slow_missed_dead] = getCDF(SRT(slow_correct_missed_dead,1),50);
[bins_correct_fast_missed_dead_withCleared cdf_correct_fast_missed_dead_withCleared] = getCDF(SRT(fast_correct_missed_dead_withCleared,1),50);
[bins_correct_fast_missed_dead_noCleared cdf_correct_fast_missed_dead_noCleared] = getCDF(SRT(fast_correct_missed_dead_noCleared,1),50);

% CDFs for correct trials, made + missed deadlines
[bins_correct_slow_made_missed cdf_correct_slow_made_missed] = getCDF(SRT(slow_correct_made_missed,1),50);
[bins_correct_fast_made_missed_withCleared cdf_correct_fast_made_missed_withCleared] = getCDF(SRT(fast_correct_made_missed_withCleared,1),50);
[bins_correct_fast_made_missed_noCleared cdf_correct_fast_made_missed_noCleared] = getCDF(SRT(fast_correct_made_missed_noCleared,1),50);

% Medium
[bins_correct_med cdf_correct_med] = getCDF(SRT(med_correct,1),50);

if nargin < 1
    figure
    subplot(3,2,1)
    plot(bins_correct_slow_made_dead,cdf_correct_slow_made_dead,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_made_dead_withCleared,cdf_correct_fast_made_dead_withCleared,'g', ...
        bins_correct_fast_made_dead_noCleared,cdf_correct_fast_made_dead_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct made deadlines')
    
    subplot(3,2,2)
    bar(1:4,[ACC.slow_made_dead ACC.med ACC.fast_made_dead_withCleared ACC.fast_made_dead_noCleared])
    ylim([.3 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC all made deadlines')
    
    subplot(3,2,3)
    plot(bins_correct_slow_missed_dead,cdf_correct_slow_missed_dead,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_missed_dead_withCleared,cdf_correct_fast_missed_dead_withCleared,'g', ...
        bins_correct_fast_missed_dead_noCleared,cdf_correct_fast_missed_dead_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct missed deadlines')
    
    subplot(3,2,4)
    bar(1:4,[ACC.slow_missed_dead ACC.med ACC.fast_missed_dead_withCleared ACC.fast_missed_dead_noCleared])
    ylim([.3 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC missed deadlines')
    
    
    subplot(3,2,5)
    plot(bins_correct_slow_made_missed,cdf_correct_slow_made_missed,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_made_missed_withCleared,cdf_correct_fast_made_missed_withCleared,'g', ...
        bins_correct_fast_made_missed_noCleared,cdf_correct_fast_made_missed_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct missed + made deadlines')
    
    subplot(3,2,6)
    bar(1:4,[ACC.slow_made_missed ACC.med ACC.fast_made_missed_withCleared ACC.fast_made_missed_noCleared])
    ylim([.3 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC missed + made deadlines')
    
    
    
    
    %================
    % Histograms
    %     multiHist_SAT(50,slow_correct_made_dead,fast_correct_made_dead)
    %     title('Correct Made Deadlines')
    %
    %     multiHist_SAT(50,slow_correct_made_missed,fast_correct_made_missed)
    %     title('Correct Made + Missed Deadlines')
    
end


sig = evalin('caller',name);


%switch for AD channels
if size(sig,2) == 3001 || size(sig,2) == 6001
    Hemi = evalin('caller','Hemi');
    isAD = 1;
    sig = fixClipped(sig,[400 900]);
    sig = baseline_correct(sig,basewin);
    %sig = truncateAD_targ(sig,SRT);
    
    %sig = filtSig(sig,[60],'notch');
    
    Plot_Time = -Target_(1,1):2500;
    Plot_Time_Resp = -800:100;
    
    SDF = sig;
    SDF_r = response_align(sig,SRT,[-800 100]);
    
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
    
    Plot_Time = -400:900;
    Plot_Time_Resp = -800:100;
    
    SDF = sSDF(sig,Target_(:,1),[-400 900]);
    SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[Plot_Time_Resp(1) Plot_Time_Resp(end)]);
    
    %normalize?
    if normalize == 1
        SDF = normalize_SP(SDF);
        SDF_r = normalize_SP(SDF_r,[300 500]);
    end
    

    
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

if calcTDT
    if isAD
        TDT.slow_correct_made_dead = getTDT_AD(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
        TDT.med_correct = getTDT_AD(sig,in.med_correct_RF,out.med_correct_RF);
        TDT.fast_correct_made_dead_withCleared = getTDT_AD(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
    else
        TDT.slow_correct_made_dead = getTDT_SP(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
        TDT.med_correct = getTDT_SP(sig,in.med_correct_RF,out.med_correct_RF);
        TDT.fast_correct_made_dead_withCleared = getTDT_SP(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
    end
else
    TDT.slow_correct_made_dead = NaN;
    TDT.med_correct = NaN;
    TDT.fast_correct_made_dead_withCleared = NaN;
end

%==============================
% WITHIN CONDITION RT BIN SPLIT
in.slow_correct_made_dead_RF_binFAST = intersect(inRF,slow_correct_made_dead_binFAST);
out.slow_correct_made_dead_RF_binFAST = intersect(outRF,slow_correct_made_dead_binFAST);
in.slow_correct_made_dead_RF_binMED = intersect(inRF,slow_correct_made_dead_binMED);
out.slow_correct_made_dead_RF_binMED = intersect(outRF,slow_correct_made_dead_binMED);
in.slow_correct_made_dead_RF_binSLOW = intersect(inRF,slow_correct_made_dead_binSLOW);
out.slow_correct_made_dead_RF_binSLOW = intersect(outRF,slow_correct_made_dead_binSLOW);

in.med_correct_RF_binFAST = intersect(inRF,med_correct_binFAST);
out.med_correct_RF_binFAST = intersect(outRF,med_correct_binFAST);
in.med_correct_RF_binMED = intersect(inRF,med_correct_binMED);
out.med_correct_RF_binMED = intersect(outRF,med_correct_binMED);
in.med_correct_RF_binSLOW = intersect(inRF,med_correct_binSLOW);
out.med_correct_RF_binSLOW = intersect(outRF,med_correct_binSLOW);

in.fast_correct_made_dead_withCleared_RF_binFAST = intersect(inRF,fast_correct_made_dead_withCleared_binFAST);
out.fast_correct_made_dead_withCleared_RF_binFAST = intersect(outRF,fast_correct_made_dead_withCleared_binFAST);
in.fast_correct_made_dead_withCleared_RF_binMED = intersect(inRF,fast_correct_made_dead_withCleared_binMED);
out.fast_correct_made_dead_withCleared_RF_binMED = intersect(outRF,fast_correct_made_dead_withCleared_binMED);
in.fast_correct_made_dead_withCleared_RF_binSLOW = intersect(inRF,fast_correct_made_dead_withCleared_binSLOW);
out.fast_correct_made_dead_withCleared_RF_binSLOW = intersect(outRF,fast_correct_made_dead_withCleared_binSLOW);


in.slow_errors_made_dead_RF_binFAST = intersect(inRF,slow_errors_made_dead_binFAST);
out.slow_errors_made_dead_RF_binFAST = intersect(outRF,slow_errors_made_dead_binFAST);
in.slow_errors_made_dead_RF_binMED = intersect(inRF,slow_errors_made_dead_binMED);
out.slow_errors_made_dead_RF_binMED = intersect(outRF,slow_errors_made_dead_binMED);
in.slow_errors_made_dead_RF_binSLOW = intersect(inRF,slow_errors_made_dead_binSLOW);
out.slow_errors_made_dead_RF_binSLOW = intersect(outRF,slow_errors_made_dead_binSLOW);
 
in.med_errors_RF_binFAST = intersect(inRF,med_errors_binFAST);
out.med_errors_RF_binFAST = intersect(outRF,med_errors_binFAST);
in.med_errors_RF_binMED = intersect(inRF,med_errors_binMED);
out.med_errors_RF_binMED = intersect(outRF,med_errors_binMED);
in.med_errors_RF_binSLOW = intersect(inRF,med_errors_binSLOW);
out.med_errors_RF_binSLOW = intersect(outRF,med_errors_binSLOW);
 
in.fast_errors_made_dead_withCleared_RF_binFAST = intersect(inRF,fast_errors_made_dead_withCleared_binFAST);
out.fast_errors_made_dead_withCleared_RF_binFAST = intersect(outRF,fast_errors_made_dead_withCleared_binFAST);
in.fast_errors_made_dead_withCleared_RF_binMED = intersect(inRF,fast_errors_made_dead_withCleared_binMED);
out.fast_errors_made_dead_withCleared_RF_binMED = intersect(outRF,fast_errors_made_dead_withCleared_binMED);
in.fast_errors_made_dead_withCleared_RF_binSLOW = intersect(inRF,fast_errors_made_dead_withCleared_binSLOW);
out.fast_errors_made_dead_withCleared_RF_binSLOW = intersect(outRF,fast_errors_made_dead_withCleared_binSLOW);

in.slow_correct_missed_dead_RF_binFAST = intersect(inRF,slow_correct_missed_dead_binFAST);
out.slow_correct_missed_dead_RF_binFAST = intersect(outRF,slow_correct_missed_dead_binFAST);
in.slow_correct_missed_dead_RF_binMED = intersect(inRF,slow_correct_missed_dead_binMED);
out.slow_correct_missed_dead_RF_binMED = intersect(outRF,slow_correct_missed_dead_binMED);
in.slow_correct_missed_dead_RF_binSLOW = intersect(inRF,slow_correct_missed_dead_binSLOW);
out.slow_correct_missed_dead_RF_binSLOW = intersect(outRF,slow_correct_missed_dead_binSLOW);
 
in.med_correct_RF_binFAST = intersect(inRF,med_correct_binFAST);
out.med_correct_RF_binFAST = intersect(outRF,med_correct_binFAST);
in.med_correct_RF_binMED = intersect(inRF,med_correct_binMED);
out.med_correct_RF_binMED = intersect(outRF,med_correct_binMED);
in.med_correct_RF_binSLOW = intersect(inRF,med_correct_binSLOW);
out.med_correct_RF_binSLOW = intersect(outRF,med_correct_binSLOW);
 
in.fast_correct_missed_dead_withCleared_RF_binFAST = intersect(inRF,fast_correct_missed_dead_withCleared_binFAST);
out.fast_correct_missed_dead_withCleared_RF_binFAST = intersect(outRF,fast_correct_missed_dead_withCleared_binFAST);
in.fast_correct_missed_dead_withCleared_RF_binMED = intersect(inRF,fast_correct_missed_dead_withCleared_binMED);
out.fast_correct_missed_dead_withCleared_RF_binMED = intersect(outRF,fast_correct_missed_dead_withCleared_binMED);
in.fast_correct_missed_dead_withCleared_RF_binSLOW = intersect(inRF,fast_correct_missed_dead_withCleared_binSLOW);
out.fast_correct_missed_dead_withCleared_RF_binSLOW = intersect(outRF,fast_correct_missed_dead_withCleared_binSLOW);
 
 
in.slow_errors_missed_dead_RF_binFAST = intersect(inRF,slow_errors_missed_dead_binFAST);
out.slow_errors_missed_dead_RF_binFAST = intersect(outRF,slow_errors_missed_dead_binFAST);
in.slow_errors_missed_dead_RF_binMED = intersect(inRF,slow_errors_missed_dead_binMED);
out.slow_errors_missed_dead_RF_binMED = intersect(outRF,slow_errors_missed_dead_binMED);
in.slow_errors_missed_dead_RF_binSLOW = intersect(inRF,slow_errors_missed_dead_binSLOW);
out.slow_errors_missed_dead_RF_binSLOW = intersect(outRF,slow_errors_missed_dead_binSLOW);
 
in.med_errors_RF_binFAST = intersect(inRF,med_errors_binFAST);
out.med_errors_RF_binFAST = intersect(outRF,med_errors_binFAST);
in.med_errors_RF_binMED = intersect(inRF,med_errors_binMED);
out.med_errors_RF_binMED = intersect(outRF,med_errors_binMED);
in.med_errors_RF_binSLOW = intersect(inRF,med_errors_binSLOW);
out.med_errors_RF_binSLOW = intersect(outRF,med_errors_binSLOW);
 
in.fast_errors_missed_dead_withCleared_RF_binFAST = intersect(inRF,fast_errors_missed_dead_withCleared_binFAST);
out.fast_errors_missed_dead_withCleared_RF_binFAST = intersect(outRF,fast_errors_missed_dead_withCleared_binFAST);
in.fast_errors_missed_dead_withCleared_RF_binMED = intersect(inRF,fast_errors_missed_dead_withCleared_binMED);
out.fast_errors_missed_dead_withCleared_RF_binMED = intersect(outRF,fast_errors_missed_dead_withCleared_binMED);
in.fast_errors_missed_dead_withCleared_RF_binSLOW = intersect(inRF,fast_errors_missed_dead_withCleared_binSLOW);
out.fast_errors_missed_dead_withCleared_RF_binSLOW = intersect(outRF,fast_errors_missed_dead_withCleared_binSLOW);


%=============================



%missed dead only
in.slow_correct_missed_dead_RF = intersect(inRF,slow_correct_missed_dead);
out.slow_correct_missed_dead_RF = intersect(outRF,slow_correct_missed_dead);

in.fast_correct_missed_dead_withCleared_RF = intersect(inRF,fast_correct_missed_dead_withCleared);
out.fast_correct_missed_dead_withCleared_RF = intersect(outRF,fast_correct_missed_dead_withCleared);

in.fast_correct_missed_dead_noCleared_RF = intersect(inRF,fast_correct_missed_dead_noCleared);
out.fast_correct_missed_dead_noCleared_RF = intersect(outRF,fast_correct_missed_dead_noCleared);

if calcTDT
    if isAD
        TDT.slow_correct_missed_dead = getTDT_AD(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
        TDT.fast_correct_missed_dead_withCleared = getTDT_AD(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
    else
        TDT.slow_correct_missed_dead = getTDT_SP(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
        TDT.fast_correct_missed_dead_withCleared = getTDT_SP(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
    end
else
    TDT.slow_correct_missed_dead = NaN;
    TDT.fast_correct_missed_dead = NaN;
end


%==================================
% target-in - distractor in Integrals (half-baked integrator)
integral.slow_correct_made_dead_RF = cumsum(nanmean(SDF(in.slow_correct_made_dead_RF,:)) - nanmean(SDF(out.slow_correct_made_dead_RF,:)));
integral.med_correct_RF = cumsum(nanmean(SDF(in.med_correct_RF,:)) - nanmean(SDF(out.med_correct_RF,:)));
integral.fast_correct_made_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)));

integral.slow_correct_missed_dead_RF = cumsum(nanmean(SDF(in.slow_correct_missed_dead_RF,:)) - nanmean(SDF(out.slow_correct_missed_dead_RF,:)));
integral.med_correct_RF = cumsum(nanmean(SDF(in.med_correct_RF,:)) - nanmean(SDF(out.med_correct_RF,:)));
integral.fast_correct_missed_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_correct_missed_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_correct_missed_dead_withCleared_RF,:)));


%==============
% ERRORS
%made dead only
in.slow_errors_made_dead_RF = intersect(inRF_err,slow_errors_made_dead);
out.slow_errors_made_dead_RF = intersect(outRF_err,slow_errors_made_dead);

in.fast_errors_made_dead_withCleared_RF = intersect(inRF_err,fast_errors_made_dead_withCleared);
out.fast_errors_made_dead_withCleared_RF = intersect(outRF_err,fast_errors_made_dead_withCleared);

in.fast_errors_made_dead_noCleared_RF = intersect(inRF_err,fast_errors_made_dead_noCleared);
out.fast_errors_made_dead_noCleared_RF = intersect(outRF_err,fast_errors_made_dead_noCleared);

in.med_errors_RF = intersect(inRF_err,med_errors);
out.med_errors_RF = intersect(outRF_err,med_errors);

if calcTDT
    if isAD
        TDT.slow_errors_made_dead = getTDT_AD(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
        TDT.med_errors = getTDT_AD(sig,in.med_errors_RF,out.med_errors_RF);
        TDT.fast_errors_made_dead_withCleared = getTDT_AD(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
    else
        TDT.slow_errors_made_dead = getTDT_SP(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
        TDT.med_errors = getTDT_SP(sig,in.med_errors_RF,out.med_errors_RF);
        TDT.fast_errors_made_dead_withCleared = getTDT_SP(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
    end
else
    TDT.slow_errors_made_dead = NaN;
    TDT.med_errors = NaN;
    TDT.fast_errors_made_dead_withCleared = NaN;
end


%missed dead only
in.slow_errors_missed_dead_RF = intersect(inRF_err,slow_errors_missed_dead);
out.slow_errors_missed_dead_RF = intersect(outRF_err,slow_errors_missed_dead);

in.fast_errors_missed_dead_withCleared_RF = intersect(inRF_err,fast_errors_missed_dead_withCleared);
out.fast_errors_missed_dead_withCleared_RF = intersect(outRF_err,fast_errors_missed_dead_withCleared);

in.fast_errors_missed_dead_noCleared_RF = intersect(inRF_err,fast_errors_missed_dead_noCleared);
out.fast_errors_missed_dead_noCleared_RF = intersect(outRF_err,fast_errors_missed_dead_noCleared);

if calcTDT
    if isAD
        TDT.slow_errors_missed_dead = getTDT_AD(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
        TDT.fast_errors_missed_dead_withCleared = getTDT_AD(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
    else
        TDT.slow_errors_missed_dead = getTDT_SP(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
        TDT.fast_errors_missed_dead_withCleared = getTDT_SP(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
    end
else
    TDT.slow_errors_missed_dead = NaN;
    TDT.fast_errors_missed_dead_withCleared = NaN;
end


%==================================
% target-in - distractor in Integrals (half-baked integrator)
integral.slow_errors_made_dead_RF = cumsum(nanmean(SDF(in.slow_errors_made_dead_RF,:)) - nanmean(SDF(out.slow_errors_made_dead_RF,:)));
integral.med_errors_RF = cumsum(nanmean(SDF(in.med_errors_RF,:)) - nanmean(SDF(out.med_errors_RF,:)));
integral.fast_errors_made_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:)));

integral.slow_errors_missed_dead_RF = cumsum(nanmean(SDF(in.slow_errors_missed_dead_RF,:)) - nanmean(SDF(out.slow_errors_missed_dead_RF,:)));
integral.med_errors_RF = cumsum(nanmean(SDF(in.med_errors_RF,:)) - nanmean(SDF(out.med_errors_RF,:)));
integral.fast_errors_missed_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_errors_missed_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_errors_missed_dead_withCleared_RF,:)));


%=====================
% Movement-aligned MF
%==============
% CORRECT
%made dead only
in.slow_correct_made_dead_MF = intersect(inMF,slow_correct_made_dead);
out.slow_correct_made_dead_MF = intersect(outMF,slow_correct_made_dead);

in.fast_correct_made_dead_withCleared_MF = intersect(inMF,fast_correct_made_dead_withCleared);
out.fast_correct_made_dead_withCleared_MF = intersect(outMF,fast_correct_made_dead_withCleared);

in.fast_correct_made_dead_noCleared_MF = intersect(inMF,fast_correct_made_dead_noCleared);
out.fast_correct_made_dead_noCleared_MF = intersect(outMF,fast_correct_made_dead_noCleared);

in.med_correct_MF = intersect(inMF,med_correct);
out.med_correct_MF = intersect(outMF,med_correct);

%==============================
% WITHIN CONDITION RT BIN SPLIT
in.slow_correct_made_dead_MF_binFAST = intersect(inMF,slow_correct_made_dead_binFAST);
out.slow_correct_made_dead_MF_binFAST = intersect(outMF,slow_correct_made_dead_binFAST);
in.slow_correct_made_dead_MF_binMED = intersect(inMF,slow_correct_made_dead_binMED);
out.slow_correct_made_dead_MF_binMED = intersect(outMF,slow_correct_made_dead_binMED);
in.slow_correct_made_dead_MF_binSLOW = intersect(inMF,slow_correct_made_dead_binSLOW);
out.slow_correct_made_dead_MF_binSLOW = intersect(outMF,slow_correct_made_dead_binSLOW);

in.med_correct_MF_binFAST = intersect(inMF,med_correct_binFAST);
out.med_correct_MF_binFAST = intersect(outMF,med_correct_binFAST);
in.med_correct_MF_binMED = intersect(inMF,med_correct_binMED);
out.med_correct_MF_binMED = intersect(outMF,med_correct_binMED);
in.med_correct_MF_binSLOW = intersect(inMF,med_correct_binSLOW);
out.med_correct_MF_binSLOW = intersect(outMF,med_correct_binSLOW);

in.fast_correct_made_dead_withCleared_MF_binFAST = intersect(inMF,fast_correct_made_dead_withCleared_binFAST);
out.fast_correct_made_dead_withCleared_MF_binFAST = intersect(outMF,fast_correct_made_dead_withCleared_binFAST);
in.fast_correct_made_dead_withCleared_MF_binMED = intersect(inMF,fast_correct_made_dead_withCleared_binMED);
out.fast_correct_made_dead_withCleared_MF_binMED = intersect(outMF,fast_correct_made_dead_withCleared_binMED);
in.fast_correct_made_dead_withCleared_MF_binSLOW = intersect(inMF,fast_correct_made_dead_withCleared_binSLOW);
out.fast_correct_made_dead_withCleared_MF_binSLOW = intersect(outMF,fast_correct_made_dead_withCleared_binSLOW);

in.slow_errors_made_dead_MF_binFAST = intersect(inMF,slow_errors_made_dead_binFAST);
out.slow_errors_made_dead_MF_binFAST = intersect(outMF,slow_errors_made_dead_binFAST);
in.slow_errors_made_dead_MF_binMED = intersect(inMF,slow_errors_made_dead_binMED);
out.slow_errors_made_dead_MF_binMED = intersect(outMF,slow_errors_made_dead_binMED);
in.slow_errors_made_dead_MF_binSLOW = intersect(inMF,slow_errors_made_dead_binSLOW);
out.slow_errors_made_dead_MF_binSLOW = intersect(outMF,slow_errors_made_dead_binSLOW);
 
in.med_errors_MF_binFAST = intersect(inMF,med_errors_binFAST);
out.med_errors_MF_binFAST = intersect(outMF,med_errors_binFAST);
in.med_errors_MF_binMED = intersect(inMF,med_errors_binMED);
out.med_errors_MF_binMED = intersect(outMF,med_errors_binMED);
in.med_errors_MF_binSLOW = intersect(inMF,med_errors_binSLOW);
out.med_errors_MF_binSLOW = intersect(outMF,med_errors_binSLOW);
 
in.fast_errors_made_dead_withCleared_MF_binFAST = intersect(inMF,fast_errors_made_dead_withCleared_binFAST);
out.fast_errors_made_dead_withCleared_MF_binFAST = intersect(outMF,fast_errors_made_dead_withCleared_binFAST);
in.fast_errors_made_dead_withCleared_MF_binMED = intersect(inMF,fast_errors_made_dead_withCleared_binMED);
out.fast_errors_made_dead_withCleared_MF_binMED = intersect(outMF,fast_errors_made_dead_withCleared_binMED);
in.fast_errors_made_dead_withCleared_MF_binSLOW = intersect(inMF,fast_errors_made_dead_withCleared_binSLOW);
out.fast_errors_made_dead_withCleared_MF_binSLOW = intersect(outMF,fast_errors_made_dead_withCleared_binSLOW);


in.slow_correct_missed_dead_MF_binFAST = intersect(inMF,slow_correct_missed_dead_binFAST);
out.slow_correct_missed_dead_MF_binFAST = intersect(outMF,slow_correct_missed_dead_binFAST);
in.slow_correct_missed_dead_MF_binMED = intersect(inMF,slow_correct_missed_dead_binMED);
out.slow_correct_missed_dead_MF_binMED = intersect(outMF,slow_correct_missed_dead_binMED);
in.slow_correct_missed_dead_MF_binSLOW = intersect(inMF,slow_correct_missed_dead_binSLOW);
out.slow_correct_missed_dead_MF_binSLOW = intersect(outMF,slow_correct_missed_dead_binSLOW);
 
in.med_correct_MF_binFAST = intersect(inMF,med_correct_binFAST);
out.med_correct_MF_binFAST = intersect(outMF,med_correct_binFAST);
in.med_correct_MF_binMED = intersect(inMF,med_correct_binMED);
out.med_correct_MF_binMED = intersect(outMF,med_correct_binMED);
in.med_correct_MF_binSLOW = intersect(inMF,med_correct_binSLOW);
out.med_correct_MF_binSLOW = intersect(outMF,med_correct_binSLOW);
 
in.fast_correct_missed_dead_withCleared_MF_binFAST = intersect(inMF,fast_correct_missed_dead_withCleared_binFAST);
out.fast_correct_missed_dead_withCleared_MF_binFAST = intersect(outMF,fast_correct_missed_dead_withCleared_binFAST);
in.fast_correct_missed_dead_withCleared_MF_binMED = intersect(inMF,fast_correct_missed_dead_withCleared_binMED);
out.fast_correct_missed_dead_withCleared_MF_binMED = intersect(outMF,fast_correct_missed_dead_withCleared_binMED);
in.fast_correct_missed_dead_withCleared_MF_binSLOW = intersect(inMF,fast_correct_missed_dead_withCleared_binSLOW);
out.fast_correct_missed_dead_withCleared_MF_binSLOW = intersect(outMF,fast_correct_missed_dead_withCleared_binSLOW);
 
in.slow_errors_missed_dead_MF_binFAST = intersect(inMF,slow_errors_missed_dead_binFAST);
out.slow_errors_missed_dead_MF_binFAST = intersect(outMF,slow_errors_missed_dead_binFAST);
in.slow_errors_missed_dead_MF_binMED = intersect(inMF,slow_errors_missed_dead_binMED);
out.slow_errors_missed_dead_MF_binMED = intersect(outMF,slow_errors_missed_dead_binMED);
in.slow_errors_missed_dead_MF_binSLOW = intersect(inMF,slow_errors_missed_dead_binSLOW);
out.slow_errors_missed_dead_MF_binSLOW = intersect(outMF,slow_errors_missed_dead_binSLOW);
 
in.med_errors_MF_binFAST = intersect(inMF,med_errors_binFAST);
out.med_errors_MF_binFAST = intersect(outMF,med_errors_binFAST);
in.med_errors_MF_binMED = intersect(inMF,med_errors_binMED);
out.med_errors_MF_binMED = intersect(outMF,med_errors_binMED);
in.med_errors_MF_binSLOW = intersect(inMF,med_errors_binSLOW);
out.med_errors_MF_binSLOW = intersect(outMF,med_errors_binSLOW);
 
in.fast_errors_missed_dead_withCleared_MF_binFAST = intersect(inMF,fast_errors_missed_dead_withCleared_binFAST);
out.fast_errors_missed_dead_withCleared_MF_binFAST = intersect(outMF,fast_errors_missed_dead_withCleared_binFAST);
in.fast_errors_missed_dead_withCleared_MF_binMED = intersect(inMF,fast_errors_missed_dead_withCleared_binMED);
out.fast_errors_missed_dead_withCleared_MF_binMED = intersect(outMF,fast_errors_missed_dead_withCleared_binMED);
in.fast_errors_missed_dead_withCleared_MF_binSLOW = intersect(inMF,fast_errors_missed_dead_withCleared_binSLOW);
out.fast_errors_missed_dead_withCleared_MF_binSLOW = intersect(outMF,fast_errors_missed_dead_withCleared_binSLOW);


%=============================


%SPIKE STATS
%NOTE: getThresh function automatically computed Target_in_RF/MF
% [thresh.slow_correct_made_dead baseline.slow_correct_made_dead ...
%     onset.slow_correct_made_dead rate.slow_correct_made_dead,labels.slow_correct_made_dead] = ...
%     getThresh(sig,RF,MF,slow_correct_made_dead,3,0);
% 
% [thresh.med_correct baseline.med_correct onset.med_correct rate.med_correct,labels.med_correct] = ...
%     getThresh(sig,RF,MF,med_correct,3,0);
% 
% [thresh.fast_correct_made_dead_withCleared baseline.fast_correct_made_dead_withCleared ...
%     onset.fast_correct_made_dead_withCleared rate.fast_correct_made_dead_withCleared,labels.fast_correct_made_dead_withCleared] = ...
%     getThresh(sig,RF,MF,fast_correct_made_dead_withCleared,3,0);
% 
% [thresh.slow_correct_missed_dead baseline.slow_correct_missed_dead ...
%     onset.slow_correct_missed_dead rate.slow_correct_missed_dead,labels.slow_correct_missed_dead] = ...
%     getThresh(sig,RF,MF,slow_correct_missed_dead,3,0);
% 
% [thresh.fast_correct_missed_dead_withCleared baseline.fast_correct_missed_dead_withCleared ...
%     onset.fast_correct_missed_dead_withCleared rate.fast_correct_missed_dead_withCleared,labels.fast_correct_missed_dead_withCleared] = ...
%     getThresh(sig,RF,MF,fast_correct_missed_dead_withCleared,3,0);
% 

%missed dead only
in.slow_correct_missed_dead_MF = intersect(inMF,slow_correct_missed_dead);
out.slow_correct_missed_dead_MF = intersect(outMF,slow_correct_missed_dead);

in.fast_correct_missed_dead_withCleared_MF = intersect(inMF,fast_correct_missed_dead_withCleared);
out.fast_correct_missed_dead_withCleared_MF = intersect(outMF,fast_correct_missed_dead_withCleared);

in.fast_correct_missed_dead_noCleared_MF = intersect(inMF,fast_correct_missed_dead_noCleared);
out.fast_correct_missed_dead_noCleared_MF = intersect(outMF,fast_correct_missed_dead_noCleared);




%==============
% ERRORS
%made dead only
in.slow_errors_made_dead_MF = intersect(inMF_err,slow_errors_made_dead);
out.slow_errors_made_dead_MF = intersect(outMF_err,slow_errors_made_dead);

in.fast_errors_made_dead_withCleared_MF = intersect(inMF_err,fast_errors_made_dead_withCleared);
out.fast_errors_made_dead_withCleared_MF = intersect(outMF_err,fast_errors_made_dead_withCleared);

in.fast_errors_made_dead_noCleared_MF = intersect(inMF_err,fast_errors_made_dead_noCleared);
out.fast_errors_made_dead_noCleared_MF = intersect(outMF_err,fast_errors_made_dead_noCleared);

%missed dead only
in.slow_errors_missed_dead_MF = intersect(inMF_err,slow_errors_missed_dead);
out.slow_errors_missed_dead_MF = intersect(outMF_err,slow_errors_missed_dead);

in.fast_errors_missed_dead_withCleared_MF = intersect(inMF_err,fast_errors_missed_dead_withCleared);
out.fast_errors_missed_dead_withCleared_MF = intersect(outMF_err,fast_errors_missed_dead_withCleared);

in.fast_errors_missed_dead_noCleared_MF = intersect(inMF_err,fast_errors_missed_dead_noCleared);
out.fast_errors_missed_dead_noCleared_MF = intersect(outMF_err,fast_errors_missed_dead_noCleared);

in.med_errors_MF = intersect(inMF_err,med_errors);
out.med_errors_MF = intersect(outMF_err,med_errors);


% %Spike Stats
% [thresh.slow_errors_made_dead baseline.slow_errors_made_dead ...
%     onset.slow_errors_made_dead rate.slow_errors_made_dead,labels.slow_errors_made_dead] = ...
%     getThresh(sig,RF,MF,slow_errors_made_dead,3,0);
% 
% [thresh.med_errors baseline.med_errors onset.med_errors rate.med_errors,labels.med_errors] = ...
%     getThresh(sig,RF,MF,med_errors,3,0);
% 
% [thresh.fast_errors_made_dead_withCleared baseline.fast_errors_made_dead_withCleared ...
%     onset.fast_errors_made_dead_withCleared rate.fast_errors_made_dead_withCleared,labels.fast_errors_made_dead_withCleared] = ...
%     getThresh(sig,RF,MF,fast_errors_made_dead_withCleared,3,0);
% 
% [thresh.slow_errors_missed_dead baseline.slow_errors_missed_dead ...
%     onset.slow_errors_missed_dead rate.slow_errors_missed_dead,labels.slow_errors_missed_dead] = ...
%     getThresh(sig,RF,MF,slow_errors_missed_dead,3,0);
% 
% [thresh.fast_errors_missed_dead_withCleared baseline.fast_errors_missed_dead_withCleared ...
%     onset.fast_errors_missed_dead_withCleared rate.fast_errors_missed_dead_withCleared,labels.fast_errors_missed_dead_withCleared] = ...
%     getThresh(sig,RF,MF,fast_errors_missed_dead_withCleared,3,0);



% Return trial numbers for neuron if user requests it
trials.in = in;
trials.out = out;
%%
%=========================================================
%  P L O T T I N G
%=========================================================

%CORRECT MADE DEADLINES
figure
fon

subplot(1,2,1)
plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r', ...
    Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF,:)),'--r', ...
    Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
    Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
    Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g', ...
    Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)),'--g')

xlim([-400 900])
box off
t_ylim = get(gca,'ylim');
title('CORRECT MADE DEADLINES')

if isAD; axis ij; end

vline(TDT.slow_correct_made_dead,'r')
vline(TDT.med_correct,'k')
vline(TDT.fast_correct_made_dead_withCleared,'g')

subplot(1,2,2)
plot(Plot_Time_Resp,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r', ...
    Plot_Time_Resp,nanmean(SDF_r(out.slow_correct_made_dead_MF,:)),'--r', ...
    Plot_Time_Resp,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
    Plot_Time_Resp,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
    Plot_Time_Resp,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g', ...
    Plot_Time_Resp,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF,:)),'--g')
set(gca,'yaxislocation','right')
xlim([-800 100])
vline(0,'k')
box off
if isAD; axis ij; end

% 
% subplot(4,4,3)
% plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binFAST,:)),':r', ...
%     -400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binMED,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binSLOW,:)),'r', ...
%     -400:200,nanmean(SDF_r(in.med_correct_MF_binFAST,:)),':k', ...
%     -400:200,nanmean(SDF_r(in.med_correct_MF_binMED,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.med_correct_MF_binSLOW,:)),'k', ...
%     -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binFAST,:)),':g', ...
%     -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binMED,:)),'--g', ...
%     -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binSLOW,:)),'g')
% xlim([-400 20])
% vline(0,'k')
% if isAD; axis ij; end
% 
% vline(onset.slow_correct_made_dead(1),':r')
% vline(onset.slow_correct_made_dead(2),'--r')
% vline(onset.slow_correct_made_dead(3),'r')
% vline(onset.med_correct(1),':k')
% vline(onset.med_correct(2),'--k')
% vline(onset.med_correct(3),'k')
% vline(onset.fast_correct_made_dead_withCleared(1),':g')
% vline(onset.fast_correct_made_dead_withCleared(2),'--g')
% vline(onset.fast_correct_made_dead_withCleared(3),'g')
% 
% 
% subplot(4,4,4)
% 
% plot(Plot_Time,integral.slow_correct_made_dead_RF,'r', ...
%     Plot_Time,integral.med_correct_RF,'k', ...
%     Plot_Time,integral.fast_correct_made_dead_withCleared_RF,'g', ...
%     Plot_Time,integral.slow_errors_made_dead_RF,'--r', ...
%     Plot_Time,integral.med_errors_RF,'--k', ...
%     Plot_Time,integral.fast_errors_made_dead_withCleared_RF,'--g','linewidth',2)
% 
% xlim([Plot_Time(1) Plot_Time(end)])
% 
% v = vline(nanmean(SRT(slow_correct_made_dead,1)),'r');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(med_correct,1)),'k');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(fast_correct_made_dead_withCleared,1)),'g');
% set(v,'linewidth',2)
% 
% title('Integral')
% 
% 
% subplot(4,4,5)
% plot(labels.slow_correct_made_dead,baseline.slow_correct_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,baseline.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_made_dead_withCleared,baseline.fast_correct_made_dead_withCleared,'og','markerfacecolor','g')
% 
% %t_ylim(2) = t_ylim(2) / 2;
% ylim(t_ylim) %set to same as target-aligned plot
% title('Baseline')
% 
% subplot(4,4,6)
% plot(labels.slow_correct_made_dead,onset.slow_correct_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_made_dead_withCleared,onset.fast_correct_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Onset')
% 
% subplot(4,4,7)
% plot(labels.slow_correct_made_dead,rate.slow_correct_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,rate.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_made_dead_withCleared,rate.fast_correct_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Rate')
% 
% subplot(4,4,8)
% plot(labels.slow_correct_made_dead,thresh.slow_correct_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,thresh.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_made_dead_withCleared,thresh.fast_correct_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Threshold')
% 
% 
% 
% %CORRECT MADE DEADLINES
% subplot(4,4,9)
% plot(Plot_Time,nanmean(SDF(in.slow_correct_missed_dead_RF,:)),'r', ...
%     Plot_Time,nanmean(SDF(out.slow_correct_missed_dead_RF,:)),'--r', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
%     Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_missed_dead_withCleared_RF,:)),'g', ...
%     Plot_Time,nanmean(SDF(out.fast_correct_missed_dead_withCleared_RF,:)),'--g')
% 
% xlim([-100 900])
% t_ylim = get(gca,'ylim');
% title('CORRECT MISSED DEADLINES')
% 
% if isAD; axis ij; end
% 
% vline(TDT.slow_correct_missed_dead,'r')
% vline(TDT.med_correct,'k')
% vline(TDT.fast_correct_missed_dead_withCleared,'g')
% 
% subplot(4,4,10)
% plot(-400:200,nanmean(SDF_r(in.slow_correct_missed_dead_MF,:)),'r', ...
%     -400:200,nanmean(SDF_r(out.slow_correct_missed_dead_MF,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
%     -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.fast_correct_missed_dead_withCleared_MF,:)),'g', ...
%     -400:200,nanmean(SDF_r(out.fast_correct_missed_dead_withCleared_MF,:)),'--g')
% 
% xlim([-400 200])
% vline(0,'k')
% if isAD; axis ij; end
% 
% 
% subplot(4,4,11)
% plot(-400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binFAST,:)),':r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binMED,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binSLOW,:)),'r', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binFAST,:)),':k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binMED,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binSLOW,:)),'k', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binFAST,:)),':g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binMED,:)),'--g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binSLOW,:)),'g')
% xlim([-400 20])
% vline(0,'k')
% if isAD; axis ij; end
% 
% vline(onset.slow_errors_missed_dead(1),':r')
% vline(onset.slow_errors_missed_dead(2),'--r')
% vline(onset.slow_errors_missed_dead(3),'r')
% vline(onset.med_errors(1),':k')
% vline(onset.med_errors(2),'--k')
% vline(onset.med_errors(3),'k')
% vline(onset.fast_errors_missed_dead_withCleared(1),':g')
% vline(onset.fast_errors_missed_dead_withCleared(2),'--g')
% vline(onset.fast_errors_missed_dead_withCleared(3),'g')
% 
% 
% 
% 
% subplot(4,4,12)
% 
% plot(Plot_Time,integral.slow_correct_missed_dead_RF,'r', ...
%     Plot_Time,integral.med_correct_RF,'k', ...
%     Plot_Time,integral.fast_correct_missed_dead_withCleared_RF,'g', ...
%     Plot_Time,integral.slow_errors_missed_dead_RF,'--r', ...
%     Plot_Time,integral.med_errors_RF,'--k', ...
%     Plot_Time,integral.fast_errors_missed_dead_withCleared_RF,'--g','linewidth',2)
% 
% xlim([Plot_Time(1) Plot_Time(end)])
% 
% v = vline(nanmean(SRT(slow_correct_missed_dead,1)),'r');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(med_correct,1)),'k');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(fast_correct_missed_dead_withCleared,1)),'g');
% set(v,'linewidth',2)
% 
% title('Integral')
% 
% 
% subplot(4,4,13)
% plot(labels.slow_correct_missed_dead,baseline.slow_correct_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,baseline.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_missed_dead_withCleared,baseline.fast_correct_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% %t_ylim(2) = t_ylim(2) / 2;
% ylim(t_ylim) %set to same as target-aligned plot
% title('Baseline')
% 
% subplot(4,4,14)
% plot(labels.slow_correct_missed_dead,onset.slow_correct_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_missed_dead_withCleared,onset.fast_correct_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Onset')
% 
% subplot(4,4,15)
% plot(labels.slow_correct_missed_dead,rate.slow_correct_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,rate.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_missed_dead_withCleared,rate.fast_correct_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Rate')
% 
% subplot(4,4,16)
% plot(labels.slow_correct_missed_dead,thresh.slow_correct_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_correct,thresh.med_correct,'ok','markerfacecolor','k')
% plot(labels.fast_correct_missed_dead_withCleared,thresh.fast_correct_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Threshold')
% 
% 
% %ERRORS MADE DEADLINES
% figure
% fon
% 
% subplot(4,4,1)
% plot(Plot_Time,nanmean(SDF(in.slow_errors_made_dead_RF,:)),'r', ...
%     Plot_Time,nanmean(SDF(out.slow_errors_made_dead_RF,:)),'--r', ...
%     Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
%     Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
%     Plot_Time,nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:)),'g', ...
%     Plot_Time,nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:)),'--g')
% 
% xlim([-100 900])
% t_ylim = get(gca,'ylim');
% title('ERRORS MADE DEADLINES')
% 
% if isAD; axis ij; end
% 
% vline(TDT.slow_errors_made_dead,'r')
% vline(TDT.med_errors,'k')
% vline(TDT.fast_errors_made_dead_withCleared,'g')
% 
% subplot(4,4,2)
% plot(-400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF,:)),'r', ...
%     -400:200,nanmean(SDF_r(out.slow_errors_made_dead_MF,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
%     -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF,:)),'g', ...
%     -400:200,nanmean(SDF_r(out.fast_errors_made_dead_withCleared_MF,:)),'--g')
% 
% xlim([-400 200])
% vline(0,'k')
% if isAD; axis ij; end
% 
% 
% subplot(4,4,3)
% plot(-400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF_binFAST,:)),':r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF_binMED,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF_binSLOW,:)),'r', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binFAST,:)),':k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binMED,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binSLOW,:)),'k', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF_binFAST,:)),':g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF_binMED,:)),'--g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF_binSLOW,:)),'g')
% xlim([-400 20])
% vline(0,'k')
% if isAD; axis ij; end
% 
% vline(onset.slow_errors_made_dead(1),':r')
% vline(onset.slow_errors_made_dead(2),'--r')
% vline(onset.slow_errors_made_dead(3),'r')
% vline(onset.med_errors(1),':k')
% vline(onset.med_errors(2),'--k')
% vline(onset.med_errors(3),'k')
% vline(onset.fast_errors_made_dead_withCleared(1),':g')
% vline(onset.fast_errors_made_dead_withCleared(2),'--g')
% vline(onset.fast_errors_made_dead_withCleared(3),'g')
% 
% 
% 
% 
% subplot(4,4,4)
% 
% plot(Plot_Time,integral.slow_correct_made_dead_RF,'r', ...
%     Plot_Time,integral.med_correct_RF,'k', ...
%     Plot_Time,integral.fast_correct_made_dead_withCleared_RF,'g', ...
%     Plot_Time,integral.slow_errors_made_dead_RF,'--r', ...
%     Plot_Time,integral.med_errors_RF,'--k', ...
%     Plot_Time,integral.fast_errors_made_dead_withCleared_RF,'--g','linewidth',2)
% 
% xlim([Plot_Time(1) Plot_Time(end)])
% 
% v = vline(nanmean(SRT(slow_errors_made_dead,1)),'r');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(med_errors,1)),'k');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(fast_errors_made_dead_withCleared,1)),'g');
% set(v,'linewidth',2)
% 
% title('Integral')
% 
% 
% subplot(4,4,5)
% plot(labels.slow_errors_made_dead,baseline.slow_errors_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,baseline.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_made_dead_withCleared,baseline.fast_errors_made_dead_withCleared,'og','markerfacecolor','g')
% 
% %t_ylim(2) = t_ylim(2) / 3;
% ylim(t_ylim) %set to same as target-aligned plot
% title('Baseline')
% 
% subplot(4,4,6)
% plot(labels.slow_errors_made_dead,onset.slow_errors_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_made_dead_withCleared,onset.fast_errors_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Onset')
% 
% subplot(4,4,7)
% plot(labels.slow_errors_made_dead,rate.slow_errors_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,rate.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_made_dead_withCleared,rate.fast_errors_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Rate')
% 
% subplot(4,4,8)
% plot(labels.slow_errors_made_dead,thresh.slow_errors_made_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,thresh.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_made_dead_withCleared,thresh.fast_errors_made_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Threshold')
% 
% 
% 
% %ERRORS MADE DEADLINES
% subplot(4,4,9)
% plot(Plot_Time,nanmean(SDF(in.slow_errors_missed_dead_RF,:)),'r', ...
%     Plot_Time,nanmean(SDF(out.slow_errors_missed_dead_RF,:)),'--r', ...
%     Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
%     Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
%     Plot_Time,nanmean(SDF(in.fast_errors_missed_dead_withCleared_RF,:)),'g', ...
%     Plot_Time,nanmean(SDF(out.fast_errors_missed_dead_withCleared_RF,:)),'--g')
% 
% xlim([-100 900])
% t_ylim = get(gca,'ylim');
% title('ERRORS MISSED DEADLINES')
% 
% if isAD; axis ij; end
% 
% vline(TDT.slow_errors_missed_dead,'r')
% vline(TDT.med_errors,'k')
% vline(TDT.fast_errors_missed_dead_withCleared,'g')
% 
% subplot(4,4,10)
% plot(-400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF,:)),'r', ...
%     -400:200,nanmean(SDF_r(out.slow_errors_missed_dead_MF,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
%     -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF,:)),'g', ...
%     -400:200,nanmean(SDF_r(out.fast_errors_missed_dead_withCleared_MF,:)),'--g')
% 
% xlim([-400 200])
% vline(0,'k')
% if isAD; axis ij; end
% 
% 
% subplot(4,4,11)
% plot(-400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binFAST,:)),':r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binMED,:)),'--r', ...
%     -400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF_binSLOW,:)),'r', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binFAST,:)),':k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binMED,:)),'--k', ...
%     -400:200,nanmean(SDF_r(in.med_errors_MF_binSLOW,:)),'k', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binFAST,:)),':g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binMED,:)),'--g', ...
%     -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF_binSLOW,:)),'g')
% xlim([-400 20])
% vline(0,'k')
% if isAD; axis ij; end
% 
% vline(onset.slow_errors_missed_dead(1),':r')
% vline(onset.slow_errors_missed_dead(2),'--r')
% vline(onset.slow_errors_missed_dead(3),'r')
% vline(onset.med_errors(1),':k')
% vline(onset.med_errors(2),'--k')
% vline(onset.med_errors(3),'k')
% vline(onset.fast_errors_missed_dead_withCleared(1),':g')
% vline(onset.fast_errors_missed_dead_withCleared(2),'--g')
% vline(onset.fast_errors_missed_dead_withCleared(3),'g')
% 
% 
% 
% 
% subplot(4,4,12)
% 
% plot(Plot_Time,integral.slow_correct_missed_dead_RF,'r', ...
%     Plot_Time,integral.med_correct_RF,'k', ...
%     Plot_Time,integral.fast_correct_missed_dead_withCleared_RF,'g', ...
%     Plot_Time,integral.slow_errors_missed_dead_RF,'--r', ...
%     Plot_Time,integral.med_errors_RF,'--k', ...
%     Plot_Time,integral.fast_errors_missed_dead_withCleared_RF,'--g','linewidth',2)
% 
% xlim([Plot_Time(1) Plot_Time(end)])
% 
% v = vline(nanmean(SRT(slow_errors_missed_dead,1)),'r');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(med_errors,1)),'k');
% set(v,'linewidth',2)
% 
% v = vline(nanmean(SRT(fast_errors_missed_dead_withCleared,1)),'g');
% set(v,'linewidth',2)
% 
% title('Integral')
% 
% 
% subplot(4,4,13)
% plot(labels.slow_errors_missed_dead,baseline.slow_errors_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,baseline.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_missed_dead_withCleared,baseline.fast_errors_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% %t_ylim(2) = t_ylim(2) / 2;
% ylim(t_ylim) %set to same as target-aligned plot
% title('Baseline')
% 
% subplot(4,4,14)
% plot(labels.slow_errors_missed_dead,onset.slow_errors_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_missed_dead_withCleared,onset.fast_errors_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Onset')
% 
% subplot(4,4,15)
% plot(labels.slow_errors_missed_dead,rate.slow_errors_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,rate.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_missed_dead_withCleared,rate.fast_errors_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Rate')
% 
% subplot(4,4,16)
% plot(labels.slow_errors_missed_dead,thresh.slow_errors_missed_dead,'or','markerfacecolor','r')
% hold on
% plot(labels.med_errors,thresh.med_errors,'ok','markerfacecolor','k')
% plot(labels.fast_errors_missed_dead_withCleared,thresh.fast_errors_missed_dead_withCleared,'og','markerfacecolor','g')
% 
% title('Threshold')
% 
% 
% 
% figure
% subplot(2,2,1)
% plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binSLOW,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binMED,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binFAST,:)),'g')
% title('SLOW CONDITION')
% xlim([-100 500])
% 
% subplot(2,2,2)
% plot(Plot_Time,nanmean(SDF(in.med_correct_RF_binSLOW,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF_binMED,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF_binFAST,:)),'g')
% title('MED CONDITION')
% xlim([-100 500])
% 
% subplot(2,2,3)
% plot(Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binSLOW,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binMED,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binFAST,:)),'g')
% title('FAST CONDITION')
% xlim([-100 500])
% 
% 
% figure
% subplot(2,2,1)
% plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binSLOW,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF_binSLOW,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binSLOW,:)),'g')
% title('Slow BINS')
% xlim([-100 500])
% 
% subplot(2,2,2)
% plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binMED,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF_binMED,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binMED,:)),'g')
% title('Med BINS')
% xlim([-100 500])
% 
% subplot(2,2,3)
% plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binFAST,:)),'r', ...
%     Plot_Time,nanmean(SDF(in.med_correct_RF_binFAST,:)),'k', ...
%     Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binFAST,:)),'g')
% title('Fast BINS')
% xlim([-100 500])




