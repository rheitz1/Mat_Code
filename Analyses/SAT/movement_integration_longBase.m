cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename5 ; filename6 ; filename7 ; filename8];
unit = [unit5 ; unit6 ; unit7 ; unit8];

leak = .01

%Note on extreme leakages
%leak = 0 : integration without leakage
%leak = 1 : instantaneous read-out (will be SDFs w/o leaky integration)

%leak = .001:.001:.1;


%Low-End of Leakage (step size larger than before)
% leak = .11:.01:.2;
% leak = .21:.01:.3;
% leak = .31:.01:.4;
% leak = .41:.01:.5;
% leak = .51:.01:.6;
% leak = .61:.01:.7;
% leak = .71:.01:.8;
% leak = .81:.01:.9;
% leak = .91:.01:1;


% leak = .001:.001:.01;     % LOWEST LEAKAGE: TIME CONSTANTS ~1000 MS
% leak = .011:.001:.02;
% leak = .021:.001:.03;
% leak = .031:.001:.04;
% leak = .041:.001:.05;
% leak = .051:.001:.06;
% leak = .061:.001:.07;
% leak = .071:.001:.08;
% leak = .081:.001:.09;
% leak = .091:.001:.10;     % HIGHEST LEAKAGE: TIME CONSTANTS ~ 10 MS

cd /volumes/Dump/Search_Data_SAT_longBase/

