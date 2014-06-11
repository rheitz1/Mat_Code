cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename1 ; filename2 ; filename3 ; filename4 ; ...
    filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];

leak = .01

%leak = .001:.001:.1;

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

cd /volumes/Dump/Search_Data_SAT_longBase/


z = zeros(size(filename,1),2001);
integ.slow_correct_made_dead = z;
integ.slow_correct_made_dead_binSlow = z;
integ.slow_correct_made_dead_binMed = z;
integ.slow_correct_made_dead_binFast = z;

integ.slow_correct_missed_dead = z;
integ.slow_correct_missed_dead_binSlow = z;
integ.slow_correct_missed_dead_binMed = z;
integ.slow_correct_missed_dead_binFast = z;

integ.med_correct = z;
integ.med_correct_binSlow = z;
integ.med_correct_binMed = z;
integ.med_correct_binFast = z;

integ.fast_correct_made_dead = z;
integ.fast_correct_made_dead_binSlow = z;
integ.fast_correct_made_dead_binMed = z;
integ.fast_correct_made_dead_binFast = z;

integ.fast_correct_missed_dead = z;
integ.fast_correct_missed_dead_binSlow = z;
integ.fast_correct_missed_dead_binMed = z;
integ.fast_correct_missed_dead_binFast = z;

integ.slow_errors_made_dead = z;
integ.slow_errors_made_dead_binSlow = z;
integ.slow_errors_made_dead_binMed = z;
integ.slow_errors_made_dead_binFast = z;

integ.slow_errors_missed_dead = z;
integ.slow_errors_missed_dead_binSlow = z;
integ.slow_errors_missed_dead_binMed = z;
integ.slow_errors_missed_dead_binFast = z;

integ.med_errors = z;
integ.med_errors_binSlow = z;
integ.med_errors_binMed = z;
integ.med_errors_binFast = z;

integ.fast_errors_made_dead = z;
integ.fast_errors_made_dead_binSlow = z;
integ.fast_errors_made_dead_binMed = z;
integ.fast_errors_made_dead_binFast = z;

integ.fast_errors_missed_dead = z;
integ.fast_errors_missed_dead_binSlow = z;
integ.fast_errors_missed_dead_binMed = z;
integ.fast_errors_missed_dead_binFast = z;


