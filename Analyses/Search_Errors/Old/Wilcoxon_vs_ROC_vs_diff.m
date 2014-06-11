
plotFlag = 1;
pdfFlag = 1;

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
    getRF
    RF = cell2mat(RF);
    antiRF = getAntiRF(RF);
    fixErrors
    
    Spike = eval(cell2mat(cell_name(file)));
    
    if isempty(RF)
        disp('RFs for cell not found!  Aborting...')
        return
    end
    
    
    
    SDF = sSDF(Spike,Target_(:,1),[-100 500]);
    %baseline correct SDFs
   % SDF = baseline_correct(SDF,[1 100]);
    
    %also check to make sure trial in SDF is not NaN
    inTrials_correct_nosub = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & ~isnan(SDF(:,1)));
    outTrials_correct_nosub = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & ~isnan(SDF(:,1)));
    
    inTrials_incorrect_nosub = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF) & ~isnan(SDF(:,1)));
    outTrials_incorrect_nosub = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF) & ~isnan(SDF(:,1)));
        
    %SubSampling
    if length(inTrials_correct_nosub) > length(inTrials_incorrect_nosub)
        inTrials_correct_sub = inTrials_correct_nosub(randperm(length(inTrials_incorrect_nosub)));
        inTrials_incorrect_sub = inTrials_incorrect_nosub;
    else
        inTrials_incorrect_sub = inTrials_incorrect_nosub(randperm(length(inTrials_correct_nosub)));
        inTrials_correct_sub = inTrials_correct_nosub;
    end
    
    if length(outTrials_correct_nosub) > length(outTrials_incorrect_nosub)
        outTrials_correct_sub = outTrials_correct_nosub(randperm(length(outTrials_incorrect_nosub)));
        outTrials_incorrect_sub = outTrials_incorrect_nosub;
    else
        outTrials_incorrect_sub = outTrials_incorrect_nosub(randperm(length(outTrials_correct_nosub)));
        outTrials_correct_sub = outTrials_correct_nosub;
    end
    
    
    %==========================================
    % TDT calculation
    
    % WILCOXON RANK-SUM
    for time = 1:size(SDF,2)
        %calculate non-sub sampled TDT
        [p_correct_nosub(time) h_correct_nosub(time)] = ranksum(SDF(inTrials_correct_nosub,time),SDF(outTrials_correct_nosub,time),'alpha',.01);
        [p_incorrect_nosub(time) h_incorrect_nosub(time)] = ranksum(SDF(inTrials_incorrect_nosub,time),SDF(outTrials_incorrect_nosub,time),'alpha',.01);
        %calculate sub-sampled TDT
        [p_correct_sub(time) h_correct_sub(time)] = ranksum(SDF(inTrials_correct_sub,time),SDF(outTrials_correct_sub,time),'alpha',.01);
        [p_incorrect_sub(time) h_incorrect_sub(time)] = ranksum(SDF(inTrials_incorrect_sub,time),SDF(outTrials_incorrect_sub,time),'alpha',.01);
    end
        
    
    % ROC AREA
    ROCarea_correct_nosub = getROC(SDF,inTrials_correct_nosub,outTrials_correct_nosub);
    ROCarea_incorrect_nosub = getROC(SDF,outTrials_incorrect_nosub,inTrials_incorrect_nosub);
    ROCarea_correct_sub = getROC(SDF,inTrials_correct_sub,outTrials_correct_sub);
    ROCarea_incorrect_sub = getROC(SDF,outTrials_incorrect_sub,inTrials_incorrect_sub);
    
    % sd of ROC area
    sd_ROC_correct_nosub = std(ROCarea_correct_nosub);
    sd_ROC_incorrect_nosub = std(ROCarea_incorrect_nosub);
    sd_ROC_correct_sub = std(ROCarea_correct_sub);
    sd_ROC_incorrect_sub = std(ROCarea_incorrect_sub);
    
    
    % Direct DIFFERENCE Method
    diff_correct_nosub = nanmean(SDF(inTrials_correct_nosub,:)) - nanmean(SDF(outTrials_correct_nosub,:));
    diff_incorrect_nosub = nanmean(SDF(outTrials_incorrect_nosub,:)) - nanmean(SDF(inTrials_incorrect_nosub,:));
    diff_correct_sub = nanmean(SDF(inTrials_correct_sub,:)) - nanmean(SDF(outTrials_correct_sub,:));
    diff_incorrect_sub = nanmean(SDF(outTrials_incorrect_sub,:)) - nanmean(SDF(inTrials_incorrect_sub,:));
    
    % sd of mean difference
    sd_diff_correct_nosub = std(diff_correct_nosub);
    sd_diff_incorrect_nosub = std(diff_incorrect_nosub);
    sd_diff_correct_sub = std(diff_correct_sub);
    sd_diff_incorrect_sub = std(diff_incorrect_sub);
    
    
    %standard deviation criterion for finding onsets
    crit = 2;
    
    TDT.Wilcoxon_correct_nosub{file,1} = min(findRuns(h_correct_nosub(200:end))) + 100;
    TDT.Wilcoxon_incorrect_nosub{file,1} = min(findRuns(h_incorrect_nosub(200:end))) + 100;
    TDT.Wilcoxon_correct_sub{file,1} = min(findRuns(h_correct_sub(200:end))) + 100;
    TDT.Wilcoxon_incorrect_sub{file,1} = min(findRuns(h_incorrect_sub(200:end))) + 100;
    
    TDT.ROC_correct_nosub_sd{file,1} = min(findRuns(ROCarea_correct_nosub(200:end) > sd_ROC_correct_nosub*crit,10)) + 100;
    TDT.ROC_incorrect_nosub_sd{file,1} = min(findRuns(ROCarea_incorrect_nosub(200:end) > sd_ROC_incorrect_nosub*crit,10)) + 100;
    TDT.ROC_correct_sub_sd{file,1} = min(findRuns(ROCarea_correct_sub(200:end) > sd_ROC_correct_sub*crit,10)) + 100;
    TDT.ROC_incorrect_sub_sd{file,1} = min(findRuns(ROCarea_incorrect_sub(200:end) > sd_ROC_incorrect_sub*crit,10)) + 100;
    
    TDT.diff_correct_nosub_sd{file,1} = min(findRuns(diff_correct_nosub(200:end) > sd_diff_correct_nosub*crit,10)) + 100;
    TDT.diff_incorrect_nosub_sd{file,1} = min(findRuns(diff_incorrect_nosub(200:end) > sd_diff_incorrect_nosub*crit,10)) + 100;
    TDT.diff_correct_sub_sd{file,1} = min(findRuns(diff_correct_sub(200:end) > sd_diff_correct_sub*crit,10)) + 100;
    TDT.diff_incorrect_sub_sd{file,1} = min(findRuns(diff_incorrect_sub(200:end) > sd_diff_incorrect_sub*crit,10)) + 100;
    
    
    %find 75% of maximum and minimum falling before maximum (down to time
    %0).  Make sure holds above that point for 10 ms.
    [ROCmax,ind] = max(ROCarea_correct_nosub(200:end));
    ROCmin = min(ROCarea_correct_nosub(200:ind+199));
    maxmin = (ROCmax - ROCmin)*.75;
    validROC = ROCarea_correct_nosub(200:end) > maxmin + ROCmin;
    
    TDT.ROC_correct_nosub_minmax{file,1} = min(findRuns(validROC,10,1)) + 100;
    
    
    [ROCmax,ind] = max(ROCarea_incorrect_nosub(200:end));
    ROCmin = min(ROCarea_incorrect_nosub(200:ind+199));
    maxmin = (ROCmax - ROCmin)*.65;
    validROC = ROCarea_incorrect_nosub(200:end) > maxmin + ROCmin;
    
    TDT.ROC_incorrect_nosub_minmax{file,1} = min(findRuns(validROC,10,1)) + 100;
    
    
    [ROCmax,ind] = max(ROCarea_correct_sub(200:end));
    ROCmin = min(ROCarea_correct_sub(200:ind+199));
    maxmin = (ROCmax - ROCmin)*.65;
    validROC = ROCarea_correct_sub(200:end) > maxmin + ROCmin;
        
    TDT.ROC_correct_sub_minmax{file,1} = min(findRuns(validROC,10,1)) + 100;
    
    
    [ROCmax,ind] = max(ROCarea_incorrect_sub(200:end));
    ROCmin = min(ROCarea_incorrect_sub(200:ind+199));
    maxmin = (ROCmax - ROCmin)*.65;
    validROC = ROCarea_incorrect_sub(200:end) > maxmin + ROCmin;
    
    TDT.ROC_incorrect_sub_minmax{file,1} = min(findRuns(validROC,10,1)) + 100;
       

    [diffmax,ind] = max(diff_correct_nosub(200:end));
    diffmin = min(diff_correct_nosub(200:ind+199));
    maxmin = (diffmax - diffmin)*.65;
    validdiff = diff_correct_nosub(200:end) > maxmin + diffmin;
 
    TDT.diff_correct_nosub_minmax{file,1} = min(findRuns(validdiff,10,1)) + 100;
    
    
    [diffmax,ind] = max(diff_incorrect_nosub(200:end));
    diffmin = min(diff_incorrect_nosub(200:ind+199));
    maxmin = (diffmax - diffmin)*.65;
    validdiff = diff_incorrect_nosub(200:end) > maxmin + diffmin;
    
    TDT.diff_incorrect_nosub_minmax{file,1} = min(findRuns(validdiff,10,1)) + 100;
    
    
    [diffmax,ind] = max(diff_correct_sub(200:end));
    diffmin = min(diff_correct_sub(200:ind+199));
    maxmin = (diffmax - diffmin)*.65;
    validdiff = diff_correct_sub(200:end) > maxmin + diffmin;
    
    TDT.diff_correct_sub_minmax{file,1} = min(findRuns(validdiff,10,1)) + 100;
    

    [diffmax,ind] = max(diff_incorrect_sub(200:end));
    diffmin = min(diff_incorrect_sub(200:ind+199));
    maxmin = (diffmax - diffmin)*.65;
    validdiff = diff_incorrect_sub(200:end) > maxmin + diffmin;
    
    TDT.diff_incorrect_sub_minmax{file,1} = min(findRuns(validdiff,10,1)) + 100;
