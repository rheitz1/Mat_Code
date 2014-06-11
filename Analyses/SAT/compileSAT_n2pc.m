cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
% [filename3] = textread('SAT_Beh_Med_S.txt','%s');
% [filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];


for file = 1:length(filename)
    try
    load(filename{file},'AD02','Hemi','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    filename{file}
    
    catch
        disp('File not found... moving on')
        keep filename file allwf_targ allTDT
        continue
    end
    
    
    try
    sig = AD02;
    catch
        disp('No EEG found... moving on')
        keep filename file allwf_targ allTDT
        continue
    end
    
    
    RF = [3 4 5];
    %     antiRF
    %     if Hemi.(unit{file}) == 'L'
    %         RF = [7 0 1];
    %        % RF = [0 1 2 3 4 5 6 7];
    %     elseif Hemi.(unit{file}) == 'R'
    %         RF = [3 4 5];
    %        % RF = [0 1 2 3 4 5 6 7];
    %     end
    %
    antiRF = mod((RF+4),8);
    
    
    %Options
    normalizeAD = 0;
    baseline_correct_AD = 1;
    %basewin = [Target_(1,1)-1000 Target_(1,1)-900];
    basewin = [Target_(1,1)-150 Target_(1,1)-50];
    JackKnife_TDT_test = 0;
    truncate_at_RT = 1;
    
    
    sig = fixClipped(sig,[3000 3800],50);
    
    if truncate_at_RT
        sig = truncateAD_targ(sig,SRT,10);
    end
    
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
    
    
    %baseline_correct
    if baseline_correct_AD
        sig_bc = baseline_correct(sig,basewin);
    else
        sig_bc = sig;
    end
    
    if normalizeAD == 1
        %normalize by the MIN of the MEAN (the negative deflection) so that it ranges to 1 for all AD
        %channels.  Do this irrespective of trial type so condition effects remain
        
        %to focus on initial transient, normalize using min average value <
        %100 ms
        mi = nanmin(nanmean(sig(:,3500:3600)));
        mi_bc = nanmin(nanmean(sig_bc(:,3500:3600)));
        
        sig = sig ./ mi;
        sig_bc = sig_bc ./ mi_bc;
        
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
    
    
    
    
    TDT.slow_correct_made_dead = getTDT_AD(sig_bc,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF);
    TDT.fast_correct_made_dead_withCleared = getTDT_AD(sig_bc,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF);
    TDT.med_correct = getTDT_AD(sig_bc,in.med_correct_RF,out.med_correct_RF);
    
    %     ROC.slow_correct_made_dead = getROC(SDF,in.slow_correct_made_dead_RF,out.slow_correct_made_dead_RF,1);
    %     ROC.med_correct = getROC(SDF,in.med_correct_RF,out.med_correct_RF,1);
    %     ROC.fast_correct_made_dead_withCleared = getROC(SDF,in.fast_correct_made_dead_withCleared_RF,out.fast_correct_made_dead_withCleared_RF,1);
    
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
    allTDT.med_correct(file,1) = TDT.med_correct;
    
    %     allROC.slow_correct_made_dead(file,1:1001) = ROC.slow_correct_made_dead;
    %     allROC.med_correct(file,1:1001) = ROC.med_correct;
    %     allROC.fast_correct_made_dead_withCleared(file,1:1001) = ROC.fast_correct_made_dead_withCleared;
    
    if JackKnife_TDT_test
        [TDT.jack_slow_vs_fast(file,1:2) t_obt(file,1) p(file,1)] = getJackKnife_TDT(-3500:2500,sig_bc(in.slow_correct_made_dead_RF,:),sig_bc(out.slow_correct_made_dead_RF,:),sig_bc(in.fast_correct_made_dead_withCleared_RF,:),sig_bc(out.fast_correct_made_dead_withCleared_RF,:));
    end
    
    allwf_targ.all.slow_all(file,:) = nanmean(sig_bc(slow_all,:));
    allwf_targ.all.med_all(file,:) = nanmean(sig_bc(med_all,:));
    allwf_targ.all.fast_all_withCleared(file,:) = nanmean(sig_bc(fast_all_withCleared,:));
    
    %Correct made dead
    allwf_targ.in.slow_correct_made_dead(file,:) = nanmean(sig_bc(in.slow_correct_made_dead_RF,:));
    allwf_targ.out.slow_correct_made_dead(file,:) = nanmean(sig_bc(out.slow_correct_made_dead_RF,:));
    allwf_targ.in.slow_correct_made_missed(file,:) = nanmean(sig_bc(in.slow_correct_made_missed_RF,:));
    allwf_targ.out.slow_correct_made_missed(file,:) = nanmean(sig_bc(out.slow_correct_made_missed_RF,:));
    
    allwf_targ.in.slow_correct_made_dead_binFAST(file,:) = nanmean(sig_bc(in.slow_correct_made_dead_RF_binFAST,:));
    allwf_targ.out.slow_correct_made_dead_binFAST(file,:) = nanmean(sig_bc(out.slow_correct_made_dead_RF_binFAST,:));
    allwf_targ.in.slow_correct_made_dead_binMED(file,:) = nanmean(sig_bc(in.slow_correct_made_dead_RF_binMED,:));
    allwf_targ.out.slow_correct_made_dead_binMED(file,:) = nanmean(sig_bc(out.slow_correct_made_dead_RF_binMED,:));
    allwf_targ.in.slow_correct_made_dead_binSLOW(file,:) = nanmean(sig_bc(in.slow_correct_made_dead_RF_binSLOW,:));
    allwf_targ.out.slow_correct_made_dead_binSLOW(file,:) = nanmean(sig_bc(out.slow_correct_made_dead_RF_binSLOW,:));
    
    allwf_targ.in.med_correct(file,:) = nanmean(sig_bc(in.med_correct_RF,:));
    allwf_targ.out.med_correct(file,:) = nanmean(sig_bc(out.med_correct_RF,:));
    allwf_targ.in.med_correct_binFAST(file,:) = nanmean(sig_bc(in.med_correct_RF_binFAST,:));
    allwf_targ.out.med_correct_binFAST(file,:) = nanmean(sig_bc(out.med_correct_RF_binFAST,:));
    allwf_targ.in.med_correct_binMED(file,:) = nanmean(sig_bc(in.med_correct_RF_binMED,:));
    allwf_targ.out.med_correct_binMED(file,:) = nanmean(sig_bc(out.med_correct_RF_binMED,:));
    allwf_targ.in.med_correct_binSLOW(file,:) = nanmean(sig_bc(in.med_correct_RF_binSLOW,:));
    allwf_targ.out.med_correct_biSLOW(file,:) = nanmean(sig_bc(out.med_correct_RF_binSLOW,:));
%     
%     allwf_targ.in.med_correct_match_slow(file,:) = nanmean(sig_bc(in.med_correct_RF_match_slow,:));
%     allwf_targ.out.med_correct_match_slow(file,:) = nanmean(sig_bc(out.med_correct_RF_match_slow,:));
%     
%     allwf_targ.in.med_correct_match_fast(file,:) = nanmean(sig_bc(in.med_correct_RF_match_fast,:));
%     allwf_targ.out.med_correct_match_fast(file,:) = nanmean(sig_bc(out.med_correct_RF_match_fast,:));
%     
%     allwf_targ.in.med_correct_nomatch(file,:) = nanmean(sig_bc(in.med_correct_RF_nomatch,:));
%     allwf_targ.out.med_correct_nomatch(file,:) = nanmean(sig_bc(out.med_correct_RF_nomatch,:));
%     
%     allwf_targ.in.med_correct_nomatch_small_sd(file,:) = nanmean(sig_bc(in.med_correct_RF_nomatch_small_sd,:));
%     allwf_targ.out.med_correct_nomatch_small_sd(file,:) = nanmean(sig_bc(out.med_correct_RF_nomatch_small_sd,:));
%     
%     allwf_targ.in.slow_correct_match_med(file,:) = nanmean(sig_bc(in.slow_correct_match_med,:));
%     allwf_targ.out.slow_correct_match_med(file,:) = nanmean(sig_bc(out.slow_correct_match_med,:));
%     
%     allwf_targ.in.med_correct_match_med(file,:) = nanmean(sig_bc(in.med_correct_match_med,:));
%     allwf_targ.out.med_correct_match_med(file,:) = nanmean(sig_bc(out.med_correct_match_med,:));
%     
%     allwf_targ.in.fast_correct_match_med(file,:) = nanmean(sig_bc(in.fast_correct_match_med,:));
%     allwf_targ.out.fast_correct_match_med(file,:) = nanmean(sig_bc(out.fast_correct_match_med,:));
%     
    
    allwf_targ.in.fast_correct_made_dead_withCleared(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_withCleared_RF,:));
    allwf_targ.out.fast_correct_made_dead_withCleared(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_withCleared_RF,:));
    
    allwf_targ.in.fast_correct_made_missed_withCleared(file,:) = nanmean(sig_bc(in.fast_correct_made_missed_withCleared_RF,:));
    allwf_targ.out.fast_correct_made_missed_withCleared(file,:) = nanmean(sig_bc(out.fast_correct_made_missed_withCleared_RF,:));
    
    allwf_targ.in.fast_correct_made_dead_withCleared_binFAST(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_withCleared_RF_binFAST,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binFAST(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_withCleared_RF_binFAST,:));
    allwf_targ.in.fast_correct_made_dead_withCleared_binMED(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_withCleared_RF_binMED,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binMED(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_withCleared_RF_binMED,:));
    allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_withCleared_RF_binSLOW,:));
    allwf_targ.out.fast_correct_made_dead_withCleared_binSLOW(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_withCleared_RF_binSLOW,:));
    
    %     allwf_targ.in.fast_correct_made_dead_noCleared(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_noCleared_RF,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_noCleared_RF,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binFAST(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_noCleared_RF_binFAST,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binFAST(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_noCleared_RF_binFAST,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binMED(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_noCleared_RF_binMED,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binMED(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_noCleared_RF_binMED,:));
    %     allwf_targ.in.fast_correct_made_dead_noCleared_binSLOW(file,:) = nanmean(sig_bc(in.fast_correct_made_dead_noCleared_RF_binSLOW,:));
    %     allwf_targ.out.fast_correct_made_dead_noCleared_binSLOW(file,:) = nanmean(sig_bc(out.fast_correct_made_dead_noCleared_RF_binSLOW,:));
    
    %Errors made dead
    allwf_targ.in.slow_errors_made_dead(file,:) = nanmean(sig_bc(in.slow_errors_made_dead_RF,:),1);
    allwf_targ.out.slow_errors_made_dead(file,:) = nanmean(sig_bc(out.slow_errors_made_dead_RF,:),1);
    
    allwf_targ.in.med_errors(file,:) = nanmean(sig_bc(in.med_errors_RF,:),1);
    allwf_targ.out.med_errors(file,:) = nanmean(sig_bc(out.med_errors_RF,:),1);
    
    allwf_targ.in.fast_errors_made_dead_withCleared(file,:) = nanmean(sig_bc(in.fast_errors_made_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_errors_made_dead_withCleared(file,:) = nanmean(sig_bc(out.fast_errors_made_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_errors_made_dead_noCleared(file,:) = nanmean(sig_bc(in.fast_errors_made_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_errors_made_dead_noCleared(file,:) = nanmean(sig_bc(out.fast_errors_made_dead_noCleared_RF,:),1);
    
    
    %Correct missed dead
    allwf_targ.in.slow_correct_missed_dead(file,:) = nanmean(sig_bc(in.slow_correct_missed_dead_RF,:),1);
    allwf_targ.out.slow_correct_missed_dead(file,:) = nanmean(sig_bc(out.slow_correct_missed_dead_RF,:),1);
    
    allwf_targ.in.fast_correct_missed_dead_withCleared(file,:) = nanmean(sig_bc(in.fast_correct_missed_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_correct_missed_dead_withCleared(file,:) = nanmean(sig_bc(out.fast_correct_missed_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_correct_missed_dead_noCleared(file,:) = nanmean(sig_bc(in.fast_correct_missed_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_correct_missed_dead_noCleared(file,:) = nanmean(sig_bc(out.fast_correct_missed_dead_noCleared_RF,:),1);
    
    %Errors missed dead
    allwf_targ.in.slow_errors_missed_dead(file,:) = nanmean(sig_bc(in.slow_errors_missed_dead_RF,:),1);
    allwf_targ.out.slow_errors_missed_dead(file,:) = nanmean(sig_bc(out.slow_errors_missed_dead_RF,:),1);
    
    allwf_targ.in.fast_errors_missed_dead_withCleared(file,:) = nanmean(sig_bc(in.fast_errors_missed_dead_withCleared_RF,:),1);
    allwf_targ.out.fast_errors_missed_dead_withCleared(file,:) = nanmean(sig_bc(out.fast_errors_missed_dead_withCleared_RF,:),1);
    
    %     allwf_targ.in.fast_errors_missed_dead_noCleared(file,:) = nanmean(sig_bc(in.fast_errors_missed_dead_noCleared_RF,:),1);
    %     allwf_targ.out.fast_errors_missed_dead_noCleared(file,:) = nanmean(sig_bc(out.fast_errors_missed_dead_noCleared_RF,:),1);
    
    %Test mean activity ? ms post target onset between Slow and Fast conditions
    % two-group test because different numbers of trials w/i each condition
    % REMOVE 0'S
    test_time = 540:570;
    %test_time = 350:400;
    %test_time = 200:250;
    %test_time = 225:250;
    testX = nanmean(sig_bc(in.slow_correct_made_dead_RF,test_time),2);
    testY = nanmean(sig_bc(in.fast_correct_made_dead_withCleared_RF,test_time),2);
    testX(find(testX == 0)) = NaN;
    testY(find(testY == 0)) = NaN;
    testX = removeNaN(testX);
    testY = removeNaN(testY);
    sigAct.slow_vs_fast(file,1) = ttest2(testX,testY);
    
    
    keep filename unit file all* Plot_Time_targ ACC RTs sigAct
    
end






%FAST vs SLOW MADE DEADLINES
% figure
% %fon
% %subplot(2,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_correct_made_dead),'--r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct),'k',-3500:2500,nanmean(allwf_targ.out.med_correct),'--k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_correct_made_dead_withCleared),'--g')
% xlim([-100 300])
% title('Correct made Deadline')
% vline(nanmean(allTDT.slow_correct_made_dead),'r')
% vline(nanmean(allTDT.med_correct),'k')
% vline(nanmean(allTDT.fast_correct_made_dead_withCleared),'g')
% set(gca,'xminortick','on')
% axis ij
% box off


figure
%fon
%subplot(2,2,1)
plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_correct_made_dead),'--r', ...
    -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_correct_made_dead_withCleared),'--g')
xlim([-100 300])
title('Correct made Deadline')
vline(nanmean(nonzeros(allTDT.slow_correct_made_dead)),'r')
vline(nanmean(nonzeros(allTDT.fast_correct_made_dead_withCleared)),'g')
set(gca,'xminortick','on')
axis ij
box off








% subplot(2,2,2)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_errors_made_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_errors_made_dead),'--r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_errors),'k',-3500:2500,nanmean(allwf_targ.out.med_errors),'--k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_errors_made_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_errors_made_dead_withCleared),'--g')
% xlim([-100 300])
% title('Errors made Deadline')
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,3)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_missed_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_correct_missed_dead),'--r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct),'k',-3500:2500,nanmean(allwf_targ.out.med_correct),'--k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_missed_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_correct_missed_dead_withCleared),'--g')
% xlim([-100 300])
% title('Correct missed Deadline')
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,4)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_errors_missed_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_errors_missed_dead),'--r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_errors),'k',-3500:2500,nanmean(allwf_targ.out.med_errors),'--k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_errors_missed_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_errors_missed_dead_withCleared),'--g')
% xlim([-100 300])
% title('Errors missed Deadline')
% set(gca,'xminortick','on')
% box off
% 
% equate_y
% subplot(2,2,1)
% legend('Slow IN','Slow OUT','Fast IN','Fast OUT','location','northwest')
% 
% %MADE vs MISSED DEADLINES
% figure
% fon
% subplot(2,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_correct_made_dead),'--r', 'linewidth',2)
% hold on
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_missed_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_correct_missed_dead),'--r')
% xlim([-100 500])
% title('SLOW CORRECT')
% set(gca,'xminortick','on')
% box off
% 
% 
% subplot(2,2,2)
% plot(-3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_correct_made_dead_withCleared),'--g', 'linewidth',2)
% hold on
% plot(-3500:2500,nanmean(allwf_targ.in.fast_correct_missed_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_correct_missed_dead_withCleared),'--g')
% xlim([-100 500])
% title('FAST CORRECT')
% set(gca,'xminortick','on')
% box off
% 
% 
% subplot(2,2,3)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_errors_made_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_errors_made_dead),'--r', 'linewidth',2)
% hold on
% plot(-3500:2500,nanmean(allwf_targ.in.slow_errors_missed_dead),'r',-3500:2500,nanmean(allwf_targ.out.slow_errors_missed_dead),'--r')
% xlim([-100 500])
% title('SLOW ERRORS')
% set(gca,'xminortick','on')
% box off
% 
% 
% subplot(2,2,4)
% plot(-3500:2500,nanmean(allwf_targ.in.fast_errors_made_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_errors_made_dead_withCleared),'--g', 'linewidth',2)
% hold on
% plot(-3500:2500,nanmean(allwf_targ.in.fast_errors_missed_dead_withCleared),'g',-3500:2500,nanmean(allwf_targ.out.fast_errors_missed_dead_withCleared),'--g')
% xlim([-100 500])
% title('FAST ERRORS')
% set(gca,'xminortick','on')
% box off
% 
% equate_y
% 
% subplot(2,2,1)
% legend('Correct IN MADE','Correct OUT MADE','Correct IN MISSED','Correct OUT MISSED','location','northwest')
% 
% 
% 
% figure
% subplot(2,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binSLOW),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binMED),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binFAST),'g')
% title('SLOW CONDITION')
% xlim([-100 500])
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,2)
% 
% plot(-3500:2500,nanmean(allwf_targ.in.med_correct_binSLOW),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_binMED),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_binFAST),'g')
% title('med CONDITION')
% xlim([-100 500])
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,3)
% plot(-3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binMED),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binFAST),'g')
% title('fast CONDITION')
% xlim([-100 500])
% equate_y
% set(gca,'xminortick','on')
% box off
% 
% 
% figure
% subplot(2,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binSLOW),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_binSLOW),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binSLOW),'g')
% title('SLOW BINS')
% xlim([-100 500])
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,2)
% 
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binMED),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_binMED),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binMED),'g')
% title('med BINS')
% xlim([-100 500])
% set(gca,'xminortick','on')
% box off
% 
% subplot(2,2,3)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead_binFAST),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_binFAST),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared_binFAST),'g')
% title('fast BINS')
% xlim([-100 500])
% equate_y
% set(gca,'xminortick','on')
% box off
% 
% 
% figure
% subplot(1,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.slow_correct_made_dead),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_match_slow),'k')
% xlim([-100 900])
% legend('Slow','Med matched to Slow')
% set(gca,'xminortick','on')
% box off
% 
% subplot(1,2,2)
% plot(-3500:2500,nanmean(allwf_targ.in.fast_correct_made_dead_withCleared),'g', ...
%     -3500:2500,nanmean(allwf_targ.in.med_correct_match_fast),'k')
% xlim([-100 900])
% legend('Fast','Med matched to Fast')
% set(gca,'xminortick','on')
% box off
% 
% 
% %haveMed = 1:146;
% haveMed = find(~isnan(allwf_targ.in.med_correct(:,1)));
% figure
% subplot(2,2,1)
% plot(-3500:2500,nanmean(allwf_targ.in.med_correct_match_med(haveMed,:)),'k', ...
%     -3500:2500,nanmean(allwf_targ.in.slow_correct_match_med(haveMed,:)),'r', ...
%     -3500:2500,nanmean(allwf_targ.in.fast_correct_match_med(haveMed,:)),'g', ...
%     -3500:2500,nanmean(allwf_targ.out.med_correct_match_med(haveMed,:)),'--k', ...
%     -3500:2500,nanmean(allwf_targ.out.slow_correct_match_med(haveMed,:)),'--r', ...
%     -3500:2500,nanmean(allwf_targ.out.fast_correct_match_med(haveMed,:)),'--g')
% xlim([-100 300])
% ylim([.3 1.1])
% set(gca,'xminortick','on')
% box off

