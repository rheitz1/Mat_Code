cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_Vis_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_Vis_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');


filename = [filename1 ; filename2 ; filename3 ; filename4 ; ...
    filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];

%leak = .001:.001:.1;
%leak = .010
% leak = .001:.001:.01;
% leak = .011:.001:.02;
% leak = .021:.001:.03;
% leak = .031:.001:.04;
% leak = .041:.001:.05;
% leak = .051:.001:.06;
% leak = .061:.001:.07;
% leak = .071:.001:.08;
% leak = .081:.001:.09;
% leak = .091:.001:.10;

for k = 1:length(leak)
    
    disp(['Running leakage = ' mat2str(leak(k))])
    leakage = leak(k);
    
    for file = 1:length(filename)
        
        load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
        filename{file}
        
        sig = eval(unit{file});
        
        MF = RFs.(unit{file});
        
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
        
        med_correct = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
        med_errors = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
        med_all = [med_correct ; med_errors];
        
        %All correct trials w/ made deadlines
        slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
        fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
        fast_correct_made_dead_noCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
        
        ntile.slow_correct_made_dead.n33 = prctile(SRT(slow_correct_made_dead,1),33);
        ntile.slow_correct_made_dead.n66 = prctile(SRT(slow_correct_made_dead,1),66);
        
        ntile.fast_correct_made_dead_withCleared.n33 = prctile(SRT(fast_correct_made_dead_withCleared,1),33);
        ntile.fast_correct_made_dead_withCleared.n66 = prctile(SRT(fast_correct_made_dead_withCleared,1),66);
        
        
        ntile.med_correct.n33 = prctile(SRT(med_correct,1),33);
        ntile.med_correct.n66 = prctile(SRT(med_correct,1),66);
        
        %=========================
        % RT BINS within condition
        slow_correct_made_dead_binFAST = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3) & SRT(:,1) <= ntile.slow_correct_made_dead.n33);
        slow_correct_made_dead_binMED = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3) & SRT(:,1) > ntile.slow_correct_made_dead.n33 & SRT(:,1) <= ntile.slow_correct_made_dead.n66);
        slow_correct_made_dead_binSLOW = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3) & SRT(:,1) > ntile.slow_correct_made_dead.n66);
        
        med_correct_binFAST = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2 & SRT(:,1) <= ntile.med_correct.n33);
        med_correct_binMED = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2 & SRT(:,1) > ntile.med_correct.n33 & SRT(:,1) <= ntile.med_correct.n66);
        med_correct_binSLOW = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2 & SRT(:,1) > ntile.med_correct.n66);
        
        fast_correct_made_dead_withCleared_binFAST = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SRT(:,1) <= ntile.fast_correct_made_dead_withCleared.n33);
        fast_correct_made_dead_withCleared_binMED = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SRT(:,1) > ntile.fast_correct_made_dead_withCleared.n33 & SRT(:,1) <= ntile.fast_correct_made_dead_withCleared.n66);
        fast_correct_made_dead_withCleared_binSLOW = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SRT(:,1) > ntile.fast_correct_made_dead_withCleared.n66);
        
        %=========================
        
        
        slow_errors_made_dead = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
        fast_errors_made_dead_withCleared = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
        
        %All trials w/ made deadlines
        slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
        fast_all_made_dead_withCleared = [fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared];
        
        
        %All correct trials w/ missed deadlines (too late in FAST/too early in SLOW
        slow_correct_missed_dead = find(Errors_(:,6) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
        fast_correct_missed_dead_withCleared = find(Errors_(:,7) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
        
        slow_errors_missed_dead = find(Errors_(:,5) == 1 & isnan(Errors_(:,6)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
        fast_errors_missed_dead_withCleared = find(Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
        
        %All trials w/ missed deadlines
        slow_all_missed_dead = [slow_correct_missed_dead ; slow_errors_missed_dead];
        fast_all_missed_dead_withCleared = [fast_correct_missed_dead_withCleared ; fast_errors_missed_dead_withCleared];
        
        
        %All correct trials made + missed
        slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];
        fast_correct_made_missed_withCleared = [fast_correct_made_dead_withCleared ; fast_correct_missed_dead_withCleared];
        
        slow_errors_made_missed = [slow_errors_made_dead ; slow_errors_missed_dead];
        fast_errors_made_missed_withCleared = [fast_errors_made_dead_withCleared ; fast_errors_missed_dead_withCleared];
        
        %All trials made + missed
        slow_all = [slow_all_made_dead ; slow_all_missed_dead];
        fast_all_withCleared = [fast_all_made_dead_withCleared ; fast_all_missed_dead_withCleared];
        
        
        
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
        in.slow_correct_made_dead_MF = intersect(inMF,slow_correct_made_dead);
        out.slow_correct_made_dead_MF = intersect(outMF,slow_correct_made_dead);
        
        in.med_correct_MF = intersect(inMF,med_correct);
        out.med_correct_MF = intersect(outMF,med_correct);
        
        
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
        
        
        
        SDF_r = sSDF(sig,SRT(:,1)+500,[-1000 200]);
        
        if normalize == 1
            SDF_r = normalize_SP(SDF_r);
        end
        
        
        %On each trial, integrate the activity beginning at stimulus onset and ending at saccade onset.
        %set out-of-bound values to NaN (WE SHOULD ALSO TRY 0'S, BUT THIS WILL AFFECT THE AVERAGES!)
        
        
        integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        leaky_integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        for trl = 1:size(SDF_r,1)
            if 1000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1)); continue; end
            
            trl_part_SDF = SDF_r(trl,1000-SRT(trl,1):1000);
            integ(1:length(trl_part_SDF)) = 0;
            integ_diff(1:length(trl_part_SDF)) = 0;
            for tm = 2:length(trl_part_SDF)
                integ(tm) = integ(tm-1) + trl_part_SDF(tm) - (leakage .* integ(tm-1));
            end
            
            integrated_SDF(trl,1000-SRT(trl,1):1000) = cumsum(SDF_r(trl,1000-SRT(trl,1):1000));
            leaky_integrated_SDF(trl,1000-SRT(trl,1):1000) = integ;
            clear integ trl_part_SDF
            %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
            
        end

        %to get integrated difference, we need to use grand averages.  For each trial, keep the SDF from
        %target onset to SRT, aligned to SRT.  Take the grand average of that
        for trl = 1:size(SDF_r,1)
            if 1000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1)); continue; end
            trl_part_SDF(trl,1000-SRT(trl,1):1000) = SDF_r(trl,1000-SRT(trl,1):1000);
        end
        
        mean_in_resp_r.slow = nanmean(trl_part_SDF(in.slow_correct_made_dead_MF,:));
        mean_out_resp_r.slow = nanmean(trl_part_SDF(out.slow_correct_made_dead_MF,:));
        
        mean_in_resp_r.med = nanmean(trl_part_SDF(in.med_correct_MF,:));
        mean_out_resp_r.med = nanmean(trl_part_SDF(out.med_correct_MF,:));
        
        mean_in_resp_r.fast = nanmean(trl_part_SDF(in.fast_correct_made_dead_withCleared_MF,:));
        mean_out_resp_r.fast = nanmean(trl_part_SDF(out.fast_correct_made_dead_withCleared_MF,:));
        
        
        mean_diff.slow = mean_in_resp_r.slow - mean_out_resp_r.slow;
        mean_diff.med = mean_in_resp_r.med - mean_out_resp_r.med;
        mean_diff.fast = mean_in_resp_r.fast - mean_out_resp_r.fast;
        
        %make integrator of means
        mean_integrated_diff.slow(1:1201) = 0;
        mean_integrated_diff.med(1:1201) = 0;
        mean_integrated_diff.fast(1:1201) = 0;
        for tm = 2:length(mean_diff.slow)
            mean_integrated_diff.slow(file,tm) = mean_integrated_diff.slow(tm-1) + mean_diff.slow(tm) - (leakage .* mean_integrated_diff.slow(tm-1));
            mean_integrated_diff.med(file,tm) = mean_integrated_diff.med(tm-1) + mean_diff.med(tm) - (leakage .* mean_integrated_diff.med(tm-1));
            mean_integrated_diff.fast(file,tm) = mean_integrated_diff.fast(tm-1) + mean_diff.fast(tm) - (leakage .* mean_integrated_diff.fast(tm-1));
        end
        clear trl_part_SDF
        
        
        
        integrated_in.slow_correct_made_dead(file,:,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_MF,:));
        integrated_in.med_correct(file,:,k) = nanmean(integrated_SDF(in.med_correct_MF,:));
        integrated_in.fast_correct_made_dead(file,:,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_MF,:));
        
        integrated_in.slow_correct_made_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_MF_binFAST,:));
        integrated_in.slow_correct_made_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_MF_binMED,:));
        integrated_in.slow_correct_made_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.slow_correct_made_dead_MF_binSLOW,:));
        
        integrated_in.med_correct_binFast(file,:,k) = nanmean(integrated_SDF(in.med_correct_MF_binFAST,:));
        integrated_in.med_correct_binMed(file,:,k) = nanmean(integrated_SDF(in.med_correct_MF_binMED,:));
        integrated_in.med_correct_binSlow(file,:,k) = nanmean(integrated_SDF(in.med_correct_MF_binSLOW,:));
        
        integrated_in.fast_correct_made_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binFAST,:));
        integrated_in.fast_correct_made_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binMED,:));
        integrated_in.fast_correct_made_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binSLOW,:));
        
        
        integrated_out.slow_correct_made_dead(file,:,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_MF,:));
        integrated_out.med_correct(file,:,k) = nanmean(integrated_SDF(out.med_correct_MF,:));
        integrated_out.fast_correct_made_dead(file,:,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_MF,:));
        
        integrated_out.slow_correct_made_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_MF_binFAST,:));
        integrated_out.slow_correct_made_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_MF_binMED,:));
        integrated_out.slow_correct_made_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.slow_correct_made_dead_MF_binSLOW,:));
        
        integrated_out.med_correct_binFast(file,:,k) = nanmean(integrated_SDF(out.med_correct_MF_binFAST,:));
        integrated_out.med_correct_binMed(file,:,k) = nanmean(integrated_SDF(out.med_correct_MF_binMED,:));
        integrated_out.med_correct_binSlow(file,:,k) = nanmean(integrated_SDF(out.med_correct_MF_binSLOW,:));
        
        integrated_out.fast_correct_made_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binFAST,:));
        integrated_out.fast_correct_made_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binMED,:));
        integrated_out.fast_correct_made_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binSLOW,:));
        
        integrated_diff.slow_correct_made_dead(file,:,k) = integrated_in.slow_correct_made_dead(file,:,k) - integrated_out.slow_correct_made_dead(file,:,k);
        integrated_diff.med_correct(file,:,k) = integrated_in.med_correct(file,:,k) - integrated_out.med_correct(file,:,k);
        integrated_diff.fast_correct_made_dead(file,:,k) = integrated_in.fast_correct_made_dead(file,:,k) - integrated_out.fast_correct_made_dead(file,:,k);
        
        integrated_diff.slow_correct_made_dead_binFast(file,:,k) = integrated_in.slow_correct_made_dead_binFast(file,:,k) - integrated_out.slow_correct_made_dead_binFast(file,:,k);
        integrated_diff.slow_correct_made_dead_binMed(file,:,k) = integrated_in.slow_correct_made_dead_binMed(file,:,k) - integrated_out.slow_correct_made_dead_binMed(file,:,k);
        integrated_diff.slow_correct_made_dead_binSlow(file,:,k) = integrated_in.slow_correct_made_dead_binSlow(file,:,k) - integrated_out.slow_correct_made_dead_binSlow(file,:,k);
        
        integrated_diff.med_correct_binFast(file,:,k) = integrated_in.med_correct_binFast(file,:,k) - integrated_out.med_correct_binFast(file,:,k);
        integrated_diff.med_correct_binMed(file,:,k) = integrated_in.med_correct_binMed(file,:,k) - integrated_out.med_correct_binMed(file,:,k);
        integrated_diff.med_correct_binSlow(file,:,k) = integrated_in.med_correct_binSlow(file,:,k) - integrated_out.med_correct_binSlow(file,:,k);
        
        integrated_diff.fast_correct_made_dead_binFast(file,:,k) = integrated_in.fast_correct_made_dead_binFast(file,:,k) - integrated_out.fast_correct_made_dead_binFast(file,:,k);
        integrated_diff.fast_correct_made_dead_binMed(file,:,k) = integrated_in.fast_correct_made_dead_binMed(file,:,k) - integrated_out.fast_correct_made_dead_binMed(file,:,k);
        integrated_diff.fast_correct_made_dead_binSlow(file,:,k) = integrated_in.fast_correct_made_dead_binSlow(file,:,k) - integrated_out.fast_correct_made_dead_binSlow(file,:,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_MF,:));
        leaky_integrated_in.med_correct(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_MF,:));
        leaky_integrated_in.fast_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_MF,:));
        
        leaky_integrated_in.slow_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_MF_binFAST,:));
        leaky_integrated_in.slow_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_MF_binMED,:));
        leaky_integrated_in.slow_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_MF_binSLOW,:));
        
        leaky_integrated_in.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_MF_binFAST,:));
        leaky_integrated_in.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_MF_binMED,:));
        leaky_integrated_in.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_MF_binSLOW,:));
        
        leaky_integrated_in.fast_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binFAST,:));
        leaky_integrated_in.fast_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binMED,:));
        leaky_integrated_in.fast_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_MF_binSLOW,:));
        
        
        leaky_integrated_out.slow_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_MF,:));
        leaky_integrated_out.med_correct(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_MF,:));
        leaky_integrated_out.fast_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_MF,:));
        
        leaky_integrated_out.slow_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_MF_binFAST,:));
        leaky_integrated_out.slow_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_MF_binMED,:));
        leaky_integrated_out.slow_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_MF_binSLOW,:));
        
        leaky_integrated_out.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_MF_binFAST,:));
        leaky_integrated_out.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_MF_binMED,:));
        leaky_integrated_out.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_MF_binSLOW,:));
        
        leaky_integrated_out.fast_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binFAST,:));
        leaky_integrated_out.fast_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binMED,:));
        leaky_integrated_out.fast_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_MF_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_correct_made_dead(file,:,k) = leaky_integrated_in.slow_correct_made_dead(file,:,k) - leaky_integrated_out.slow_correct_made_dead(file,:,k);
        leaky_integrated_diff.med_correct(file,:,k) = leaky_integrated_in.med_correct(file,:,k) - leaky_integrated_out.med_correct(file,:,k);
        leaky_integrated_diff.fast_correct_made_dead(file,:,k) = leaky_integrated_in.fast_correct_made_dead(file,:,k) - leaky_integrated_out.fast_correct_made_dead(file,:,k);
        
        leaky_integrated_diff.slow_correct_made_dead_binFast(file,:,k) = leaky_integrated_in.slow_correct_made_dead_binFast(file,:,k) - leaky_integrated_out.slow_correct_made_dead_binFast(file,:,k);
        leaky_integrated_diff.slow_correct_made_dead_binMed(file,:,k) = leaky_integrated_in.slow_correct_made_dead_binMed(file,:,k) - leaky_integrated_out.slow_correct_made_dead_binMed(file,:,k);
        leaky_integrated_diff.slow_correct_made_dead_binSlow(file,:,k) = leaky_integrated_in.slow_correct_made_dead_binSlow(file,:,k) - leaky_integrated_out.slow_correct_made_dead_binSlow(file,:,k);
        
        leaky_integrated_diff.med_correct_binFast(file,:,k) = leaky_integrated_in.med_correct_binFast(file,:,k) - leaky_integrated_out.med_correct_binFast(file,:,k);
        leaky_integrated_diff.med_correct_binMed(file,:,k) = leaky_integrated_in.med_correct_binMed(file,:,k) - leaky_integrated_out.med_correct_binMed(file,:,k);
        leaky_integrated_diff.med_correct_binSlow(file,:,k) = leaky_integrated_in.med_correct_binSlow(file,:,k) - leaky_integrated_out.med_correct_binSlow(file,:,k);
        
        leaky_integrated_diff.fast_correct_made_dead_binFast(file,:,k) = leaky_integrated_in.fast_correct_made_dead_binFast(file,:,k) - leaky_integrated_out.fast_correct_made_dead_binFast(file,:,k);
        leaky_integrated_diff.fast_correct_made_dead_binMed(file,:,k) = leaky_integrated_in.fast_correct_made_dead_binMed(file,:,k) - leaky_integrated_out.fast_correct_made_dead_binMed(file,:,k);
        leaky_integrated_diff.fast_correct_made_dead_binSlow(file,:,k) = leaky_integrated_in.fast_correct_made_dead_binSlow(file,:,k) - leaky_integrated_out.fast_correct_made_dead_binSlow(file,:,k);
        
        
        

        
        keep k leak leakage filename unit file mean_integrated_diff integrated_in integrated_out integrated_diff leaky_integrated_in leaky_integrated_out leaky_integrated_diff
        
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
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast),'g')

hold on

plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binFast),'g')

plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast),'g')

box off
set(gca,'xminortick','on')
title('leaky_integrated Target-In')