%=========================================================================

    
  %Keep track of mean SRT (correct & errors) for session
        TDT.SRT_correct{file,1} = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
        TDT.SRT_errors{file,1} = nanmean(SRT(find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    

        
%=======================================================
% PLOTTING
    if plotFlag == 1
        f = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(3,2,1)
        plot(-100:500,nanmean(SDF(inTrials_correct_nosub,:)),'b',-100:500,nanmean(SDF(outTrials_correct_nosub,:)),'--b',-100:500,nanmean(SDF(inTrials_incorrect_nosub,:)),'r',-100:500,nanmean(SDF(outTrials_incorrect_nosub,:)),'--r')
        vline(TDT.Wilcoxon_correct_nosub{file,1},'b')
        vline(TDT.Wilcoxon_incorrect_nosub{file,1},'r')
        title(['Wilcoxon Not Sub Sampled  nIn = ' mat2str(length(inTrials_correct_nosub)) ' nOut = ' mat2str(length(outTrials_correct_nosub))])
        xlim([-100 500])
        
        subplot(3,2,2)
        plot(-100:500,nanmean(SDF(inTrials_correct_sub,:)),'b',-100:500,nanmean(SDF(outTrials_correct_sub,:)),'--b',-100:500,nanmean(SDF(inTrials_incorrect_sub,:)),'r',-100:500,nanmean(SDF(outTrials_incorrect_sub,:)),'--r')
        vline(TDT.Wilcoxon_correct_sub{file,1},'b')
        vline(TDT.Wilcoxon_incorrect_sub{file,1},'r')
        title(['Wilcoxon Sub Sampled   nIn = ' mat2str(length(inTrials_correct_sub)) ' nOut = ' mat2str(length(outTrials_correct_sub))])
        xlim([-100 500])
        
        subplot(3,2,3)
        plot(-100:500,ROCarea_correct_nosub,'b',-100:500,ROCarea_incorrect_nosub,'r')
        title('Not Sub Sampled ROC')
        xlim([-100 500])
        %ylim([.5 .75])
        vline(TDT.ROC_correct_nosub_sd{file,1},'b')
        vline(TDT.ROC_incorrect_nosub_sd{file,1},'r')
        vline(TDT.ROC_correct_nosub_minmax{file,1},'--b')
        vline(TDT.ROC_incorrect_nosub_minmax{file,1},'--r')
        
        subplot(3,2,4)
        plot(-100:500,ROCarea_correct_sub,'b',-100:500,ROCarea_incorrect_sub,'r')
        title('Sub Sampled ROC')
        xlim([-100 500])
        %ylim([.5 .75])
        vline(TDT.ROC_correct_sub_sd{file,1},'b')
        vline(TDT.ROC_incorrect_sub_sd{file,1},'r')
        vline(TDT.ROC_correct_sub_minmax{file,1},'--b')
        vline(TDT.ROC_incorrect_sub_minmax{file,1},'--r')
        
        subplot(3,2,5)
        plot(-100:500,diff_correct_nosub,'b',-100:500,diff_incorrect_nosub,'r')
        title('Not Sub Sampled Difference')
        xlim([-100 500])
        hold
        vline(TDT.diff_correct_nosub_sd{file,1},'b')
        vline(TDT.diff_incorrect_nosub_sd{file,1},'r')
        vline(TDT.diff_correct_nosub_minmax{file,1},'--b')
        vline(TDT.diff_incorrect_nosub_minmax{file,1},'--r')
        
        subplot(3,2,6)
        plot(-100:500,diff_correct_sub,'b',-100:500,diff_incorrect_sub,'r')
        title('Sub Sampled Difference')
        xlim([-100 500])
        vline(TDT.diff_correct_sub_sd{file,1},'b')
        vline(TDT.diff_incorrect_sub_sd{file,1},'r')
        vline(TDT.diff_correct_sub_minmax{file,1},'--b')
        vline(TDT.diff_incorrect_sub_minmax{file,1},'--r')
    end
    
    if pdfFlag == 1
        eval(['print -dpdf ',q,'/volumes/Dump/Analyses/Errors/Wil_vs_ROC_vs_diff/VisMove/',[cell2mat(file_name(file)) cell2mat(cell_name(file))],'.pdf',q])
        close(f)
    end
    
    keep TDT file_name cell_name plotFlag pdfFlag q c qcq file
    
end