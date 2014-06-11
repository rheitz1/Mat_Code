% cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
%[filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%[filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
%[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
%[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');
% 
% 
filename = [filename1 ; filename2 ; filename5 ; filename6];
unit = [unit1 ; unit2 ; unit5 ; unit6];

% dsk
% [filename unit] = textread('QS_MOVE_NEW2.txt','%s %s');

allwf_move.in.slow_correct_made_dead = [];
allwf_move.out.slow_correct_made_dead = [];
allwf_move.in.med_correct = [];
allwf_move.out.med_correct = [];
allwf_move.in.fast_correct_made_dead_withCleared = [];
allwf_move.out.fast_correct_made_dead_withCleared = [];
    
allwf_move.in.slow_errors_made_dead = [];
allwf_move.out.slow_errors_made_dead = [];
allwf_move.in.med_errors = [];
allwf_move.out.med_errors = [];
allwf_move.in.fast_errors_made_dead_withCleared = [];
allwf_move.out.fast_errors_made_dead_withCleared = [];

for file = 1:length(filename)
    
    load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    filename{file}
    
    sig = eval(unit{file});
    
    MF = MFs.(unit{file});
    
    antiMF = mod((MF+4),8);
    %     [~,saccLoc] = getSRT(EyeX_,EyeY_);
    %     clear EyeX_ EyeY_
    
    normalizeSDF = 1;
    
    
    trunc_RT = 2000;
    %plotBaselineBlocks = 0;
    %separate_cleared_nocleared = 0;
    %within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
    %match_variability = 0;
    %plot_integrals = 0;
    %basewin = [400 500]; %baseline correction window for AD channels
    
    %============
    % FIND TRIALS
    %===================================================================
    
    getTrials_SAT
    
    
    
    
    %====================
    % Calculate ACC rates
    %percentage of CORRECT trials that missed the deadline
    prc_missed_slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
    prc_missed_fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
    prc_missed_fast_correct_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));
    
    %ACC rate for made deadlines
    ACC.slow_made_dead(file,1) = length(slow_correct_made_dead) / length(slow_all_made_dead);
    ACC.fast_made_dead_withCleared(file,1) = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
    ACC.fast_made_dead_noCleared(file,1) = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);
    
    
    %ACC rate for missed deadlines
    ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
    ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
    ACC.fast_missed_dead_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);
    
    
    %overall ACC rate for made + missed deadlines
    ACC.slow_made_missed(file,1) = length(slow_correct_made_missed) / length(slow_all);
    ACC.fast_made_missed_withCleared(file,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
    ACC.fast_made_missed_noCleared(file,1) = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);
    
    ACC.med(file,1) = length(med_correct) / length(med_all);
    
    
    RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    RTs.fast_correct_made_dead_noCleared(file,1) = nanmean(SRT(fast_correct_made_dead_noCleared,1));
    
    RTs.slow_correct_missed_dead(file,1) = nanmean(SRT(slow_correct_missed_dead,1));
    RTs.fast_correct_missed_dead_withCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_withCleared,1));
    
    
    RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    RTs.fast_errors_made_dead_noCleared(file,1) = nanmean(SRT(fast_errors_made_dead_noCleared,1));
    
    
    SDF = sSDF(sig,Target_(:,1),[-100 1000]);
    
    if normalizeSDF == 1
        SDF = normalize_SP(SDF);
    end
    
    
    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
    outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
    
    
    %======================
    % Movement-Aligned MF
    %==============
    % CORRECT
    %made dead only
    in.slow_correct_made_dead_MF = intersect(inMF,slow_correct_made_dead);
    out.slow_correct_made_dead_MF = intersect(outMF,slow_correct_made_dead);
    
    in.slow_correct_made_missed_MF = intersect(inMF,slow_correct_made_missed);
    out.slow_correct_made_missed_MF = intersect(outMF,slow_correct_made_missed);
    
    
    in.med_correct_MF = intersect(inMF,med_correct);
    out.med_correct_MF = intersect(outMF,med_correct);
    
    in.med_correct_MF_match_fast = intersect(inMF,med_correct_match_fast);
    out.med_correct_MF_match_fast = intersect(outMF,med_correct_match_fast);
    
    in.med_correct_MF_match_slow = intersect(inMF,med_correct_match_slow);
    out.med_correct_MF_match_slow = intersect(outMF,med_correct_match_slow);
    
    in.med_correct_MF_nomatch = intersect(inMF,med_correct_nomatch);
    out.med_correct_MF_nomatch = intersect(outMF,med_correct_nomatch);
    
    in.med_correct_MF_nomatch_small_sd = intersect(inMF,med_correct_nomatch_small_sd);
    out.med_correct_MF_nomatch_small_sd = intersect(outMF,med_correct_nomatch_small_sd);
    
    in.slow_correct_match_med = intersect(inMF,slow_correct_match_med);
    out.slow_correct_match_med = intersect(outMF,slow_correct_match_med);
    
    %match Neutral condition to its own mean +/- 1 sd (limit variability)
    in.med_correct_match_med = intersect(inMF,med_correct_match_med);
    out.med_correct_match_med = intersect(outMF,med_correct_match_med);
    
    in.fast_correct_match_med = intersect(inMF,fast_correct_match_med);
    out.fast_correct_match_med = intersect(outMF,fast_correct_match_med);
    
    
    in.fast_correct_made_dead_withCleared_MF = intersect(inMF,fast_correct_made_dead_withCleared);
    out.fast_correct_made_dead_withCleared_MF = intersect(outMF,fast_correct_made_dead_withCleared);
    
    in.fast_correct_made_missed_withCleared_MF = intersect(inMF,fast_correct_made_missed_withCleared);
    out.fast_correct_made_missed_withCleared_MF = intersect(outMF,fast_correct_made_missed_withCleared);
    
    
    %     in.fast_correct_made_dead_noCleared_MF = intersect(inMF,fast_correct_made_dead_noCleared);
    %     out.fast_correct_made_dead_noCleared_MF = intersect(outMF,fast_correct_made_dead_noCleared);
    
    
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
    
    %     in.fast_correct_made_dead_noCleared_MF_binFAST = intersect(inMF,fast_correct_made_dead_noCleared_binFAST);
    %     out.fast_correct_made_dead_noCleared_MF_binFAST = intersect(outMF,fast_correct_made_dead_noCleared_binFAST);
    %     in.fast_correct_made_dead_noCleared_MF_binMED = intersect(inMF,fast_correct_made_dead_noCleared_binMED);
    %     out.fast_correct_made_dead_noCleared_MF_binMED = intersect(outMF,fast_correct_made_dead_noCleared_binMED);
    %     in.fast_correct_made_dead_noCleared_MF_binSLOW = intersect(inMF,fast_correct_made_dead_noCleared_binSLOW);
    %     out.fast_correct_made_dead_noCleared_MF_binSLOW = intersect(outMF,fast_correct_made_dead_noCleared_binSLOW);
    
    %=============================
    
    
    
    %missed dead only
    in.slow_correct_missed_dead_MF = intersect(inMF,slow_correct_missed_dead);
    out.slow_correct_missed_dead_MF = intersect(outMF,slow_correct_missed_dead);
    
    in.fast_correct_missed_dead_withCleared_MF = intersect(inMF,fast_correct_missed_dead_withCleared);
    out.fast_correct_missed_dead_withCleared_MF = intersect(outMF,fast_correct_missed_dead_withCleared);
    
    %     in.fast_correct_missed_dead_noCleared_MF = intersect(inMF,fast_correct_missed_dead_noCleared);
    %     out.fast_correct_missed_dead_noCleared_MF = intersect(outMF,fast_correct_missed_dead_noCleared);
    
    
    
    %==============
    % ERRORS
    %made dead only
    in.slow_errors_made_dead_MF = intersect(inMF_err,slow_errors_made_dead);
    out.slow_errors_made_dead_MF = intersect(outMF_err,slow_errors_made_dead);
    
    in.med_errors_MF = intersect(inMF_err,med_errors);
    out.med_errors_MF = intersect(outMF_err,med_errors);
    
    in.fast_errors_made_dead_withCleared_MF = intersect(inMF_err,fast_errors_made_dead_withCleared);
    out.fast_errors_made_dead_withCleared_MF = intersect(outMF_err,fast_errors_made_dead_withCleared);
    
    in.fast_errors_made_dead_noCleared_MF = intersect(inMF_err,fast_errors_made_dead_noCleared);
    out.fast_errors_made_dead_noCleared_MF = intersect(outMF_err,fast_errors_made_dead_noCleared);
    
    %missed dead only
    in.slow_errors_missed_dead_MF = intersect(inMF_err,slow_errors_missed_dead);
    out.slow_errors_missed_dead_MF = intersect(outMF_err,slow_errors_missed_dead);
    
    in.fast_errors_missed_dead_withCleared_MF = intersect(inMF_err,fast_errors_missed_dead_withCleared);
    out.fast_errors_missed_dead_withCleared_MF = intersect(outMF_err,fast_errors_missed_dead_withCleared);
    
    %     in.fast_errors_missed_dead_noCleared_MF = intersect(inMF_err,fast_errors_missed_dead_noCleared);
    %     out.fast_errors_missed_dead_noCleared_MF = intersect(outMF_err,fast_errors_missed_dead_noCleared);
    
    
    %====================================
    %====================================
    % Keep track of infos & waveforms
    %Plot_Time_targ = Plot_Time;
    %Plot_Time_resp = -400:200;
    
    %Correct made dead
    allwf_move.in.slow_correct_made_dead = [allwf_move.in.slow_correct_made_dead ; SDF(in.slow_correct_made_dead_MF,:)];
    allwf_move.out.slow_correct_made_dead = [allwf_move.out.slow_correct_made_dead ; SDF(out.slow_correct_made_dead_MF,:)];
    
        
    allwf_move.in.med_correct = [allwf_move.in.med_correct ; SDF(in.med_correct_MF,:)];
    allwf_move.out.med_correct = [allwf_move.out.med_correct ; SDF(out.med_correct_MF,:)];
        
    
    allwf_move.in.fast_correct_made_dead_withCleared = [allwf_move.in.fast_correct_made_dead_withCleared ; SDF(in.fast_correct_made_dead_withCleared_MF,:)];
    allwf_move.out.fast_correct_made_dead_withCleared = [allwf_move.out.fast_correct_made_dead_withCleared ; SDF(out.fast_correct_made_dead_withCleared_MF,:)];
    
    if length(in.slow_errors_made_dead_MF) > 1 && length(out.slow_errors_made_dead_MF) > 1
        allwf_move.in.slow_errors_made_dead = [allwf_move.in.slow_errors_made_dead ; SDF(in.slow_errors_made_dead_MF,:)];
        allwf_move.out.slow_errors_made_dead = [allwf_move.out.slow_errors_made_dead ; SDF(out.slow_errors_made_dead_MF,:)];
    end
    
    if length(in.med_errors_MF) > 1 && length(out.med_errors_MF) > 1
        allwf_move.in.med_errors = [allwf_move.in.med_errors ; SDF(in.med_errors_MF,:)];
        allwf_move.out.med_errors = [allwf_move.out.med_errors ; SDF(out.med_errors_MF,:)];
    end
    
    if length(in.fast_errors_made_dead_withCleared_MF) > 1 && length(out.fast_errors_made_dead_withCleared_MF) > 1
        allwf_move.in.fast_errors_made_dead_withCleared = [allwf_move.in.fast_errors_made_dead_withCleared ; SDF(in.fast_errors_made_dead_withCleared_MF,:)];
        allwf_move.out.fast_errors_made_dead_withCleared = [allwf_move.out.fast_errors_made_dead_withCleared ; SDF(out.fast_errors_made_dead_withCleared_MF,:)];
    end
    
    
    keep filename unit file allwf_move Plot_Time_targ ACC RTs sigThresh
    
end

