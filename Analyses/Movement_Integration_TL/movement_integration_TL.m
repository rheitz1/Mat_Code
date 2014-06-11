% cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
 [filename unit] = textread('QS_Move_TL.txt','%s %s');





% dsk
%[filename unit] = textread('QS_MOVE_NEW.txt','%s %s');
% [filename unit] = textread('QS_MOVE_NEW2.txt','%s %s');

% leak = .01;

leak = .001:.001:.1;

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
        
        load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','Errors_','RFs','MFs','newfile')
        filename{file}
        
        sig = eval(unit{file});
        
        MF = MFs.(unit{file});
        
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
        %getTrials_SAT
        
        ss2_correct = find(Correct_(:,2) == 1 & Target_(:,5) == 2);
        ss2_errors = find(Errors_(:,5) == 1 & Target_(:,5) == 2);
        ss4_correct = find(Correct_(:,2) == 1 & Target_(:,5) == 4);
        ss4_errors = find(Errors_(:,5) == 1 & Target_(:,5) == 4);
        ss8_correct = find(Correct_(:,2) == 1 & Target_(:,5) == 8);
        ss8_errors = find(Errors_(:,5) == 1 & Target_(:,5) == 8);
        
%        
%         %====================
%         % Calculate ACC rates
%         %percentage of CORRECT trials that missed the deadline
%         prc_missed_slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
%         prc_missed_fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(ss8_correct_withCleared) + length(fast_correct_missed_dead_withCleared));
%         
%         %ACC rate for made deadlines
%         ACC.slow_made_dead(file,1) = length(slow_correct_made_dead) / length(slow_all_made_dead);
%         ACC.fast_made_dead_withCleared(file,1) = length(ss8_correct_withCleared) / length(fast_all_made_dead_withCleared);
%         
%         
%         %ACC rate for missed deadlines
%         ACC.slow_missed_dead(file,1) = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
%         ACC.fast_missed_dead_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
%         
%         
%         %overall ACC rate for made + missed deadlines
%         ACC.slow_made_missed(file,1) = length(slow_correct_made_missed) / length(slow_all);
%         ACC.fast_made_missed_withCleared(file,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
%         
%         
%         ACC.med(file,1) = length(med_correct) / length(med_all);
%         
%         
%         RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
%         RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
%         RTs.ss8_correct_withCleared(file,1) = nanmean(SRT(ss8_correct_withCleared,1));
%         
%         
%         RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
%         RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
%         RTs.ss8_errors_withCleared(file,1) = nanmean(SRT(ss8_errors_withCleared,1));
%         
%         
        
        inMF = find(ismember(Target_(:,2),MF));
        outMF = find(ismember(Target_(:,2),antiMF));
        inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
        outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
        
        
        %======================
        % Movement-Aligned MF
        %==============
        % CORRECT
        %made dead only
        in.ss2_correct = intersect(inMF,ss2_correct);
        out.ss2_correct = intersect(outMF,ss2_correct);
        
        in.ss4_correct = intersect(inMF,ss4_correct);
        out.ss4_correct = intersect(outMF,ss4_correct);
        
        
        in.ss8_correct = intersect(inMF,ss8_correct);
        out.ss8_correct = intersect(outMF,ss8_correct);
        

        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
%         in.ss2_correct_binFAST = intersect(inMF,ss2_correct_binFAST);
%         out.ss2_correct_binFAST = intersect(outMF,ss2_correct_binFAST);
%         in.ss2_correct_binMED = intersect(inMF,ss2_correct_binMED);
%         out.ss2_correct_binMED = intersect(outMF,ss2_correct_binMED);
%         in.ss2_correct_binSLOW = intersect(inMF,ss2_correct_binSLOW);
%         out.ss2_correct_binSLOW = intersect(outMF,ss2_correct_binSLOW);
%         
%         in.ss4_correct_binFAST = intersect(inMF,ss4_correct_binFAST);
%         out.ss4_correct_binFAST = intersect(outMF,ss4_correct_binFAST);
%         in.ss4_correct_binMED = intersect(inMF,ss4_correct_binMED);
%         out.ss4_correct_binMED = intersect(outMF,ss4_correct_binMED);
%         in.ss4_correct_binSLOW = intersect(inMF,ss4_correct_binSLOW);
%         out.ss4_correct_binSLOW = intersect(outMF,ss4_correct_binSLOW);
%         
%         in.ss8_correct_binFAST = intersect(inMF,ss8_correct_binFAST);
%         out.ss8_correct_binFAST = intersect(outMF,ss8_correct_binFAST);
%         in.ss8_correct_binMED = intersect(inMF,ss8_correct_binMED);
%         out.ss8_correct_binMED = intersect(outMF,ss8_correct_binMED);
%         in.ss8_correct_binSLOW = intersect(inMF,ss8_correct_binSLOW);
%         out.ss8_correct_binSLOW = intersect(outMF,ss8_correct_binSLOW);
        
        
        
        in.ss2_errors = intersect(inMF,ss2_errors);
        out.ss2_errors = intersect(outMF,ss2_errors);
        
        in.ss4_errors = intersect(inMF,ss4_errors);
        out.ss4_errors = intersect(outMF,ss4_errors);
        
        
        in.ss8_errors = intersect(inMF,ss8_errors);
        out.ss8_errors = intersect(outMF,ss8_errors);
        
        
        
        
        %==============================
        % WITHIN CONDITION RT BIN SPLIT
%         in.ss2_errors_binFAST = intersect(inMF,ss2_errors_binFAST);
%         out.ss2_errors_binFAST = intersect(outMF,ss2_errors_binFAST);
%         in.ss2_errors_binMED = intersect(inMF,ss2_errors_binMED);
%         out.ss2_errors_binMED = intersect(outMF,ss2_errors_binMED);
%         in.ss2_errors_binSLOW = intersect(inMF,ss2_errors_binSLOW);
%         out.ss2_errors_binSLOW = intersect(outMF,ss2_errors_binSLOW);
%         
%         in.ss4_errors_binFAST = intersect(inMF,ss4_errors_binFAST);
%         out.ss4_errors_binFAST = intersect(outMF,ss4_errors_binFAST);
%         in.ss4_errors_binMED = intersect(inMF,ss4_errors_binMED);
%         out.ss4_errors_binMED = intersect(outMF,ss4_errors_binMED);
%         in.ss4_errors_binSLOW = intersect(inMF,ss4_errors_binSLOW);
%         out.ss4_errors_binSLOW = intersect(outMF,ss4_errors_binSLOW);
%         
%         in.ss8_errors_binFAST = intersect(inMF,ss8_errors_binFAST);
%         out.ss8_errors_binFAST = intersect(outMF,ss8_errors_binFAST);
%         in.ss8_errors_binMED = intersect(inMF,ss8_errors_binMED);
%         out.ss8_errors_binMED = intersect(outMF,ss8_errors_binMED);
%         in.ss8_errors_binSLOW = intersect(inMF,ss8_errors_binSLOW);
%         out.ss8_errors_binSLOW = intersect(outMF,ss8_errors_binSLOW);
        
%         %made dead only
%         in.slow_correct_missed_dead = intersect(inMF,slow_correct_missed_dead);
%         out.slow_correct_missed_dead = intersect(outMF,slow_correct_missed_dead);
%         
%         in.ss4_correct = intersect(inMF,ss4_correct);
%         out.ss4_correct = intersect(outMF,ss4_correct);
%         
%         
%         in.fast_correct_missed_dead_withCleared = intersect(inMF,fast_correct_missed_dead_withCleared);
%         out.fast_correct_missed_dead_withCleared = intersect(outMF,fast_correct_missed_dead_withCleared);
%         
%         in.fast_correct_missed_dead_noCleared = intersect(inMF,fast_correct_missed_dead_noCleared);
%         out.fast_correct_missed_dead_noCleared = intersect(outMF,fast_correct_missed_dead_noCleared);
%         
%         
%         %==============================
%         % WITHIN CONDITION RT BIN SPLIT
%         in.slow_correct_missed_dead_binFAST = intersect(inMF,slow_correct_missed_dead_binFAST);
%         out.slow_correct_missed_dead_binFAST = intersect(outMF,slow_correct_missed_dead_binFAST);
%         in.slow_correct_missed_dead_binMED = intersect(inMF,slow_correct_missed_dead_binMED);
%         out.slow_correct_missed_dead_binMED = intersect(outMF,slow_correct_missed_dead_binMED);
%         in.slow_correct_missed_dead_binSLOW = intersect(inMF,slow_correct_missed_dead_binSLOW);
%         out.slow_correct_missed_dead_binSLOW = intersect(outMF,slow_correct_missed_dead_binSLOW);
%         
%         in.ss4_correct_binFAST = intersect(inMF,ss4_correct_binFAST);
%         out.ss4_correct_binFAST = intersect(outMF,ss4_correct_binFAST);
%         in.ss4_correct_binMED = intersect(inMF,ss4_correct_binMED);
%         out.ss4_correct_binMED = intersect(outMF,ss4_correct_binMED);
%         in.ss4_correct_binSLOW = intersect(inMF,ss4_correct_binSLOW);
%         out.ss4_correct_binSLOW = intersect(outMF,ss4_correct_binSLOW);
%         
%         in.fast_correct_missed_dead_withCleared_binFAST = intersect(inMF,fast_correct_missed_dead_withCleared_binFAST);
%         out.fast_correct_missed_dead_withCleared_binFAST = intersect(outMF,fast_correct_missed_dead_withCleared_binFAST);
%         in.fast_correct_missed_dead_withCleared_binMED = intersect(inMF,fast_correct_missed_dead_withCleared_binMED);
%         out.fast_correct_missed_dead_withCleared_binMED = intersect(outMF,fast_correct_missed_dead_withCleared_binMED);
%         in.fast_correct_missed_dead_withCleared_binSLOW = intersect(inMF,fast_correct_missed_dead_withCleared_binSLOW);
%         out.fast_correct_missed_dead_withCleared_binSLOW = intersect(outMF,fast_correct_missed_dead_withCleared_binSLOW);
%         
%         
%         
%         in.slow_errors_missed_dead = intersect(inMF,slow_errors_missed_dead);
%         out.slow_errors_missed_dead = intersect(outMF,slow_errors_missed_dead);
%         
%         in.ss4_errors = intersect(inMF,ss4_errors);
%         out.ss4_errors = intersect(outMF,ss4_errors);
%         
%         
%         in.fast_errors_missed_dead_withCleared = intersect(inMF,fast_errors_missed_dead_withCleared);
%         out.fast_errors_missed_dead_withCleared = intersect(outMF,fast_errors_missed_dead_withCleared);
%         
%         
%         
%         
%         %==============================
%         % WITHIN CONDITION RT BIN SPLIT
%         in.slow_errors_missed_dead_binFAST = intersect(inMF,slow_errors_missed_dead_binFAST);
%         out.slow_errors_missed_dead_binFAST = intersect(outMF,slow_errors_missed_dead_binFAST);
%         in.slow_errors_missed_dead_binMED = intersect(inMF,slow_errors_missed_dead_binMED);
%         out.slow_errors_missed_dead_binMED = intersect(outMF,slow_errors_missed_dead_binMED);
%         in.slow_errors_missed_dead_binSLOW = intersect(inMF,slow_errors_missed_dead_binSLOW);
%         out.slow_errors_missed_dead_binSLOW = intersect(outMF,slow_errors_missed_dead_binSLOW);
%         
%         in.ss4_errors_binFAST = intersect(inMF,ss4_errors_binFAST);
%         out.ss4_errors_binFAST = intersect(outMF,ss4_errors_binFAST);
%         in.ss4_errors_binMED = intersect(inMF,ss4_errors_binMED);
%         out.ss4_errors_binMED = intersect(outMF,ss4_errors_binMED);
%         in.ss4_errors_binSLOW = intersect(inMF,ss4_errors_binSLOW);
%         out.ss4_errors_binSLOW = intersect(outMF,ss4_errors_binSLOW);
%         
%         in.fast_errors_missed_dead_withCleared_binFAST = intersect(inMF,fast_errors_missed_dead_withCleared_binFAST);
%         out.fast_errors_missed_dead_withCleared_binFAST = intersect(outMF,fast_errors_missed_dead_withCleared_binFAST);
%         in.fast_errors_missed_dead_withCleared_binMED = intersect(inMF,fast_errors_missed_dead_withCleared_binMED);
%         out.fast_errors_missed_dead_withCleared_binMED = intersect(outMF,fast_errors_missed_dead_withCleared_binMED);
%         in.fast_errors_missed_dead_withCleared_binSLOW = intersect(inMF,fast_errors_missed_dead_withCleared_binSLOW);
%         out.fast_errors_missed_dead_withCleared_binSLOW = intersect(outMF,fast_errors_missed_dead_withCleared_binSLOW);
%         
%         
        %=============================
        %=============================
        
        
        
        SDF_r = sSDF(sig,SRT(:,1)+500,[-1000 200]);
        
        if normalize == 1
            SDF_r = normalize_SP(SDF_r);
        end
        
        SRT = round(SRT(:,1));
        %On each trial, integrate the activity beginning at stimulus onset and ending at saccade onset.
        %set out-of-bound values to 0 (WE SHOULD ALSO TRY NaNs, BUT THIS WILL AFFECT THE AVERAGES!)
        
        
        integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        leaky_integrated_SDF(1:size(SDF_r,1),1:1201) = 0;
        for trl = 1:size(SDF_r,1)
            if 1000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1)); continue; end
            
            trl_part_SDF = SDF_r(trl,1000-SRT(trl,1):1200); %+100 so that integration starts 100 ms after target onset
            integ(1:length(trl_part_SDF)) = 0;
            for tm = 2:length(trl_part_SDF)
                integ(tm) = integ(tm-1) + trl_part_SDF(tm) - (leakage .* integ(tm-1));
            end
            
            integrated_SDF(trl,1000-SRT(trl,1):1200) = cumsum(SDF_r(trl,1000-SRT(trl,1):1200));
            leaky_integrated_SDF(trl,1000-SRT(trl,1):1200) = integ;
            clear integ
            %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
            
        end
        
        %integrated_SDF(:,800:1000) = cumsum(SDF_r(:,800:1000),2);
        
        
        %REMOVE TRIALS WITH NO SPIKES
