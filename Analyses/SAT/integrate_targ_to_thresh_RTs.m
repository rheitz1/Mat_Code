cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename1 unit1] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename1 ; filename2 ; filename3 ; filename4] ;% ...
    %filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4] ;% unit5 ; unit6 ; unit7 ; unit8];


% with leakage = .01, mean threshold value at time = 0 (saccade -- not 20-10 before)
% is 81.755107670541070
% I will integrate target-aligned, integrated movement activity until that point at take the RT
% For this analysis, we will only look at errors and missed-deadline activity, as they did not factor
% into the threshold value calculated earlier.
%
% The medium (Neutral) condition is undefined with respect to deadline, so they will factor in only for
% errors

leak = .01;
for k = 1:length(leak)
    
    disp(['Running leakage = ' mat2str(leak(k))])
    leakage = leak(k);
    
    for file = 1:length(filename)
        
        load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
        filename{file}
        
        sig = eval(unit{file});
        
        MF = MFs.(unit{file});
        
        antiMF = mod((MF+4),8);
        
        normalize = 1;
        
        trunc_RT = 2000;
        plotBaselineBlocks = 0;
        separate_cleared_nocleared = 0;
        within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
        match_variability = 0;
        plot_integrals = 0;
        
        
        %============
        % FIND TRIALS
        %===================================================================
        
        getTrials_SAT

        
        %====================
        % Calculate ACC rates
        
        %ACC rate for missed deadlines
        ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
        ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
        ACC.med(file,1) = length(med_correct) / length(med_all);
        
        RTs.slow_errors_missed_dead(file,1) = nanmean(SRT(slow_errors_missed_dead,1));
        RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
        RTs.fast_errors_missed_dead_withCleared(file,1) = nanmean(SRT(fast_errors_missed_dead_withCleared,1));
        
        
        
        inMF = find(ismember(Target_(:,2),MF));
        outMF = find(ismember(Target_(:,2),antiMF));
        inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
        outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
        
        
        %======================
        % Movement-Aligned MF
        %==============
        
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
               
        
        
        
        
        
        
        in.slow_correct_missed_dead = intersect(inMF,slow_correct_missed_dead);
        out.slow_correct_missed_dead = intersect(outMF,slow_correct_missed_dead);
        
        in.fast_correct_missed_dead_withCleared = intersect(inMF,fast_correct_missed_dead_withCleared);
        out.fast_correct_missed_dead_withCleared = intersect(outMF,fast_correct_missed_dead_withCleared);
        

        in.slow_errors_made_dead = intersect(inMF,slow_errors_made_dead);
        out.slow_errors_made_dead = intersect(outMF,slow_errors_made_dead);
        
        in.fast_errors_made_dead = intersect(inMF,fast_errors_made_dead_withCleared);
        out.fast_errors_made_dead = intersect(outMF,fast_errors_made_dead_withCleared);
        

        in.slow_errors_missed_dead = intersect(inMF,slow_errors_missed_dead);
        out.slow_errors_missed_dead = intersect(outMF,slow_errors_missed_dead);
        
        in.fast_errors_missed_dead = intersect(inMF,fast_errors_missed_dead_withCleared);
        out.fast_errors_missed_dead = intersect(outMF,fast_errors_missed_dead_withCleared);
        
        in.med_errors = intersect(inMF,med_errors);
        out.med_errors = intersect(outMF,med_errors);
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
       
        in.slow_correct_missed_dead_binFAST = intersect(inMF,slow_correct_missed_dead_binFAST);
        out.slow_correct_missed_dead_binFAST = intersect(outMF,slow_correct_missed_dead_binFAST);
        in.slow_correct_missed_dead_binMED = intersect(inMF,slow_correct_missed_dead_binMED);
        out.slow_correct_missed_dead_binMED = intersect(outMF,slow_correct_missed_dead_binMED);
        in.slow_correct_missed_dead_binSLOW = intersect(inMF,slow_correct_missed_dead_binSLOW);
        out.slow_correct_missed_dead_binSLOW = intersect(outMF,slow_correct_missed_dead_binSLOW);
        
        in.fast_correct_missed_dead_withCleared_binFAST = intersect(inMF,fast_correct_missed_dead_withCleared_binFAST);
        out.fast_correct_missed_dead_withCleared_binFAST = intersect(outMF,fast_correct_missed_dead_withCleared_binFAST);
        in.fast_correct_missed_dead_withCleared_binMED = intersect(inMF,fast_correct_missed_dead_withCleared_binMED);
        out.fast_correct_missed_dead_withCleared_binMED = intersect(outMF,fast_correct_missed_dead_withCleared_binMED);
        in.fast_correct_missed_dead_withCleared_binSLOW = intersect(inMF,fast_correct_missed_dead_withCleared_binSLOW);
        out.fast_correct_missed_dead_withCleared_binSLOW = intersect(outMF,fast_correct_missed_dead_withCleared_binSLOW);
        
        
        in.slow_errors_made_dead_binFAST = intersect(inMF,slow_errors_made_dead_binFAST);
        out.slow_errors_made_dead_binFAST = intersect(outMF,slow_errors_made_dead_binFAST);
        in.slow_errors_made_dead_binMED = intersect(inMF,slow_errors_made_dead_binMED);
        out.slow_errors_made_dead_binMED = intersect(outMF,slow_errors_made_dead_binMED);
        in.slow_errors_made_dead_binSLOW = intersect(inMF,slow_errors_made_dead_binSLOW);
        out.slow_errors_made_dead_binSLOW = intersect(outMF,slow_errors_made_dead_binSLOW);
        
        in.fast_errors_made_dead_withCleared_binFAST = intersect(inMF,fast_errors_made_dead_withCleared_binFAST);
        out.fast_errors_made_dead_withCleared_binFAST = intersect(outMF,fast_errors_made_dead_withCleared_binFAST);
        in.fast_errors_made_dead_withCleared_binMED = intersect(inMF,fast_errors_made_dead_withCleared_binMED);
        out.fast_errors_made_dead_withCleared_binMED = intersect(outMF,fast_errors_made_dead_withCleared_binMED);
        in.fast_errors_made_dead_withCleared_binSLOW = intersect(inMF,fast_errors_made_dead_withCleared_binSLOW);
        out.fast_errors_made_dead_withCleared_binSLOW = intersect(outMF,fast_errors_made_dead_withCleared_binSLOW);
        
        in.slow_errors_missed_dead_binFAST = intersect(inMF,slow_errors_missed_dead_binFAST);
        out.slow_errors_missed_dead_binFAST = intersect(outMF,slow_errors_missed_dead_binFAST);
        in.slow_errors_missed_dead_binMED = intersect(inMF,slow_errors_missed_dead_binMED);
        out.slow_errors_missed_dead_binMED = intersect(outMF,slow_errors_missed_dead_binMED);
        in.slow_errors_missed_dead_binSLOW = intersect(inMF,slow_errors_missed_dead_binSLOW);
        out.slow_errors_missed_dead_binSLOW = intersect(outMF,slow_errors_missed_dead_binSLOW);
        
        in.fast_errors_missed_dead_withCleared_binFAST = intersect(inMF,fast_errors_missed_dead_withCleared_binFAST);
        out.fast_errors_missed_dead_withCleared_binFAST = intersect(outMF,fast_errors_missed_dead_withCleared_binFAST);
        in.fast_errors_missed_dead_withCleared_binMED = intersect(inMF,fast_errors_missed_dead_withCleared_binMED);
        out.fast_errors_missed_dead_withCleared_binMED = intersect(outMF,fast_errors_missed_dead_withCleared_binMED);
        in.fast_errors_missed_dead_withCleared_binSLOW = intersect(inMF,fast_errors_missed_dead_withCleared_binSLOW);
        out.fast_errors_missed_dead_withCleared_binSLOW = intersect(outMF,fast_errors_missed_dead_withCleared_binSLOW);
        
        
        in.med_errors_binFAST = intersect(inMF,med_errors_binFAST);
        out.med_errors_binFAST = intersect(outMF,med_errors_binFAST);
        in.med_errors_binMED = intersect(inMF,med_errors_binMED);
        out.med_errors_binMED = intersect(outMF,med_errors_binMED);
        in.med_errors_binSLOW = intersect(inMF,med_errors_binSLOW);
        out.med_errors_binSLOW = intersect(outMF,med_errors_binSLOW);

        
  
        %=============================
        
        
        
        
        SDF_r = sSDF(sig,SRT(:,1)+500,[-1000 200]);
        SDF = sSDF(sig,Target_(:,1),[0 1200]);
        
        if normalize == 1
            SDF_r = normalize_SP(SDF_r);
            SDF = normalize_SP(SDF);
        end
        
        
        %On each trial, integrate the activity beginning at stimulus onset and ending at saccade onset.
        %set out-of-bound values to 0 (WE SHOULD ALSO TRY NaNs, BUT THIS WILL AFFECT THE AVERAGES!)
        
        
        integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        leaky_integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        for trl = 1:size(SDF_r,1)
            if 1000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1)); continue; end
            
            trl_part_SDF = SDF_r(trl,1000-SRT(trl,1):1200);
            integ(1:length(trl_part_SDF)) = 0;
            for tm = 2:length(trl_part_SDF)
                integ(tm) = integ(tm-1) + trl_part_SDF(tm) - (leakage .* integ(tm-1));
            end
            
            %integrated_SDF(trl,1000-SRT(trl,1):1000) = cumsum(SDF_r(trl,1000-SRT(trl,1):1000));
            leaky_integrated_SDF(trl,1000-SRT(trl,1):1200) = integ;
            clear integ
            %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
            
        end
        
        
        %Find the mean trigger threshold across all conditions at saccade onset
        
        
        leaky_integrated_in.slow_correct_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead,:));
        leaky_integrated_in.med_correct(file,:) = nanmean(leaky_integrated_SDF(in.med_correct,:));
        leaky_integrated_in.fast_correct_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared,:));
        
        triggerVal.slow(file,1) = nanmean(leaky_integrated_in.slow_correct_made_dead(file,980:990));
        triggerVal.med(file,1) = nanmean(leaky_integrated_in.med_correct(file,980:990));
        triggerVal.fast(file,1) = nanmean(leaky_integrated_in.fast_correct_made_dead(file,980:990));
        
        
        
