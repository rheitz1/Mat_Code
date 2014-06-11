% Function to plot SAT mean behavioral effects (RT, ACC rate, RT
% distributions, etc.  Also plots mean SDFs, target and response aligned,
% if a unit name is provided
%
% RPH

function [] = plotSAT(name)

Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');

if nargin >0
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
Hemi = evalin('caller','Hemi');
end

try
    SRT = evalin('caller','SRT');
    saccLoc = evalin('caller','saccLoc');
catch
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    newfile = evalin('caller','newfile');
    [SRT,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
    assignin('caller','SRT',SRT);
end

trunc_RT = 4000; %set very high to functionally turn off.  Leaving code in place just in case.
plotBaselineBlocks = 1;
separate_cleared_nocleared = 0;
within_condition_RT_bins = 0; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
match_variability = 0;
plot_integrals = 0;
basewin = [Target_(1,1)-100 Target_(1,1)]; %baseline correction window for AD channels

%============
% FIND TRIALS
%===================================================================
getTrials_SAT




%======
% To try:  play back FAST trials where deadline missed and display cleared.
% Make sure that this catches the 'juke' trials




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
    ylim([.5 1])
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
    ylim([0 1])
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
    ylim([0 1])
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

if nargin >= 1
    
    sig = evalin('caller',name);
    
    
    %switch for AD channels
    if size(sig,2) == 3001 | size(sig,2) == 6001
        isAD = 1;
        sig = fixClipped(sig,[Target_(1,1)-100 Target_(1,1)+400]);
        sig = baseline_correct(sig,basewin);
        %sig = truncateAD_targ(sig,SRT);
        
        sig = filtSig(sig,[60],'notch');
        
        Plot_Time = -500:2500;
        
        SDF = sig;
        SDF_r = response_align(sig,SRT,[-400 200]);
        
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
        SDF = sSDF(sig,Target_(:,1),[-100 900]);
        SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-400 200]);
        Plot_Time = -100:900;
        
        
        RF = RFs.(name);
        
        if isempty(RF)
            disp('Empty RF')
            RF = [];
        end
        
        antiRF = mod((RF+4),8);
        inRF = find(ismember(Target_(:,2),RF));
        outRF = find(ismember(Target_(:,2),antiRF));
        
        
        
        MF = MFs.(name);
        if isempty(MF)
            disp('Empty MF')
            MF = [];
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
    %=============================
    
    
    
    %missed dead only
    in.slow_correct_missed_dead_RF = intersect(inRF,slow_correct_missed_dead);
    out.slow_correct_missed_dead_RF = intersect(outRF,slow_correct_missed_dead);
    
    in.fast_correct_missed_dead_withCleared_RF = intersect(inRF,fast_correct_missed_dead_withCleared);
    out.fast_correct_missed_dead_withCleared_RF = intersect(outRF,fast_correct_missed_dead_withCleared);
    
    in.fast_correct_missed_dead_noCleared_RF = intersect(inRF,fast_correct_missed_dead_noCleared);
    out.fast_correct_missed_dead_noCleared_RF = intersect(outRF,fast_correct_missed_dead_noCleared);
    
    %made+missed
    in.slow_correct_made_missed_RF = intersect(inRF,slow_correct_made_missed);
    out.slow_correct_made_missed_RF = intersect(outRF,slow_correct_made_missed);
    
    in.fast_correct_made_missed_withCleared_RF = intersect(inRF,fast_correct_made_missed_withCleared);
    out.fast_correct_made_missed_withCleared_RF = intersect(outRF,fast_correct_made_missed_withCleared);
    
    in.fast_correct_made_missed_noCleared_RF = intersect(inRF,fast_correct_made_missed_noCleared);
    out.fast_correct_made_missed_noCleared_RF = intersect(outRF,fast_correct_made_missed_noCleared);
    
    in.med_correct_RF = intersect(inRF,med_correct);
    out.med_correct_RF = intersect(outRF,med_correct);
    
    
    %==================================
    % target-in - distractor in Integrals (half-baked integrator)
    integral.slow_correct_made_dead_RF = cumsum(nanmean(SDF(in.slow_correct_made_dead_RF,:)) - nanmean(SDF(out.slow_correct_made_dead_RF,:)));
    integral.med_correct_RF = cumsum(nanmean(SDF(in.med_correct_RF,:)) - nanmean(SDF(out.med_correct_RF,:)));
    integral.fast_correct_made_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)));
    
    
    %==============
    % ERRORS
    %made dead only
    in.slow_errors_made_dead_RF = intersect(inRF_err,slow_errors_made_dead);
    out.slow_errors_made_dead_RF = intersect(outRF_err,slow_errors_made_dead);
    
    in.fast_errors_made_dead_withCleared_RF = intersect(inRF_err,fast_errors_made_dead_withCleared);
    out.fast_errors_made_dead_withCleared_RF = intersect(outRF_err,fast_errors_made_dead_withCleared);
    
    in.fast_errors_made_dead_noCleared_RF = intersect(inRF_err,fast_errors_made_dead_noCleared);
    out.fast_errors_made_dead_noCleared_RF = intersect(outRF_err,fast_errors_made_dead_noCleared);
    
    %missed dead only
    in.slow_errors_missed_dead_RF = intersect(inRF_err,slow_errors_missed_dead);
    out.slow_errors_missed_dead_RF = intersect(outRF_err,slow_errors_missed_dead);
    
    in.fast_errors_missed_dead_withCleared_RF = intersect(inRF_err,fast_errors_missed_dead_withCleared);
    out.fast_errors_missed_dead_withCleared_RF = intersect(outRF_err,fast_errors_missed_dead_withCleared);
    
    in.fast_errors_missed_dead_noCleared_RF = intersect(inRF_err,fast_errors_missed_dead_noCleared);
    out.fast_errors_missed_dead_noCleared_RF = intersect(outRF_err,fast_errors_missed_dead_noCleared);
    
    
    %made+missed
    in.slow_errors_made_missed_RF = intersect(inRF_err,slow_errors_made_missed);
    out.slow_errors_made_missed_RF = intersect(outRF_err,slow_errors_made_missed);
    
    in.fast_errors_made_missed_withCleared_RF = intersect(inRF_err,fast_errors_made_missed_withCleared);
    out.fast_errors_made_missed_withCleared_RF = intersect(outRF_err,fast_errors_made_missed_withCleared);
    
    in.fast_errors_made_missed_noCleared_RF = intersect(inRF_err,fast_errors_made_missed_noCleared);
    out.fast_errors_made_missed_noCleared_RF = intersect(outRF_err,fast_errors_made_missed_noCleared);
    
    in.med_errors_RF = intersect(inRF_err,med_errors);
    out.med_errors_RF = intersect(outRF_err,med_errors);
    
    
    %==================================
    % target-in - distractor in Integrals (half-baked integrator)
    integral.slow_errors_made_dead_RF = cumsum(nanmean(SDF(in.slow_errors_made_dead_RF,:)) - nanmean(SDF(out.slow_errors_made_dead_RF,:)));
    integral.med_errors_RF = cumsum(nanmean(SDF(in.med_errors_RF,:)) - nanmean(SDF(out.med_errors_RF,:)));
    integral.fast_errors_made_dead_withCleared_RF = cumsum(nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:)) - nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:)));
    
    
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
    %=============================
    
    
    %missed dead only
    in.slow_correct_missed_dead_MF = intersect(inMF,slow_correct_missed_dead);
    out.slow_correct_missed_dead_MF = intersect(outMF,slow_correct_missed_dead);
    
    in.fast_correct_missed_dead_withCleared_MF = intersect(inMF,fast_correct_missed_dead_withCleared);
    out.fast_correct_missed_dead_withCleared_MF = intersect(outMF,fast_correct_missed_dead_withCleared);
    
    in.fast_correct_missed_dead_noCleared_MF = intersect(inMF,fast_correct_missed_dead_noCleared);
    out.fast_correct_missed_dead_noCleared_MF = intersect(outMF,fast_correct_missed_dead_noCleared);
    
    %made+missed
    in.slow_correct_made_missed_MF = intersect(inMF,slow_correct_made_missed);
    out.slow_correct_made_missed_MF = intersect(outMF,slow_correct_made_missed);
    
    in.fast_correct_made_missed_withCleared_MF = intersect(inMF,fast_correct_made_missed_withCleared);
    out.fast_correct_made_missed_withCleared_MF = intersect(outMF,fast_correct_made_missed_withCleared);
    
    in.fast_correct_made_missed_noCleared_MF = intersect(inMF,fast_correct_made_missed_noCleared);
    out.fast_correct_made_missed_noCleared_MF = intersect(outMF,fast_correct_made_missed_noCleared);
    
    in.med_correct_MF = intersect(inMF,med_correct);
    out.med_correct_MF = intersect(outMF,med_correct);
    
    
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
    
    
    %made+missed
    in.slow_errors_made_missed_MF = intersect(inMF_err,slow_errors_made_missed);
    out.slow_errors_made_missed_MF = intersect(outMF_err,slow_errors_made_missed);
    
    in.fast_errors_made_missed_withCleared_MF = intersect(inMF_err,fast_errors_made_missed_withCleared);
    out.fast_errors_made_missed_withCleared_MF = intersect(outMF_err,fast_errors_made_missed_withCleared);
    
    in.fast_errors_made_missed_noCleared_MF = intersect(inMF_err,fast_errors_made_missed_noCleared);
    out.fast_errors_made_missed_noCleared_MF = intersect(outMF_err,fast_errors_made_missed_noCleared);
    
    in.med_errors_MF = intersect(inMF_err,med_errors);
    out.med_errors_MF = intersect(outMF_err,med_errors);
    
    
    
    if match_variability
        %========================
        % Variability matching
        %
        % Want to see what SLOW made deadline condition SDF looks like if you find trials in
        % which the SRT variability is approximately the same as for FAST made
        % deadlines, as they by definition always have very low variability
        %
        % find variability for Fast trials
        target_std = nanstd(SRT(fast_correct_made_dead_withCleared,1));
        
        %start with mean of SLOW made dealine condition since most of the data
        %will hover around it.
        mSRT_slow = nanmean(SRT(slow_correct_made_dead,1));
        
        
        reached_target = 0;
        stepwin = 100;
        
        while ~reached_target
            current_set_full = find(SRT(:,1) >= mSRT_slow - stepwin & SRT(:,1) <= mSRT_slow + stepwin);
            current_set = intersect(current_set_full,slow_correct_made_dead);
            
            if nanstd(SRT(current_set,1)) <= target_std
                restricted_set = current_set;
                reached_target = 1;
            end
            
            stepwin = stepwin - 1;
            clear current_set*
        end
        
        in.slow_correct_made_dead_restricted_var_RF = intersect(restricted_set,in.slow_correct_made_dead_RF);
        out.slow_correct_made_dead_restricted_var_RF = intersect(restricted_set,out.slow_correct_made_dead_RF);
        in.slow_correct_made_dead_restricted_var_MF = intersect(restricted_set,in.slow_correct_made_dead_MF);
        out.slow_correct_made_dead_restricted_var_MF = intersect(restricted_set,out.slow_correct_made_dead_MF);
        
    end
    
    
    if plot_integrals == 1
        figure
        plot(Plot_Time,integral.slow_correct_made_dead_RF,'r', ...
            Plot_Time,integral.med_correct_RF,'k', ...
            Plot_Time,integral.fast_correct_made_dead_withCleared_RF,'g', ...
            Plot_Time,integral.slow_errors_made_dead_RF,'--r', ...
            Plot_Time,integral.med_errors_RF,'--k', ...
            Plot_Time,integral.fast_errors_made_dead_withCleared_RF,'--g','linewidth',2)
        
        xlim([Plot_Time(1) Plot_Time(end)])
        
        v = vline(nanmean(SRT(slow_correct_made_dead,1)),'r');
        set(v,'linewidth',2)
        
        v = vline(nanmean(SRT(fast_correct_made_dead_withCleared,1)),'g');
        set(v,'linewidth',2)
        
        
        title('Target in - Distractor in integral')
        