%         integ_sum = sum(integrated_SDF,2);
%         remove = find(integ_sum == 0);
%         integrated_SDF(remove,:) = NaN;
        
        
        
        integrated_in.ss2_correct(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_correct,:));
        integrated_in.ss4_correct(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct,:));
        integrated_in.ss8_correct(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_correct,:));
         
%         integrated_in.ss2_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_correct_binFAST,:));
%         integrated_in.ss2_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_correct_binMED,:));
%         integrated_in.ss2_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_correct_binSLOW,:));
%         
%         integrated_in.ss4_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binFAST,:));
%         integrated_in.ss4_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binMED,:));
%         integrated_in.ss4_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binSLOW,:));
%         
%         integrated_in.ss8_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_correct_binFAST,:));
%         integrated_in.ss8_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_correct_binMED,:));
%         integrated_in.ss8_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_correct_binSLOW,:));
        
        
        integrated_out.ss2_correct(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_correct,:));
        integrated_out.ss4_correct(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct,:));
        integrated_out.ss8_correct(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_correct,:));
        
%         integrated_out.ss2_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_correct_binFAST,:));
%         integrated_out.ss2_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_correct_binMED,:));
%         integrated_out.ss2_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_correct_binSLOW,:));
%         
%         integrated_out.ss4_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binFAST,:));
%         integrated_out.ss4_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binMED,:));
%         integrated_out.ss4_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binSLOW,:));
%         
%         integrated_out.ss8_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_correct_binFAST,:));
%         integrated_out.ss8_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_correct_binMED,:));
%         integrated_out.ss8_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_correct_binSLOW,:));
        
        integrated_diff.ss2_correct(file,1:1201,k) = integrated_in.ss2_correct(file,1:1201,k) - integrated_out.ss2_correct(file,1:1201,k);
        integrated_diff.ss4_correct(file,1:1201,k) = integrated_in.ss4_correct(file,1:1201,k) - integrated_out.ss4_correct(file,1:1201,k);
        integrated_diff.ss8_correct(file,1:1201,k) = integrated_in.ss8_correct(file,1:1201,k) - integrated_out.ss8_correct(file,1:1201,k);
        
