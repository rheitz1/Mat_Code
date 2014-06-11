cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_Vis_Med_Q.txt','%s %s');
%  [filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
%  [filename4 unit4] = textread('SAT_Vis_Med_S.txt','%s %s');
%  [filename5 unit5] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
%  [filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
%  [filename7 unit7] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%  [filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
%    [filename9 unit9] = textread('SAT_Move_NoMed_Q.txt','%s %s');
%    [filename10 unit10] = textread('SAT_Move_Med_Q.txt','%s %s');
%    [filename11 unit11] = textread('SAT_Move_NoMed_S.txt','%s %s');
%    [filename12 unit12] = textread('SAT_Move_Med_S.txt','%s %s');

 [filename1 unit1] = textread('SAT2_FEF_Vis_NoMed_D.txt','%s %s');
%  [filename2 unit2] = textread('SAT2_SC_VisMove_NoMed_D.txt','%s %s');
% [filename3 unit3] = textread('SAT2_SC_Vis_NoMed_E.txt','%s %s');
% [filename4 unit4] = textread('SAT2_SC_VisMove_NoMed_E.txt','%s %s');

filename = [filename1];
unit = [unit1 ];





for file = 1:length(filename)
    
    load(filename{file},unit{file},'TrialStart_','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    filename{file}
    
    sig = eval(unit{file});
    
    RF = RFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    %
    %     [~,saccLoc] = getSRT(EyeX_,EyeY_);
    %     clear EyeX_ EyeY_
    %
    
    normalizeSDF = 1;
    
    %Plot_Time = -400:900;
    %truncate_;
    plotBaselineBlocks = 0;
    separate_cleared_nocleared = 0;
    within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
    match_variability = 0;
    plot_integrals = 0;
    basewin = [400 500]; %baseline correction window for AD channels
    JackKnife_TDT_test = 0;
    
    %============
    % FIND TRIALS
    %===================================================================
   
    
    getTrials_SAT
    
    %====================
    % Calculate ACC rates
    %percentage of CORRECT trials that missed the deadline
    prc_missed_slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
    prc_missed_fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
    %prc_missed_fast_correct_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));
    
    %ACC rate for made deadlines
    ACC.slow_made_dead(file,1) = length(slow_correct_made_dead) / length(slow_all_made_dead);
    ACC.fast_made_dead_withCleared(file,1) = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
    %ACC.fast_made_dead_noCleared(file,1) = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);
    
    
    %ACC rate for missed deadlines
    ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
    ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
    %ACC.fast_missed_dead_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);
    
    
    %overall ACC rate for made + missed deadlines
    ACC.slow_made_missed(file,1) = length(slow_correct_made_missed) / length(slow_all);
    ACC.fast_made_missed_withCleared(file,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
    %ACC.fast_made_missed_noCleared(file,1) = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);
    
    ACC.med(file,1) = length(med_correct) / length(med_all);
    
    
    RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    
    RTs.slow_correct_missed_dead(file,1) = nanmean(SRT(slow_correct_missed_dead,1));
    RTs.fast_correct_missed_dead_withCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_withCleared,1));
    
    %RTs.fast_correct_made_dead_noCleared(file,1) = nanmean(SRT(fast_correct_made_dead_noCleared,1));
    
    RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    %RTs.fast_errors_made_dead_noCleared(file,1) = nanmean(SRT(fast_errors_made_dead_noCleared,1));
    
    
    SDF = sSDF(sig,Target_(:,1),[-100 900]);
    
    if normalizeSDF == 1
        SDF = normalize_SP(SDF);
    end
    
    inRF = find(ismember(Target_(:,2),RF));
    outRF = find(ismember(Target_(:,2),antiRF));
    inRF_err = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
    outRF_err = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
    
    
    %======================
    % Target-Aligned RF
    %==============
    % CORRECT
    %made dead only
    in.slow_correct_made_dead_RF = intersect(inRF,slow_correct_made_dead);
    out.slow_correct_made_dead_RF = intersect(outRF,slow_correct_made_dead);
    
    in.slow_correct_made_missed_RF = intersect(inRF,slow_correct_made_missed);
    out.slow_correct_made_missed_RF = intersect(outRF,slow_correct_made_missed);
    
    in.med_correct_RF = intersect(inRF,med_correct);
    out.med_correct_RF = intersect(outRF,med_correct);
    
    in.med_correct_RF_match_fast = intersect(inRF,med_correct_match_fast);
    out.med_correct_RF_match_fast = intersect(outRF,med_correct_match_fast);
    
    in.med_correct_RF_match_slow = intersect(inRF,med_correct_match_slow);
    out.med_correct_RF_match_slow = intersect(outRF,med_correct_match_slow);
    
    in.med_correct_RF_nomatch = intersect(inRF,med_correct_nomatch);
    out.med_correct_RF_nomatch = intersect(outRF,med_correct_nomatch);
    
    in.med_correct_RF_nomatch_small_sd = intersect(inRF,med_correct_nomatch_small_sd);
    out.med_correct_RF_nomatch_small_sd = intersect(outRF,med_correct_nomatch_small_sd);
    
    in.slow_correct_match_med = intersect(inRF,slow_correct_match_med);
    out.slow_correct_match_med = intersect(outRF,slow_correct_match_med);
    
    %match Neutral condition to its own mean +/- 1 sd (limit variability)
    in.med_correct_match_med = intersect(inRF,med_correct_match_med);
    out.med_correct_match_med = intersect(outRF,med_correct_match_med);
    
    in.fast_correct_match_med = intersect(inRF,fast_correct_match_med);
    out.fast_correct_match_med = intersect(outRF,fast_correct_match_med);
    
    in.fast_correct_made_dead_withCleared_RF = intersect(inRF,fast_correct_made_dead_withCleared);
    out.fast_correct_made_dead_withCleared_RF = intersect(outRF,fast_correct_made_dead_withCleared);
    
    in.fast_correct_made_missed_withCleared_RF = intersect(inRF,fast_correct_made_missed_withCleared);
    out.fast_correct_made_missed_withCleared_RF = intersect(outRF,fast_correct_made_missed_withCleared);
    
    %     in.fast_correct_made_dead_noCleared_RF = intersect(inRF,fast_correct_made_dead_noCleared);
    %     out.fast_correct_made_dead_noCleared_RF = intersect(outRF,fast_correct_made_dead_noCleared);
    

    stats.slow = getSpikeStats(sig,50,10,[-1000 2500],slow_correct_made_dead);
    stats.med = getSpikeStats(sig,50,10,[-1000 2500],med_correct);
    stats.fast = getSpikeStats(sig,50,10,[-1000 2500],fast_correct_made_dead_withCleared);
    
    TDT.slow_correct_made_dead = getTDT_SP(sig,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
    TDT.fast_correct_made_dead_withCleared = getTDT_SP(sig,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
    %   TDT.fast_correct_made_dead_noCleared = getTDT_SP(sig,in.fast_correct_made_dead_noCleared_RF,out.fast_correct_made_dead_noCleared_RF);
    TDT.med_correct = getTDT_SP(sig,in.med_correct_RF,out.med_correct_RF);
    
    ROC.slow_correct_made_dead = getROC(SDF,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF,1);
    ROC.med_correct = getROC(SDF,in.med_correct_RF,out.med_correct_RF,1);
    ROC.fast_correct_made_dead_withCleared = getROC(SDF,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF,1);
    
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
    
    %     in.fast_correct_made_dead_noCleared_RF_binFAST = intersect(inRF,fast_correct_made_dead_noCleared_binFAST);
    %     out.fast_correct_made_dead_noCleared_RF_binFAST = intersect(outRF,fast_correct_made_dead_noCleared_binFAST);
    %     in.fast_correct_made_dead_noCleared_RF_binMED = intersect(inRF,fast_correct_made_dead_noCleared_binMED);
    %     out.fast_correct_made_dead_noCleared_RF_binMED = intersect(outRF,fast_correct_made_dead_noCleared_binMED);
    %     in.fast_correct_made_dead_noCleared_RF_binSLOW = intersect(inRF,fast_correct_made_dead_noCleared_binSLOW);
    %     out.fast_correct_made_dead_noCleared_RF_binSLOW = intersect(outRF,fast_correct_made_dead_noCleared_binSLOW);
    %
    %=============================
    
    
    
    %missed dead only
    in.slow_correct_missed_dead_RF = intersect(inRF,slow_correct_missed_dead);
    out.slow_correct_missed_dead_RF = intersect(outRF,slow_correct_missed_dead);
    
    in.fast_correct_missed_dead_withCleared_RF = intersect(inRF,fast_correct_missed_dead_withCleared);
    out.fast_correct_missed_dead_withCleared_RF = intersect(outRF,fast_correct_missed_dead_withCleared);
    %
    %     in.fast_correct_missed_dead_noCleared_RF = intersect(inRF,fast_correct_missed_dead_noCleared);
    %     out.fast_correct_missed_dead_noCleared_RF = intersect(outRF,fast_correct_missed_dead_noCleared);
    
    
    
    %==============
    % ERRORS
    %made dead only
    in.slow_errors_made_dead_RF = intersect(inRF_err,slow_errors_made_dead);
    out.slow_errors_made_dead_RF = intersect(outRF_err,slow_errors_made_dead);
    
    in.med_errors_RF = intersect(inRF_err,med_errors);
    out.med_errors_RF = intersect(outRF_err,med_errors);
    
    in.fast_errors_made_dead_withCleared_RF = intersect(inRF_err,fast_errors_made_dead_withCleared);
    out.fast_errors_made_dead_withCleared_RF = intersect(outRF_err,fast_errors_made_dead_withCleared);
    
    %     in.fast_errors_made_dead_noCleared_RF = intersect(inRF_err,fast_errors_made_dead_noCleared);
    %     out.fast_errors_made_dead_noCleared_RF = intersect(outRF_err,fast_errors_made_dead_noCleared);
    
    %missed dead only
    in.slow_errors_missed_dead_RF = intersect(inRF_err,slow_errors_missed_dead);
    out.slow_errors_missed_dead_RF = intersect(outRF_err,slow_errors_missed_dead);
    
    in.fast_errors_missed_dead_withCleared_RF = intersect(inRF_err,fast_errors_missed_dead_withCleared);
    out.fast_errors_missed_dead_withCleared_RF = intersect(outRF_err,fast_errors_missed_dead_withCleared);
    %
    %     in.fast_errors_missed_dead_noCleared_RF = intersect(inRF_err,fast_errors_missed_dead_noCleared);
    %     out.fast_errors_missed_dead_noCleared_RF = intersect(outRF_err,fast_errors_missed_dead_noCleared);
    
    
    %====================================
    %====================================
    % Keep track of infos & waveforms
    %Plot_Time_targ = Plot_Time;
    %Plot_Time_resp = -400:200;
    
    allTDT.slow_correct_made_dead(file,1) = TDT.slow_correct_made_dead;
    allTDT.fast_correct_made_dead_withCleared(file,1) = TDT.fast_correct_made_dead_withCleared;
    %  allTDT.fast_correct_made_dead_noCleared(file,1) = TDT.fast_correct_made_dead_noCleared;
    allTDT.med_correct(file,1) = TDT.med_correct;
    
    allROC.slow_correct_made_dead(file,1:1001) = ROC.slow_correct_made_dead;
    allROC.med_correct(file,1:1001) = ROC.med_correct;
    allROC.fast_correct_made_dead_withCleared(file,1:1001) = ROC.fast_correct_made_dead_withCleared;
    
    if JackKnife_TDT_test
        [TDT.jack_slow_vs_fast(file,1:2) t_obt(file,1) p(file,1)] = getJackKnife_TDT(-100:900,SDF(in.slow_correct_made_dead_RF,:),SDF(out.slow_correct_made_dead_RF,:),SDF(in.fast_correct_made_dead_withCleared_RF,:),SDF(out.fast_correct_made_dead_withCleared_RF,:));
    end
    
    %Correct made dead
%     allFano.slow(file,1:301) = stats.slow.Fano; %hard-coding 1:301 to deal with potential NaNs in MED condition
%     allFano.med(file,1:301) = stats.med.Fano;
%     allFano.fast(file,1:301) = stats.fast.Fano;
    
    allwf_targ.in.slow_correct_made_dead(file,:) = nanmean(SDF(in.slow_correct_made_dead_RF,:));
    allwf_targ.out.slow_correct_made_dead(file,:) = nanmean(SDF(out.slow_correct_made_dead_RF,:));
    allwf_targ.in.slow_correct_made_missed(file,:) = nanmean(SDF(in.slow_correct_made_missed_RF,:));
    allwf_targ.out.slow_correct_made_missed(file,:) = nanmean(SDF(out.slow_correct_made_missed_RF,:));
    
    allwf_targ.in.slow_correct_made_dead_binFAST(file,:) = nanmean(SDF(in.slow_correct_made_dead_RF_binFAST,:));
    allwf_targ.out.slow_correct_made_dead_binFAST(file,:) = nanmean(SDF(out.slow_correct_made_dead_RF_binFAST,:));
    allwf_targ.in.slow_correct_made_dead_binMED(file,:) = nanmean(SDF(in.slow_correct_made_dead_RF_binMED,:));
    allwf_targ.out.slow_correct_made_dead_binMED(file,:) = nanmean(SDF(out.slow_correct_made_dead_RF_binMED,:));
    allwf_targ.in.slow_correct_made_dead_binSLOW(file,:) = nanmean(SDF(in.slow_correct_made_dead_RF_binSLOW,:));
    allwf_targ.out.slow_correct_made_dead_binSLOW(file,:) = nanmean(SDF(out.slow_correct_made_dead_RF_binSLOW,:));
    
    allwf_targ.in.med_correct(file,:) = nanmean(SDF(in.med_correct_RF,:));
    allwf_targ.out.med_correct(file,:) = nanmean(SDF(out.med_correct_RF,:));
    allwf_targ.in.med_correct_binFAST(file,:) = nanmean(SDF(in.med_correct_RF_binFAST,:));
    allwf_targ.out.med_correct_binFAST(file,:) = nanmean(SDF(out.med_correct_RF_binFAST,:));
    allwf_targ.in.med_correct_binMED(file,:) = nanmean(SDF(in.med_correct_RF_binMED,:));
    allwf_targ.out.med_correct_binMED(file,:) = nanmean(SDF(out.med_correct_RF_binMED,:));
    allwf_targ.in.med_correct_binSLOW(file,:) = nanmean(SDF(in.med_correct_RF_binSLOW,:));
    allwf_targ.out.med_correct_biSLOW(file,:) = nanmean(SDF(out.med_correct_RF_binSLOW,:));
    
    allwf_targ.in.med_correct_match_slow(file,:) = nanmean(SDF(in.med_correct_RF_match_slow,:));
    allwf_targ.out.med_correct_match_slow(file,:) = nanmean(SDF(out.med_correct_RF_match_slow,:));
    
    allwf_targ.in.med_correct_match_fast(file,:) = nanmean(SDF(in.med_correct_RF_match_fast,:));
    allwf_targ.out.med_correct_match_fast(file,:) = nanmean(SDF(out.med_correct_RF_match_fast,:));
    
    allwf_targ.in.med_correct_nomatch(file,:) = nanmean(SDF(in.med_correct_RF_nomatch,:));
    allwf_targ.out.med_correct_nomatch(file,:) = nanmean(SDF(out.med_correct_RF_nomatch,:));
    
    allwf_targ.in.med_correct_nomatch_small_sd(file,:) = nanmean(SDF(in.med_correct_RF_nomatch_small_sd,:));
    allwf_targ.out.med_correct_nomatch_small_sd(file,:) = nanmean(SDF(out.med_correct_RF_nomatch_small_sd,:));
    
    allwf_targ.in.slow_correct_match_med(file,:) = nanmean(SDF(in.slow_correct_match_med,:));
    allwf_targ.out.slow_correct_match_med(file,:) = nanmean(SDF(out.slow_correct_match_med,:));
    
    allwf_targ.in.med_correct_match_med(file,:) = nanmean(SDF(in.med_correct_match_med,:));
    allwf_targ.out.med_correct_match_med(file,:) = nanmean(SDF(out.med_correct_match_med,:));
    
    allwf_targ.in.fast_correct_match_med(file,:) = nanmean(SDF(in.fast_correct_match_med,:));
    allwf_targ.out.fast_correct_match_med(file,:) = nanmean(SDF(out.fast_correct_match_med,:));
    
    
    allwf_targ.in.fast_correct_made_dead_withCleared(file,:) = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,:));
    allwf_targ.out.fast_correct_made_dead_withCleared(file,:) = nanmean(SDF(out.fast_correct_made_dead_withCleared_RF,:));
    
    allwf_targ.in.fast_correct_made_missed_withCleared(file,:) = nanmean(SDF(in.fast_correct_made_missed_withCleared_RF,:));
    allwf_targ.out.fast_correct_made_missed_withCleared(file,:) = nanmean(SDF(out.fast_correct_made_missed_withCleared_RF,:));
    
    allwf_targ.in.fast_correct_made_dead_withCleared_binFAST(file,:) = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binFAST,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binFAST(file,:) = nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binFAST,:));
    allwf_targ.in.fast_correct_made_dead_withCleared_binMED(file,:) = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binMED,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binMED(file,:) = nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binMED,:));
    allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW(file,:) = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF_binSLOW,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binSLOW(file,:) = nanmean(SDF(out.fast_correct_made_dead_withCleared_RF_binSLOW,:));
    
    %     allwf_targ.in.fast_correct_made_dead_noCleared(file,:) = nanmean(SDF(in.fast_correct_made_dead_noCleared_RF,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared(file,:) = nanmean(SDF(out.fast_correct_made_dead_noCleared_RF,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binFAST(file,:) = nanmean(SDF(in.fast_correct_made_dead_noCleared_RF_binFAST,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binFAST(file,:) = nanmean(SDF(out.fast_correct_made_dead_noCleared_RF_binFAST,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binMED(file,:) = nanmean(SDF(in.fast_correct_made_dead_noCleared_RF_binMED,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binMED(file,:) = nanmean(SDF(out.fast_correct_made_dead_noCleared_RF_binMED,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binSLOW(file,:) = nanmean(SDF(in.fast_correct_made_dead_noCleared_RF_binSLOW,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binSLOW(file,:) = nanmean(SDF(out.fast_correct_made_dead_noCleared_RF_binSLOW,:));
    
    %Errors made dead
    allwf_targ.in.slow_errors_made_dead(file,:) = nanmean(SDF(in.slow_errors_made_dead_RF,:),1);
    allwf_targ.out.slow_errors_made_dead(file,:) = nanmean(SDF(out.slow_errors_made_dead_RF,:),1);
    
    allwf_targ.in.med_errors(file,:) = nanmean(SDF(in.med_errors_RF,:),1);
    allwf_targ.out.med_errors(file,:) = nanmean(SDF(out.med_errors_RF,:),1);
    
    allwf_targ.in.fast_errors_made_dead_withCleared(file,:) = nanmean(SDF(in.fast_errors_made_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_errors_made_dead_withCleared(file,:) = nanmean(SDF(out.fast_errors_made_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_errors_made_dead_noCleared(file,:) = nanmean(SDF(in.fast_errors_made_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_errors_made_dead_noCleared(file,:) = nanmean(SDF(out.fast_errors_made_dead_noCleared_RF,:),1);
    
    
    %Correct missed dead
    allwf_targ.in.slow_correct_missed_dead(file,:) = nanmean(SDF(in.slow_correct_missed_dead_RF,:),1);
    allwf_targ.out.slow_correct_missed_dead(file,:) = nanmean(SDF(out.slow_correct_missed_dead_RF,:),1);
    
    allwf_targ.in.fast_correct_missed_dead_withCleared(file,:) = nanmean(SDF(in.fast_correct_missed_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_correct_missed_dead_withCleared(file,:) = nanmean(SDF(out.fast_correct_missed_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_correct_missed_dead_noCleared(file,:) = nanmean(SDF(in.fast_correct_missed_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_correct_missed_dead_noCleared(file,:) = nanmean(SDF(out.fast_correct_missed_dead_noCleared_RF,:),1);
    
    %Errors missed dead
    allwf_targ.in.slow_errors_missed_dead(file,:) = nanmean(SDF(in.slow_errors_missed_dead_RF,:),1);
    allwf_targ.out.slow_errors_missed_dead(file,:) = nanmean(SDF(out.slow_errors_missed_dead_RF,:),1);
    
    allwf_targ.in.fast_errors_missed_dead_withCleared(file,:) = nanmean(SDF(in.fast_errors_missed_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_errors_missed_dead_withCleared(file,:) = nanmean(SDF(out.fast_errors_missed_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_errors_missed_dead_noCleared(file,:) = nanmean(SDF(in.fast_errors_missed_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_errors_missed_dead_noCleared(file,:) = nanmean(SDF(out.fast_errors_missed_dead_noCleared_RF,:),1);
    
    %Test mean activity ? ms post target onset between Slow and Fast conditions
    % two-group test because different numbers of trials w/i each condition
    % REMOVE 0'S
    
    
    %===================================================
    % Target-aligned slopes (for Movement-cell analysis)
    % Regress from 100ms post-target onset to RT.  -100 ms baseline, so start at 200 ms
% % %     
% % %     slopeSDF.slow = nanmean(SDF(in.slow_correct_made_dead_RF,200:RTs.slow_correct_made_dead(file,1)+100),1);
% % %     slopeSDF.fast = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,200:RTs.fast_correct_made_dead_withCleared(file,1)+100),1);
% % %     
% % %     if ~isempty(in.med_correct_RF)
% % %         slopeSDF.med = nanmean(SDF(in.med_correct_RF,200:RTs.med_correct(file,1)+100),1);
% % %     else
% % %         slopeSDF.med = NaN;
% % %     end
% % %       
% % %     %Note: divide time axis (x) by 1000 so that slopes will be in spikes/sec per sec
% % %     [slope.slow(file,1),~,r.slow(file,1)] = linreg(slopeSDF.slow',(1:length(slopeSDF.slow))'./1000);
% % %     [slope.fast(file,1),~,r.fast(file,1)] = linreg(slopeSDF.fast',(1:length(slopeSDF.fast))'./1000);
% % %     
% % %     if ~isempty(in.med_correct_RF)
% % %         [slope.med(file,1),~,r.med(file,1)] = linreg(slopeSDF.med',(1:length(slopeSDF.med))'./1000);
% % %     else
% % %         slope.med(file,1) = NaN;
% % %         r.med(file,1) = NaN;
% % %     end

    
    
    
    
    test_time1 = 200:225; %100 - 125 ms post array onset
    test_time2 = 350:400; %250 - 300 ms post array onset
   
    testX = nanmean(SDF(in.slow_correct_made_dead_RF,test_time1),2);
    testY = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,test_time1),2);
    testX(find(testX == 0)) = NaN;
    testY(find(testY == 0)) = NaN;
    testX = removeNaN(testX);
    testY = removeNaN(testY);
    sigAct_100_125.slow_vs_fast(file,1) = ttest2(testX,testY);
    
    
    testX = nanmean(SDF(in.slow_correct_made_dead_RF,test_time2),2);
    testY = nanmean(SDF(in.fast_correct_made_dead_withCleared_RF,test_time2),2);
    testX(find(testX == 0)) = NaN;
    testY(find(testY == 0)) = NaN;
    testX = removeNaN(testX);
    testY = removeNaN(testY);
    sigAct_250_300.slow_vs_fast(file,1) = ttest2(testX,testY);
    
    keep allFano filename unit file all* Plot_Time_targ ACC RTs sigAct* slope
    
end

sems.in.slow_correct_made_dead = sem(allwf_targ.in.slow_correct_made_dead);
sems.out.slow_correct_made_dead = sem(allwf_targ.out.slow_correct_made_dead);
sems.in.med_correct = sem(allwf_targ.in.med_correct);
sems.out.med_correct = sem(allwf_targ.out.med_correct);
sems.in.fast_correct_made_dead = sem(allwf_targ.in.fast_correct_made_dead_withCleared);
sems.out.fast_correct_made_dead = sem(allwf_targ.out.fast_correct_made_dead_withCleared);

%FAST vs SLOW MADE DEADLINES
figure
fon
subplot(2,2,1)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead),'r',-100:900,nanmean(allwf_targ.out.slow_correct_made_dead),'--r', ...
    -100:900,nanmean(allwf_targ.in.med_correct),'k',-100:900,nanmean(allwf_targ.out.med_correct),'--k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_correct_made_dead_withCleared),'--g')
xlim([-100 300])
title('Correct made Deadline')
vline(nanmean(allTDT.slow_correct_made_dead),'r')
vline(nanmean(allTDT.med_correct),'k')
vline(nanmean(allTDT.fast_correct_made_dead_withCleared),'g')
%set(gca,'xminortick','on')
box off

subplot(2,2,2)
plot(-100:900,nanmean(allwf_targ.in.slow_errors_made_dead),'r',-100:900,nanmean(allwf_targ.out.slow_errors_made_dead),'--r', ...
    -100:900,nanmean(allwf_targ.in.med_errors),'k',-100:900,nanmean(allwf_targ.out.med_errors),'--k', ...
    -100:900,nanmean(allwf_targ.in.fast_errors_made_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_errors_made_dead_withCleared),'--g')
xlim([-100 300])
title('Errors made Deadline')
set(gca,'xminortick','on')
box off

subplot(2,2,3)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_missed_dead),'r',-100:900,nanmean(allwf_targ.out.slow_correct_missed_dead),'--r', ...
    -100:900,nanmean(allwf_targ.in.med_correct),'k',-100:900,nanmean(allwf_targ.out.med_correct),'--k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_missed_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_correct_missed_dead_withCleared),'--g')
xlim([-100 300])
title('Correct missed Deadline')
set(gca,'xminortick','on')
box off

subplot(2,2,4)
plot(-100:900,nanmean(allwf_targ.in.slow_errors_missed_dead),'r',-100:900,nanmean(allwf_targ.out.slow_errors_missed_dead),'--r', ...
    -100:900,nanmean(allwf_targ.in.med_errors),'k',-100:900,nanmean(allwf_targ.out.med_errors),'--k', ...
    -100:900,nanmean(allwf_targ.in.fast_errors_missed_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_errors_missed_dead_withCleared),'--g')
xlim([-100 300])
title('Errors missed Deadline')
set(gca,'xminortick','on')
box off

%equate_y
subplot(2,2,1)
legend('Slow IN','Slow OUT','Fast IN','Fast OUT','location','northwest')

%MADE vs MISSED DEADLINES
figure
fon
subplot(2,2,1)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead),'r',-100:900,nanmean(allwf_targ.out.slow_correct_made_dead),'--r', 'linewidth',2)
hold on
plot(-100:900,nanmean(allwf_targ.in.slow_correct_missed_dead),'r',-100:900,nanmean(allwf_targ.out.slow_correct_missed_dead),'--r')
xlim([-100 500])
title('SLOW CORRECT')
set(gca,'xminortick','on')
box off


subplot(2,2,2)
plot(-100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_correct_made_dead_withCleared),'--g', 'linewidth',2)
hold on
plot(-100:900,nanmean(allwf_targ.in.fast_correct_missed_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_correct_missed_dead_withCleared),'--g')
xlim([-100 500])
title('FAST CORRECT')
set(gca,'xminortick','on')
box off


subplot(2,2,3)
plot(-100:900,nanmean(allwf_targ.in.slow_errors_made_dead),'r',-100:900,nanmean(allwf_targ.out.slow_errors_made_dead),'--r', 'linewidth',2)
hold on
plot(-100:900,nanmean(allwf_targ.in.slow_errors_missed_dead),'r',-100:900,nanmean(allwf_targ.out.slow_errors_missed_dead),'--r')
xlim([-100 500])
title('SLOW ERRORS')
set(gca,'xminortick','on')
box off


subplot(2,2,4)
plot(-100:900,nanmean(allwf_targ.in.fast_errors_made_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_errors_made_dead_withCleared),'--g', 'linewidth',2)
hold on
plot(-100:900,nanmean(allwf_targ.in.fast_errors_missed_dead_withCleared),'g',-100:900,nanmean(allwf_targ.out.fast_errors_missed_dead_withCleared),'--g')
xlim([-100 500])
title('FAST ERRORS')
set(gca,'xminortick','on')
box off

%equate_y

subplot(2,2,1)
legend('Correct IN MADE','Correct OUT MADE','Correct IN MISSED','Correct OUT MISSED','location','northwest')



figure
subplot(2,2,1)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binSLOW),'r', ...
    -100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binMED),'k', ...
    -100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binFAST),'g')
title('SLOW CONDITION')
xlim([-100 500])
set(gca,'xminortick','on')
box off

subplot(2,2,2)

plot(-100:900,nanmean(allwf_targ.in.med_correct_binSLOW),'r', ...
    -100:900,nanmean(allwf_targ.in.med_correct_binMED),'k', ...
    -100:900,nanmean(allwf_targ.in.med_correct_binFAST),'g')
title('med CONDITION')
xlim([-100 500])
set(gca,'xminortick','on')
box off

subplot(2,2,3)
plot(-100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW),'r', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binMED),'k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binFAST),'g')
title('fast CONDITION')
xlim([-100 500])
%equate_y
set(gca,'xminortick','on')
box off


figure
subplot(2,2,1)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binSLOW),'r', ...
    -100:900,nanmean(allwf_targ.in.med_correct_binSLOW),'k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW),'g')
title('SLOW BINS')
xlim([-100 500])
set(gca,'xminortick','on')
box off

subplot(2,2,2)

plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binMED),'r', ...
    -100:900,nanmean(allwf_targ.in.med_correct_binMED),'k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binMED),'g')
title('med BINS')
xlim([-100 500])
set(gca,'xminortick','on')
box off

subplot(2,2,3)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead_binFAST),'r', ...
    -100:900,nanmean(allwf_targ.in.med_correct_binFAST),'k', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binFAST),'g')
title('fast BINS')
xlim([-100 500])
%equate_y
set(gca,'xminortick','on')
box off


figure
subplot(1,2,1)
plot(-100:900,nanmean(allwf_targ.in.slow_correct_made_dead),'r', ...
    -100:900,nanmean(allwf_targ.in.med_correct_match_slow),'k')
xlim([-100 900])
legend('Slow','Med matched to Slow')
set(gca,'xminortick','on')
box off

subplot(1,2,2)
plot(-100:900,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g', ...
    -100:900,nanmean(allwf_targ.in.med_correct_match_fast),'k')
xlim([-100 900])
legend('Fast','Med matched to Fast')
set(gca,'xminortick','on')
box off


%haveMed = 1:146;
haveMed = find(~isnan(allwf_targ.in.med_correct(:,1)));
figure
subplot(2,2,1)
plot(-100:900,nanmean(allwf_targ.in.med_correct_match_med(haveMed,:)),'k', ...
    -100:900,nanmean(allwf_targ.in.slow_correct_match_med(haveMed,:)),'r', ...
    -100:900,nanmean(allwf_targ.in.fast_correct_match_med(haveMed,:)),'g', ...
    -100:900,nanmean(allwf_targ.out.med_correct_match_med(haveMed,:)),'--k', ...
    -100:900,nanmean(allwf_targ.out.slow_correct_match_med(haveMed,:)),'--r', ...
    -100:900,nanmean(allwf_targ.out.fast_correct_match_med(haveMed,:)),'--g')
xlim([-100 300])
ylim([.3 1.1])
set(gca,'xminortick','on')
box off