for k = 1:length(leak)
    
    disp(['Running leakage = ' mat2str(leak(k))])
    leakage = leak(k);
    
    for file = 1:length(filename)
        
        load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
        filename{file}
        
        MF = MFs.(unit{file});

        sig = eval(unit{file});
        
        antiMF = mod((MF+4),8);
        %     [~,saccLoc] = getSRT(EyeX_,EyeY_);
        %     clear EyeX_ EyeY_
        
        normalize = 1;
        
        trunc_RT = 2000;
        plotBaselineBlocks = 0;
        separate_cleared_nocleared = 0;
        within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
        match_variability = 0;
        plot_integrals = 0;
        basewin = [400 500]; %baseline correction window for AD channels
        
        %============
        % FIND TRIALS
        %===================================================================
        getTrials_SAT
        
        
        %====================
        % Calculate ACC rates
        %percentage of CORRECT trials that missed the deadline
        prc_missed_slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
        prc_missed_fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
        
        %ACC rate for made deadlines
        ACC.slow_made_dead(file,1) = length(slow_correct_made_dead) / length(slow_all_made_dead);
        ACC.fast_made_dead_withCleared(file,1) = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
        
        
        %ACC rate for missed deadlines
        ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
        ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
        
        
        %overall ACC rate for made + missed deadlines
        ACC.slow_made_missed(file,1) = length(slow_correct_made_missed) / length(slow_all);
        ACC.fast_made_missed_withCleared(file,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
        
        
        ACC.med(file,1) = length(med_correct) / length(med_all);
        
        
        RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
        RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
        RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
        
        
        RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
        RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
        RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
        
        
        
        inMF = find(ismember(Target_(:,2),MF));
        outMF = find(ismember(Target_(:,2),antiMF));
        inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
        outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
        
        
        %======================
        % Movement-Aligned MF
        %==============
        % CORRECT
        %made dead only
        in.slow_correct_made_dead = intersect(inMF,slow_correct_made_dead);
        out.slow_correct_made_dead = intersect(outMF,slow_correct_made_dead);
        
        in.med_correct = intersect(inMF,med_correct);
        out.med_correct = intersect(outMF,med_correct);
        
        
        in.fast_correct_made_dead_withCleared = intersect(inMF,fast_correct_made_dead_withCleared);
        out.fast_correct_made_dead_withCleared = intersect(outMF,fast_correct_made_dead_withCleared);
        
        in.fast_correct_made_dead_noCleared = intersect(inMF,fast_correct_made_dead_noCleared);
        out.fast_correct_made_dead_noCleared = intersect(outMF,fast_correct_made_dead_noCleared);
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
        in.slow_correct_made_dead_binFAST = intersect(inMF,slow_correct_made_dead_binFAST);
        out.slow_correct_made_dead_binFAST = intersect(outMF,slow_correct_made_dead_binFAST);
        in.slow_correct_made_dead_binMED = intersect(inMF,slow_correct_made_dead_binMED);
        out.slow_correct_made_dead_binMED = intersect(outMF,slow_correct_made_dead_binMED);
        in.slow_correct_made_dead_binSLOW = intersect(inMF,slow_correct_made_dead_binSLOW);
        out.slow_correct_made_dead_binSLOW = intersect(outMF,slow_correct_made_dead_binSLOW);
        
        in.med_correct_binFAST = intersect(inMF,med_correct_binFAST);
        out.med_correct_binFAST = intersect(outMF,med_correct_binFAST);
        in.med_correct_binMED = intersect(inMF,med_correct_binMED);
        out.med_correct_binMED = intersect(outMF,med_correct_binMED);
        in.med_correct_binSLOW = intersect(inMF,med_correct_binSLOW);
        out.med_correct_binSLOW = intersect(outMF,med_correct_binSLOW);
        
        in.fast_correct_made_dead_withCleared_binFAST = intersect(inMF,fast_correct_made_dead_withCleared_binFAST);
        out.fast_correct_made_dead_withCleared_binFAST = intersect(outMF,fast_correct_made_dead_withCleared_binFAST);
        in.fast_correct_made_dead_withCleared_binMED = intersect(inMF,fast_correct_made_dead_withCleared_binMED);
        out.fast_correct_made_dead_withCleared_binMED = intersect(outMF,fast_correct_made_dead_withCleared_binMED);
        in.fast_correct_made_dead_withCleared_binSLOW = intersect(inMF,fast_correct_made_dead_withCleared_binSLOW);
        out.fast_correct_made_dead_withCleared_binSLOW = intersect(outMF,fast_correct_made_dead_withCleared_binSLOW);
        
        
        
        in.slow_errors_made_dead = intersect(inMF,slow_errors_made_dead);
        out.slow_errors_made_dead = intersect(outMF,slow_errors_made_dead);
        
        in.med_errors = intersect(inMF,med_errors);
        out.med_errors = intersect(outMF,med_errors);
        
        
        in.fast_errors_made_dead_withCleared = intersect(inMF,fast_errors_made_dead_withCleared);
        out.fast_errors_made_dead_withCleared = intersect(outMF,fast_errors_made_dead_withCleared);
        
        
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
        in.slow_errors_made_dead_binFAST = intersect(inMF,slow_errors_made_dead_binFAST);
        out.slow_errors_made_dead_binFAST = intersect(outMF,slow_errors_made_dead_binFAST);
        in.slow_errors_made_dead_binMED = intersect(inMF,slow_errors_made_dead_binMED);
        out.slow_errors_made_dead_binMED = intersect(outMF,slow_errors_made_dead_binMED);
        in.slow_errors_made_dead_binSLOW = intersect(inMF,slow_errors_made_dead_binSLOW);
        out.slow_errors_made_dead_binSLOW = intersect(outMF,slow_errors_made_dead_binSLOW);
        
        in.med_errors_binFAST = intersect(inMF,med_errors_binFAST);
        out.med_errors_binFAST = intersect(outMF,med_errors_binFAST);
        in.med_errors_binMED = intersect(inMF,med_errors_binMED);
        out.med_errors_binMED = intersect(outMF,med_errors_binMED);
        in.med_errors_binSLOW = intersect(inMF,med_errors_binSLOW);
        out.med_errors_binSLOW = intersect(outMF,med_errors_binSLOW);
        
        in.fast_errors_made_dead_withCleared_binFAST = intersect(inMF,fast_errors_made_dead_withCleared_binFAST);
        out.fast_errors_made_dead_withCleared_binFAST = intersect(outMF,fast_errors_made_dead_withCleared_binFAST);
        in.fast_errors_made_dead_withCleared_binMED = intersect(inMF,fast_errors_made_dead_withCleared_binMED);
        out.fast_errors_made_dead_withCleared_binMED = intersect(outMF,fast_errors_made_dead_withCleared_binMED);
        in.fast_errors_made_dead_withCleared_binSLOW = intersect(inMF,fast_errors_made_dead_withCleared_binSLOW);
        out.fast_errors_made_dead_withCleared_binSLOW = intersect(outMF,fast_errors_made_dead_withCleared_binSLOW);
        
        %made dead only
        in.slow_correct_missed_dead = intersect(inMF,slow_correct_missed_dead);
        out.slow_correct_missed_dead = intersect(outMF,slow_correct_missed_dead);
        
        in.med_correct = intersect(inMF,med_correct);
        out.med_correct = intersect(outMF,med_correct);
        
        
        in.fast_correct_missed_dead_withCleared = intersect(inMF,fast_correct_missed_dead_withCleared);
        out.fast_correct_missed_dead_withCleared = intersect(outMF,fast_correct_missed_dead_withCleared);
        
        in.fast_correct_missed_dead_noCleared = intersect(inMF,fast_correct_missed_dead_noCleared);
        out.fast_correct_missed_dead_noCleared = intersect(outMF,fast_correct_missed_dead_noCleared);
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
        in.slow_correct_missed_dead_binFAST = intersect(inMF,slow_correct_missed_dead_binFAST);
        out.slow_correct_missed_dead_binFAST = intersect(outMF,slow_correct_missed_dead_binFAST);
        in.slow_correct_missed_dead_binMED = intersect(inMF,slow_correct_missed_dead_binMED);
        out.slow_correct_missed_dead_binMED = intersect(outMF,slow_correct_missed_dead_binMED);
        in.slow_correct_missed_dead_binSLOW = intersect(inMF,slow_correct_missed_dead_binSLOW);
        out.slow_correct_missed_dead_binSLOW = intersect(outMF,slow_correct_missed_dead_binSLOW);
        
        in.med_correct_binFAST = intersect(inMF,med_correct_binFAST);
        out.med_correct_binFAST = intersect(outMF,med_correct_binFAST);
        in.med_correct_binMED = intersect(inMF,med_correct_binMED);
        out.med_correct_binMED = intersect(outMF,med_correct_binMED);
        in.med_correct_binSLOW = intersect(inMF,med_correct_binSLOW);
        out.med_correct_binSLOW = intersect(outMF,med_correct_binSLOW);
        
        in.fast_correct_missed_dead_withCleared_binFAST = intersect(inMF,fast_correct_missed_dead_withCleared_binFAST);
        out.fast_correct_missed_dead_withCleared_binFAST = intersect(outMF,fast_correct_missed_dead_withCleared_binFAST);
        in.fast_correct_missed_dead_withCleared_binMED = intersect(inMF,fast_correct_missed_dead_withCleared_binMED);
        out.fast_correct_missed_dead_withCleared_binMED = intersect(outMF,fast_correct_missed_dead_withCleared_binMED);
        in.fast_correct_missed_dead_withCleared_binSLOW = intersect(inMF,fast_correct_missed_dead_withCleared_binSLOW);
        out.fast_correct_missed_dead_withCleared_binSLOW = intersect(outMF,fast_correct_missed_dead_withCleared_binSLOW);
        
        
        
        in.slow_errors_missed_dead = intersect(inMF,slow_errors_missed_dead);
        out.slow_errors_missed_dead = intersect(outMF,slow_errors_missed_dead);
        
        in.med_errors = intersect(inMF,med_errors);
        out.med_errors = intersect(outMF,med_errors);
        
        
        in.fast_errors_missed_dead_withCleared = intersect(inMF,fast_errors_missed_dead_withCleared);
        out.fast_errors_missed_dead_withCleared = intersect(outMF,fast_errors_missed_dead_withCleared);
        
        
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
        in.slow_errors_missed_dead_binFAST = intersect(inMF,slow_errors_missed_dead_binFAST);
        out.slow_errors_missed_dead_binFAST = intersect(outMF,slow_errors_missed_dead_binFAST);
        in.slow_errors_missed_dead_binMED = intersect(inMF,slow_errors_missed_dead_binMED);
        out.slow_errors_missed_dead_binMED = intersect(outMF,slow_errors_missed_dead_binMED);
        in.slow_errors_missed_dead_binSLOW = intersect(inMF,slow_errors_missed_dead_binSLOW);
        out.slow_errors_missed_dead_binSLOW = intersect(outMF,slow_errors_missed_dead_binSLOW);
        
        in.med_errors_binFAST = intersect(inMF,med_errors_binFAST);
        out.med_errors_binFAST = intersect(outMF,med_errors_binFAST);
        in.med_errors_binMED = intersect(inMF,med_errors_binMED);
        out.med_errors_binMED = intersect(outMF,med_errors_binMED);
        in.med_errors_binSLOW = intersect(inMF,med_errors_binSLOW);
        out.med_errors_binSLOW = intersect(outMF,med_errors_binSLOW);
        
        in.fast_errors_missed_dead_withCleared_binFAST = intersect(inMF,fast_errors_missed_dead_withCleared_binFAST);
        out.fast_errors_missed_dead_withCleared_binFAST = intersect(outMF,fast_errors_missed_dead_withCleared_binFAST);
        in.fast_errors_missed_dead_withCleared_binMED = intersect(inMF,fast_errors_missed_dead_withCleared_binMED);
        out.fast_errors_missed_dead_withCleared_binMED = intersect(outMF,fast_errors_missed_dead_withCleared_binMED);
        in.fast_errors_missed_dead_withCleared_binSLOW = intersect(inMF,fast_errors_missed_dead_withCleared_binSLOW);
        out.fast_errors_missed_dead_withCleared_binSLOW = intersect(outMF,fast_errors_missed_dead_withCleared_binSLOW);
        
        
        %=============================
        %=============================
        
        
        
        SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-2000 200]);
        
        if normalize == 1
            SDF_r = normalize_SP(SDF_r);
        end
        
        
        %On each trial, integrate the activity beginning at stimulus onset and ending at saccade onset.
        %set out-of-bound values to 0 (WE SHOULD ALSO TRY NaNs, BUT THIS WILL AFFECT THE AVERAGES!)
        
        
        integrated_SDF(1:size(SDF_r,1),1:2201) = 0;
        leaky_integrated_SDF(1:size(SDF_r,1),1:2201) = 0;
        for trl = 1:size(SDF_r,1)
            if 2000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1)); continue; end
            
            trl_part_SDF = SDF_r(trl,2000-SRT(trl,1):2000);
            integ(1:length(trl_part_SDF)) = 0;
            for tm = 2:length(trl_part_SDF)
                integ(tm) = integ(tm-1) + trl_part_SDF(tm) - (leakage .* integ(tm-1));
            end
            
            integrated_SDF(trl,2000-SRT(trl,1):2000) = cumsum(SDF_r(trl,2000-SRT(trl,1):2000));
            leaky_integrated_SDF(trl,2000-SRT(trl,1):2000) = integ;
            clear integ
            %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
            
        end
        
        %integrated_SDF(:,800:1000) = cumsum(SDF_r(:,800:1000),2);
        
        
        %REMOVE TRIALS WITH NO SPIKES
