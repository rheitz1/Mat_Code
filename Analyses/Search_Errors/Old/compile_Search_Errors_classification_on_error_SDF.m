%compile data from Search_Errors_classification_on_error_SDF

cd /volumes/Dump/Analyses/Errors/classification_on_error_SDF_subsample/Matrices/
file_list = dir('*.mat');

for sess = 1:length(file_list);
    sess
    load(file_list(sess).name)
    
    nosubTDT_all.correct_Spike(sess,1) = nosubTDT.correct_Spike;
    nosubTDT_all.correct_LFP(sess,1) = nosubTDT.correct_LFP;
    nosubTDT_all.correct_EEG(sess,1) = nosubTDT.correct_EEG;
    nosubTDT_all.error_Spike(sess,1) = nosubTDT.error_Spike;
    nosubTDT_all.error_LFP(sess,1) = nosubTDT.error_LFP;
    nosubTDT_all.error_EEG(sess,1) = nosubTDT.error_EEG;
    
    nosub_wf_all.Spike.correct_in(sess,1:601) = nosub_wf.Spike.correct_in;
    nosub_wf_all.Spike.correct_out(sess,1:601) = nosub_wf.Spike.correct_out;
    nosub_wf_all.Spike.error_in(sess,1:601) = nosub_wf.Spike.error_in;
    nosub_wf_all.Spike.error_out(sess,1:601) = nosub_wf.Spike.error_out;
    
    nosub_wf_all.LFP.correct_in(sess,1:3001) = nosub_wf.LFP.correct_in;
    nosub_wf_all.LFP.correct_out(sess,1:3001) = nosub_wf.LFP.correct_out;
    nosub_wf_all.LFP.error_in(sess,1:3001) = nosub_wf.LFP.error_in;
    nosub_wf_all.LFP.error_out(sess,1:3001) = nosub_wf.LFP.error_out;
    
    nosub_wf_all.EEG.correct_in(sess,1:3001) = nosub_wf.EEG.correct_in;
    nosub_wf_all.EEG.correct_out(sess,1:3001) = nosub_wf.EEG.correct_out;
    nosub_wf_all.EEG.error_in(sess,1:3001) = nosub_wf.EEG.error_in;
    nosub_wf_all.EEG.error_out(sess,1:3001) = nosub_wf.EEG.error_out;
    
    %keep track of mean sub-sampled TDTs.  This applies only to correct
    %trials because only correct trials were sub-sampled.  The
    %corresponding error trial TDTs will be the nosub TDTs.
    subTDT_all.correct_Spike(sess,1) = nanmean(subTDT.correct_Spike);
    subTDT_all.correct_LFP(sess,1) = nanmean(subTDT.correct_LFP);
    subTDT_all.correct_EEG(sess,1) = nanmean(subTDT.correct_EEG);

    
    %keep track of mean sub-sampled waveforms.  This applies only to
    %correct trials because only correct trials were sub-sampled.  The
    %corresponding error trial waveforms will be the nosub waveforms.
    sub_wf_all.Spike.correct_in(sess,1:601) = nanmean(sub_wf.Spike.correct_in);
    sub_wf_all.Spike.correct_out(sess,1:601) = nanmean(sub_wf.Spike.correct_out);
    sub_wf_all.LFP.correct_in(sess,1:3001) = nanmean(sub_wf.LFP.correct_in);
    sub_wf_all.LFP.correct_out(sess,1:3001) = nanmean(sub_wf.LFP.correct_out);
    sub_wf_all.EEG.correct_in(sess,1:3001) = nanmean(sub_wf.EEG.correct_in);
    sub_wf_all.EEG.correct_out(sess,1:3001) = nanmean(sub_wf.EEG.correct_out);
    
    keep file_list sess *_all*
end

fig

subplot(1,3,1)
plot(-100:500,nanmean(sub_wf_all.Spike.correct_in),'b',-100:500,nanmean(sub_wf_all.Spike.correct_out),'--b',-100:500,nanmean(nosub_wf_all.Spike.error_in),'r',-100:500,nanmean(nosub_wf_all.Spike.error_out),'--r','linewidth',2)
xlim([-100 500])
vline(nanmean(subTDT_all.correct_Spike),'b')
vline(nanmean(nosubTDT_all.error_Spike),'r')
fon
legend('Cor In','Cor Out','Err In','Err Out','location','southeast')
title('Spikes')

subplot(1,3,2)
plot(-500:2500,nanmean(sub_wf_all.LFP.correct_in),'b',-500:2500,nanmean(sub_wf_all.LFP.correct_out),'--b',-500:2500,nanmean(nosub_wf_all.LFP.error_in),'r',-500:2500,nanmean(nosub_wf_all.LFP.error_out),'--r','linewidth',2)
xlim([-100 500])
axis ij
vline(nanmean(subTDT_all.correct_LFP),'b')
vline(nanmean(nosubTDT_all.error_LFP),'r')
fon
title('LFP')

subplot(1,3,3)
plot(-500:2500,nanmean(sub_wf_all.EEG.correct_in),'b',-500:2500,nanmean(sub_wf_all.EEG.correct_out),'--b',-500:2500,nanmean(nosub_wf_all.EEG.error_in),'r',-500:2500,nanmean(nosub_wf_all.EEG.error_out),'--r','linewidth',2)
xlim([-100 500])
axis ij
vline(nanmean(subTDT_all.correct_EEG),'b')
vline(nanmean(nosubTDT_all.error_EEG),'r')
fon
title('EEG')