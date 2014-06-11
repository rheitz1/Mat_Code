%Search Error analysis;  Considers only sessions and electrodes used by
%Jeremiah Cohen in the Spike/LFP/EEG analysis.  For EEG channel, used
%electrode on same side of the brain as the microelectrode.  Trials were
%chosen based on the neuron's RF

[file_name DSPname LFPname EEGname] = textread('QS_Jeremiah.txt', '%s %s %s %s');

for sess = 1:length(file_name)
   file_name{sess}
   load(cell2mat(file_name(sess)),DSPname{sess},LFPname{sess},EEGname{sess},'Target_','EyeX_','EyeY_','Hemi','SRT','Correct_','Errors_','RFs','BestRF','Decide_','newfile','TrialStart_','-mat')
   
   %get saccade metrics including saccade location (do not check for
   %Translate-encoded SaccDir_, due to some question about its accuracy.
   srt
   
   %fix 'Errors_' variable for old files
   fixErrors
   
   %RF = RFs.(DSPname{sess});
   RF = BestRF.(DSPname{sess});
   antiRF = mod((RF+4),8);
   
   
   %find relevant trials and randomize them for later subsampling
   inTrials_correct = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
   outTrials_correct = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
   
   inTrials_error = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
   outTrials_error = shake(find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
   
   %check number of trials.  Set criterion that all signals must have at
   %least 10 trials
   if findMin(length(inTrials_correct),length(outTrials_correct),length(inTrials_error),length(outTrials_error)) < 10
       disp('Too Few Trials, continuing...')
       continue
   end
   
      
   Spike = eval(DSPname{sess});
   LFP = eval(LFPname{sess});
   EEG = eval(EEGname{sess});
   
   %get TDTs beore sub-sampling
   nosubTDT.correct_Spike = getTDT_SP(Spike,inTrials_correct,outTrials_correct,1);
   nosubTDT.correct_LFP = getTDT_AD(LFP,inTrials_correct,outTrials_correct,1);
   nosubTDT.correct_EEG = getTDT_AD(EEG,inTrials_correct,outTrials_correct,1);
   nosubTDT.error_Spike = getTDT_SP(Spike,inTrials_error,outTrials_error,1);
   nosubTDT.error_LFP = getTDT_AD(LFP,inTrials_error,outTrials_error,1);
   nosubTDT.error_EEG = getTDT_AD(EEG,inTrials_error,outTrials_error,1);
   
   
   nosub_wf.Spike.correct_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_correct,TrialStart_);
   nosub_wf.Spike.correct_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_correct,TrialStart_);
   nosub_wf.Spike.error_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_error,TrialStart_);
   nosub_wf.Spike.error_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_error,TrialStart_);
   
   nosub_wf.LFP.correct_in = nanmean(LFP(inTrials_correct,:));
   nosub_wf.LFP.correct_out = nanmean(LFP(outTrials_correct,:));
   nosub_wf.LFP.error_in = nanmean(LFP(inTrials_error,:));
   nosub_wf.LFP.error_out = nanmean(LFP(outTrials_error,:));
   
   nosub_wf.EEG.correct_in = nanmean(EEG(inTrials_correct,:));
   nosub_wf.EEG.correct_out = nanmean(EEG(outTrials_correct,:));
   nosub_wf.EEG.error_in = nanmean(EEG(inTrials_error,:));
   nosub_wf.EEG.error_out = nanmean(EEG(outTrials_error,:));
   
   nosub_n.correct_in = length(inTrials_correct);
   nosub_n.correct_out = length(outTrials_correct);
   nosub_n.error_in = length(inTrials_error);
   nosub_n.error_out = length(outTrials_error);
   
   
   
   %now subsample
   newLength = findMin(length(inTrials_correct),length(outTrials_correct),length(inTrials_error),length(outTrials_error));
   
   inTrials_correct = inTrials_correct(randperm(newLength));
   outTrials_correct = outTrials_correct(randperm(newLength));
   inTrials_error = inTrials_error(randperm(newLength));
   outTrials_error = outTrials_error(randperm(newLength));
   
   
   subTDT.correct_Spike = getTDT_SP(Spike,inTrials_correct,outTrials_correct,1);
   subTDT.correct_LFP = getTDT_AD(LFP,inTrials_correct,outTrials_correct,1);
   subTDT.correct_EEG = getTDT_AD(EEG,inTrials_correct,outTrials_correct,1);
   nosubTDT.error_Spike = getTDT_SP(Spike,inTrials_error,outTrials_error,1);
   nosubTDT.error_LFP = getTDT_AD(LFP,inTrials_error,outTrials_error,1);
   nosubTDT.error_EEG = getTDT_AD(EEG,inTrials_error,outTrials_error,1);
   
   
   sub_wf.Spike.correct_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_correct,TrialStart_);
   sub_wf.Spike.correct_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_correct,TrialStart_);
   sub_wf.Spike.error_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],inTrials_error,TrialStart_);
   sub_wf.Spike.error_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],outTrials_error,TrialStart_);
   
   sub_wf.LFP.correct_in = nanmean(LFP(inTrials_correct,:));
   sub_wf.LFP.correct_out = nanmean(LFP(outTrials_correct,:));
   sub_wf.LFP.error_in = nanmean(LFP(inTrials_error,:));
   sub_wf.LFP.error_out = nanmean(LFP(outTrials_error,:));
   
   sub_wf.EEG.correct_in = nanmean(EEG(inTrials_correct,:));
   sub_wf.EEG.correct_out = nanmean(EEG(outTrials_correct,:));
   sub_wf.EEG.error_in = nanmean(EEG(inTrials_error,:));
   sub_wf.EEG.error_out = nanmean(EEG(outTrials_error,:));
   
   sub_n.correct_in = length(inTrials_correct);
   sub_n.correct_out = length(outTrials_correct);
   sub_n.error_in = length(inTrials_error);
   sub_n.error_out = length(outTrials_error);
disp('hi')
   
end