%         integrated_SDF(1:size(SDF,1),1:1201) = 0;
%         leaky_integrated_SDF(1:size(SDF,1),1:1201) = 0;
%         for trl = 1:size(SDF,1)
%             if isnan(SRT(trl,1)) | SRT(trl,1) > 1000; continue; end
%             
%             trl_part_SDF = SDF(trl,1:1201);
%             integ(1:length(trl_part_SDF)) = 0;
%             for tm = 2:length(trl_part_SDF)
%                 integ(tm) = integ(tm-1) + trl_part_SDF(tm) - (leakage .* integ(tm-1));
%             end
%             
%             %integrated_SDF(trl,1000-SRT(trl,1):1000) = cumsum(SDF_r(trl,1000-SRT(trl,1):1000));
%             leaky_integrated_SDF(trl,1:1201) = integ;
%             clear integ
%             %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
%             
%         end
        
                
        %Now, predict mean RT using mean integrators on missed dead trials
% % %         for trl = 1:length(in.slow_correct_missed_dead)
% % %             thresh_cross = find(leaky_integrated_SDF(in.slow_correct_missed_dead(trl),:) >= triggerVal.slow,1);
% % %             activity_start = find(leaky_integrated_SDF(in.slow_correct_missed_dead(trl),:) > 0,1);
% % %             predicted_RT.slow_correct_missed_dead = thresh_cross - activity_start;
% % %         end

        
        leaky_integrated_in.slow_correct_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead,:));
        leaky_integrated_in.med_correct(file,:) = nanmean(leaky_integrated_SDF(in.med_correct,:));
        leaky_integrated_in.fast_correct_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared,:));
        
        leaky_integrated_in.slow_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binFAST,:));
        leaky_integrated_in.slow_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binMED,:));
        leaky_integrated_in.slow_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_made_dead_binSLOW,:));
        
        leaky_integrated_in.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binFAST,:));
        leaky_integrated_in.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binMED,:));
        leaky_integrated_in.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binSLOW,:));
        
        leaky_integrated_in.fast_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_made_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead,:));
        leaky_integrated_out.med_correct(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct,:));
        leaky_integrated_out.fast_correct_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared,:));
        
        leaky_integrated_out.slow_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binFAST,:));
        leaky_integrated_out.slow_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binMED,:));
        leaky_integrated_out.slow_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_made_dead_binSLOW,:));
        
        leaky_integrated_out.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binFAST,:));
        leaky_integrated_out.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binMED,:));
        leaky_integrated_out.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binSLOW,:));
        
        leaky_integrated_out.fast_correct_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_correct_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_correct_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_made_dead_withCleared_binSLOW,:));
        
        
        
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
        
        
        
        integrated_in.slow_correct_missed_dead(file,:,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead,:));
        integrated_in.med_correct(file,:,k) = nanmean(integrated_SDF(in.med_correct,:));
        integrated_in.fast_correct_missed_dead(file,:,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
        
        integrated_in.slow_correct_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
        integrated_in.slow_correct_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binMED,:));
        integrated_in.slow_correct_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
        
        integrated_in.med_correct_binFast(file,:,k) = nanmean(integrated_SDF(in.med_correct_binFAST,:));
        integrated_in.med_correct_binMed(file,:,k) = nanmean(integrated_SDF(in.med_correct_binMED,:));
        integrated_in.med_correct_binSlow(file,:,k) = nanmean(integrated_SDF(in.med_correct_binSLOW,:));
        
        integrated_in.fast_correct_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
        integrated_in.fast_correct_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
        integrated_in.fast_correct_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_correct_missed_dead(file,:,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead,:));
        integrated_out.med_correct(file,:,k) = nanmean(integrated_SDF(out.med_correct,:));
        integrated_out.fast_correct_missed_dead(file,:,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
        
        integrated_out.slow_correct_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
        integrated_out.slow_correct_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binMED,:));
        integrated_out.slow_correct_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
        
        integrated_out.med_correct_binFast(file,:,k) = nanmean(integrated_SDF(out.med_correct_binFAST,:));
        integrated_out.med_correct_binMed(file,:,k) = nanmean(integrated_SDF(out.med_correct_binMED,:));
        integrated_out.med_correct_binSlow(file,:,k) = nanmean(integrated_SDF(out.med_correct_binSLOW,:));
        
        integrated_out.fast_correct_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
        integrated_out.fast_correct_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
        integrated_out.fast_correct_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_correct_missed_dead(file,:,k) = integrated_in.slow_correct_missed_dead(file,:,k) - integrated_out.slow_correct_missed_dead(file,:,k);
        integrated_diff.med_correct(file,:,k) = integrated_in.med_correct(file,:,k) - integrated_out.med_correct(file,:,k);
        integrated_diff.fast_correct_missed_dead(file,:,k) = integrated_in.fast_correct_missed_dead(file,:,k) - integrated_out.fast_correct_missed_dead(file,:,k);
        
        integrated_diff.slow_correct_missed_dead_binFast(file,:,k) = integrated_in.slow_correct_missed_dead_binFast(file,:,k) - integrated_out.slow_correct_missed_dead_binFast(file,:,k);
        integrated_diff.slow_correct_missed_dead_binMed(file,:,k) = integrated_in.slow_correct_missed_dead_binMed(file,:,k) - integrated_out.slow_correct_missed_dead_binMed(file,:,k);
        integrated_diff.slow_correct_missed_dead_binSlow(file,:,k) = integrated_in.slow_correct_missed_dead_binSlow(file,:,k) - integrated_out.slow_correct_missed_dead_binSlow(file,:,k);
        
        integrated_diff.med_correct_binFast(file,:,k) = integrated_in.med_correct_binFast(file,:,k) - integrated_out.med_correct_binFast(file,:,k);
        integrated_diff.med_correct_binMed(file,:,k) = integrated_in.med_correct_binMed(file,:,k) - integrated_out.med_correct_binMed(file,:,k);
        integrated_diff.med_correct_binSlow(file,:,k) = integrated_in.med_correct_binSlow(file,:,k) - integrated_out.med_correct_binSlow(file,:,k);
        
        integrated_diff.fast_correct_missed_dead_binFast(file,:,k) = integrated_in.fast_correct_missed_dead_binFast(file,:,k) - integrated_out.fast_correct_missed_dead_binFast(file,:,k);
        integrated_diff.fast_correct_missed_dead_binMed(file,:,k) = integrated_in.fast_correct_missed_dead_binMed(file,:,k) - integrated_out.fast_correct_missed_dead_binMed(file,:,k);
        integrated_diff.fast_correct_missed_dead_binSlow(file,:,k) = integrated_in.fast_correct_missed_dead_binSlow(file,:,k) - integrated_out.fast_correct_missed_dead_binSlow(file,:,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_correct_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead,:));
        leaky_integrated_in.med_correct(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct,:));
        leaky_integrated_in.fast_correct_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
        
        leaky_integrated_in.slow_correct_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
        leaky_integrated_in.slow_correct_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binMED,:));
        leaky_integrated_in.slow_correct_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
        
        leaky_integrated_in.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binFAST,:));
        leaky_integrated_in.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binMED,:));
        leaky_integrated_in.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.med_correct_binSLOW,:));
        
        leaky_integrated_in.fast_correct_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_correct_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_correct_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_correct_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead,:));
        leaky_integrated_out.med_correct(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct,:));
        leaky_integrated_out.fast_correct_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
        
        leaky_integrated_out.slow_correct_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
        leaky_integrated_out.slow_correct_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binMED,:));
        leaky_integrated_out.slow_correct_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
        
        leaky_integrated_out.med_correct_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binFAST,:));
        leaky_integrated_out.med_correct_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binMED,:));
        leaky_integrated_out.med_correct_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.med_correct_binSLOW,:));
        
        leaky_integrated_out.fast_correct_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_correct_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_correct_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_correct_missed_dead(file,:,k) = leaky_integrated_in.slow_correct_missed_dead(file,:,k) - leaky_integrated_out.slow_correct_missed_dead(file,:,k);
        leaky_integrated_diff.med_correct(file,:,k) = leaky_integrated_in.med_correct(file,:,k) - leaky_integrated_out.med_correct(file,:,k);
        leaky_integrated_diff.fast_correct_missed_dead(file,:,k) = leaky_integrated_in.fast_correct_missed_dead(file,:,k) - leaky_integrated_out.fast_correct_missed_dead(file,:,k);
        
        leaky_integrated_diff.slow_correct_missed_dead_binFast(file,:,k) = leaky_integrated_in.slow_correct_missed_dead_binFast(file,:,k) - leaky_integrated_out.slow_correct_missed_dead_binFast(file,:,k);
        leaky_integrated_diff.slow_correct_missed_dead_binMed(file,:,k) = leaky_integrated_in.slow_correct_missed_dead_binMed(file,:,k) - leaky_integrated_out.slow_correct_missed_dead_binMed(file,:,k);
        leaky_integrated_diff.slow_correct_missed_dead_binSlow(file,:,k) = leaky_integrated_in.slow_correct_missed_dead_binSlow(file,:,k) - leaky_integrated_out.slow_correct_missed_dead_binSlow(file,:,k);
        
        leaky_integrated_diff.med_correct_binFast(file,:,k) = leaky_integrated_in.med_correct_binFast(file,:,k) - leaky_integrated_out.med_correct_binFast(file,:,k);
        leaky_integrated_diff.med_correct_binMed(file,:,k) = leaky_integrated_in.med_correct_binMed(file,:,k) - leaky_integrated_out.med_correct_binMed(file,:,k);
        leaky_integrated_diff.med_correct_binSlow(file,:,k) = leaky_integrated_in.med_correct_binSlow(file,:,k) - leaky_integrated_out.med_correct_binSlow(file,:,k);
        
        leaky_integrated_diff.fast_correct_missed_dead_binFast(file,:,k) = leaky_integrated_in.fast_correct_missed_dead_binFast(file,:,k) - leaky_integrated_out.fast_correct_missed_dead_binFast(file,:,k);
        leaky_integrated_diff.fast_correct_missed_dead_binMed(file,:,k) = leaky_integrated_in.fast_correct_missed_dead_binMed(file,:,k) - leaky_integrated_out.fast_correct_missed_dead_binMed(file,:,k);
        leaky_integrated_diff.fast_correct_missed_dead_binSlow(file,:,k) = leaky_integrated_in.fast_correct_missed_dead_binSlow(file,:,k) - leaky_integrated_out.fast_correct_missed_dead_binSlow(file,:,k);
        
        
        
        leaky_integrated_in.slow_errors_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead,:));
        leaky_integrated_in.med_errors(file,:) = nanmean(leaky_integrated_SDF(in.med_errors,:));
        leaky_integrated_in.fast_errors_made_dead(file,:) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared,:));
        
        leaky_integrated_in.slow_errors_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binFAST,:));
        leaky_integrated_in.slow_errors_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binMED,:));
        leaky_integrated_in.slow_errors_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_made_dead_binSLOW,:));
        
        leaky_integrated_in.med_errors_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binFAST,:));
        leaky_integrated_in.med_errors_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binMED,:));
        leaky_integrated_in.med_errors_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binSLOW,:));
        
        leaky_integrated_in.fast_errors_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_errors_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_errors_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_made_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_errors_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead,:));
        leaky_integrated_out.med_errors(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors,:));
        leaky_integrated_out.fast_errors_made_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared,:));
        
        leaky_integrated_out.slow_errors_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binFAST,:));
        leaky_integrated_out.slow_errors_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binMED,:));
        leaky_integrated_out.slow_errors_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_made_dead_binSLOW,:));
        
        leaky_integrated_out.med_errors_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binFAST,:));
        leaky_integrated_out.med_errors_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binMED,:));
        leaky_integrated_out.med_errors_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binSLOW,:));
        
        leaky_integrated_out.fast_errors_made_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_errors_made_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_errors_made_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_made_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_errors_made_dead(file,:,k) = leaky_integrated_in.slow_errors_made_dead(file,:,k) - leaky_integrated_out.slow_errors_made_dead(file,:,k);
        leaky_integrated_diff.med_errors(file,:,k) = leaky_integrated_in.med_errors(file,:,k) - leaky_integrated_out.med_errors(file,:,k);
        leaky_integrated_diff.fast_errors_made_dead(file,:,k) = leaky_integrated_in.fast_errors_made_dead(file,:,k) - leaky_integrated_out.fast_errors_made_dead(file,:,k);
        
        leaky_integrated_diff.slow_errors_made_dead_binFast(file,:,k) = leaky_integrated_in.slow_errors_made_dead_binFast(file,:,k) - leaky_integrated_out.slow_errors_made_dead_binFast(file,:,k);
        leaky_integrated_diff.slow_errors_made_dead_binMed(file,:,k) = leaky_integrated_in.slow_errors_made_dead_binMed(file,:,k) - leaky_integrated_out.slow_errors_made_dead_binMed(file,:,k);
        leaky_integrated_diff.slow_errors_made_dead_binSlow(file,:,k) = leaky_integrated_in.slow_errors_made_dead_binSlow(file,:,k) - leaky_integrated_out.slow_errors_made_dead_binSlow(file,:,k);
        
        leaky_integrated_diff.med_errors_binFast(file,:,k) = leaky_integrated_in.med_errors_binFast(file,:,k) - leaky_integrated_out.med_errors_binFast(file,:,k);
        leaky_integrated_diff.med_errors_binMed(file,:,k) = leaky_integrated_in.med_errors_binMed(file,:,k) - leaky_integrated_out.med_errors_binMed(file,:,k);
        leaky_integrated_diff.med_errors_binSlow(file,:,k) = leaky_integrated_in.med_errors_binSlow(file,:,k) - leaky_integrated_out.med_errors_binSlow(file,:,k);
        
        leaky_integrated_diff.fast_errors_made_dead_binFast(file,:,k) = leaky_integrated_in.fast_errors_made_dead_binFast(file,:,k) - leaky_integrated_out.fast_errors_made_dead_binFast(file,:,k);
        leaky_integrated_diff.fast_errors_made_dead_binMed(file,:,k) = leaky_integrated_in.fast_errors_made_dead_binMed(file,:,k) - leaky_integrated_out.fast_errors_made_dead_binMed(file,:,k);
        leaky_integrated_diff.fast_errors_made_dead_binSlow(file,:,k) = leaky_integrated_in.fast_errors_made_dead_binSlow(file,:,k) - leaky_integrated_out.fast_errors_made_dead_binSlow(file,:,k);
        
        
        
        integrated_in.slow_errors_missed_dead(file,:,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead,:));
        integrated_in.med_errors(file,:,k) = nanmean(integrated_SDF(in.med_errors,:));
        integrated_in.fast_errors_missed_dead(file,:,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
        
        integrated_in.slow_errors_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
        integrated_in.slow_errors_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binMED,:));
        integrated_in.slow_errors_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
        
        integrated_in.med_errors_binFast(file,:,k) = nanmean(integrated_SDF(in.med_errors_binFAST,:));
        integrated_in.med_errors_binMed(file,:,k) = nanmean(integrated_SDF(in.med_errors_binMED,:));
        integrated_in.med_errors_binSlow(file,:,k) = nanmean(integrated_SDF(in.med_errors_binSLOW,:));
        
        integrated_in.fast_errors_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
        integrated_in.fast_errors_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
        integrated_in.fast_errors_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        integrated_out.slow_errors_missed_dead(file,:,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead,:));
        integrated_out.med_errors(file,:,k) = nanmean(integrated_SDF(out.med_errors,:));
        integrated_out.fast_errors_missed_dead(file,:,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
        
        integrated_out.slow_errors_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
        integrated_out.slow_errors_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binMED,:));
        integrated_out.slow_errors_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
        
        integrated_out.med_errors_binFast(file,:,k) = nanmean(integrated_SDF(out.med_errors_binFAST,:));
        integrated_out.med_errors_binMed(file,:,k) = nanmean(integrated_SDF(out.med_errors_binMED,:));
        integrated_out.med_errors_binSlow(file,:,k) = nanmean(integrated_SDF(out.med_errors_binSLOW,:));
        
        integrated_out.fast_errors_missed_dead_binFast(file,:,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
        integrated_out.fast_errors_missed_dead_binMed(file,:,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
        integrated_out.fast_errors_missed_dead_binSlow(file,:,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        integrated_diff.slow_errors_missed_dead(file,:,k) = integrated_in.slow_errors_missed_dead(file,:,k) - integrated_out.slow_errors_missed_dead(file,:,k);
        integrated_diff.med_errors(file,:,k) = integrated_in.med_errors(file,:,k) - integrated_out.med_errors(file,:,k);
        integrated_diff.fast_errors_missed_dead(file,:,k) = integrated_in.fast_errors_missed_dead(file,:,k) - integrated_out.fast_errors_missed_dead(file,:,k);
        
        integrated_diff.slow_errors_missed_dead_binFast(file,:,k) = integrated_in.slow_errors_missed_dead_binFast(file,:,k) - integrated_out.slow_errors_missed_dead_binFast(file,:,k);
        integrated_diff.slow_errors_missed_dead_binMed(file,:,k) = integrated_in.slow_errors_missed_dead_binMed(file,:,k) - integrated_out.slow_errors_missed_dead_binMed(file,:,k);
        integrated_diff.slow_errors_missed_dead_binSlow(file,:,k) = integrated_in.slow_errors_missed_dead_binSlow(file,:,k) - integrated_out.slow_errors_missed_dead_binSlow(file,:,k);
        
        integrated_diff.med_errors_binFast(file,:,k) = integrated_in.med_errors_binFast(file,:,k) - integrated_out.med_errors_binFast(file,:,k);
        integrated_diff.med_errors_binMed(file,:,k) = integrated_in.med_errors_binMed(file,:,k) - integrated_out.med_errors_binMed(file,:,k);
        integrated_diff.med_errors_binSlow(file,:,k) = integrated_in.med_errors_binSlow(file,:,k) - integrated_out.med_errors_binSlow(file,:,k);
        
        integrated_diff.fast_errors_missed_dead_binFast(file,:,k) = integrated_in.fast_errors_missed_dead_binFast(file,:,k) - integrated_out.fast_errors_missed_dead_binFast(file,:,k);
        integrated_diff.fast_errors_missed_dead_binMed(file,:,k) = integrated_in.fast_errors_missed_dead_binMed(file,:,k) - integrated_out.fast_errors_missed_dead_binMed(file,:,k);
        integrated_diff.fast_errors_missed_dead_binSlow(file,:,k) = integrated_in.fast_errors_missed_dead_binSlow(file,:,k) - integrated_out.fast_errors_missed_dead_binSlow(file,:,k);
        
        
        
        
        
        
        leaky_integrated_in.slow_errors_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead,:));
        leaky_integrated_in.med_errors(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors,:));
        leaky_integrated_in.fast_errors_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
        
        leaky_integrated_in.slow_errors_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
        leaky_integrated_in.slow_errors_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binMED,:));
        leaky_integrated_in.slow_errors_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
        
        leaky_integrated_in.med_errors_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binFAST,:));
        leaky_integrated_in.med_errors_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binMED,:));
        leaky_integrated_in.med_errors_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.med_errors_binSLOW,:));
        
        leaky_integrated_in.fast_errors_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
        leaky_integrated_in.fast_errors_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
        leaky_integrated_in.fast_errors_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        leaky_integrated_out.slow_errors_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead,:));
        leaky_integrated_out.med_errors(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors,:));
        leaky_integrated_out.fast_errors_missed_dead(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
        
        leaky_integrated_out.slow_errors_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
        leaky_integrated_out.slow_errors_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binMED,:));
        leaky_integrated_out.slow_errors_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
        
        leaky_integrated_out.med_errors_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binFAST,:));
        leaky_integrated_out.med_errors_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binMED,:));
        leaky_integrated_out.med_errors_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.med_errors_binSLOW,:));
        
        leaky_integrated_out.fast_errors_missed_dead_binFast(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
        leaky_integrated_out.fast_errors_missed_dead_binMed(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
        leaky_integrated_out.fast_errors_missed_dead_binSlow(file,:,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
        
        
        
        leaky_integrated_diff.slow_errors_missed_dead(file,:,k) = leaky_integrated_in.slow_errors_missed_dead(file,:,k) - leaky_integrated_out.slow_errors_missed_dead(file,:,k);
        leaky_integrated_diff.med_errors(file,:,k) = leaky_integrated_in.med_errors(file,:,k) - leaky_integrated_out.med_errors(file,:,k);
        leaky_integrated_diff.fast_errors_missed_dead(file,:,k) = leaky_integrated_in.fast_errors_missed_dead(file,:,k) - leaky_integrated_out.fast_errors_missed_dead(file,:,k);
        
        leaky_integrated_diff.slow_errors_missed_dead_binFast(file,:,k) = leaky_integrated_in.slow_errors_missed_dead_binFast(file,:,k) - leaky_integrated_out.slow_errors_missed_dead_binFast(file,:,k);
        leaky_integrated_diff.slow_errors_missed_dead_binMed(file,:,k) = leaky_integrated_in.slow_errors_missed_dead_binMed(file,:,k) - leaky_integrated_out.slow_errors_missed_dead_binMed(file,:,k);
        leaky_integrated_diff.slow_errors_missed_dead_binSlow(file,:,k) = leaky_integrated_in.slow_errors_missed_dead_binSlow(file,:,k) - leaky_integrated_out.slow_errors_missed_dead_binSlow(file,:,k);
        
        leaky_integrated_diff.med_errors_binFast(file,:,k) = leaky_integrated_in.med_errors_binFast(file,:,k) - leaky_integrated_out.med_errors_binFast(file,:,k);
        leaky_integrated_diff.med_errors_binMed(file,:,k) = leaky_integrated_in.med_errors_binMed(file,:,k) - leaky_integrated_out.med_errors_binMed(file,:,k);
        leaky_integrated_diff.med_errors_binSlow(file,:,k) = leaky_integrated_in.med_errors_binSlow(file,:,k) - leaky_integrated_out.med_errors_binSlow(file,:,k);
        
        leaky_integrated_diff.fast_errors_missed_dead_binFast(file,:,k) = leaky_integrated_in.fast_errors_missed_dead_binFast(file,:,k) - leaky_integrated_out.fast_errors_missed_dead_binFast(file,:,k);
        leaky_integrated_diff.fast_errors_missed_dead_binMed(file,:,k) = leaky_integrated_in.fast_errors_missed_dead_binMed(file,:,k) - leaky_integrated_out.fast_errors_missed_dead_binMed(file,:,k);
        leaky_integrated_diff.fast_errors_missed_dead_binSlow(file,:,k) = leaky_integrated_in.fast_errors_missed_dead_binSlow(file,:,k) - leaky_integrated_out.fast_errors_missed_dead_binSlow(file,:,k);
        

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



figure
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead),'g')
box off
set(gca,'xminortick','on')
 
figure
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast),'g')
 
hold on
 
plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binFast),'g')
 
plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast),'g')
 
box off
set(gca,'xminortick','on')
title('MISSED DEAD leaky_integrated Target-In')