%         %assume we don't want any other plots
%         return
    end
    
    %====================================================
    %====================================================
    if separate_cleared_nocleared == 1
        
        if match_variability
            figure
            subplot(1,2,1)
            plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF,:)),'--r', ...
                Plot_Time,nanmean(SDF(in.slow_correct_made_dead_restricted_var_RF,:)),'b', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_restricted_var_RF,:)),'--b', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)),'--g', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_noCleared_RF,:)),'m', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_noCleared_RF,:)),'--m')
            xlim([-100 900])
            if isAD; axis ij; end
            
            title(['Target std = ' mat2str(round(target_std*100)/100) '  Restricted std = ' mat2str(round(nanstd(SRT(restricted_set,1))*100)/100)])
            
            subplot(1,2,2)
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF,:)),'--r', ...
                -400:200,nanmean(SDF_r(in.slow_correct_made_dead_restricted_var_MF,:)),'b', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_restricted_var_MF,:)),'--b', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF,:)),'--g', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_noCleared_MF,:)),'m', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_noCleared_MF,:)),'--m')
            xlim([-400 200])
            if isAD; axis ij; end
            
            title(['nSlow all in = ' mat2str(length(in.slow_correct_made_dead_RF)) '  nSlow restricted in = ' mat2str(length(in.slow_correct_made_dead_restricted_var_RF))])
            
        end
        
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_dead_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_dead_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
            TDT.med = getTDT_AD(sig,in.med_correct_RF,out.med_correct_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_correct_made_dead_noCleared_RF,out.fast_correct_made_dead_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
            TDT.med = getTDT_SP(sig,in.med_correct_RF,out.med_correct_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_correct_made_dead_noCleared_RF,out.fast_correct_made_dead_noCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--m')
        
        
        title(['Correct Made Deadline ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_dead_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_dead_noCleared_MF,:)),'--m')
        xlim([-400 200])
        vline(0,'k')
        if isAD; axis ij; end
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_missed_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_missed_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_missed_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_missed_dead_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_correct_missed_dead_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_correct_missed_dead_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_correct_missed_dead_noCleared_RF,out.fast_correct_missed_dead_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_correct_missed_dead_noCleared_RF,out.fast_correct_missed_dead_noCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--m')
        
        
        title(['Correct Missed Deadline ' name])
        
        subplot(1,2,2)
        
        plot(-400:200,nanmean(SDF_r(in.slow_correct_missed_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_missed_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_missed_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_missed_dead_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_correct_missed_dead_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_correct_missed_dead_noCleared_MF,:)),'--m')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_made_missed_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_made_missed_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_missed_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_missed_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_missed_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_missed_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_made_missed_RF,out.slow_correct_made_missed_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_made_missed_withCleared_RF,out.fast_correct_made_missed_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_correct_made_missed_noCleared_RF,out.fast_correct_made_missed_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_made_missed_RF,out.slow_correct_made_missed_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_made_missed_withCleared_RF,out.fast_correct_made_missed_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_correct_made_missed_noCleared_RF,out.fast_correct_made_missed_noCleared_RF);
        end
        
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--m')
        
        title(['Correct Made + Missed ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_correct_made_missed_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_made_missed_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_missed_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_missed_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_missed_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_missed_noCleared_MF,:)),'--m')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_made_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_made_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_dead_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_dead_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
            TDT.med = getTDT_AD(sig,in.med_errors_RF,out.med_errors_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_errors_made_dead_noCleared_RF,out.fast_errors_made_dead_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
            TDT.med = getTDT_SP(sig,in.med_errors_RF,out.med_errors_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_errors_made_dead_noCleared_RF,out.fast_errors_made_dead_noCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--m')
        
        
        title(['errors Made Deadline ' name])
        
        subplot(1,2,2)
        
        plot(-400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_made_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_dead_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_dead_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_dead_noCleared_MF,:)),'--m')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_missed_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_missed_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_missed_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_missed_dead_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_errors_missed_dead_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_errors_missed_dead_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_errors_missed_dead_noCleared_RF,out.fast_errors_missed_dead_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_errors_missed_dead_noCleared_RF,out.fast_errors_missed_dead_noCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--m')
        
        
        title(['errors Missed Deadline ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_missed_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_missed_dead_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_errors_missed_dead_noCleared_MF,:)),'--m')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_made_missed_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_made_missed_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_missed_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_missed_withCleared_RF,:)),'--g', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_missed_noCleared_RF,:)),'m', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_missed_noCleared_RF,:)),'--m')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_made_missed_RF,out.slow_errors_made_missed_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_made_missed_withCleared_RF,out.fast_errors_made_missed_withCleared_RF);
            TDT.fast_noCleared = getTDT_AD(sig,in.fast_errors_made_missed_noCleared_RF,out.fast_errors_made_missed_noCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_made_missed_RF,out.slow_errors_made_missed_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_made_missed_withCleared_RF,out.fast_errors_made_missed_withCleared_RF);
            TDT.fast_noCleared = getTDT_SP(sig,in.fast_errors_made_missed_noCleared_RF,out.fast_errors_made_missed_noCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        vline(TDT.fast_noCleared,'--g')
        
        
        title(['errors Made + Missed ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_errors_made_missed_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_made_missed_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_missed_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_missed_withCleared_MF,:)),'--g', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_missed_noCleared_MF,:)),'m', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_missed_noCleared_MF,:)),'--m')
        
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        
        
        
        if plotBaselineBlocks
            %get baseline effect over blocks
            first_in_set = [1 ; find(diff(SAT_(:,1)) < 0)+1 ; size(SAT_,1)+1];
            
            num_of_sets = length(first_in_set)-1;
            
            for sets = 1:num_of_sets
                curr_set_slow_made = intersect(in.slow_correct_made_dead,(first_in_set(sets):first_in_set(sets+1)-1))';
                curr_set_fast_made = intersect(in.fast_correct_made_dead_noCleared,(first_in_set(sets):first_in_set(sets+1)-1))';
                
                curr_set_slow_missed = intersect(in.slow_correct_missed_dead,(first_in_set(sets):first_in_set(sets+1)-1))';
                curr_set_fast_missed = intersect(in.fast_correct_missed_dead_noCleared,(first_in_set(sets):first_in_set(sets+1)-1))';
                
                
                base_slow_correct_in_made(sets,1) = nanmean(nanmean(SDF(curr_set_slow_made,1:100),2));
                base_fast_correct_in_made(sets,1) = nanmean(nanmean(SDF(curr_set_fast_made,1:100),2));
                
                base_slow_correct_in_missed(sets,1) = nanmean(nanmean(SDF(curr_set_slow_missed,1:100),2));
                base_fast_correct_in_missed(sets,1) = nanmean(nanmean(SDF(curr_set_fast_missed,1:100),2));
                
                
            end
            
            figure
            subplot(1,2,1)
            plot(base_slow_correct_in_made,'b')
            hold on
            plot(base_fast_correct_in_made,'r')
            title('Made deadlines')
            
            subplot(1,2,2)
            plot(base_slow_correct_in_missed,'b')
            hold on
            plot(base_fast_correct_in_missed,'r')
            title('Missed Deadlines')
        end
        
        
    elseif separate_cleared_nocleared == 0
        
        if match_variability
            figure
            subplot(1,2,1)
            plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF,:)),'--r', ...
                Plot_Time,nanmean(SDF(in.slow_correct_made_dead_restricted_var_RF,:)),'b', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_restricted_var_RF,:)),'--b', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)),'--g')
            xlim([-100 900])
            if isAD; axis ij; end
            
            title(['Target std = ' mat2str(round(target_std*100)/100) '  Restricted std = ' mat2str(round(nanstd(SRT(restricted_set,1))*100)/100)])
            
            subplot(1,2,2)
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF,:)),'--r', ...
                -400:200,nanmean(SDF_r(in.slow_correct_made_dead_restricted_var_MF,:)),'b', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_restricted_var_MF,:)),'--b', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF,:)),'--g')
            xlim([-400 200])
            if isAD; axis ij; end
            
            title(['nSlow all in = ' mat2str(length(in.slow_correct_made_dead_RF)) '  nSlow restricted in = ' mat2str(length(in.slow_correct_made_dead_restricted_var_RF))])
            
        end
        
        
        if within_condition_RT_bins
            figure
            subplot(1,2,1)
            plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binSLOW,:)),'r', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF_binSLOW,:)),'--r', ...
                Plot_Time,nanmean(SDF(in.med_correct_RF_binSLOW,:)),'k', ...
                Plot_Time,nanmean(SDF(out.med_correct_RF_binSLOW,:)),'--k', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binSLOW,:)),'g', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binSLOW,:)),'--g','linewidth',5)
            hold on
            plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binMED,:)),'r', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF_binMED,:)),'--r', ...
                Plot_Time,nanmean(SDF(in.med_correct_RF_binMED,:)),'k', ...
                Plot_Time,nanmean(SDF(out.med_correct_RF_binMED,:)),'--k', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binMED,:)),'g', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binMED,:)),'--g','linewidth',2)
            
            plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF_binFAST,:)),'r', ...
                Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF_binFAST,:)),'--r', ...
                Plot_Time,nanmean(SDF(in.med_correct_RF_binFAST,:)),'k', ...
                Plot_Time,nanmean(SDF(out.med_correct_RF_binFAST,:)),'--k', ...
                Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binFAST,:)),'g', ...
                Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binFAST,:)),'--g','linewidth',1)
            
            if isAD; axis ij; end
            xlim([Plot_Time(1) Plot_Time(end)])
            
            
            subplot(1,2,2)
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binSLOW,:)),'r', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF_binSLOW,:)),'--r', ...
                -400:200,nanmean(SDF_r(in.med_correct_MF_binSLOW,:)),'k', ...
                -400:200,nanmean(SDF_r(out.med_correct_MF_binSLOW,:)),'--k', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binSLOW,:)),'g', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF_binSLOW,:)),'--g','linewidth',5)
            hold on
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binMED,:)),'r', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF_binMED,:)),'--r', ...
                -400:200,nanmean(SDF_r(in.med_correct_MF_binMED,:)),'k', ...
                -400:200,nanmean(SDF_r(out.med_correct_MF_binMED,:)),'--k', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binMED,:)),'g', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF_binMED,:)),'--g','linewidth',2)
            
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF_binFAST,:)),'r', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF_binFAST,:)),'--r', ...
                -400:200,nanmean(SDF_r(in.med_correct_MF_binFAST,:)),'k', ...
                -400:200,nanmean(SDF_r(out.med_correct_MF_binFAST,:)),'--k', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF_binFAST,:)),'g', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF_binFAST,:)),'--g','linewidth',1)
            
            if isAD; axis ij; end
            xlim([-400 200])
            v = vline(0,'k');
            set(v,'linewidth',2)
            
            %assume we don't want any other plots
            return
        end
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_made_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_made_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
            TDT.med = getTDT_AD(sig,in.med_correct_RF,out.med_correct_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
            TDT.med = getTDT_SP(sig,in.med_correct_RF,out.med_correct_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        
        
        title(['Correct Made Deadline ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_correct_made_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_made_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_dead_withCleared_MF,:)),'--g')
        
        xlim([-400 200])
        vline(0,'k')
        if isAD; axis ij; end
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_missed_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_missed_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_missed_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_missed_dead_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_missed_dead_RF,out.slow_correct_missed_dead_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_missed_dead_withCleared_RF,out.fast_correct_missed_dead_withCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        
        title(['Correct Missed Deadline ' name])
        
        subplot(1,2,2)
        
        plot(-400:200,nanmean(SDF_r(in.slow_correct_missed_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_missed_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_missed_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_missed_dead_withCleared_MF,:)),'--g')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_correct_made_missed_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_correct_made_missed_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_correct_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_correct_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_correct_made_missed_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_correct_made_missed_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_correct_made_missed_RF,out.slow_correct_made_missed_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_correct_made_missed_withCleared_RF,out.fast_correct_made_missed_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_correct_made_missed_RF,out.slow_correct_made_missed_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_correct_made_missed_withCleared_RF,out.fast_correct_made_missed_withCleared_RF);
        end
        
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        
        title(['Correct Made + Missed ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_correct_made_missed_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_correct_made_missed_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_correct_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_correct_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_correct_made_missed_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_correct_made_missed_withCleared_MF,:)),'--g')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_made_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_made_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
            TDT.med = getTDT_AD(sig,in.med_errors_RF,out.med_errors_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_made_dead_RF,out.slow_errors_made_dead_RF);
            TDT.med = getTDT_SP(sig,in.med_errors_RF,out.med_errors_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_made_dead_withCleared_RF,out.fast_errors_made_dead_withCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        title(['errors Made Deadline ' name])
        
        subplot(1,2,2)
        
        plot(-400:200,nanmean(SDF_r(in.slow_errors_made_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_made_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_dead_withCleared_MF,:)),'--g')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_missed_dead_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_missed_dead_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_missed_dead_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_missed_dead_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_missed_dead_RF,out.slow_errors_missed_dead_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_missed_dead_withCleared_RF,out.fast_errors_missed_dead_withCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        title(['errors Missed Deadline ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_errors_missed_dead_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_missed_dead_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_missed_dead_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_missed_dead_withCleared_MF,:)),'--g')
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
        
        figure
        subplot(1,2,1)
        
        plot(Plot_Time,nanmean(SDF(in.slow_errors_made_missed_RF,:)),'r', ...
            Plot_Time,nanmean(SDF(out.slow_errors_made_missed_RF,:)),'--r', ...
            Plot_Time,nanmean(SDF(in.med_errors_RF,:)),'k', ...
            Plot_Time,nanmean(SDF(out.med_errors_RF,:)),'--k', ...
            Plot_Time,nanmean(SDF(in.fast_errors_made_missed_withCleared_RF,:)),'g', ...
            Plot_Time,nanmean(SDF(out.fast_errors_made_missed_withCleared_RF,:)),'--g')
        
        xlim([-100 900])
        if isAD; axis ij; end
        
        if isAD
            TDT.slow = getTDT_AD(sig,in.slow_errors_made_missed_RF,out.slow_errors_made_missed_RF);
            TDT.fast_withCleared = getTDT_AD(sig,in.fast_errors_made_missed_withCleared_RF,out.fast_errors_made_missed_withCleared_RF);
        else
            TDT.slow = getTDT_SP(sig,in.slow_errors_made_missed_RF,out.slow_errors_made_missed_RF);
            TDT.fast_withCleared = getTDT_SP(sig,in.fast_errors_made_missed_withCleared_RF,out.fast_errors_made_missed_withCleared_RF);
        end
        
        vline(TDT.slow,'r')
        vline(TDT.med,'k')
        vline(TDT.fast_withCleared,'g')
        
        
        
        title(['errors Made + Missed ' name])
        
        subplot(1,2,2)
        plot(-400:200,nanmean(SDF_r(in.slow_errors_made_missed_MF,:)),'r', ...
            -400:200,nanmean(SDF_r(out.slow_errors_made_missed_MF,:)),'--r', ...
            -400:200,nanmean(SDF_r(in.med_errors_MF,:)),'k', ...
            -400:200,nanmean(SDF_r(out.med_errors_MF,:)),'--k', ...
            -400:200,nanmean(SDF_r(in.fast_errors_made_missed_withCleared_MF,:)),'g', ...
            -400:200,nanmean(SDF_r(out.fast_errors_made_missed_withCleared_MF,:)),'--g')
        
        
        xlim([-400 200])
        if isAD; axis ij; end
        vline(0,'k')
        
    end
    
    
    if plotBaselineBlocks
        %get baseline effect over blocks
        first_in_set = [1 ; find(diff(SAT_(:,1)) < 0)+1 ; size(SAT_,1)+1];
        
        num_of_sets = length(first_in_set)-1;
        
        for sets = 1:num_of_sets
            curr_set_slow_made = intersect(in.slow_correct_made_dead_RF,(first_in_set(sets):first_in_set(sets+1)-1))';
            curr_set_fast_made = intersect(in.fast_correct_made_dead_withCleared_RF,(first_in_set(sets):first_in_set(sets+1)-1))';
            
            curr_set_slow_missed = intersect(in.slow_correct_missed_dead_RF,(first_in_set(sets):first_in_set(sets+1)-1))';
            curr_set_fast_missed = intersect(in.fast_correct_missed_dead_withCleared_RF,(first_in_set(sets):first_in_set(sets+1)-1))';
            
            
            base_slow_correct_in_made(sets,1) = nanmean(nanmean(SDF(curr_set_slow_made,1:100),2));
            base_fast_correct_in_made(sets,1) = nanmean(nanmean(SDF(curr_set_fast_made,1:100),2));
            
            base_slow_correct_in_missed(sets,1) = nanmean(nanmean(SDF(curr_set_slow_missed,1:100),2));
            base_fast_correct_in_missed(sets,1) = nanmean(nanmean(SDF(curr_set_fast_missed,1:100),2));
        end

        
        figure
        subplot(1,2,1)
        plot(base_slow_correct_in_made,'r')
        hold on
        plot(base_fast_correct_in_made,'g')
        title('Made deadlines')
        
        subplot(1,2,2)
        plot(base_slow_correct_in_missed,'r')
        hold on
        plot(base_fast_correct_in_missed,'g')
        title('Missed Deadlines')
    end
end

%tileFigs



