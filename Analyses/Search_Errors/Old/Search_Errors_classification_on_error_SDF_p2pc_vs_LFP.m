% Search Error analysis;  Considers only sessions cherry-picked after
% plotting the correct and error trial p2pc's.
% Reading from text file that was generated based on the selectivity of the
% NEURONS: if the Neurons had a significant TDT for error trials, the
% session is included.
% In this version, compare EEG and LFP using HEMIFIELD; also check to make
% sure that TDT timing trunc vs notrunc is within 10 ms either direction

%[file_name DSPname LFPname EEGname] = textread('QS_selection_on_all_subsampled_signals.txt', '%s %s %s %s');
[file_name DSPname LFPname EEGname] = textread('QS_selection_on_error_SDF.txt', '%s %s %s %s');

for sess = 1:length(file_name)
    file_name{sess}
    load(cell2mat(file_name(sess)),DSPname{sess},LFPname{sess},EEGname{sess},'Target_','EyeX_','EyeY_','Hemi','SRT','Correct_','Errors_','RFs','BestRF','Decide_','newfile','TrialStart_','-mat')
    
    %get saccade metrics including saccade location (do not check for
    %Translate-encoded SaccDir_, due to some question about its accuracy.
    srt
    
    %fix 'Errors_' variable for old files
    fixErrors
    
    LFP = eval(LFPname{sess});
    EEG = eval(EEGname{sess});
    
    
    
    %baseline correct
    LFP = baseline_correct(LFP,[400 500]);
    EEG = baseline_correct(EEG,[400 500]);
    
    
    if Hemi.(LFPname{sess}) == 'R'
        inTrials_correct_full = find(Correct_(:,2) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        outTrials_correct_full = find(Correct_(:,2) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        inTrials_errors_full = find(ismember(Target_(:,2),[3 4 5]) & ismember(saccLoc,[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        outTrials_errors_full = find(ismember(Target_(:,2),[7 0 1]) & ismember(saccLoc,[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    elseif Hemi.(LFPname{sess}) == 'L'
        inTrials_correct_full = find(Correct_(:,2) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        outTrials_correct_full = find(Correct_(:,2) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        inTrials_errors_full = find(ismember(Target_(:,2),[7 0 1]) & ismember(saccLoc,[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        outTrials_errors_full = find(ismember(Target_(:,2),[3 4 5]) & ismember(saccLoc,[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    end
    
    %remove saturated signals
    LFP = fixClipped(LFP);
    EEG = fixClipped(EEG);
    
    %get TDTs before sub-sampling
    nosubTDT.correct_LFP = getTDT_AD(LFP,inTrials_correct_full,outTrials_correct_full);
    nosubTDT.correct_EEG = getTDT_AD(EEG,inTrials_correct_full,outTrials_correct_full);
    nosubTDT.errors_LFP = getTDT_AD(LFP,inTrials_errors_full,outTrials_errors_full);
    nosubTDT.errors_EEG = getTDT_AD(EEG,inTrials_errors_full,outTrials_errors_full);
    
    %calculate truncated TDT times for EEG and LFP.  If difference between
    %truncated and non-truncated for *either* signal > 5 ms, skip file.
    LFP_trunc = truncateAD_targ(LFP,SRT);
    TDT_correct_trunc_LFP = getTDT_AD(LFP_trunc,inTrials_correct_full,outTrials_correct_full);
    
    if isnan(TDT_correct_trunc_LFP)
        disp('No truncated LFP TDT detected...')
        keep nosub* sub* sess file_name f DSPname LFPname EEGname TDT_correct_trunc
        continue
    end
    
    
    if abs(TDT_correct_trunc_LFP - nosubTDT.correct_LFP) > 10
        disp('Truncated LFP timing not equivalent to non-truncated. moving on...')
        keep nosub* sub* sess file_name f DSPname LFPname EEGname TDT_correct_trunc
        continue
    end
    
    
    EEG_trunc = truncateAD_targ(EEG,SRT);
    TDT_correct_trunc_EEG = getTDT_AD(EEG_trunc,inTrials_correct_full,outTrials_correct_full);
    
    if isnan(TDT_correct_trunc_EEG)
        disp('No truncated EEG TDT detected...')
        keep nosub* sub* sess file_name f DSPname LFPname EEGname TDT_correct_trunc
        continue
    end
    
    if abs(TDT_correct_trunc_EEG - nosubTDT.correct_EEG) > 10
        disp('Truncated p2pc timing not equivalent to non-truncated. moving on...')
        keep nosub* sub* sess file_name f DSPname LFPname EEGname TDT_correct_trunc
        continue
    end
    
    
    
    nosub_wf.LFP.correct_in = nanmean(LFP(inTrials_correct_full,:));
    nosub_wf.LFP.correct_out = nanmean(LFP(outTrials_correct_full,:));
    nosub_wf.LFP.errors_in = nanmean(LFP(inTrials_errors_full,:));
    nosub_wf.LFP.errors_out = nanmean(LFP(outTrials_errors_full,:));
    
    nosub_wf.EEG.correct_in = nanmean(EEG(inTrials_correct_full,:));
    nosub_wf.EEG.correct_out = nanmean(EEG(outTrials_correct_full,:));
    nosub_wf.EEG.errors_in = nanmean(EEG(inTrials_errors_full,:));
    nosub_wf.EEG.errors_out = nanmean(EEG(outTrials_errors_full,:));
    
    nosub_n.correct_in = length(inTrials_correct_full);
    nosub_n.correct_out = length(outTrials_correct_full);
    nosub_n.errors_in = length(inTrials_errors_full);
    nosub_n.errors_out = length(outTrials_errors_full);
    
    f = figure;
    set(gcf,'color','white')
    subplot(2,2,1)
    plot(-500:2500,nosub_wf.LFP.correct_in,'b',-500:2500,nosub_wf.LFP.correct_out,'--b',-500:2500,nosub_wf.LFP.errors_in,'r',-500:2500,nosub_wf.LFP.errors_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nosubTDT.correct_LFP,'b')
    vline(nosubTDT.errors_LFP,'r')
    
    subplot(2,2,2)
    plot(-500:2500,nosub_wf.EEG.correct_in,'b',-500:2500,nosub_wf.EEG.correct_out,'--b',-500:2500,nosub_wf.EEG.errors_in,'r',-500:2500,nosub_wf.EEG.errors_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nosubTDT.correct_EEG,'b')
    vline(nosubTDT.errors_EEG,'r')
    
    
    %now subsample, but subsample based on # of IN trials AND number of OUT
    %trials.  This should equate correct and error trials while maintaining
    %some semblance of SNR.  For correct trials, we will do this 100 times
    %and take the mean TDT and mean waveform.
    
    newLength_in = findMin(length(inTrials_correct_full),length(inTrials_errors_full));
    newLength_out = findMin(length(outTrials_correct_full),length(outTrials_errors_full));
    
    nReps = 1;
    for rep = 1:nReps
        rep
        
        %re-randomize
        inTrials_correct = shake(inTrials_correct_full);
        outTrials_correct = shake(outTrials_correct_full);
        
        
        %subsample only for correct trials
        inTrials_correct = inTrials_correct(randperm(newLength_in));
        outTrials_correct = outTrials_correct(randperm(newLength_out));
        
        
        subTDT.correct_LFP(rep,1) = getTDT_AD(LFP,inTrials_correct,outTrials_correct);
        subTDT.correct_EEG(rep,1) = getTDT_AD(EEG,inTrials_correct,outTrials_correct);
        
        if subTDT.correct_LFP(rep,1) > nanmean(SRT(:,1))
            subTDT.correct_LFP(rep,1) = NaN;
        end
        
        if subTDT.correct_EEG(rep,1) > nanmean(SRT(:,1))
            subTDT.correct_EEG(rep,1) = NaN;
        end
        
        
        sub_wf.LFP.correct_in(rep,1:3001) = nanmean(LFP(inTrials_correct,:));
        sub_wf.LFP.correct_out(rep,1:3001) = nanmean(LFP(outTrials_correct,:));
        
        sub_wf.EEG.correct_in(rep,1:3001) = nanmean(EEG(inTrials_correct,:));
        sub_wf.EEG.correct_out(rep,1:3001) = nanmean(EEG(outTrials_correct,:));
    end
    
    sub_n.correct_in = newLength_in;
    sub_n.correct_out = newLength_out;
    
    
    %========================================
    
    
    subplot(2,2,3)
    plot(-500:2500,mean(sub_wf.LFP.correct_in),'b',-500:2500,mean(sub_wf.LFP.correct_out),'--b',-500:2500,nosub_wf.LFP.errors_in,'r',-500:2500,nosub_wf.LFP.errors_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nanmean(subTDT.correct_LFP),'b')
    vline(nosubTDT.errors_LFP,'r')
    
    subplot(2,2,4)
    plot(-500:2500,mean(sub_wf.EEG.correct_in),'b',-500:2500,mean(sub_wf.EEG.correct_out),'--b',-500:2500,nosub_wf.EEG.errors_in,'r',-500:2500,nosub_wf.EEG.errors_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nanmean(subTDT.correct_EEG),'b')
    vline(nosubTDT.errors_EEG,'r')
    
    [ax h] = suplabel(file_name{sess},'t');
    set(h,'fontsize',14,'fontweight','bold')
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/Timing/p2pc_vs_LFP/PDF/' file_name{sess} '.pdf'])
    
    keep nosub* sub* sess file_name f DSPname LFPname EEGname TDT_correct_trunc
    
    
    q = '''';
    c = ',';
    qcq = [q c q];
    outdir = '/volumes/Dump/Analyses/Errors/Timing/p2pc_vs_LFP/Matrices/';
    
    
    eval(['save(' q outdir file_name{sess} q ')'])
    
    close(f)
end