%         integrated_diff.ss2_correct_binFast(file,1:1201,k) = integrated_in.ss2_correct_binFast(file,1:1201,k) - integrated_out.ss2_correct_binFast(file,1:1201,k);
%         integrated_diff.ss2_correct_binMed(file,1:1201,k) = integrated_in.ss2_correct_binMed(file,1:1201,k) - integrated_out.ss2_correct_binMed(file,1:1201,k);
%         integrated_diff.ss2_correct_binSlow(file,1:1201,k) = integrated_in.ss2_correct_binSlow(file,1:1201,k) - integrated_out.ss2_correct_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss4_correct_binFast(file,1:1201,k) = integrated_in.ss4_correct_binFast(file,1:1201,k) - integrated_out.ss4_correct_binFast(file,1:1201,k);
%         integrated_diff.ss4_correct_binMed(file,1:1201,k) = integrated_in.ss4_correct_binMed(file,1:1201,k) - integrated_out.ss4_correct_binMed(file,1:1201,k);
%         integrated_diff.ss4_correct_binSlow(file,1:1201,k) = integrated_in.ss4_correct_binSlow(file,1:1201,k) - integrated_out.ss4_correct_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss8_correct_binFast(file,1:1201,k) = integrated_in.ss8_correct_binFast(file,1:1201,k) - integrated_out.ss8_correct_binFast(file,1:1201,k);
%         integrated_diff.ss8_correct_binMed(file,1:1201,k) = integrated_in.ss8_correct_binMed(file,1:1201,k) - integrated_out.ss8_correct_binMed(file,1:1201,k);
%         integrated_diff.ss8_correct_binSlow(file,1:1201,k) = integrated_in.ss8_correct_binSlow(file,1:1201,k) - integrated_out.ss8_correct_binSlow(file,1:1201,k);
  
        
        
        
        
        
        leaky_integrated_in.ss2_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_correct,:));
        leaky_integrated_in.ss4_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct,:));
        leaky_integrated_in.ss8_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_correct,:));
        
%         leaky_integrated_in.ss2_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_correct_binFAST,:));
%         leaky_integrated_in.ss2_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_correct_binMED,:));
%         leaky_integrated_in.ss2_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_correct_binSLOW,:));
%         
%         leaky_integrated_in.ss4_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binFAST,:));
%         leaky_integrated_in.ss4_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binMED,:));
%         leaky_integrated_in.ss4_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binSLOW,:));
%         
%         leaky_integrated_in.ss8_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_correct_binFAST,:));
%         leaky_integrated_in.ss8_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_correct_binMED,:));
%         leaky_integrated_in.ss8_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_correct_binSLOW,:));
        
        
        leaky_integrated_out.ss2_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_correct,:));
        leaky_integrated_out.ss4_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct,:));
        leaky_integrated_out.ss8_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_correct,:));
        