%         integ_sum = sum(integrated_SDF,2);
%         remove = find(integ_sum == 0);
%         integrated_SDF(remove,:) = NaN;
        
        
        
        integrated_in.slow_correct_made_dead(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_made_dead,:));
        integrated_in.med_correct(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct,:));
        integrated_in.fast_correct_made_dead(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared,:));
        
        integrated_in.slow_correct_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_binFAST,:));
        integrated_in.slow_correct_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_binMED,:));
        integrated_in.slow_correct_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_binSLOW,:));
        
        integrated_in.med_correct_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binFAST,:));
        integrated_in.med_correct_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binMED,:));
        integrated_in.med_correct_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binSLOW,:));
        
        integrated_in.fast_correct_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_binFAST,:));
        integrated_in.fast_correct_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_binMED,:));
        integrated_in.fast_correct_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_correct_made_dead(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_made_dead,:));
        integrated_out.med_correct(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct,:));
        integrated_out.fast_correct_made_dead(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared,:));
        
        integrated_out.slow_correct_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_binFAST,:));
        integrated_out.slow_correct_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_binMED,:));
        integrated_out.slow_correct_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_binSLOW,:));
        
        integrated_out.med_correct_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binFAST,:));
        integrated_out.med_correct_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binMED,:));
        integrated_out.med_correct_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binSLOW,:));
        
        integrated_out.fast_correct_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_binFAST,:));
        integrated_out.fast_correct_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_binMED,:));
        integrated_out.fast_correct_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_correct_made_dead(file,1:2201,k) = integrated_in.slow_correct_made_dead(file,1:2201,k) - integrated_out.slow_correct_made_dead(file,1:2201,k);
        integrated_diff.med_correct(file,1:2201,k) = integrated_in.med_correct(file,1:2201,k) - integrated_out.med_correct(file,1:2201,k);
        integrated_diff.fast_correct_made_dead(file,1:2201,k) = integrated_in.fast_correct_made_dead(file,1:2201,k) - integrated_out.fast_correct_made_dead(file,1:2201,k);
        
        integrated_diff.slow_correct_made_dead_binFast(file,1:2201,k) = integrated_in.slow_correct_made_dead_binFast(file,1:2201,k) - integrated_out.slow_correct_made_dead_binFast(file,1:2201,k);
        integrated_diff.slow_correct_made_dead_binMed(file,1:2201,k) = integrated_in.slow_correct_made_dead_binMed(file,1:2201,k) - integrated_out.slow_correct_made_dead_binMed(file,1:2201,k);
        integrated_diff.slow_correct_made_dead_binSlow(file,1:2201,k) = integrated_in.slow_correct_made_dead_binSlow(file,1:2201,k) - integrated_out.slow_correct_made_dead_binSlow(file,1:2201,k);
        
        integrated_diff.med_correct_binFast(file,1:2201,k) = integrated_in.med_correct_binFast(file,1:2201,k) - integrated_out.med_correct_binFast(file,1:2201,k);
        integrated_diff.med_correct_binMed(file,1:2201,k) = integrated_in.med_correct_binMed(file,1:2201,k) - integrated_out.med_correct_binMed(file,1:2201,k);
        integrated_diff.med_correct_binSlow(file,1:2201,k) = integrated_in.med_correct_binSlow(file,1:2201,k) - integrated_out.med_correct_binSlow(file,1:2201,k);
        
        integrated_diff.fast_correct_made_dead_binFast(file,1:2201,k) = integrated_in.fast_correct_made_dead_binFast(file,1:2201,k) - integrated_out.fast_correct_made_dead_binFast(file,1:2201,k);
        integrated_diff.fast_correct_made_dead_binMed(file,1:2201,k) = integrated_in.fast_correct_made_dead_binMed(file,1:2201,k) - integrated_out.fast_correct_made_dead_binMed(file,1:2201,k);
        integrated_diff.fast_correct_made_dead_binSlow(file,1:2201,k) = integrated_in.fast_correct_made_dead_binSlow(file,1:2201,k) - integrated_out.fast_correct_made_dead_binSlow(file,1:2201,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_correct_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead,:));
        leaky_integrated_in.med_correct(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct,:));
        leaky_integrated_in.fast_correct_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared,:));
        
        leaky_integrated_in.slow_correct_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binFAST,:));
        leaky_integrated_in.slow_correct_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binMED,:));
        leaky_integrated_in.slow_correct_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binSLOW,:));
        
        leaky_integrated_in.med_correct_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binFAST,:));
        leaky_integrated_in.med_correct_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binMED,:));
        leaky_integrated_in.med_correct_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binSLOW,:));
        
        leaky_integrated_in.fast_correct_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_correct_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_correct_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_correct_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead,:));
        leaky_integrated_out.med_correct(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct,:));
        leaky_integrated_out.fast_correct_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared,:));
        
        leaky_integrated_out.slow_correct_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binFAST,:));
        leaky_integrated_out.slow_correct_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binMED,:));
        leaky_integrated_out.slow_correct_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binSLOW,:));
        
        leaky_integrated_out.med_correct_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binFAST,:));
        leaky_integrated_out.med_correct_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binMED,:));
        leaky_integrated_out.med_correct_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binSLOW,:));
        
        leaky_integrated_out.fast_correct_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_correct_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_correct_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_correct_made_dead(file,1:2201,k) = leaky_integrated_in.slow_correct_made_dead(file,1:2201,k) - leaky_integrated_out.slow_correct_made_dead(file,1:2201,k);
        leaky_integrated_diff.med_correct(file,1:2201,k) = leaky_integrated_in.med_correct(file,1:2201,k) - leaky_integrated_out.med_correct(file,1:2201,k);
        leaky_integrated_diff.fast_correct_made_dead(file,1:2201,k) = leaky_integrated_in.fast_correct_made_dead(file,1:2201,k) - leaky_integrated_out.fast_correct_made_dead(file,1:2201,k);
        
        leaky_integrated_diff.slow_correct_made_dead_binFast(file,1:2201,k) = leaky_integrated_in.slow_correct_made_dead_binFast(file,1:2201,k) - leaky_integrated_out.slow_correct_made_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.slow_correct_made_dead_binMed(file,1:2201,k) = leaky_integrated_in.slow_correct_made_dead_binMed(file,1:2201,k) - leaky_integrated_out.slow_correct_made_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.slow_correct_made_dead_binSlow(file,1:2201,k) = leaky_integrated_in.slow_correct_made_dead_binSlow(file,1:2201,k) - leaky_integrated_out.slow_correct_made_dead_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.med_correct_binFast(file,1:2201,k) = leaky_integrated_in.med_correct_binFast(file,1:2201,k) - leaky_integrated_out.med_correct_binFast(file,1:2201,k);
        leaky_integrated_diff.med_correct_binMed(file,1:2201,k) = leaky_integrated_in.med_correct_binMed(file,1:2201,k) - leaky_integrated_out.med_correct_binMed(file,1:2201,k);
        leaky_integrated_diff.med_correct_binSlow(file,1:2201,k) = leaky_integrated_in.med_correct_binSlow(file,1:2201,k) - leaky_integrated_out.med_correct_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.fast_correct_made_dead_binFast(file,1:2201,k) = leaky_integrated_in.fast_correct_made_dead_binFast(file,1:2201,k) - leaky_integrated_out.fast_correct_made_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.fast_correct_made_dead_binMed(file,1:2201,k) = leaky_integrated_in.fast_correct_made_dead_binMed(file,1:2201,k) - leaky_integrated_out.fast_correct_made_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.fast_correct_made_dead_binSlow(file,1:2201,k) = leaky_integrated_in.fast_correct_made_dead_binSlow(file,1:2201,k) - leaky_integrated_out.fast_correct_made_dead_binSlow(file,1:2201,k);
        
        
        
        
        integrated_in.slow_errors_made_dead(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_made_dead,:));
        integrated_in.med_errors(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors,:));
        integrated_in.fast_errors_made_dead(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_made_dead_withCleared,:));
        
        integrated_in.slow_errors_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_made_dead_binFAST,:));
        integrated_in.slow_errors_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_made_dead_binMED,:));
        integrated_in.slow_errors_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_made_dead_binSLOW,:));
        
        integrated_in.med_errors_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binFAST,:));
        integrated_in.med_errors_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binMED,:));
        integrated_in.med_errors_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binSLOW,:));
        
        integrated_in.fast_errors_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_made_dead_withCleared_binFAST,:));
        integrated_in.fast_errors_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_made_dead_withCleared_binMED,:));
        integrated_in.fast_errors_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_made_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_errors_made_dead(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_made_dead,:));
        integrated_out.med_errors(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors,:));
        integrated_out.fast_errors_made_dead(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_made_dead_withCleared,:));
        
        integrated_out.slow_errors_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_made_dead_binFAST,:));
        integrated_out.slow_errors_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_made_dead_binMED,:));
        integrated_out.slow_errors_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_made_dead_binSLOW,:));
        
        integrated_out.med_errors_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binFAST,:));
        integrated_out.med_errors_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binMED,:));
        integrated_out.med_errors_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binSLOW,:));
        
        integrated_out.fast_errors_made_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_made_dead_withCleared_binFAST,:));
        integrated_out.fast_errors_made_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_made_dead_withCleared_binMED,:));
        integrated_out.fast_errors_made_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_made_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_errors_made_dead(file,1:2201,k) = integrated_in.slow_errors_made_dead(file,1:2201,k) - integrated_out.slow_errors_made_dead(file,1:2201,k);
        integrated_diff.med_errors(file,1:2201,k) = integrated_in.med_errors(file,1:2201,k) - integrated_out.med_errors(file,1:2201,k);
        integrated_diff.fast_errors_made_dead(file,1:2201,k) = integrated_in.fast_errors_made_dead(file,1:2201,k) - integrated_out.fast_errors_made_dead(file,1:2201,k);
        
        integrated_diff.slow_errors_made_dead_binFast(file,1:2201,k) = integrated_in.slow_errors_made_dead_binFast(file,1:2201,k) - integrated_out.slow_errors_made_dead_binFast(file,1:2201,k);
        integrated_diff.slow_errors_made_dead_binMed(file,1:2201,k) = integrated_in.slow_errors_made_dead_binMed(file,1:2201,k) - integrated_out.slow_errors_made_dead_binMed(file,1:2201,k);
        integrated_diff.slow_errors_made_dead_binSlow(file,1:2201,k) = integrated_in.slow_errors_made_dead_binSlow(file,1:2201,k) - integrated_out.slow_errors_made_dead_binSlow(file,1:2201,k);
        
        integrated_diff.med_errors_binFast(file,1:2201,k) = integrated_in.med_errors_binFast(file,1:2201,k) - integrated_out.med_errors_binFast(file,1:2201,k);
        integrated_diff.med_errors_binMed(file,1:2201,k) = integrated_in.med_errors_binMed(file,1:2201,k) - integrated_out.med_errors_binMed(file,1:2201,k);
        integrated_diff.med_errors_binSlow(file,1:2201,k) = integrated_in.med_errors_binSlow(file,1:2201,k) - integrated_out.med_errors_binSlow(file,1:2201,k);
        
        integrated_diff.fast_errors_made_dead_binFast(file,1:2201,k) = integrated_in.fast_errors_made_dead_binFast(file,1:2201,k) - integrated_out.fast_errors_made_dead_binFast(file,1:2201,k);
        integrated_diff.fast_errors_made_dead_binMed(file,1:2201,k) = integrated_in.fast_errors_made_dead_binMed(file,1:2201,k) - integrated_out.fast_errors_made_dead_binMed(file,1:2201,k);
        integrated_diff.fast_errors_made_dead_binSlow(file,1:2201,k) = integrated_in.fast_errors_made_dead_binSlow(file,1:2201,k) - integrated_out.fast_errors_made_dead_binSlow(file,1:2201,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_errors_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead,:));
        leaky_integrated_in.med_errors(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors,:));
        leaky_integrated_in.fast_errors_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared,:));
        
        
        leaky_integrated_in.slow_errors_made_missed(file,1:2201,k) = nanmean(leaky_integrated_SDF([in.slow_errors_made_dead ; in.slow_errors_missed_dead],:));
        leaky_integrated_in.fast_errors_made_missed(file,1:2201,k) = nanmean(leaky_integrated_SDF([in.fast_errors_made_dead_withCleared ; in.fast_errors_missed_dead_withCleared],:));
        
        
        
        leaky_integrated_in.slow_errors_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binFAST,:));
        leaky_integrated_in.slow_errors_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binMED,:));
        leaky_integrated_in.slow_errors_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binSLOW,:));
        
        leaky_integrated_in.med_errors_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binFAST,:));
        leaky_integrated_in.med_errors_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binMED,:));
        leaky_integrated_in.med_errors_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binSLOW,:));
        
        leaky_integrated_in.fast_errors_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_errors_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_errors_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_errors_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead,:));
        leaky_integrated_out.med_errors(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors,:));
        leaky_integrated_out.fast_errors_made_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared,:));
        
        
        leaky_integrated_out.slow_errors_made_missed(file,1:2201,k) = nanmean(leaky_integrated_SDF([out.slow_errors_made_dead ; in.slow_errors_missed_dead],:));
        leaky_integrated_out.fast_errors_made_missed(file,1:2201,k) = nanmean(leaky_integrated_SDF([out.fast_errors_made_dead_withCleared ; in.fast_errors_missed_dead_withCleared],:));
        
        
        leaky_integrated_out.slow_errors_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binFAST,:));
        leaky_integrated_out.slow_errors_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binMED,:));
        leaky_integrated_out.slow_errors_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binSLOW,:));
        
        leaky_integrated_out.med_errors_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binFAST,:));
        leaky_integrated_out.med_errors_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binMED,:));
        leaky_integrated_out.med_errors_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binSLOW,:));
        
        leaky_integrated_out.fast_errors_made_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_errors_made_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_errors_made_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_errors_made_dead(file,1:2201,k) = leaky_integrated_in.slow_errors_made_dead(file,1:2201,k) - leaky_integrated_out.slow_errors_made_dead(file,1:2201,k);
        leaky_integrated_diff.med_errors(file,1:2201,k) = leaky_integrated_in.med_errors(file,1:2201,k) - leaky_integrated_out.med_errors(file,1:2201,k);
        leaky_integrated_diff.fast_errors_made_dead(file,1:2201,k) = leaky_integrated_in.fast_errors_made_dead(file,1:2201,k) - leaky_integrated_out.fast_errors_made_dead(file,1:2201,k);
        
        leaky_integrated_diff.slow_errors_made_dead_binFast(file,1:2201,k) = leaky_integrated_in.slow_errors_made_dead_binFast(file,1:2201,k) - leaky_integrated_out.slow_errors_made_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.slow_errors_made_dead_binMed(file,1:2201,k) = leaky_integrated_in.slow_errors_made_dead_binMed(file,1:2201,k) - leaky_integrated_out.slow_errors_made_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.slow_errors_made_dead_binSlow(file,1:2201,k) = leaky_integrated_in.slow_errors_made_dead_binSlow(file,1:2201,k) - leaky_integrated_out.slow_errors_made_dead_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.med_errors_binFast(file,1:2201,k) = leaky_integrated_in.med_errors_binFast(file,1:2201,k) - leaky_integrated_out.med_errors_binFast(file,1:2201,k);
        leaky_integrated_diff.med_errors_binMed(file,1:2201,k) = leaky_integrated_in.med_errors_binMed(file,1:2201,k) - leaky_integrated_out.med_errors_binMed(file,1:2201,k);
        leaky_integrated_diff.med_errors_binSlow(file,1:2201,k) = leaky_integrated_in.med_errors_binSlow(file,1:2201,k) - leaky_integrated_out.med_errors_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.fast_errors_made_dead_binFast(file,1:2201,k) = leaky_integrated_in.fast_errors_made_dead_binFast(file,1:2201,k) - leaky_integrated_out.fast_errors_made_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.fast_errors_made_dead_binMed(file,1:2201,k) = leaky_integrated_in.fast_errors_made_dead_binMed(file,1:2201,k) - leaky_integrated_out.fast_errors_made_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.fast_errors_made_dead_binSlow(file,1:2201,k) = leaky_integrated_in.fast_errors_made_dead_binSlow(file,1:2201,k) - leaky_integrated_out.fast_errors_made_dead_binSlow(file,1:2201,k);
        
        
        integrated_in.slow_correct_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead,:));
        integrated_in.med_correct(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct,:));
        integrated_in.fast_correct_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
        
        integrated_in.slow_correct_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
        integrated_in.slow_correct_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binMED,:));
        integrated_in.slow_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
        
        integrated_in.med_correct_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binFAST,:));
        integrated_in.med_correct_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binMED,:));
        integrated_in.med_correct_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.med_correct_binSLOW,:));
        
        integrated_in.fast_correct_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
        integrated_in.fast_correct_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
        integrated_in.fast_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_correct_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead,:));
        integrated_out.med_correct(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct,:));
        integrated_out.fast_correct_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
        
        integrated_out.slow_correct_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
        integrated_out.slow_correct_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binMED,:));
        integrated_out.slow_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
        
        integrated_out.med_correct_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binFAST,:));
        integrated_out.med_correct_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binMED,:));
        integrated_out.med_correct_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.med_correct_binSLOW,:));
        
        integrated_out.fast_correct_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
        integrated_out.fast_correct_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
        integrated_out.fast_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_correct_missed_dead(file,1:2201,k) = integrated_in.slow_correct_missed_dead(file,1:2201,k) - integrated_out.slow_correct_missed_dead(file,1:2201,k);
        integrated_diff.med_correct(file,1:2201,k) = integrated_in.med_correct(file,1:2201,k) - integrated_out.med_correct(file,1:2201,k);
        integrated_diff.fast_correct_missed_dead(file,1:2201,k) = integrated_in.fast_correct_missed_dead(file,1:2201,k) - integrated_out.fast_correct_missed_dead(file,1:2201,k);
        
        integrated_diff.slow_correct_missed_dead_binFast(file,1:2201,k) = integrated_in.slow_correct_missed_dead_binFast(file,1:2201,k) - integrated_out.slow_correct_missed_dead_binFast(file,1:2201,k);
        integrated_diff.slow_correct_missed_dead_binMed(file,1:2201,k) = integrated_in.slow_correct_missed_dead_binMed(file,1:2201,k) - integrated_out.slow_correct_missed_dead_binMed(file,1:2201,k);
        integrated_diff.slow_correct_missed_dead_binSlow(file,1:2201,k) = integrated_in.slow_correct_missed_dead_binSlow(file,1:2201,k) - integrated_out.slow_correct_missed_dead_binSlow(file,1:2201,k);
        
        integrated_diff.med_correct_binFast(file,1:2201,k) = integrated_in.med_correct_binFast(file,1:2201,k) - integrated_out.med_correct_binFast(file,1:2201,k);
        integrated_diff.med_correct_binMed(file,1:2201,k) = integrated_in.med_correct_binMed(file,1:2201,k) - integrated_out.med_correct_binMed(file,1:2201,k);
        integrated_diff.med_correct_binSlow(file,1:2201,k) = integrated_in.med_correct_binSlow(file,1:2201,k) - integrated_out.med_correct_binSlow(file,1:2201,k);
        
        integrated_diff.fast_correct_missed_dead_binFast(file,1:2201,k) = integrated_in.fast_correct_missed_dead_binFast(file,1:2201,k) - integrated_out.fast_correct_missed_dead_binFast(file,1:2201,k);
        integrated_diff.fast_correct_missed_dead_binMed(file,1:2201,k) = integrated_in.fast_correct_missed_dead_binMed(file,1:2201,k) - integrated_out.fast_correct_missed_dead_binMed(file,1:2201,k);
        integrated_diff.fast_correct_missed_dead_binSlow(file,1:2201,k) = integrated_in.fast_correct_missed_dead_binSlow(file,1:2201,k) - integrated_out.fast_correct_missed_dead_binSlow(file,1:2201,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_correct_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead,:));
        leaky_integrated_in.med_correct(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct,:));
        leaky_integrated_in.fast_correct_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
        
        leaky_integrated_in.slow_correct_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
        leaky_integrated_in.slow_correct_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binMED,:));
        leaky_integrated_in.slow_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
        
        leaky_integrated_in.med_correct_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binFAST,:));
        leaky_integrated_in.med_correct_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binMED,:));
        leaky_integrated_in.med_correct_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_correct_binSLOW,:));
        
        leaky_integrated_in.fast_correct_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_correct_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_correct_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead,:));
        leaky_integrated_out.med_correct(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct,:));
        leaky_integrated_out.fast_correct_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
        
        leaky_integrated_out.slow_correct_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
        leaky_integrated_out.slow_correct_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binMED,:));
        leaky_integrated_out.slow_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
        
        leaky_integrated_out.med_correct_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binFAST,:));
        leaky_integrated_out.med_correct_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binMED,:));
        leaky_integrated_out.med_correct_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_correct_binSLOW,:));
        
        leaky_integrated_out.fast_correct_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_correct_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_correct_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_correct_missed_dead(file,1:2201,k) = leaky_integrated_in.slow_correct_missed_dead(file,1:2201,k) - leaky_integrated_out.slow_correct_missed_dead(file,1:2201,k);
        leaky_integrated_diff.med_correct(file,1:2201,k) = leaky_integrated_in.med_correct(file,1:2201,k) - leaky_integrated_out.med_correct(file,1:2201,k);
        leaky_integrated_diff.fast_correct_missed_dead(file,1:2201,k) = leaky_integrated_in.fast_correct_missed_dead(file,1:2201,k) - leaky_integrated_out.fast_correct_missed_dead(file,1:2201,k);
        
        leaky_integrated_diff.slow_correct_missed_dead_binFast(file,1:2201,k) = leaky_integrated_in.slow_correct_missed_dead_binFast(file,1:2201,k) - leaky_integrated_out.slow_correct_missed_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.slow_correct_missed_dead_binMed(file,1:2201,k) = leaky_integrated_in.slow_correct_missed_dead_binMed(file,1:2201,k) - leaky_integrated_out.slow_correct_missed_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.slow_correct_missed_dead_binSlow(file,1:2201,k) = leaky_integrated_in.slow_correct_missed_dead_binSlow(file,1:2201,k) - leaky_integrated_out.slow_correct_missed_dead_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.med_correct_binFast(file,1:2201,k) = leaky_integrated_in.med_correct_binFast(file,1:2201,k) - leaky_integrated_out.med_correct_binFast(file,1:2201,k);
        leaky_integrated_diff.med_correct_binMed(file,1:2201,k) = leaky_integrated_in.med_correct_binMed(file,1:2201,k) - leaky_integrated_out.med_correct_binMed(file,1:2201,k);
        leaky_integrated_diff.med_correct_binSlow(file,1:2201,k) = leaky_integrated_in.med_correct_binSlow(file,1:2201,k) - leaky_integrated_out.med_correct_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.fast_correct_missed_dead_binFast(file,1:2201,k) = leaky_integrated_in.fast_correct_missed_dead_binFast(file,1:2201,k) - leaky_integrated_out.fast_correct_missed_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.fast_correct_missed_dead_binMed(file,1:2201,k) = leaky_integrated_in.fast_correct_missed_dead_binMed(file,1:2201,k) - leaky_integrated_out.fast_correct_missed_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.fast_correct_missed_dead_binSlow(file,1:2201,k) = leaky_integrated_in.fast_correct_missed_dead_binSlow(file,1:2201,k) - leaky_integrated_out.fast_correct_missed_dead_binSlow(file,1:2201,k);
        
        
        
        
        integrated_in.slow_errors_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead,:));
        integrated_in.med_errors(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors,:));
        integrated_in.fast_errors_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
        
        integrated_in.slow_errors_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
        integrated_in.slow_errors_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binMED,:));
        integrated_in.slow_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
        
        integrated_in.med_errors_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binFAST,:));
        integrated_in.med_errors_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binMED,:));
        integrated_in.med_errors_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.med_errors_binSLOW,:));
        
        integrated_in.fast_errors_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
        integrated_in.fast_errors_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
        integrated_in.fast_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_errors_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead,:));
        integrated_out.med_errors(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors,:));
        integrated_out.fast_errors_missed_dead(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
        
        integrated_out.slow_errors_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
        integrated_out.slow_errors_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binMED,:));
        integrated_out.slow_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
        
        integrated_out.med_errors_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binFAST,:));
        integrated_out.med_errors_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binMED,:));
        integrated_out.med_errors_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.med_errors_binSLOW,:));
        
        integrated_out.fast_errors_missed_dead_binFast(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
        integrated_out.fast_errors_missed_dead_binMed(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
        integrated_out.fast_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_errors_missed_dead(file,1:2201,k) = integrated_in.slow_errors_missed_dead(file,1:2201,k) - integrated_out.slow_errors_missed_dead(file,1:2201,k);
        integrated_diff.med_errors(file,1:2201,k) = integrated_in.med_errors(file,1:2201,k) - integrated_out.med_errors(file,1:2201,k);
        integrated_diff.fast_errors_missed_dead(file,1:2201,k) = integrated_in.fast_errors_missed_dead(file,1:2201,k) - integrated_out.fast_errors_missed_dead(file,1:2201,k);
        
        integrated_diff.slow_errors_missed_dead_binFast(file,1:2201,k) = integrated_in.slow_errors_missed_dead_binFast(file,1:2201,k) - integrated_out.slow_errors_missed_dead_binFast(file,1:2201,k);
        integrated_diff.slow_errors_missed_dead_binMed(file,1:2201,k) = integrated_in.slow_errors_missed_dead_binMed(file,1:2201,k) - integrated_out.slow_errors_missed_dead_binMed(file,1:2201,k);
        integrated_diff.slow_errors_missed_dead_binSlow(file,1:2201,k) = integrated_in.slow_errors_missed_dead_binSlow(file,1:2201,k) - integrated_out.slow_errors_missed_dead_binSlow(file,1:2201,k);
        
        integrated_diff.med_errors_binFast(file,1:2201,k) = integrated_in.med_errors_binFast(file,1:2201,k) - integrated_out.med_errors_binFast(file,1:2201,k);
        integrated_diff.med_errors_binMed(file,1:2201,k) = integrated_in.med_errors_binMed(file,1:2201,k) - integrated_out.med_errors_binMed(file,1:2201,k);
        integrated_diff.med_errors_binSlow(file,1:2201,k) = integrated_in.med_errors_binSlow(file,1:2201,k) - integrated_out.med_errors_binSlow(file,1:2201,k);
        
        integrated_diff.fast_errors_missed_dead_binFast(file,1:2201,k) = integrated_in.fast_errors_missed_dead_binFast(file,1:2201,k) - integrated_out.fast_errors_missed_dead_binFast(file,1:2201,k);
        integrated_diff.fast_errors_missed_dead_binMed(file,1:2201,k) = integrated_in.fast_errors_missed_dead_binMed(file,1:2201,k) - integrated_out.fast_errors_missed_dead_binMed(file,1:2201,k);
        integrated_diff.fast_errors_missed_dead_binSlow(file,1:2201,k) = integrated_in.fast_errors_missed_dead_binSlow(file,1:2201,k) - integrated_out.fast_errors_missed_dead_binSlow(file,1:2201,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_errors_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead,:));
        leaky_integrated_in.med_errors(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors,:));
        leaky_integrated_in.fast_errors_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
        
        leaky_integrated_in.slow_errors_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
        leaky_integrated_in.slow_errors_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binMED,:));
        leaky_integrated_in.slow_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
        
        leaky_integrated_in.med_errors_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binFAST,:));
        leaky_integrated_in.med_errors_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binMED,:));
        leaky_integrated_in.med_errors_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.med_errors_binSLOW,:));
        
        leaky_integrated_in.fast_errors_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_errors_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_errors_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead,:));
        leaky_integrated_out.med_errors(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors,:));
        leaky_integrated_out.fast_errors_missed_dead(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
        
        leaky_integrated_out.slow_errors_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
        leaky_integrated_out.slow_errors_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binMED,:));
        leaky_integrated_out.slow_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
        
        leaky_integrated_out.med_errors_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binFAST,:));
        leaky_integrated_out.med_errors_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binMED,:));
        leaky_integrated_out.med_errors_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.med_errors_binSLOW,:));
        
        leaky_integrated_out.fast_errors_missed_dead_binFast(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_errors_missed_dead_binMed(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_errors_missed_dead_binSlow(file,1:2201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_errors_missed_dead(file,1:2201,k) = leaky_integrated_in.slow_errors_missed_dead(file,1:2201,k) - leaky_integrated_out.slow_errors_missed_dead(file,1:2201,k);
        leaky_integrated_diff.med_errors(file,1:2201,k) = leaky_integrated_in.med_errors(file,1:2201,k) - leaky_integrated_out.med_errors(file,1:2201,k);
        leaky_integrated_diff.fast_errors_missed_dead(file,1:2201,k) = leaky_integrated_in.fast_errors_missed_dead(file,1:2201,k) - leaky_integrated_out.fast_errors_missed_dead(file,1:2201,k);
        
        leaky_integrated_diff.slow_errors_missed_dead_binFast(file,1:2201,k) = leaky_integrated_in.slow_errors_missed_dead_binFast(file,1:2201,k) - leaky_integrated_out.slow_errors_missed_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.slow_errors_missed_dead_binMed(file,1:2201,k) = leaky_integrated_in.slow_errors_missed_dead_binMed(file,1:2201,k) - leaky_integrated_out.slow_errors_missed_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.slow_errors_missed_dead_binSlow(file,1:2201,k) = leaky_integrated_in.slow_errors_missed_dead_binSlow(file,1:2201,k) - leaky_integrated_out.slow_errors_missed_dead_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.med_errors_binFast(file,1:2201,k) = leaky_integrated_in.med_errors_binFast(file,1:2201,k) - leaky_integrated_out.med_errors_binFast(file,1:2201,k);
        leaky_integrated_diff.med_errors_binMed(file,1:2201,k) = leaky_integrated_in.med_errors_binMed(file,1:2201,k) - leaky_integrated_out.med_errors_binMed(file,1:2201,k);
        leaky_integrated_diff.med_errors_binSlow(file,1:2201,k) = leaky_integrated_in.med_errors_binSlow(file,1:2201,k) - leaky_integrated_out.med_errors_binSlow(file,1:2201,k);
        
        leaky_integrated_diff.fast_errors_missed_dead_binFast(file,1:2201,k) = leaky_integrated_in.fast_errors_missed_dead_binFast(file,1:2201,k) - leaky_integrated_out.fast_errors_missed_dead_binFast(file,1:2201,k);
        leaky_integrated_diff.fast_errors_missed_dead_binMed(file,1:2201,k) = leaky_integrated_in.fast_errors_missed_dead_binMed(file,1:2201,k) - leaky_integrated_out.fast_errors_missed_dead_binMed(file,1:2201,k);
        leaky_integrated_diff.fast_errors_missed_dead_binSlow(file,1:2201,k) = leaky_integrated_in.fast_errors_missed_dead_binSlow(file,1:2201,k) - leaky_integrated_out.fast_errors_missed_dead_binSlow(file,1:2201,k);
        
        

        
        keep k leak leakage filename unit file integrated_in integrated_out integrated_diff leaky_integrated_in leaky_integrated_out leaky_integrated_diff
        
    end
    
end
%
% figure
% plot(-1000:200,nanmean(integrated_in.slow_correct_made_dead),'r', ...
%     -1000:200,nanmean(integrated_in.med_correct),'k', ...
%     -1000:200,nanmean(integrated_in.fast_correct_made_dead),'g')
% box off
% set(gca,'xminortick','on')
%
% figure
% plot(-1000:200,nanmean(integrated_in.slow_correct_made_dead_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.slow_correct_made_dead_binMed),'k', ...
% -1000:200,nanmean(integrated_in.slow_correct_made_dead_binFast),'g')
%
% hold on
%
% plot(-1000:200,nanmean(integrated_in.med_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.med_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_in.med_correct_binFast),'g')
%
% plot(-1000:200,nanmean(integrated_in.fast_correct_made_dead_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.fast_correct_made_dead_binMed),'k', ...
% -1000:200,nanmean(integrated_in.fast_correct_made_dead_binFast),'g')
%
% box off
% set(gca,'xminortick','on')
% title('Integrated Target-In')
%
%
%
% figure
% plot(-1000:200,nanmean(integrated_diff.slow_correct_made_dead),'r', ...
%     -1000:200,nanmean(integrated_diff.med_correct),'k', ...
%     -1000:200,nanmean(integrated_diff.fast_correct_made_dead),'g')
% box off
% set(gca,'xminortick','on')
%
% figure
% plot(-1000:200,nanmean(integrated_diff.slow_correct_made_dead_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.slow_correct_made_dead_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.slow_correct_made_dead_binFast),'g')
%
% hold on
%
% plot(-1000:200,nanmean(integrated_diff.med_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.med_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.med_correct_binFast),'g')
%
% plot(-1000:200,nanmean(integrated_diff.fast_correct_made_dead_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.fast_correct_made_dead_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.fast_correct_made_dead_binFast),'g')
%
% box off
% set(gca,'xminortick','on')
% title('Integrated Difference')
%
%
%

% WITH LEAKAGE
figure
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead),'g')
box off
set(gca,'xminortick','on')

figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast),'g')

subplot(2,2,2)
plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binFast),'g')

subplot(2,2,3)
plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast),'g')

box off
set(gca,'xminortick','on')
title('leaky_integrated Target-In')



