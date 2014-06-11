%Errors

plotFlag = 1;
pdfFlag = 1;
saveFlag = 1;
cRT = [];
eRT = [];
correctTDT = [];
errorTDT = [];
% correctROCarea = [];
% errorROCarea = [];
%read in files and neurons
[file_name cell_name] = textread('Errors_vismove.txt', '%s %s');

q = '''';
c = ',';
qcq = [q c q];

for file = 1:size(file_name,1)
    %echo current file and cell
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'SaccDir_' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    
    %Check file to see if SaccDir_ contains only NaNs (before this was
    %coded in Tempo)
    if length(find(~isnan(SaccDir_))) < 5 %sometimes there are a couple strays
        eval(['load(' q cell2mat(file_name(file)) qcq 'EyeX_' qcq 'EyeY_' q ')'])
        getMonk
        [x SaccDir_] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
        clear x EyeX_ EyeY_ ASL_Delay monkey
    end
    
    
    %Get relevant RF and MF for file
    getRF_MF
    anti_RF = getAntiRF(RF);
    fixErrors
    Align_Time(1:size(Target_,1),1) = 500;
    
    if isempty(RF)
        disp('RFs for cell not found!  Aborting...')
        return
    end
    
    getMonk
    getCellnames
    
    %do median split on correct and all DIRECTION errors, regardless of
    %saccade location
    cMedian = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 150 & Target_(:,2) ~= 255)),1);
    eMedian = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 150 & Target_(:,2) ~= 255)),1);
    express = 150;
    
    %keep track of behavioral RTs & Acc's in BEH variable
    BEH(file,1) = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 150)),1);
    BEH(file,2) = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 150)),1);
    BEH(file,3) = nanmean(Correct_(find(SRT(:,1) < 2000 & SRT(:,1) > 150 & Target_(:,2) ~= 255),2));
    
    
    %=================================================
    % SET UP TRIALS
    %collapased over RT
    inTrials_correct = find(ismember(Target_(:,2),RF) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > express);
    outTrials_correct = find(ismember(Target_(:,2),anti_RF) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > express);
    %error when target in RF but saccade into anti_RF
    inTrials_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,anti_RF) & SRT(:,1) < 2000 & SRT(:,1) > express);
    %error when target in antiRF but saccade into RF
    outTrials_incorrect = find(ismember(Target_(:,2),anti_RF) & ismember(SaccDir_,RF) & SRT(:,1) < 2000 & SRT(:,1) > express);
    
    %median split for fast/slow and then express saccades (< 150 ms)
    inTrials_correct_fast = find(ismember(Target_(:,2),RF) & Correct_(:,2) == 1 & SRT(:,1) < cMedian & SRT(:,1) > express);
    inTrials_correct_slow = find(ismember(Target_(:,2),RF) & Correct_(:,2) == 1 & SRT(:,1) >= cMedian & SRT(:,1) < 2000);
    outTrials_correct_fast = find(ismember(Target_(:,2),anti_RF) & Correct_(:,2) == 1 & SRT(:,1) < cMedian & SRT(:,1) > express);
    outTrials_correct_slow = find(ismember(Target_(:,2),anti_RF) & Correct_(:,2) == 1 & SRT(:,1) >= cMedian & SRT(:,1) < 2000);
    %error when target in RF but saccade into anti_RF
    inTrials_incorrect_fast = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,anti_RF) & SRT(:,1) < eMedian & SRT(:,1) > express);
    inTrials_incorrect_slow = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,anti_RF) & SRT(:,1) >= eMedian & SRT(:,1) < 2000);
    %error when target in antiRF but saccade into RF
    outTrials_incorrect_fast = find(ismember(Target_(:,2),anti_RF) & ismember(SaccDir_,RF) & SRT(:,1) < eMedian & SRT(:,1) > express);
    outTrials_incorrect_slow = find(ismember(Target_(:,2),anti_RF) & ismember(SaccDir_,RF) & SRT(:,1) >= eMedian & SRT(:,1) < 2000);
    
    inTrials_correct_express = find(ismember(Target_(:,2),RF) & Correct_(:,2) == 1 & SRT(:,1) <= express);
    outTrials_correct_express = find(ismember(Target_(:,2),anti_RF) & Correct_(:,2) == 1 & SRT(:,1) <= express);
    inTrials_incorrect_express = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,anti_RF) & SRT(:,1) <= express);
    outTrials_incorrect_express = find(ismember(Target_(:,2),anti_RF) & ismember(SaccDir_,RF) & SRT(:,1) <= express);
    %=======================================================
    
    
    %get CellNames again (should only have one left after clearing all rest
    getCellnames
    
    TotalSpikes = [];
    %correct Cell name will always be 1st one as long as only one in
    %workspace
    TotalSpikes = eval(cell2mat(CellNames(1)));
    Spikes = TotalSpikes;
    
    Plot_Time = [-50 500];
    Align_Time(1:size(Spikes,1),1) = 500;
    
    
    %====================================================================
    % Trial-by-trial SDFs (needed for Wilcoxon tests
    SDF_all(1:size(Spikes,1),1:(abs(Plot_Time(1)) + abs(Plot_Time(2)))) = 0;
    %calculate SDF matrix, trial-by-trial
    disp('Creating trial-by-trial SDFs...')
    for n = 1:size(Spikes,1)
        curr_SDF = spikeDensityfunction_singletrial(Spikes(n,:),Align_Time(n,1),Plot_Time);
        SDF_all(n,1:length(curr_SDF)) = curr_SDF;
    end
    
    % Assign single-trial SDFs to correct variable
    SDFs_in_correct = SDF_all(inTrials_correct,:);
    SDFs_out_correct = SDF_all(outTrials_correct,:);
    SDFs_in_incorrect = SDF_all(inTrials_incorrect,:);
    SDFs_out_incorrect = SDF_all(outTrials_incorrect,:);
    
    
    
    %=============================================================
    %=============================================================
    % ROC TDT calculation (not bootstrapped)
    disp('ROC')
    ROCarea_correct = ROC(SDF_all,inTrials_correct,outTrials_correct);
    ROCarea_incorrect = ROC(SDF_all,inTrials_incorrect,outTrials_incorrect);
    
    %rule: ROC (corrected to be centered at 0) must exceed 1.5sd of ROC area
    %and maintain for 20 ms.
    ROCarea_correct = ROCarea_correct - .5;
    ROCarea_incorrect = ROCarea_incorrect - .5;
    
    crit_correct = std(ROCarea_correct)*1;
    crit_incorrect = std(ROCarea_incorrect)*1;
    
    %logical: ROCarea values (absolute) greater than criterion
    %NOTE: START SEARCH AT +100 ms (ACTUAL TIME == 100 ms POST TARGET
    exceed_correct = abs(ROCarea_correct(150:end)) > crit_correct;
    exceed_incorrect = abs(ROCarea_incorrect(150:end)) > crit_incorrect;
    
    %find runs of 20 ms and call TDT
    if ~isempty(findRuns(exceed_correct,20))
        tempTDT = min(findRuns(exceed_correct,20));
        %determine selectivity direction
        if ROCarea_correct(tempTDT) > 0
            TDT_correct_ROC(file,2) = 1;
        else
            TDT_correct_ROC(file,2) = -1;
        end
        TDT_correct_ROC(file,1) = tempTDT - 50 + 150;
    else
        TDT_correct_ROC(file,1:2) = NaN;
    end
    
    if ~isempty(findRuns(exceed_incorrect,20))
        tempTDT = min(findRuns(exceed_incorrect,20));
        %determine selectivity direction
        if ROCarea_incorrect(tempTDT) > 0
            TDT_incorrect_ROC(file,2) = 1;
        else
            TDT_incorrect_ROC(file,2) = -1;
        end
        TDT_incorrect_ROC(file,1) = tempTDT - 50 + 150;
    else
        TDT_incorrect_ROC(file,1:2) = NaN;
    end
    %=============================================================
    
    
    %=============================================================
    %=============================================================
    % Bootstrapped ROC TDT calculation
    %simulate 1000 trials
    disp('ROC - bootstrapped')
    Spikes_in_correct_boot = bootSDF(Spikes(inTrials_correct,:),1000);
    Spikes_out_correct_boot = bootSDF(Spikes(outTrials_correct,:),1000);
    Spikes_in_incorrect_boot = bootSDF(Spikes(inTrials_incorrect,:),1000);
    Spikes_out_incorrect_boot = bootSDF(Spikes(outTrials_incorrect,:),1000);
    
    %create trial-by-trial SDFs
    disp('Creating trial-by-trial SDFs...')
    for n = 1:1000
        SDFs_in_correct_boot(n,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spikes_in_correct_boot(n,:),500,Plot_Time);
        SDFs_out_correct_boot(n,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spikes_out_correct_boot(n,:),500,Plot_Time);
        SDFs_in_incorrect_boot(n,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spikes_in_incorrect_boot(n,:),500,Plot_Time);
        SDFs_out_incorrect_boot(n,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spikes_out_incorrect_boot(n,:),500,Plot_Time);
    end
    
    %concatenate SDF matrices for ROC function
    cor = cat(1,SDFs_in_correct_boot,SDFs_out_correct_boot);
    err = cat(1,SDFs_in_incorrect_boot,SDFs_out_incorrect_boot);
    
    %get ROC areas
    ROCarea_correct_boot = ROC(cor,1:1000,1001:2000);
    ROCarea_incorrect_boot = ROC(err,1:1000,1001:2000);
    
    %rule: ROC (corrected to be centered at 0) must exceed 1.5sd of ROC area
    %and maintain for 20 ms.
    ROCarea_correct_boot = ROCarea_correct_boot - .5;
    ROCarea_incorrect_boot = ROCarea_incorrect_boot - .5;
    
    crit_correct_boot = std(ROCarea_correct_boot)*1;
    crit_incorrect_boot = std(ROCarea_incorrect_boot)*1;
    
    %logical: ROCarea values (absolute) greater than criterion
    %NOTE: START SEARCH AT +100 ms (ACTUAL TIME == 100 ms POST TARGET
    exceed_correct_boot = abs(ROCarea_correct_boot(150:end)) > crit_correct_boot;
    exceed_incorrect_boot = abs(ROCarea_incorrect_boot(150:end)) > crit_incorrect_boot;
    
    %find runs of 20 ms and call TDT
    if ~isempty(findRuns(exceed_correct_boot,20))
        tempTDT_boot = min(findRuns(exceed_correct_boot,20));
        %determine selectivity direction
        if ROCarea_correct_boot(tempTDT_boot) > 0
            TDT_correct_ROC_boot(file,2) = 1;
        else
            TDT_correct_ROC_boot(file,2) = -1;
        end
        TDT_correct_ROC_boot(file,1) = tempTDT_boot - 50 + 150;
    else
        TDT_correct_ROC_boot(file,1:2) = NaN;
    end
    
    if ~isempty(findRuns(exceed_incorrect_boot,20))
        tempTDT_boot = min(findRuns(exceed_incorrect_boot,20));
        %determine selectivity direction
        if ROCarea_incorrect_boot(tempTDT) > 0
            TDT_incorrect_ROC_boot(file,2) = 1;
        else
            TDT_incorrect_ROC_boot(file,2) = -1;
        end
        TDT_incorrect_ROC_boot(file,1) = tempTDT - 50 + 150;
    else
        TDT_incorrect_ROC_boot(file,1:2) = NaN;
    end
    %=========================================================================
    
    
    %=========================================================================
    % Wilcoxon TDT calculation (Not Bootstrapped)
    %find TDT based on all trials
    disp('Wilcoxon')
    for time = 1:size(SDFs_in_correct,2)
        [p_correct(time),h_correct(time)] = ranksum(SDFs_in_correct(:,time),SDFs_out_correct(:,time),'alpha',.01);
        [p_incorrect(time),h_incorrect(time)] = ranksum(SDFs_in_incorrect(:,time),SDFs_out_incorrect(:,time),'alpha',.01);
    end
    sigRuns_correct = getEmpty(h_correct(150:end));
    sigRuns_incorrect = getEmpty(h_incorrect(150:end));
    
    %convert cell ID to time value. Correct -50 because 50 ms baseline;
    %correct +100 because had started search at 100th cell in (i.e.,
    %started searching at +50 ms)
    if ~isempty(sigRuns_correct)
        TDT_correct_Wilcoxon(file,1) = sigRuns_correct(1) - 50 + 150;
    else
        TDT_correct_Wilcoxon(file,1) = NaN;
    end
    
    if ~isempty(sigRuns_incorrect)
        TDT_incorrect_Wilcoxon(file,1) = sigRuns_incorrect(1) - 50 + 150;
    else
        TDT_incorrect_Wilcoxon(file,1) = NaN;
    end
    
    %=================================================================
    
    
    %===============================================================
    % Bootstrapped Wilcoxon
    %   Reverse bootstrap inTrials and outTrials to number of *Incorrect*
    %   trials.  This will help maintain some SNR.  Other option is to
    %   reverse bootstrap to smallest number of trials (typically,
    %   incorrect outTrials) but this may lead to very noisy signals.  For
    %   TDT calculation, do not split on fast/slow/express (for now)
    disp('Wilcoxon - bootstrapped')
    
    %get Wilcoxon values with correct trials bootstrapped to incorrect
    %trial sizes
    for time = 1:size(SDFs_in_correct,2)
        [p_correct(time),h_correct(time)] = ranksum(SDFs_in_correct_boot(:,time),SDFs_out_correct_boot(:,time),'alpha',.01);
        [p_incorrect(time),h_incorrect(time)] = ranksum(SDFs_in_incorrect(:,time),SDFs_out_incorrect(:,time),'alpha',.01);
    end
    
    %find runs of 10 significant time points
    %use 'getEmpty' function that finds 10 consecutive 1's in a vector;
    %origianlly used to eliminate trials with no spikes from SDF function
    %Start looking at 50 ms post-target onset
    sigRuns_correct = getEmpty(h_correct(150:end));
    sigRuns_incorrect = getEmpty(h_incorrect(150:end));
    
    %convert cell ID to time value. Correct -50 because 50 ms baseline;
    %correct +100 because had started search at 100th cell in (i.e.,
    %started searching at +50 ms)
    if ~isempty(sigRuns_correct)
        TDT_correct_Wilcoxon_boot(file,1) = sigRuns_correct(1) - 50 + 150;
    else
        TDT_correct_Wilcoxon_boot(file,1) = NaN;
    end
    
    if ~isempty(sigRuns_incorrect)
        TDT_incorrect_Wilcoxon_boot(file,1) = sigRuns_incorrect(1) - 50 + 150;
    else
        TDT_incorrect_Wilcoxon_boot(file,1) = NaN;
    end
    %=======================================================================
    
    
    %======================================================================
    %subsampled Wilcoxon ('reverse bootstrap')
    %downsample correct trials to # of trials for errors
    %draw without replacement
    %calculate TDT after each subsample (n = 100) and then take median value across
    %draws
    disp('Wilcoxon - subsampled')
    for iter = 1:100
        if size(SDFs_in_correct,1) > size(SDFs_in_incorrect,1)
            current_in_correct_SDF = SDFs_in_correct(myrandint(size(SDFs_in_incorrect,1),1,1:size(SDFs_in_incorrect),'noreplace'),:);
            current_in_incorrect_SDF = SDFs_in_incorrect;
        else
            current_in_incorrect_SDF = SDFs_in_incorrect(myrandint(size(SDFs_in_correct,1),1,1:size(SDFs_in_correct),'noreplace'),:);
            current_in_correct_SDF = SDFs_in_correct;
        end
        
        if size(SDFs_out_correct,1) > size(SDFs_out_incorrect,1)
            current_out_correct_SDF = SDFs_out_correct(myrandint(size(SDFs_out_incorrect,1),1,1:size(SDFs_out_incorrect),'noreplace'),:);
            current_out_incorrect_SDF = SDFs_out_incorrect;
        else
            current_out_incorrect_SDF = SDFs_out_incorrect(myrandint(size(SDFs_out_correct,1),1,1:size(SDFs_out_correct),'noreplace'),:);
            current_out_correct_SDF = SDFs_out_correct;
        end
        
        %calculate TDT
        for time = 1:size(SDFs_in_correct,2)
            [p_correct(time),h_correct(time)] = ranksum(current_in_correct_SDF(:,time),current_out_correct_SDF(:,time),'alpha',.01);
            [p_incorrect(time),h_incorrect(time)] = ranksum(current_in_incorrect_SDF(:,time),current_out_incorrect_SDF(:,time),'alpha',.01);
        end
        
        %find runs of 10 significant time points
        %use 'getEmpty' function that finds 10 consecutive 1's in a vector;
        %origianlly used to eliminate trials with no spikes from SDF function
        %Start looking at 100 ms post-target onset
        sigRuns_correct = getEmpty(h_correct(150:end));
        sigRuns_incorrect = getEmpty(h_incorrect(150:end));
        
        %convert cell ID to time value. Correct -50 because 50 ms baseline;
        %correct +100 because had started search at 100th cell in (i.e.,
        %started searching at +50 ms)
        if ~isempty(sigRuns_correct)
            temp_TDT_correct(iter,1) = sigRuns_correct(1) - 50 + 150;
        else
            temp_TDT_correct(iter,1) = NaN;
        end
        
        if ~isempty(sigRuns_incorrect)
            temp_TDT_incorrect(iter,1) = sigRuns_incorrect(1) - 50 + 150;
        else
            temp_TDT_incorrect(iter,1) = NaN;
        end
    end
    
    %after all iterations, take median value for TDT
    TDT_correct_Wilcoxon_reverseboot(file,1) = nanmedian(temp_TDT_correct);
    TDT_incorrect_Wilcoxon_reverseboot(file,1) = nanmedian(temp_TDT_incorrect);
    %===================================================================
    
    
    
    
    
    %=============================================================
    % subsampled ROC ('reverse bootstrap')
    disp('ROC - subsampled')
    for iter = 1:100
        if size(SDFs_in_correct,1) > size(SDFs_in_incorrect,1)
            current_in_correct_SDF = SDFs_in_correct(myrandint(size(SDFs_in_incorrect,1),1,1:size(SDFs_in_incorrect),'noreplace'),:);
            current_in_incorrect_SDF = SDFs_in_incorrect;
        else
            current_in_incorrect_SDF = SDFs_in_incorrect(myrandint(size(SDFs_in_correct,1),1,1:size(SDFs_in_correct),'noreplace'),:);
            current_in_correct_SDF = SDFs_in_correct;
        end
        
        if size(SDFs_out_correct,1) > size(SDFs_out_incorrect,1)
            current_out_correct_SDF = SDFs_out_correct(myrandint(size(SDFs_out_incorrect,1),1,1:size(SDFs_out_incorrect),'noreplace'),:);
            current_out_incorrect_SDF = SDFs_out_incorrect;
        else
            current_out_incorrect_SDF = SDFs_out_incorrect(myrandint(size(SDFs_out_correct,1),1,1:size(SDFs_out_correct),'noreplace'),:);
            current_out_correct_SDF = SDFs_out_correct;
        end
        
        %concatenate for ROC function
        cor = cat(1,current_in_correct_SDF,current_out_correct_SDF);
        err = cat(1,current_in_incorrect_SDF,current_out_incorrect_SDF);
        
        ROCarea_correct = ROC(cor,1:size(current_in_correct_SDF,1),size(current_in_correct_SDF,1)+1:size(cor,1));
        ROCarea_incorrect = ROC(err,1:size(current_in_correct_SDF,1),size(current_in_correct_SDF,1)+1:size(err,1));
        
        %rule: ROC (corrected to be centered at 0) must exceed 1.5sd of ROC area
        %and maintain for 20 ms.
        ROCarea_correct = ROCarea_correct - .5;
        ROCarea_incorrect = ROCarea_incorrect - .5;
        
        crit_correct = std(ROCarea_correct)*1;
        crit_incorrect = std(ROCarea_incorrect)*1;
        
        %logical: ROCarea values (absolute) greater than criterion
        %NOTE: START SEARCH AT +100 ms (ACTUAL TIME == 100 ms POST TARGET
        exceed_correct = abs(ROCarea_correct(150:end)) > crit_correct;
        exceed_incorrect = abs(ROCarea_incorrect(150:end)) > crit_incorrect;
        
        %find runs of 20 ms and call TDT
        if ~isempty(findRuns(exceed_correct,20))
            tempTDT = min(findRuns(exceed_correct,20));
            %determine selectivity direction
            %         if ROCarea_correct(tempTDT) > 0
            %             TDT_correct_ROC(file,2) = 1;
            %         else
            %             TDT_correct_ROC(file,2) = -1;
            %         end
            temp_TDT_correct_ROC(iter,1) = tempTDT - 50 + 150;
        else
            temp_TDT_correct_ROC(iter,1:2) = NaN;
        end
        
        if ~isempty(findRuns(exceed_incorrect,20))
            tempTDT = min(findRuns(exceed_incorrect,20));
            %determine selectivity direction
            %         if ROCarea_incorrect(tempTDT) > 0
            %             TDT_incorrect_ROC(file,2) = 1;
            %         else
            %             TDT_incorrect_ROC(file,2) = -1;
            %         end
            temp_TDT_incorrect_ROC(iter,1) = tempTDT - 50 + 150;
        else
            temp_TDT_incorrect_ROC(iter,1:2) = NaN;
        end
    end %for subsampling
    
    %take median of TDT values
    TDT_correct_ROC_reverseboot(file,1) = nanmedian(temp_TDT_correct_ROC(:,1));
    TDT_incorrect_ROC_reverseboot(file,1) = nanmedian(temp_TDT_incorrect_ROC(:,1));
    %=============================================================
    
    if plotFlag == 1
        figure
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,1,1)
        plot(Plot_Time(1):Plot_Time(2),nanmean(SDFs_in_correct),'b',Plot_Time(1):Plot_Time(2),nanmean(SDFs_out_correct),'--b',Plot_Time(1):Plot_Time(2),nanmean(SDFs_in_incorrect),'r',Plot_Time(1):Plot_Time(2),nanmean(SDFs_out_incorrect),'--r')
        %lines for non-bootstrapped Wilcoxon estimation [SOLID]
        line([TDT_correct_Wilcoxon(file,1) TDT_correct_Wilcoxon(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b')
        line([TDT_incorrect_Wilcoxon(file,1) TDT_incorrect_Wilcoxon(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r')
        
        %lines for bootstrapped Wilcoxon esimation [DASHED]
        line([TDT_correct_Wilcoxon_boot(file,1) TDT_correct_Wilcoxon_boot(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b','linestyle','--')
        line([TDT_incorrect_Wilcoxon_boot(file,1) TDT_incorrect_Wilcoxon_boot(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r','linestyle','--')
        
        %lines for non-bootstrapped ROC estimation [DASH-DOT]
        line([TDT_correct_ROC(file,1) TDT_correct_ROC(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b','linestyle','-.')
        line([TDT_incorrect_ROC(file,1) TDT_incorrect_ROC(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r','linestyle','-.')
        
        %lines for bootstrapped ROC estimation [DOTTED]
        line([TDT_correct_ROC_boot(file,1) TDT_correct_ROC_boot(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b','linestyle',':')
        line([TDT_incorrect_ROC_boot(file,1) TDT_incorrect_ROC_boot(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r','linestyle',':')
        
        xlim([-50 500])
        title('Regular and bootstrapped TDT')
        %=================================
        subplot(2,1,2)
        plot(Plot_Time(1):Plot_Time(2),nanmean(SDFs_in_correct),'b',Plot_Time(1):Plot_Time(2),nanmean(SDFs_out_correct),'--b',Plot_Time(1):Plot_Time(2),nanmean(SDFs_in_incorrect),'r',Plot_Time(1):Plot_Time(2),nanmean(SDFs_out_incorrect),'--r')
        line([TDT_correct_Wilcoxon_reverseboot(file,1) TDT_correct_Wilcoxon_reverseboot(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b','linestyle','--')
        line([TDT_incorrect_Wilcoxon_reverseboot(file,1) TDT_incorrect_Wilcoxon_reverseboot(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r','linestyle','--')
        
        line([TDT_correct_ROC_reverseboot(file,1) TDT_correct_ROC_reverseboot(file,1)],[0 max(max(nanmean(SDFs_in_correct)),max(nanmean(SDFs_out_correct)))],'color','b','linestyle',':')
        line([TDT_incorrect_ROC_reverseboot(file,1) TDT_incorrect_ROC_reverseboot(file,1)],[0 max(max(nanmean(SDFs_in_incorrect)),max(nanmean(SDFs_out_incorrect)))],'color','r','linestyle',':')
        
        xlim([-50 500])
        title('Downsampled TDT')
    end
    
    
    % % % % % % % % % % %
    % % % % % % % % % % %     SDFs_in_correct_fast = SDF_all(inTrials_correct_fast,:);
    % % % % % % % % % % %     SDFs_in_correct_slow = SDF_all(inTrials_correct_slow,:);
    % % % % % % % % % % %     SDFs_out_correct_fast = SDF_all(outTrials_correct_fast,:);
    % % % % % % % % % % %     SDFs_out_correct_slow = SDF_all(outTrials_correct_slow,:);
    % % % % % % % % % % %     SDFs_in_incorrect_fast = SDF_all(inTrials_incorrect_fast,:);
    % % % % % % % % % % %     SDFs_in_incorrect_slow = SDF_all(inTrials_incorrect_slow,:);
    % % % % % % % % % % %     SDFs_out_incorrect_fast = SDF_all(outTrials_incorrect_fast,:);
    % % % % % % % % % % %     SDFs_out_incorrect_slow = SDF_all(outTrials_incorrect_slow,:);
    % % % % % % % % % % %
    % % % % % % % % % % %     SDFs_in_correct_express = SDF_all(inTrials_correct_express,:);
    % % % % % % % % % % %     SDFs_out_correct_express = SDF_all(outTrials_correct_express,:);
    % % % % % % % % % % %     SDFs_in_incorrect_express = SDF_all(inTrials_incorrect_express,:);
    % % % % % % % % % % %     SDFs_out_incorrect_express = SDF_all(outTrials_incorrect_express,:);
    % % % % % % % % % % %     %===============================================================
    % % % % % % % % % % %
    % % % % % % % % % % %
    %==================================================================
    % % % % % % % % %
    
    
    keep TDT_correct_ROC_reverseboot TDT_incorrect_ROC_reverseboot ...
        TDT_correct_Wilcoxon_reverseboot TDT_incorrect_Wilcoxon_reverseboot ...
        TDT_correct_Wilcoxon TDT_incorrect_Wilcoxon TDT_correct_Wilcoxon_boot ...
        TDT_incorrect_Wilcoxon_boot TDT_correct_ROC ...
        TDT_incorrect_ROC TDT_correct_ROC_boot TDT_incorrect_ROC_boot ...
        plotFlag pdfFlag ssaveFlag cRT eRT correctTDT errorTDT file_name ...
        cell_name q c qcq file
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/FastSlow/VisMove/',cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'-Vismove_fastslow.pdf'])
    close all
end
