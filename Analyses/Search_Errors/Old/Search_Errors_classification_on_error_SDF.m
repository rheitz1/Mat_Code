%Search Error analysis;  Considers only sessions and electrodes used by
%Jeremiah Cohen in the Spike/LFP/EEG analysis.  For EEG channel, used
%electrode on same side of the brain as the microelectrode.  Trials were
%chosen based on the neuron's RF

[file_name DSPname LFPname EEGname] = textread('QS_selection_on_all_subsampled_signals.txt', '%s %s %s %s');

for sess = 1:length(file_name)
    file_name{sess}
    load(cell2mat(file_name(sess)),DSPname{sess},LFPname{sess},EEGname{sess},'Target_','EyeX_','EyeY_','Hemi','SRT','Correct_','Errors_','RFs','BestRF','Decide_','newfile','TrialStart_','-mat')
    
    %get saccade metrics including saccade location (do not check for
    %Translate-encoded SaccDir_, due to some question about its accuracy.
    srt
    
    %fix 'Errors_' variable for old files
    fixErrors
    
    %RF = RFs.(DSPname{sess});
    RF = RFs.(DSPname{sess});
    antiRF = mod((RF+4),8);
    
    
    %find relevant trials and randomize them for later subsampling
    inTrials_correct_full = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
    outTrials_correct_full = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
    
    inTrials_error_full = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
    outTrials_error_full = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
    
    %check number of trials.  Set criterion that all signals must have at
    %least 10 trials
    %    if findMin(length(inTrials_correct),length(outTrials_correct),length(inTrials_error),length(outTrials_error)) < 10
    %        disp('Too Few Trials, continuing...')
    %        continue
    %    end
    
    
    Spike = eval(DSPname{sess});
    LFP = eval(LFPname{sess});
    EEG = eval(EEGname{sess});
    
    %baseline correct
    LFP = baseline_correct(LFP,[400 500]);
    EEG = baseline_correct(EEG,[400 500]);
    
    %check to see if ipsilateral or contralateral RF.  If ipsilateral,
    %invert EEG so that all m-p2pc will go in same direction
    if Hemi.(DSPname{sess}) == 'R' & ismember(RF,[7 0 1]) == 1 & strmatch(EEGname{sess},'AD02','exact') %RF is on same side as EEG electrode; invert
        EEG = EEG * -1;
        disp('Ipsilateral RF - inverting EEG');
    end
    
    if Hemi.(DSPname{sess}) == 'L' & ismember(RF,[3 4 5]) == 1 & strmatch(EEGname{sess},'AD03','exact')
        EEG = EEG * -1;
        disp('Ipsilateral RF - inverting EEG');
    end
    
    
    %get TDTs beore sub-sampling
    nosubTDT.correct_Spike = getTDT_SP(Spike,inTrials_correct_full,outTrials_correct_full);
    nosubTDT.correct_LFP = getTDT_AD(LFP,inTrials_correct_full,outTrials_correct_full);
    nosubTDT.correct_EEG = getTDT_AD(EEG,inTrials_correct_full,outTrials_correct_full);
    nosubTDT.error_Spike = getTDT_SP(Spike,inTrials_error_full,outTrials_error_full);
    nosubTDT.error_LFP = getTDT_AD(LFP,inTrials_error_full,outTrials_error_full);
    nosubTDT.error_EEG = getTDT_AD(EEG,inTrials_error_full,outTrials_error_full);
    
    
    nosub_wf.Spike.correct_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_correct_full,TrialStart_);
    nosub_wf.Spike.correct_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_correct_full,TrialStart_);
    nosub_wf.Spike.error_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_error_full,TrialStart_);
    nosub_wf.Spike.error_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_error_full,TrialStart_);
    
    nosub_wf.LFP.correct_in = nanmean(LFP(inTrials_correct_full,:));
    nosub_wf.LFP.correct_out = nanmean(LFP(outTrials_correct_full,:));
    nosub_wf.LFP.error_in = nanmean(LFP(inTrials_error_full,:));
    nosub_wf.LFP.error_out = nanmean(LFP(outTrials_error_full,:));
    
    nosub_wf.EEG.correct_in = nanmean(EEG(inTrials_correct_full,:));
    nosub_wf.EEG.correct_out = nanmean(EEG(outTrials_correct_full,:));
    nosub_wf.EEG.error_in = nanmean(EEG(inTrials_error_full,:));
    nosub_wf.EEG.error_out = nanmean(EEG(outTrials_error_full,:));
    
    nosub_n.correct_in = length(inTrials_correct_full);
    nosub_n.correct_out = length(outTrials_correct_full);
    nosub_n.error_in = length(inTrials_error_full);
    nosub_n.error_out = length(outTrials_error_full);
    
    f = figure;
    set(gcf,'color','white')
    subplot(2,3,1)
    plot(-100:500,nosub_wf.Spike.correct_in,'b',-100:500,nosub_wf.Spike.correct_out,'--b',-100:500,nosub_wf.Spike.error_in,'r',-100:500,nosub_wf.Spike.error_out,'--r')
    xlim([-100 500])
    vline(nosubTDT.correct_Spike,'b')
    vline(nosubTDT.error_Spike,'r')
    
    subplot(2,3,2)
    plot(-500:2500,nosub_wf.LFP.correct_in,'b',-500:2500,nosub_wf.LFP.correct_out,'--b',-500:2500,nosub_wf.LFP.error_in,'r',-500:2500,nosub_wf.LFP.error_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nosubTDT.correct_LFP,'b')
    vline(nosubTDT.error_LFP,'r')
    
    subplot(2,3,3)
    plot(-500:2500,nosub_wf.EEG.correct_in,'b',-500:2500,nosub_wf.EEG.correct_out,'--b',-500:2500,nosub_wf.EEG.error_in,'r',-500:2500,nosub_wf.EEG.error_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nosubTDT.correct_EEG,'b')
    vline(nosubTDT.error_EEG,'r')
    
    
    %now subsample, but subsample based on # of IN trials AND number of OUT
    %trials.  This should equate correct and error trials while maintaining
    %some semblance of SNR.  For correct trials, we will do this 100 times
    %and take the mean TDT and mean waveform.
    
    newLength_in = findMin(length(inTrials_correct_full),length(inTrials_error_full));
    newLength_out = findMin(length(outTrials_correct_full),length(outTrials_error_full));
    
    nReps = 100;
    for rep = 1:nReps
        rep
        
        %re-randomize
        inTrials_correct = shake(inTrials_correct_full);
        outTrials_correct = shake(outTrials_correct_full);
        inTrials_error = shake(inTrials_error_full);
        outTrials_error = shake(outTrials_error_full);
        
        inTrials_correct = inTrials_correct(randperm(newLength_in));
        outTrials_correct = outTrials_correct(randperm(newLength_out));
        inTrials_error = inTrials_error(randperm(newLength_in));
        outTrials_error = outTrials_error(randperm(newLength_out));
        
        subTDT.correct_Spike(rep,1) = getTDT_SP(Spike,inTrials_correct,outTrials_correct);
        subTDT.correct_LFP(rep,1) = getTDT_AD(LFP,inTrials_correct,outTrials_correct);
        subTDT.correct_EEG(rep,1) = getTDT_AD(EEG,inTrials_correct,outTrials_correct);
        
        if subTDT.correct_Spike(rep,1) > nanmean(SRT(:,1))
            subTDT.correct_Spike(rep,1) = NaN;
        end
        
        if subTDT.correct_LFP(rep,1) > nanmean(SRT(:,1))
            subTDT.correct_LFP(rep,1) = NaN;
        end
        
        if subTDT.correct_EEG(rep,1) > nanmean(SRT(:,1))
            subTDT.correct_EEG(rep,1) = NaN;
        end
        
        
        %         subTDT.error_Spike(rep,1) = getTDT_SP(Spike,inTrials_error,outTrials_error);
        %         subTDT.error_LFP(rep,1) = getTDT_AD(LFP,inTrials_error,outTrials_error);
        %         subTDT.error_EEG(rep,1) = getTDT_AD(EEG,inTrials_error,outTrials_error);
        
        
        sub_wf.Spike.correct_in(rep,1:601) = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_correct,TrialStart_);
        sub_wf.Spike.correct_out(rep,1:601) = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_correct,TrialStart_);
        %         sub_wf.Spike.error_in(rep,1:601) = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_error,TrialStart_);
        %         sub_wf.Spike.error_out(rep,1:601) = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_error,TrialStart_);
        
        sub_wf.LFP.correct_in(rep,1:3001) = nanmean(LFP(inTrials_correct,:));
        sub_wf.LFP.correct_out(rep,1:3001) = nanmean(LFP(outTrials_correct,:));
        %         sub_wf.LFP.error_in(rep,1:3001) = nanmean(LFP(inTrials_error,:));
        %         sub_wf.LFP.error_out(rep,1:3001) = nanmean(LFP(outTrials_error,:));
        
        sub_wf.EEG.correct_in(rep,1:3001) = nanmean(EEG(inTrials_correct,:));
        sub_wf.EEG.correct_out(rep,1:3001) = nanmean(EEG(outTrials_correct,:));
        %         sub_wf.EEG.error_in(rep,1:3001) = nanmean(EEG(inTrials_error,:));
        %         sub_wf.EEG.error_out(rep,1:3001) = nanmean(EEG(outTrials_error,:));
        
        
    end
    
    sub_n.correct_in = newLength_in;
    sub_n.correct_out = newLength_out;
    %         sub_n.error_in = newLength_in;
    %         sub_n.error_out = newLength_out;
    
    
    %========================================
    
    
    subplot(2,3,4)
    plot(-100:500,mean(sub_wf.Spike.correct_in),'b',-100:500,mean(sub_wf.Spike.correct_out),'--b',-100:500,nosub_wf.Spike.error_in,'r',-100:500,nosub_wf.Spike.error_out,'--r')
    xlim([-100 500])
    vline(nanmean(subTDT.correct_Spike),'b')
    vline(nosubTDT.error_Spike,'r')
    
    subplot(2,3,5)
    plot(-500:2500,mean(sub_wf.LFP.correct_in),'b',-500:2500,mean(sub_wf.LFP.correct_out),'--b',-500:2500,nosub_wf.LFP.error_in,'r',-500:2500,nosub_wf.LFP.error_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nanmean(subTDT.correct_LFP),'b')
    vline(nosubTDT.error_LFP,'r')
    
    subplot(2,3,6)
    plot(-500:2500,mean(sub_wf.EEG.correct_in),'b',-500:2500,mean(sub_wf.EEG.correct_out),'--b',-500:2500,nosub_wf.EEG.error_in,'r',-500:2500,nosub_wf.EEG.error_out,'--r')
    xlim([-100 500])
    axis ij
    vline(nanmean(subTDT.correct_EEG),'b')
    vline(nosubTDT.error_EEG,'r')
    
    [ax h] = suplabel(file_name{sess},'t');
    set(h,'fontsize',14,'fontweight','bold')
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/classification_on_error_SDF_subsample/PDF/' file_name{sess} '_' DSPname{sess}])
    
    keep nosub* sub* sess file_name f DSPname LFPname EEGname
    
    
    q = '''';
    c = ',';
    qcq = [q c q];
    outdir = '/volumes/Dump/Analyses/Errors/classification_on_error_SDF_subsample/Matrices/';
    
    
    eval(['save(' q outdir file_name{sess} '_' DSPname{sess} q ')'])
    
    close(f)
end