%Errors

plotFlag = 1;
pdfFlag = 1;

cRT = [];
eRT = [];
correctTDT = [];
errorTDT = [];
correctROCarea = [];
errorROCarea = [];
%read in files and neurons
f_path = '/volumes/Dump/Analyses/Errors/';
[file_name cell_name] = textread('temp.txt', '%s %s');

q = '''';
c = ',';
qcq = [q c q];

for file = 1:size(file_name,1)
    %echo current file and cell
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'SaccDir_' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])

    %Check file to see if SaccDir_ contains only NaNs (before this was
    %coded in Tempo)
    if length(find(~isnan(SaccDir_))) < 5
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

    %what monkey?
    getMonk
    getCellnames
    temp = cell2mat(CellNames(1));
    stub = temp(end-2:end-1);
    ADname = strcat('AD',stub);

    eval(['load(' q cell2mat(file_name(file)) qcq ADname q ')'])
    LFP = eval(ADname);

    %baseline correct LFP
    %LFP = baseline_correction(LFP,50);

    %eval(['keep ' cell2mat(CellNames(cel)) ' LFP correctROCarea errorROCarea errorTDT correctTDT cRT eRT EyeX_ EyeY_ pdfFlag plotFlag monkey Align_Time Correct_ Decide_ Errors_ RF SRT Target_ TrialStart_ cell_name cl f_path file fileID file_name newfile' ])




    %get saccade locations

    %[SRT saccloc] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);

    inTrials_correct = find(ismember(Target_(:,2),RF) & Correct_(:,2) == 1);
    outTrials_correct = find(ismember(Target_(:,2),anti_RF) & Correct_(:,2) == 1);

    %error when target in RF but saccade into anti_RF
    inTrials_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,anti_RF));
    %error when target in antiRF but saccade into RF
    outTrials_incorrect = find(ismember(Target_(:,2),anti_RF) & ismember(SaccDir_,RF));

    %     cRT(file,1) = nanmean(SRT(find(Correct_(:,2) == 1),1));
    %     eRT(file,1) = nanmean(SRT(find(Correct_(:,2) == 0),1));


    %get CellNames again (should only have one left after clearing all rest
    getCellnames

    TotalSpikes = [];
    %correct Cell name will always be 1st one as long as only one in
    %workspace
    TotalSpikes = eval(cell2mat(CellNames(1)));
    Spikes = TotalSpikes;

    Plot_Time_s = [-50 300];
    %Plot_Time_r = [-400 100];
    Align_Time_s(1:size(Spikes,1),1) = 500;
    %Align_Time_r = SRT(:,1) + 500;
    %
    %     %===========================
    %     %Get TDT using ROC analysis
    %     % [cTDT cROCarea] = ROC_20008(Spikes,Plot_Time_s,Align_Time_s,inTrials_correct,outTrials_correct);
    %     % [eTDT eROCarea] = ROC_20008(Spikes,Plot_Time_s,Align_Time_s,inTrials_incorrect,outTrials_incorrect);
    %
    %     temp = [length(inTrials_correct) length(outTrials_correct) length(inTrials_incorrect) length(outTrials_incorrect)];
    %     n = min(temp);
    %     %n = 100;
    %     if n < 5
    %         n = 5;
    %     end
    %
    %     t = 100;
    %     [cTDT cROCarea boot_in_c boot_out_c] = bootstrp_ROC_2008(Spikes,Plot_Time_s,Align_Time_s,inTrials_correct,outTrials_correct,n,t);
    %
    %     if length(inTrials_incorrect) > 0 && length(outTrials_incorrect) > 0
    %         [eTDT eROCarea boot_in_i boot_out_i] = bootstrp_ROC_2008(Spikes,Plot_Time_s,Align_Time_s,inTrials_incorrect,outTrials_incorrect,n,t);
    %     else
    %         eTDT = 0;
    %         eROCarea = 0;
    %     end

    %Get TDT using Wilcoxon rank-sum test (nonparametric paired t-test)
    %initiate SDF_all
    SDF_all(1:size(Spikes,1),1:(abs(Plot_Time_s(1)) + abs(Plot_Time_s(2)))) = 0;
    %calculate SDF matrix, trial-by-trial

    disp('Creating trial-by-trial SDFs...')
    for n = 1:size(Spikes,1)
        curr_SDF = spikeDensityfunction_singletrial(Spikes(n,:),Align_Time(n,1),Plot_Time_s);
        SDF_all(n,1:length(curr_SDF)) = curr_SDF;
    end

    SDFs_in_correct = SDF_all(inTrials_correct,:);
    SDFs_out_correct = SDF_all(outTrials_correct,:);
    SDFs_in_incorrect = SDF_all(inTrials_incorrect,:);
    SDFs_out_incorrect = SDF_all(outTrials_incorrect,:);

    %calculate Wilcoxon p-values [p] and 0/1 hypothesis test [h]
    for time = 1:size(SDFs_in_correct,2)
        [p_correct(time),h_correct(time)] = ranksum(SDFs_in_correct(:,time),SDFs_out_correct(:,time),'alpha',.01);
        [p_incorrect(time),h_incorrect(time)] = ranksum(SDFs_in_incorrect(:,time),SDFs_out_incorrect(:,time),'alpha',.01);
    end

    %find runs of 10 significant time points
    %use 'getEmpty' function that finds 10 consecutive 1's in a vector;
    %origianlly used to eliminate trials with no spikes from SDF function
    sigRuns_correct = getEmpty(h_correct(100:end));
    sigRuns_incorrect = getEmpty(h_incorrect(100:end));
    if ~isempty(sigRuns_correct)
        TDT_correct = sigRuns_correct(1) - 50 + 100;
    else
        TDT_correct = NaN;
    end

    if ~isempty(sigRuns_incorrect)
        TDT_incorrect = sigRuns_incorrect(1) - 50 + 100;
    else
        TDT_incorrect = NaN;
    end
    cTDT(file) = TDT_correct;
    eTDT(file) = TDT_incorrect;

    %     correctTDT(file,1) = cTDT;
    %     errorTDT(file,1) = eTDT;
    %
    %     correctROCarea(file,1:length(cROCarea)) = cROCarea;
    %     errorROCarea(file,1:length(eROCarea)) = eROCarea;

    %     if ~isempty(Spikes)
    %     SDF_in_correct_s = spikedensityfunct(TotalSpikes,Align_Time_s,Plot_Time_s,inTrials_correct, TrialStart_);
    %     SDF_out_correct_s = spikedensityfunct(TotalSpikes,Align_Time_s,Plot_Time_s,outTrials_correct, TrialStart_);
    %     SDF_in_incorrect_s = spikedensityfunct(TotalSpikes,Align_Time_s,Plot_Time_s,inTrials_incorrect, TrialStart_);
    %     SDF_out_incorrect_s = spikedensityfunct(TotalSpikes,Align_Time_s,Plot_Time_s,outTrials_incorrect, TrialStart_);
    %
    %     SDF_in_correct_r = spikedensityfunct(TotalSpikes,Align_Time_r,Plot_Time_r,inTrials_correct, TrialStart_);
    %     SDF_out_correct_r = spikedensityfunct(TotalSpikes,Align_Time_r,Plot_Time_r,outTrials_correct, TrialStart_);
    %     SDF_in_incorrect_r = spikedensityfunct(TotalSpikes,Align_Time_r,Plot_Time_r,inTrials_incorrect, TrialStart_);
    %     SDF_out_incorrect_r = spikedensityfunct(TotalSpikes,Align_Time_r,Plot_Time_r,outTrials_incorrect, TrialStart_);
    %     %     end



    %LFPs
    %equate vector for SDF time scale
    LFP = LFP(:,450:800);

    LFP_in_correct = nanmean(LFP(inTrials_correct,:));
    LFP_out_correct = nanmean(LFP(outTrials_correct,:));
    LFP_in_incorrect = nanmean(LFP(inTrials_incorrect,:));
    LFP_out_incorrect = nanmean(LFP(outTrials_incorrect,:));

    SDFs_in_correct_s = nanmean(SDFs_in_correct);
    SDFs_out_correct_s = nanmean(SDFs_out_correct);
    SDFs_in_incorrect_s = nanmean(SDFs_in_incorrect);
    SDFs_out_incorrect_s = nanmean(SDFs_out_incorrect);

    if plotFlag == 1
        fig
        subplot(1,2,1)
        plot(Plot_Time_s(1):Plot_Time_s(2),SDFs_in_correct_s,'b',Plot_Time_s(1):Plot_Time_s(2),SDFs_out_correct_s,'--b',Plot_Time_s(1):Plot_Time_s(2),SDFs_in_incorrect_s,'r',Plot_Time_s(1):Plot_Time_s(2),SDFs_out_incorrect_s,'--r')
        %plot(Plot_Time_s(1):Plot_Time_s(2),boot_in_c,Plot_Time_s(1):Plot_Time_s(2),boot_out_c,Plot_Time_s(1):Plot_Time_s(2),boot_in_i,Plot_Time_s(1):Plot_Time_s(2),boot_out_i)
        if ~isnan(TDT_correct)
            line([TDT_correct TDT_correct],[min(min(SDFs_in_correct_s),min(SDFs_out_correct_s)) SDFs_in_correct_s(TDT_correct + abs(Plot_Time_s(1)))],'Color','b')
        end
        if ~isnan(TDT_incorrect)
            line([TDT_incorrect TDT_incorrect],[min(min(SDFs_in_incorrect_s),min(SDFs_out_incorrect_s)) SDFs_in_incorrect_s(TDT_incorrect + abs(Plot_Time_s(1)))],'Color','r')
        end

        legend('T in Correct','T out Correct','T in Incorrect','T out Incorrect')
        title(['T in Correct: ' mat2str(length(inTrials_correct)) ' T out Correct: ' mat2str(length(outTrials_correct)) ' T in Incorrect: ' mat2str(length(inTrials_incorrect)) ' T out Incorrect: ' mat2str(length(outTrials_incorrect)) ' cTDT = ' mat2str(TDT_correct) ' eTDT = ' mat2str(TDT_incorrect)],'fontsize',12)

        %         subplot(1,2,2)
        %         %plot(Plot_Time_r(1):Plot_Time_r(2),SDF_in_correct_r,Plot_Time_r(1):Plot_Time_r(2),SDF_out_correct_r,Plot_Time_r(1):Plot_Time_r(2),SDF_in_incorrect_r,Plot_Time_r(1):Plot_Time_r(2),SDF_out_incorrect_r)
        %         plot(Plot_Time_s(1):Plot_Time_s(2),SDF_in_correct_s,Plot_Time_s(1):Plot_Time_s(2),SDF_out_correct_s,Plot_Time_s(1):Plot_Time_s(2),SDF_in_incorrect_s,Plot_Time_s(1):Plot_Time_s(2),SDF_out_incorrect_s)
        %

        subplot(1,2,2)
        plot(Plot_Time_s(1):Plot_Time_s(2),LFP_in_correct,'b',Plot_Time_s(1):Plot_Time_s(2),LFP_out_correct,'--b',Plot_Time_s(1):Plot_Time_s(2),LFP_in_incorrect,'r',Plot_Time_s(1):Plot_Time_s(2),LFP_out_incorrect,'--r')
        title('LFP')
  
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(CellNames(1))),'   Generated: ',date),'t');
        set(h3,'FontSize',12)
        %pause

        if pdfFlag == 1
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/',cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'-Vis_reverseBoot.pdf'])
            %             eval(['print -dpdf ',outdir,batch_list(i).name,'_',cell2mat(CellNames(k)),'_1s.pdf']);
        end

        keep cTDT eTDT plotFlag pdfFlag file file_name cell_name f_path q c qcq
        close all

    end
end