%         leaky_integrated_out.ss2_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_correct_binFAST,:));
%         leaky_integrated_out.ss2_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_correct_binMED,:));
%         leaky_integrated_out.ss2_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_correct_binSLOW,:));
%         
%         leaky_integrated_out.ss4_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binFAST,:));
%         leaky_integrated_out.ss4_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binMED,:));
%         leaky_integrated_out.ss4_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binSLOW,:));
%         
%         leaky_integrated_out.ss8_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_correct_binFAST,:));
%         leaky_integrated_out.ss8_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_correct_binMED,:));
%         leaky_integrated_out.ss8_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_correct_binSLOW,:));
        
        
        
        leaky_integrated_diff.ss2_correct(file,1:1201,k) = leaky_integrated_in.ss2_correct(file,1:1201,k) - leaky_integrated_out.ss2_correct(file,1:1201,k);
        leaky_integrated_diff.ss4_correct(file,1:1201,k) = leaky_integrated_in.ss4_correct(file,1:1201,k) - leaky_integrated_out.ss4_correct(file,1:1201,k);
        leaky_integrated_diff.ss8_correct(file,1:1201,k) = leaky_integrated_in.ss8_correct(file,1:1201,k) - leaky_integrated_out.ss8_correct(file,1:1201,k);
        
%         leaky_integrated_diff.ss2_correct_binFast(file,1:1201,k) = leaky_integrated_in.ss2_correct_binFast(file,1:1201,k) - leaky_integrated_out.ss2_correct_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss2_correct_binMed(file,1:1201,k) = leaky_integrated_in.ss2_correct_binMed(file,1:1201,k) - leaky_integrated_out.ss2_correct_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss2_correct_binSlow(file,1:1201,k) = leaky_integrated_in.ss2_correct_binSlow(file,1:1201,k) - leaky_integrated_out.ss2_correct_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss4_correct_binFast(file,1:1201,k) = leaky_integrated_in.ss4_correct_binFast(file,1:1201,k) - leaky_integrated_out.ss4_correct_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss4_correct_binMed(file,1:1201,k) = leaky_integrated_in.ss4_correct_binMed(file,1:1201,k) - leaky_integrated_out.ss4_correct_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss4_correct_binSlow(file,1:1201,k) = leaky_integrated_in.ss4_correct_binSlow(file,1:1201,k) - leaky_integrated_out.ss4_correct_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss8_correct_binFast(file,1:1201,k) = leaky_integrated_in.ss8_correct_binFast(file,1:1201,k) - leaky_integrated_out.ss8_correct_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss8_correct_binMed(file,1:1201,k) = leaky_integrated_in.ss8_correct_binMed(file,1:1201,k) - leaky_integrated_out.ss8_correct_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss8_correct_binSlow(file,1:1201,k) = leaky_integrated_in.ss8_correct_binSlow(file,1:1201,k) - leaky_integrated_out.ss8_correct_binSlow(file,1:1201,k);
        
        
        
        
        integrated_in.ss2_errors(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_errors,:));
        integrated_in.ss4_errors(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors,:));
        integrated_in.ss8_errors(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_errors,:));
        
%         integrated_in.ss2_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_errors_binFAST,:));
%         integrated_in.ss2_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_errors_binMED,:));
%         integrated_in.ss2_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss2_errors_binSLOW,:));
%         
%         integrated_in.ss4_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binFAST,:));
%         integrated_in.ss4_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binMED,:));
%         integrated_in.ss4_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binSLOW,:));
%         
%         integrated_in.ss8_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_errors_binFAST,:));
%         integrated_in.ss8_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_errors_binMED,:));
%         integrated_in.ss8_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss8_errors_binSLOW,:));
        
        
        integrated_out.ss2_errors(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_errors,:));
        integrated_out.ss4_errors(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors,:));
        integrated_out.ss8_errors(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_errors,:));
        
%         integrated_out.ss2_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_errors_binFAST,:));
%         integrated_out.ss2_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_errors_binMED,:));
%         integrated_out.ss2_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss2_errors_binSLOW,:));
%         
%         integrated_out.ss4_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binFAST,:));
%         integrated_out.ss4_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binMED,:));
%         integrated_out.ss4_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binSLOW,:));
%         
%         integrated_out.ss8_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_errors_binFAST,:));
%         integrated_out.ss8_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_errors_binMED,:));
%         integrated_out.ss8_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss8_errors_binSLOW,:));
        
        integrated_diff.ss2_errors(file,1:1201,k) = integrated_in.ss2_errors(file,1:1201,k) - integrated_out.ss2_errors(file,1:1201,k);
        integrated_diff.ss4_errors(file,1:1201,k) = integrated_in.ss4_errors(file,1:1201,k) - integrated_out.ss4_errors(file,1:1201,k);
        integrated_diff.ss8_errors(file,1:1201,k) = integrated_in.ss8_errors(file,1:1201,k) - integrated_out.ss8_errors(file,1:1201,k);
        
%         integrated_diff.ss2_errors_binFast(file,1:1201,k) = integrated_in.ss2_errors_binFast(file,1:1201,k) - integrated_out.ss2_errors_binFast(file,1:1201,k);
%         integrated_diff.ss2_errors_binMed(file,1:1201,k) = integrated_in.ss2_errors_binMed(file,1:1201,k) - integrated_out.ss2_errors_binMed(file,1:1201,k);
%         integrated_diff.ss2_errors_binSlow(file,1:1201,k) = integrated_in.ss2_errors_binSlow(file,1:1201,k) - integrated_out.ss2_errors_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss4_errors_binFast(file,1:1201,k) = integrated_in.ss4_errors_binFast(file,1:1201,k) - integrated_out.ss4_errors_binFast(file,1:1201,k);
%         integrated_diff.ss4_errors_binMed(file,1:1201,k) = integrated_in.ss4_errors_binMed(file,1:1201,k) - integrated_out.ss4_errors_binMed(file,1:1201,k);
%         integrated_diff.ss4_errors_binSlow(file,1:1201,k) = integrated_in.ss4_errors_binSlow(file,1:1201,k) - integrated_out.ss4_errors_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss8_errors_binFast(file,1:1201,k) = integrated_in.ss8_errors_binFast(file,1:1201,k) - integrated_out.ss8_errors_binFast(file,1:1201,k);
%         integrated_diff.ss8_errors_binMed(file,1:1201,k) = integrated_in.ss8_errors_binMed(file,1:1201,k) - integrated_out.ss8_errors_binMed(file,1:1201,k);
%         integrated_diff.ss8_errors_binSlow(file,1:1201,k) = integrated_in.ss8_errors_binSlow(file,1:1201,k) - integrated_out.ss8_errors_binSlow(file,1:1201,k);
        
        
        
        
        
        
        leaky_integrated_in.ss2_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_errors,:));
        leaky_integrated_in.ss4_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors,:));
        leaky_integrated_in.ss8_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_errors,:));
        
        