for k = 1:length(leak)
    
    disp(['Running leakage = ' mat2str(leak(k))])
    leakage = leak(k);
    
    for file = 1:length(filename)
        
        load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
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
        
        
        
        allAct(1:size(SDF_r,1),1:2000) = 0;
        
        for trl = 1:size(SDF_r,1)
            if 2000 - SRT(trl,1) <= 0 | isnan(SRT(trl,1))
                continue
            else
                trl_part_SDF = SDF_r(trl,2000-SRT(trl,1):2000);
                allAct(trl,2000-SRT(trl,1):2000) = trl_part_SDF;
            end
            
            
            %
            %
            %             for tm = 2:length(trl_part_SDF)
            %                 integ(tm) = integ(file,tm-1,k) + trl_part_SDF(tm) - (leakage .* integ(file,tm-1,k));
            %             end
            %
            %             integrated_SDF(trl,1000-SRT(trl,1):1000) = cumsum(SDF_r(trl,1000-SRT(trl,1):1000));
            %             leaky_integrated_SDF(trl,1000-SRT(trl,1):1000) = integ;
            %             clear integ
            %             %leaky_integrated_SDF(trl,:) = integrated_SDF(trl,:) - (integrated_SDF(trl,:) .* .4);
            
        end
        
        before_integrator.slow_correct_made_dead = nanmean(allAct(in.slow_correct_made_dead,:));
        before_integrator.slow_correct_made_dead_binSlow = nanmean(allAct(in.slow_correct_made_dead_binSLOW,:));
        before_integrator.slow_correct_made_dead_binMed = nanmean(allAct(in.slow_correct_made_dead_binMED,:));
        before_integrator.slow_correct_made_dead_binFast = nanmean(allAct(in.slow_correct_made_dead_binFAST,:));
        
        before_integrator.slow_correct_missed_dead = nanmean(allAct(in.slow_correct_missed_dead,:));
        before_integrator.slow_correct_missed_dead_binSlow = nanmean(allAct(in.slow_correct_missed_dead_binSLOW,:));
        before_integrator.slow_correct_missed_dead_binMed = nanmean(allAct(in.slow_correct_missed_dead_binMED,:));
        before_integrator.slow_correct_missed_dead_binFast = nanmean(allAct(in.slow_correct_missed_dead_binFAST,:));
        
        
        before_integrator.med_correct = nanmean(allAct(in.med_correct,:));
        before_integrator.med_correct_binSlow = nanmean(allAct(in.med_correct_binSLOW,:));
        before_integrator.med_correct_binMed = nanmean(allAct(in.med_correct_binMED,:));
        before_integrator.med_correct_binFast = nanmean(allAct(in.med_correct_binFAST,:));
        
        
        before_integrator.fast_correct_made_dead = nanmean(allAct(in.fast_correct_made_dead_withCleared,:));
        before_integrator.fast_correct_made_dead_binSlow = nanmean(allAct(in.fast_correct_made_dead_withCleared_binSLOW,:));
        before_integrator.fast_correct_made_dead_binMed = nanmean(allAct(in.fast_correct_made_dead_withCleared_binMED,:));
        before_integrator.fast_correct_made_dead_binFast = nanmean(allAct(in.fast_correct_made_dead_withCleared_binFAST,:));
        
        before_integrator.fast_correct_missed_dead = nanmean(allAct(in.fast_correct_missed_dead_withCleared,:));
        before_integrator.fast_correct_missed_dead_binSlow = nanmean(allAct(in.fast_correct_missed_dead_withCleared_binSLOW,:));
        before_integrator.fast_correct_missed_dead_binMed = nanmean(allAct(in.fast_correct_missed_dead_withCleared_binMED,:));
        before_integrator.fast_correct_missed_dead_binFast = nanmean(allAct(in.fast_correct_missed_dead_withCleared_binFAST,:));
        
        
        % USING RF-OUT FOR ERRORS!!!
        before_integrator.slow_errors_made_dead = nanmean(allAct(out.slow_errors_made_dead,:));
        before_integrator.slow_errors_made_dead_binSlow = nanmean(allAct(out.slow_errors_made_dead_binSLOW,:));
        before_integrator.slow_errors_made_dead_binMed = nanmean(allAct(out.slow_errors_made_dead_binMED,:));
        before_integrator.slow_errors_made_dead_binFast = nanmean(allAct(out.slow_errors_made_dead_binFAST,:));
        
        before_integrator.slow_errors_missed_dead = nanmean(allAct(out.slow_errors_missed_dead,:));
        before_integrator.slow_errors_missed_dead_binSlow = nanmean(allAct(out.slow_errors_missed_dead_binSLOW,:));
        before_integrator.slow_errors_missed_dead_binMed = nanmean(allAct(out.slow_errors_missed_dead_binMED,:));
        before_integrator.slow_errors_missed_dead_binFast = nanmean(allAct(out.slow_errors_missed_dead_binFAST,:));
        
        
        before_integrator.med_errors = nanmean(allAct(out.med_errors,:));
        before_integrator.med_errors_binSlow = nanmean(allAct(out.med_errors_binSLOW,:));
        before_integrator.med_errors_binMed = nanmean(allAct(out.med_errors_binMED,:));
        before_integrator.med_errors_binFast = nanmean(allAct(out.med_errors_binFAST,:));
        
        
        before_integrator.fast_errors_made_dead = nanmean(allAct(out.fast_errors_made_dead_withCleared,:));
        before_integrator.fast_errors_made_dead_binSlow = nanmean(allAct(out.fast_errors_made_dead_withCleared_binSLOW,:));
        before_integrator.fast_errors_made_dead_binMed = nanmean(allAct(out.fast_errors_made_dead_withCleared_binMED,:));
        before_integrator.fast_errors_made_dead_binFast = nanmean(allAct(out.fast_errors_made_dead_withCleared_binFAST,:));
        
        before_integrator.fast_errors_missed_dead = nanmean(allAct(out.fast_errors_missed_dead_withCleared,:));
        before_integrator.fast_errors_missed_dead_binSlow = nanmean(allAct(out.fast_errors_missed_dead_withCleared_binSLOW,:));
        before_integrator.fast_errors_missed_dead_binMed = nanmean(allAct(out.fast_errors_missed_dead_withCleared_binMED,:));
        before_integrator.fast_errors_missed_dead_binFast = nanmean(allAct(out.fast_errors_missed_dead_withCleared_binFAST,:));
        
        
        
        
        
        
        
        
        for tm = 2:length(2:2001)
                integ.slow_correct_made_dead(file,tm,k) = integ.slow_correct_made_dead(file,tm-1,k) + ...
                    before_integrator.slow_correct_made_dead(tm) - (leakage .* integ.slow_correct_made_dead(file,tm-1,k));
            
            try
                integ.slow_correct_made_dead_binSlow(file,tm,k) = integ.slow_correct_made_dead_binSlow(file,tm-1,k) + ...
                    before_integrator.slow_correct_made_dead_binSlow(tm) - (leakage .* integ.slow_correct_made_dead_binSlow(file,tm-1,k));
            end
            
            try
                integ.slow_correct_made_dead_binMed(file,tm,k) = integ.slow_correct_made_dead_binMed(file,tm-1,k) + ...
                    before_integrator.slow_correct_made_dead_binMed(tm) - (leakage .* integ.slow_correct_made_dead_binMed(file,tm-1,k));
            end
            
            try
                integ.slow_correct_made_dead_binFast(file,tm,k) = integ.slow_correct_made_dead_binFast(file,tm-1,k) + ...
                    before_integrator.slow_correct_made_dead_binFast(tm) - (leakage .* integ.slow_correct_made_dead_binFast(file,tm-1,k));
            end
            
            try
                integ.slow_correct_missed_dead(file,tm,k) = integ.slow_correct_missed_dead(file,tm-1,k) + ...
                    before_integrator.slow_correct_missed_dead(tm) - (leakage .* integ.slow_correct_missed_dead(file,tm-1,k));
            end
            
            try
                integ.slow_correct_missed_dead_binSlow(file,tm,k) = integ.slow_correct_missed_dead_binSlow(file,tm-1,k) + ...
                    before_integrator.slow_correct_missed_dead_binSlow(tm) - (leakage .* integ.slow_correct_missed_dead_binSlow(file,tm-1,k));
            end
            
            try
                integ.slow_correct_missed_dead_binMed(file,tm,k) = integ.slow_correct_missed_dead_binMed(file,tm-1,k) + ...
                    before_integrator.slow_correct_missed_dead_binMed(tm) - (leakage .* integ.slow_correct_missed_dead_binMed(file,tm-1,k));
            end
            
            try
                integ.slow_correct_missed_dead_binFast(file,tm,k) = integ.slow_correct_missed_dead_binFast(file,tm-1,k) + ...
                    before_integrator.slow_correct_missed_dead_binFast(tm) - (leakage .* integ.slow_correct_missed_dead_binFast(file,tm-1,k));
            end
            
            try
                integ.med_correct(file,tm,k) = integ.med_correct(file,tm-1,k) + ...
                    before_integrator.med_correct(tm) - (leakage .* integ.med_correct(file,tm-1,k));
            end
            
            try
                integ.med_correct_binSlow(file,tm,k) = integ.med_correct_binSlow(file,tm-1,k) + ...
                    before_integrator.med_correct_binSlow(tm) - (leakage .* integ.med_correct_binSlow(file,tm-1,k));
            end
            
            try
                integ.med_correct_binMed(file,tm,k) = integ.med_correct_binMed(file,tm-1,k) + ...
                    before_integrator.med_correct_binMed(tm) - (leakage .* integ.med_correct_binMed(file,tm-1,k));
            end
            
            try
                integ.med_correct_binFast(file,tm,k) = integ.med_correct_binFast(file,tm-1,k) + ...
                    before_integrator.med_correct_binFast(tm) - (leakage .* integ.med_correct_binFast(file,tm-1,k));
            end
            
            try
                integ.fast_correct_made_dead(file,tm,k) = integ.fast_correct_made_dead(file,tm-1,k) + ...
                    before_integrator.fast_correct_made_dead(tm) - (leakage .* integ.fast_correct_made_dead(file,tm-1,k));
            end
            
            try
                integ.fast_correct_made_dead_binSlow(file,tm,k) = integ.fast_correct_made_dead_binSlow(file,tm-1,k) + ...
                    before_integrator.fast_correct_made_dead_binSlow(tm) - (leakage .* integ.fast_correct_made_dead_binSlow(file,tm-1,k));
            end
            
            try
                integ.fast_correct_made_dead_binMed(file,tm,k) = integ.fast_correct_made_dead_binMed(file,tm-1,k) + ...
                    before_integrator.fast_correct_made_dead_binMed(tm) - (leakage .* integ.fast_correct_made_dead_binMed(file,tm-1,k));
            end
            
            try
                integ.fast_correct_made_dead_binFast(file,tm,k) = integ.fast_correct_made_dead_binFast(file,tm-1,k) + ...
                    before_integrator.fast_correct_made_dead_binFast(tm) - (leakage .* integ.fast_correct_made_dead_binFast(file,tm-1,k));
            end
            
            try
                integ.fast_correct_missed_dead(file,tm,k) = integ.fast_correct_missed_dead(file,tm-1,k) + ...
                    before_integrator.fast_correct_missed_dead(tm) - (leakage .* integ.fast_correct_missed_dead(file,tm-1,k));
            end
            
            try
                integ.fast_correct_missed_dead_binSlow(file,tm,k) = integ.fast_correct_missed_dead_binSlow(file,tm-1,k) + ...
                    before_integrator.fast_correct_missed_dead_binSlow(tm) - (leakage .* integ.fast_correct_missed_dead_binSlow(file,tm-1,k));
            end
            
            try
                integ.fast_correct_missed_dead_binMed(file,tm,k) = integ.fast_correct_missed_dead_binMed(file,tm-1,k) + ...
                    before_integrator.fast_correct_missed_dead_binMed(tm) - (leakage .* integ.fast_correct_missed_dead_binMed(file,tm-1,k));
            end
            
            try
                integ.fast_correct_missed_dead_binFast(file,tm,k) = integ.fast_correct_missed_dead_binFast(file,tm-1,k) + ...
                    before_integrator.fast_correct_missed_dead_binFast(tm) - (leakage .* integ.fast_correct_missed_dead_binFast(file,tm-1,k));
            end
        end
        
        
        keep k leak leakage filename unit file integ
        
    end
    
end