%         leaky_integrated_in.slow_errors_made_missed(file,1:1201,k) = nanmean(leaky_integrated_SDF([in.ss2_errors ; in.slow_errors_missed_dead],:));
%         leaky_integrated_in.fast_errors_made_missed(file,1:1201,k) = nanmean(leaky_integrated_SDF([in.ss8_errors ; in.fast_errors_missed_dead_withCleared],:));
        
        
        
%         leaky_integrated_in.ss2_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_errors_binFAST,:));
%         leaky_integrated_in.ss2_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_errors_binMED,:));
%         leaky_integrated_in.ss2_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss2_errors_binSLOW,:));
%         
%         leaky_integrated_in.ss4_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binFAST,:));
%         leaky_integrated_in.ss4_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binMED,:));
%         leaky_integrated_in.ss4_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binSLOW,:));
%         
%         leaky_integrated_in.ss8_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_errors_binFAST,:));
%         leaky_integrated_in.ss8_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_errors_binMED,:));
%         leaky_integrated_in.ss8_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss8_errors_binSLOW,:));
        
        
        leaky_integrated_out.ss2_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_errors,:));
        leaky_integrated_out.ss4_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors,:));
        leaky_integrated_out.ss8_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_errors,:));
        
        
%         leaky_integrated_out.slow_errors_made_missed(file,1:1201,k) = nanmean(leaky_integrated_SDF([out.ss2_errors ; in.slow_errors_missed_dead],:));
%         leaky_integrated_out.fast_errors_made_missed(file,1:1201,k) = nanmean(leaky_integrated_SDF([out.ss8_errors ; in.fast_errors_missed_dead_withCleared],:));
        
        
%         leaky_integrated_out.ss2_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_errors_binFAST,:));
%         leaky_integrated_out.ss2_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_errors_binMED,:));
%         leaky_integrated_out.ss2_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss2_errors_binSLOW,:));
%         
%         leaky_integrated_out.ss4_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binFAST,:));
%         leaky_integrated_out.ss4_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binMED,:));
%         leaky_integrated_out.ss4_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binSLOW,:));
%         
%         leaky_integrated_out.ss8_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_errors_binFAST,:));
%         leaky_integrated_out.ss8_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_errors_binMED,:));
%         leaky_integrated_out.ss8_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss8_errors_binSLOW,:));
        
        
        
        leaky_integrated_diff.ss2_errors(file,1:1201,k) = leaky_integrated_in.ss2_errors(file,1:1201,k) - leaky_integrated_out.ss2_errors(file,1:1201,k);
        leaky_integrated_diff.ss4_errors(file,1:1201,k) = leaky_integrated_in.ss4_errors(file,1:1201,k) - leaky_integrated_out.ss4_errors(file,1:1201,k);
        leaky_integrated_diff.ss8_errors(file,1:1201,k) = leaky_integrated_in.ss8_errors(file,1:1201,k) - leaky_integrated_out.ss8_errors(file,1:1201,k);
        
%         leaky_integrated_diff.ss2_errors_binFast(file,1:1201,k) = leaky_integrated_in.ss2_errors_binFast(file,1:1201,k) - leaky_integrated_out.ss2_errors_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss2_errors_binMed(file,1:1201,k) = leaky_integrated_in.ss2_errors_binMed(file,1:1201,k) - leaky_integrated_out.ss2_errors_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss2_errors_binSlow(file,1:1201,k) = leaky_integrated_in.ss2_errors_binSlow(file,1:1201,k) - leaky_integrated_out.ss2_errors_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss4_errors_binFast(file,1:1201,k) = leaky_integrated_in.ss4_errors_binFast(file,1:1201,k) - leaky_integrated_out.ss4_errors_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss4_errors_binMed(file,1:1201,k) = leaky_integrated_in.ss4_errors_binMed(file,1:1201,k) - leaky_integrated_out.ss4_errors_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss4_errors_binSlow(file,1:1201,k) = leaky_integrated_in.ss4_errors_binSlow(file,1:1201,k) - leaky_integrated_out.ss4_errors_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss8_errors_binFast(file,1:1201,k) = leaky_integrated_in.ss8_errors_binFast(file,1:1201,k) - leaky_integrated_out.ss8_errors_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss8_errors_binMed(file,1:1201,k) = leaky_integrated_in.ss8_errors_binMed(file,1:1201,k) - leaky_integrated_out.ss8_errors_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss8_errors_binSlow(file,1:1201,k) = leaky_integrated_in.ss8_errors_binSlow(file,1:1201,k) - leaky_integrated_out.ss8_errors_binSlow(file,1:1201,k);
        
        
%         integrated_in.slow_correct_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead,:));
%         integrated_in.ss4_correct(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct,:));
%         integrated_in.fast_correct_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
%         
%         integrated_in.slow_correct_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
%         integrated_in.slow_correct_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binMED,:));
%         integrated_in.slow_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
%         
%         integrated_in.ss4_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binFAST,:));
%         integrated_in.ss4_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binMED,:));
%         integrated_in.ss4_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_correct_binSLOW,:));
%         
%         integrated_in.fast_correct_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
%         integrated_in.fast_correct_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
%         integrated_in.fast_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
%         
%         
%         integrated_out.slow_correct_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead,:));
%         integrated_out.ss4_correct(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct,:));
%         integrated_out.fast_correct_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
%         
%         integrated_out.slow_correct_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
%         integrated_out.slow_correct_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binMED,:));
%         integrated_out.slow_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
%         
%         integrated_out.ss4_correct_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binFAST,:));
%         integrated_out.ss4_correct_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binMED,:));
%         integrated_out.ss4_correct_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_correct_binSLOW,:));
%         
%         integrated_out.fast_correct_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
%         integrated_out.fast_correct_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
%         integrated_out.fast_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
%         
%         integrated_diff.slow_correct_missed_dead(file,1:1201,k) = integrated_in.slow_correct_missed_dead(file,1:1201,k) - integrated_out.slow_correct_missed_dead(file,1:1201,k);
%         integrated_diff.ss4_correct(file,1:1201,k) = integrated_in.ss4_correct(file,1:1201,k) - integrated_out.ss4_correct(file,1:1201,k);
%         integrated_diff.fast_correct_missed_dead(file,1:1201,k) = integrated_in.fast_correct_missed_dead(file,1:1201,k) - integrated_out.fast_correct_missed_dead(file,1:1201,k);
%         
%         integrated_diff.slow_correct_missed_dead_binFast(file,1:1201,k) = integrated_in.slow_correct_missed_dead_binFast(file,1:1201,k) - integrated_out.slow_correct_missed_dead_binFast(file,1:1201,k);
%         integrated_diff.slow_correct_missed_dead_binMed(file,1:1201,k) = integrated_in.slow_correct_missed_dead_binMed(file,1:1201,k) - integrated_out.slow_correct_missed_dead_binMed(file,1:1201,k);
%         integrated_diff.slow_correct_missed_dead_binSlow(file,1:1201,k) = integrated_in.slow_correct_missed_dead_binSlow(file,1:1201,k) - integrated_out.slow_correct_missed_dead_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss4_correct_binFast(file,1:1201,k) = integrated_in.ss4_correct_binFast(file,1:1201,k) - integrated_out.ss4_correct_binFast(file,1:1201,k);
%         integrated_diff.ss4_correct_binMed(file,1:1201,k) = integrated_in.ss4_correct_binMed(file,1:1201,k) - integrated_out.ss4_correct_binMed(file,1:1201,k);
%         integrated_diff.ss4_correct_binSlow(file,1:1201,k) = integrated_in.ss4_correct_binSlow(file,1:1201,k) - integrated_out.ss4_correct_binSlow(file,1:1201,k);
%         
%         integrated_diff.fast_correct_missed_dead_binFast(file,1:1201,k) = integrated_in.fast_correct_missed_dead_binFast(file,1:1201,k) - integrated_out.fast_correct_missed_dead_binFast(file,1:1201,k);
%         integrated_diff.fast_correct_missed_dead_binMed(file,1:1201,k) = integrated_in.fast_correct_missed_dead_binMed(file,1:1201,k) - integrated_out.fast_correct_missed_dead_binMed(file,1:1201,k);
%         integrated_diff.fast_correct_missed_dead_binSlow(file,1:1201,k) = integrated_in.fast_correct_missed_dead_binSlow(file,1:1201,k) - integrated_out.fast_correct_missed_dead_binSlow(file,1:1201,k);
%         
%         
%         
%         
%         
%         
%         leaky_integrated_in.slow_correct_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead,:));
%         leaky_integrated_in.ss4_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct,:));
%         leaky_integrated_in.fast_correct_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared,:));
%         
%         leaky_integrated_in.slow_correct_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binFAST,:));
%         leaky_integrated_in.slow_correct_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binMED,:));
%         leaky_integrated_in.slow_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_correct_missed_dead_binSLOW,:));
%         
%         leaky_integrated_in.ss4_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binFAST,:));
%         leaky_integrated_in.ss4_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binMED,:));
%         leaky_integrated_in.ss4_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_correct_binSLOW,:));
%         
%         leaky_integrated_in.fast_correct_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binFAST,:));
%         leaky_integrated_in.fast_correct_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binMED,:));
%         leaky_integrated_in.fast_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_correct_missed_dead_withCleared_binSLOW,:));
%         
%         
%         leaky_integrated_out.slow_correct_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead,:));
%         leaky_integrated_out.ss4_correct(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct,:));
%         leaky_integrated_out.fast_correct_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared,:));
%         
%         leaky_integrated_out.slow_correct_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binFAST,:));
%         leaky_integrated_out.slow_correct_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binMED,:));
%         leaky_integrated_out.slow_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_correct_missed_dead_binSLOW,:));
%         
%         leaky_integrated_out.ss4_correct_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binFAST,:));
%         leaky_integrated_out.ss4_correct_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binMED,:));
%         leaky_integrated_out.ss4_correct_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_correct_binSLOW,:));
%         
%         leaky_integrated_out.fast_correct_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binFAST,:));
%         leaky_integrated_out.fast_correct_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binMED,:));
%         leaky_integrated_out.fast_correct_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_correct_missed_dead_withCleared_binSLOW,:));
%         
%         
%         
%         leaky_integrated_diff.slow_correct_missed_dead(file,1:1201,k) = leaky_integrated_in.slow_correct_missed_dead(file,1:1201,k) - leaky_integrated_out.slow_correct_missed_dead(file,1:1201,k);
%         leaky_integrated_diff.ss4_correct(file,1:1201,k) = leaky_integrated_in.ss4_correct(file,1:1201,k) - leaky_integrated_out.ss4_correct(file,1:1201,k);
%         leaky_integrated_diff.fast_correct_missed_dead(file,1:1201,k) = leaky_integrated_in.fast_correct_missed_dead(file,1:1201,k) - leaky_integrated_out.fast_correct_missed_dead(file,1:1201,k);
%         
%         leaky_integrated_diff.slow_correct_missed_dead_binFast(file,1:1201,k) = leaky_integrated_in.slow_correct_missed_dead_binFast(file,1:1201,k) - leaky_integrated_out.slow_correct_missed_dead_binFast(file,1:1201,k);
%         leaky_integrated_diff.slow_correct_missed_dead_binMed(file,1:1201,k) = leaky_integrated_in.slow_correct_missed_dead_binMed(file,1:1201,k) - leaky_integrated_out.slow_correct_missed_dead_binMed(file,1:1201,k);
%         leaky_integrated_diff.slow_correct_missed_dead_binSlow(file,1:1201,k) = leaky_integrated_in.slow_correct_missed_dead_binSlow(file,1:1201,k) - leaky_integrated_out.slow_correct_missed_dead_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss4_correct_binFast(file,1:1201,k) = leaky_integrated_in.ss4_correct_binFast(file,1:1201,k) - leaky_integrated_out.ss4_correct_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss4_correct_binMed(file,1:1201,k) = leaky_integrated_in.ss4_correct_binMed(file,1:1201,k) - leaky_integrated_out.ss4_correct_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss4_correct_binSlow(file,1:1201,k) = leaky_integrated_in.ss4_correct_binSlow(file,1:1201,k) - leaky_integrated_out.ss4_correct_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.fast_correct_missed_dead_binFast(file,1:1201,k) = leaky_integrated_in.fast_correct_missed_dead_binFast(file,1:1201,k) - leaky_integrated_out.fast_correct_missed_dead_binFast(file,1:1201,k);
%         leaky_integrated_diff.fast_correct_missed_dead_binMed(file,1:1201,k) = leaky_integrated_in.fast_correct_missed_dead_binMed(file,1:1201,k) - leaky_integrated_out.fast_correct_missed_dead_binMed(file,1:1201,k);
%         leaky_integrated_diff.fast_correct_missed_dead_binSlow(file,1:1201,k) = leaky_integrated_in.fast_correct_missed_dead_binSlow(file,1:1201,k) - leaky_integrated_out.fast_correct_missed_dead_binSlow(file,1:1201,k);
%         
%         
%         
%         
%         integrated_in.slow_errors_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead,:));
%         integrated_in.ss4_errors(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors,:));
%         integrated_in.fast_errors_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
%         
%         integrated_in.slow_errors_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
%         integrated_in.slow_errors_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binMED,:));
%         integrated_in.slow_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
%         
%         integrated_in.ss4_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binFAST,:));
%         integrated_in.ss4_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binMED,:));
%         integrated_in.ss4_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.ss4_errors_binSLOW,:));
%         
%         integrated_in.fast_errors_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
%         integrated_in.fast_errors_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
%         integrated_in.fast_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
%         
%         
%         integrated_out.slow_errors_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead,:));
%         integrated_out.ss4_errors(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors,:));
%         integrated_out.fast_errors_missed_dead(file,1:1201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
%         
%         integrated_out.slow_errors_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
%         integrated_out.slow_errors_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binMED,:));
%         integrated_out.slow_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
%         
%         integrated_out.ss4_errors_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binFAST,:));
%         integrated_out.ss4_errors_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binMED,:));
%         integrated_out.ss4_errors_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.ss4_errors_binSLOW,:));
%         
%         integrated_out.fast_errors_missed_dead_binFast(file,1:1201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
%         integrated_out.fast_errors_missed_dead_binMed(file,1:1201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
%         integrated_out.fast_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
%         
%         integrated_diff.slow_errors_missed_dead(file,1:1201,k) = integrated_in.slow_errors_missed_dead(file,1:1201,k) - integrated_out.slow_errors_missed_dead(file,1:1201,k);
%         integrated_diff.ss4_errors(file,1:1201,k) = integrated_in.ss4_errors(file,1:1201,k) - integrated_out.ss4_errors(file,1:1201,k);
%         integrated_diff.fast_errors_missed_dead(file,1:1201,k) = integrated_in.fast_errors_missed_dead(file,1:1201,k) - integrated_out.fast_errors_missed_dead(file,1:1201,k);
%         
%         integrated_diff.slow_errors_missed_dead_binFast(file,1:1201,k) = integrated_in.slow_errors_missed_dead_binFast(file,1:1201,k) - integrated_out.slow_errors_missed_dead_binFast(file,1:1201,k);
%         integrated_diff.slow_errors_missed_dead_binMed(file,1:1201,k) = integrated_in.slow_errors_missed_dead_binMed(file,1:1201,k) - integrated_out.slow_errors_missed_dead_binMed(file,1:1201,k);
%         integrated_diff.slow_errors_missed_dead_binSlow(file,1:1201,k) = integrated_in.slow_errors_missed_dead_binSlow(file,1:1201,k) - integrated_out.slow_errors_missed_dead_binSlow(file,1:1201,k);
%         
%         integrated_diff.ss4_errors_binFast(file,1:1201,k) = integrated_in.ss4_errors_binFast(file,1:1201,k) - integrated_out.ss4_errors_binFast(file,1:1201,k);
%         integrated_diff.ss4_errors_binMed(file,1:1201,k) = integrated_in.ss4_errors_binMed(file,1:1201,k) - integrated_out.ss4_errors_binMed(file,1:1201,k);
%         integrated_diff.ss4_errors_binSlow(file,1:1201,k) = integrated_in.ss4_errors_binSlow(file,1:1201,k) - integrated_out.ss4_errors_binSlow(file,1:1201,k);
%         
%         integrated_diff.fast_errors_missed_dead_binFast(file,1:1201,k) = integrated_in.fast_errors_missed_dead_binFast(file,1:1201,k) - integrated_out.fast_errors_missed_dead_binFast(file,1:1201,k);
%         integrated_diff.fast_errors_missed_dead_binMed(file,1:1201,k) = integrated_in.fast_errors_missed_dead_binMed(file,1:1201,k) - integrated_out.fast_errors_missed_dead_binMed(file,1:1201,k);
%         integrated_diff.fast_errors_missed_dead_binSlow(file,1:1201,k) = integrated_in.fast_errors_missed_dead_binSlow(file,1:1201,k) - integrated_out.fast_errors_missed_dead_binSlow(file,1:1201,k);
%         
%         
%         
%         
%         
%         
%         leaky_integrated_in.slow_errors_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead,:));
%         leaky_integrated_in.ss4_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors,:));
%         leaky_integrated_in.fast_errors_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared,:));
%         
%         leaky_integrated_in.slow_errors_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binFAST,:));
%         leaky_integrated_in.slow_errors_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binMED,:));
%         leaky_integrated_in.slow_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.slow_errors_missed_dead_binSLOW,:));
%         
%         leaky_integrated_in.ss4_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binFAST,:));
%         leaky_integrated_in.ss4_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binMED,:));
%         leaky_integrated_in.ss4_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.ss4_errors_binSLOW,:));
%         
%         leaky_integrated_in.fast_errors_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binFAST,:));
%         leaky_integrated_in.fast_errors_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binMED,:));
%         leaky_integrated_in.fast_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(in.fast_errors_missed_dead_withCleared_binSLOW,:));
%         
%         
%         leaky_integrated_out.slow_errors_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead,:));
%         leaky_integrated_out.ss4_errors(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors,:));
%         leaky_integrated_out.fast_errors_missed_dead(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared,:));
%         
%         leaky_integrated_out.slow_errors_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binFAST,:));
%         leaky_integrated_out.slow_errors_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binMED,:));
%         leaky_integrated_out.slow_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.slow_errors_missed_dead_binSLOW,:));
%         
%         leaky_integrated_out.ss4_errors_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binFAST,:));
%         leaky_integrated_out.ss4_errors_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binMED,:));
%         leaky_integrated_out.ss4_errors_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.ss4_errors_binSLOW,:));
%         
%         leaky_integrated_out.fast_errors_missed_dead_binFast(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binFAST,:));
%         leaky_integrated_out.fast_errors_missed_dead_binMed(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binMED,:));
%         leaky_integrated_out.fast_errors_missed_dead_binSlow(file,1:1201,k) = nanmean(leaky_integrated_SDF(out.fast_errors_missed_dead_withCleared_binSLOW,:));
%         
%         
%         
%         leaky_integrated_diff.slow_errors_missed_dead(file,1:1201,k) = leaky_integrated_in.slow_errors_missed_dead(file,1:1201,k) - leaky_integrated_out.slow_errors_missed_dead(file,1:1201,k);
%         leaky_integrated_diff.ss4_errors(file,1:1201,k) = leaky_integrated_in.ss4_errors(file,1:1201,k) - leaky_integrated_out.ss4_errors(file,1:1201,k);
%         leaky_integrated_diff.fast_errors_missed_dead(file,1:1201,k) = leaky_integrated_in.fast_errors_missed_dead(file,1:1201,k) - leaky_integrated_out.fast_errors_missed_dead(file,1:1201,k);
%         
%         leaky_integrated_diff.slow_errors_missed_dead_binFast(file,1:1201,k) = leaky_integrated_in.slow_errors_missed_dead_binFast(file,1:1201,k) - leaky_integrated_out.slow_errors_missed_dead_binFast(file,1:1201,k);
%         leaky_integrated_diff.slow_errors_missed_dead_binMed(file,1:1201,k) = leaky_integrated_in.slow_errors_missed_dead_binMed(file,1:1201,k) - leaky_integrated_out.slow_errors_missed_dead_binMed(file,1:1201,k);
%         leaky_integrated_diff.slow_errors_missed_dead_binSlow(file,1:1201,k) = leaky_integrated_in.slow_errors_missed_dead_binSlow(file,1:1201,k) - leaky_integrated_out.slow_errors_missed_dead_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.ss4_errors_binFast(file,1:1201,k) = leaky_integrated_in.ss4_errors_binFast(file,1:1201,k) - leaky_integrated_out.ss4_errors_binFast(file,1:1201,k);
%         leaky_integrated_diff.ss4_errors_binMed(file,1:1201,k) = leaky_integrated_in.ss4_errors_binMed(file,1:1201,k) - leaky_integrated_out.ss4_errors_binMed(file,1:1201,k);
%         leaky_integrated_diff.ss4_errors_binSlow(file,1:1201,k) = leaky_integrated_in.ss4_errors_binSlow(file,1:1201,k) - leaky_integrated_out.ss4_errors_binSlow(file,1:1201,k);
%         
%         leaky_integrated_diff.fast_errors_missed_dead_binFast(file,1:1201,k) = leaky_integrated_in.fast_errors_missed_dead_binFast(file,1:1201,k) - leaky_integrated_out.fast_errors_missed_dead_binFast(file,1:1201,k);
%         leaky_integrated_diff.fast_errors_missed_dead_binMed(file,1:1201,k) = leaky_integrated_in.fast_errors_missed_dead_binMed(file,1:1201,k) - leaky_integrated_out.fast_errors_missed_dead_binMed(file,1:1201,k);
%         leaky_integrated_diff.fast_errors_missed_dead_binSlow(file,1:1201,k) = leaky_integrated_in.fast_errors_missed_dead_binSlow(file,1:1201,k) - leaky_integrated_out.fast_errors_missed_dead_binSlow(file,1:1201,k);
        
        

        
        keep k leak leakage filename unit file integrated_in integrated_out integrated_diff leaky_integrated_in leaky_integrated_out leaky_integrated_diff
        
    end
    
end
%
% figure
% plot(-1000:200,nanmean(integrated_in.ss2_correct),'r', ...
%     -1000:200,nanmean(integrated_in.ss4_correct),'k', ...
%     -1000:200,nanmean(integrated_in.ss8_correct),'g')
% box off
% set(gca,'xminortick','on')
%
% figure
% plot(-1000:200,nanmean(integrated_in.ss2_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.ss2_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_in.ss2_correct_binFast),'g')
%
% hold on
%
% plot(-1000:200,nanmean(integrated_in.ss4_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.ss4_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_in.ss4_correct_binFast),'g')
%
% plot(-1000:200,nanmean(integrated_in.ss8_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_in.ss8_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_in.ss8_correct_binFast),'g')
%
% box off
% set(gca,'xminortick','on')
% title('Integrated Target-In')
%
%
%
% figure
% plot(-1000:200,nanmean(integrated_diff.ss2_correct),'r', ...
%     -1000:200,nanmean(integrated_diff.ss4_correct),'k', ...
%     -1000:200,nanmean(integrated_diff.ss8_correct),'g')
% box off
% set(gca,'xminortick','on')
%
% figure
% plot(-1000:200,nanmean(integrated_diff.ss2_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.ss2_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.ss2_correct_binFast),'g')
%
% hold on
%
% plot(-1000:200,nanmean(integrated_diff.ss4_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.ss4_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.ss4_correct_binFast),'g')
%
% plot(-1000:200,nanmean(integrated_diff.ss8_correct_binSlow),'r', ...
% -1000:200,nanmean(integrated_diff.ss8_correct_binMed),'k', ...
% -1000:200,nanmean(integrated_diff.ss8_correct_binFast),'g')
%
% box off
% set(gca,'xminortick','on')
% title('Integrated Difference')
%
%
%

% WITH LEAKAGE
figure
plot(-1000:200,nanmean(leaky_integrated_in.ss2_correct),'r', ...
    -1000:200,nanmean(leaky_integrated_in.ss4_correct),'k', ...
    -1000:200,nanmean(leaky_integrated_in.ss8_correct),'g')
box off
set(gca,'xminortick','on')

figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.ss2_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.ss2_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.ss2_correct_binFast),'g')

subplot(2,2,2)
plot(-1000:200,nanmean(leaky_integrated_in.ss4_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.ss4_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.ss4_correct_binFast),'g')

subplot(2,2,3)
plot(-1000:200,nanmean(leaky_integrated_in.ss8_correct_binSlow),'r', ...
    -1000:200,nanmean(leaky_integrated_in.ss8_correct_binMed),'k', ...
    -1000:200,nanmean(leaky_integrated_in.ss8_correct_binFast),'g')

box off
set(gca,'xminortick','on')
title('leaky_integrated Target-In')



