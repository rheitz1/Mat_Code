%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

cd /volumes/dump2/Coherence/MG/Matrices/EEG-EEG/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');

%preallocate
coh_correct_all(1:281,1:206,1:length(batch_list)) = NaN;
cor_correct_all(1:length(batch_list),1:401) = NaN;
wf_sig1_correct_all(1:length(batch_list),1:3001) = NaN;
wf_sig2_correct_all(1:length(batch_list),1:3001) = NaN;

for sess = 1:length(batch_list)
    sess
    load(batch_list(sess).name,'coh_correct_targ','cor_correct_targ','wf_sig1_correct_targ','wf_sig2_correct_targ','freqind_targ','freqvals_targ','tind_targ','tvals_targ','lags')
    
    coh_correct_all(1:281,1:206,sess) = coh_correct_targ;
    cor_correct_all(sess,1:401) = nanmean(cor_correct_targ);
    wf_sig1_correct_all(sess,1:3001) = wf_sig1_correct_targ;
    wf_sig2_correct_all(sess,1:3001) = wf_sig2_correct_targ;
    
    
    clear coh_correct_targ cor_correct_targ wf_sig1_correct_targ wf_sig2_correct_targ
end
clear batch_list i
% 
% figure
% set(gcf,'color','white')
% orient landscape
% subplot(2,2,1)
% imagesc(nanmean(abs(coh_correct_all),3)')
% axis xy
% colorbar
% axhand = gca;
% set(axhand,'YTickLabel',freqvals);
% set(axhand,'YTick',freqind);
% set(axhand,'XTickLabel',tvals);
% set(axhand,'XTick',tind);
% title('Mean Coherence - Correct')
% 
% subplot(2,2,2)
% imagesc(nanmean(abs(coh_errors_all),3)')
% axis xy
% colorbar
% axhand = gca;
% set(axhand,'YTickLabel',freqvals);
% set(axhand,'YTick',freqind);
% set(axhand,'XTickLabel',tvals);
% set(axhand,'XTick',tind);
% title('Mean Coherence - Errors')
% 
% subplot(2,2,3)
% plot(-200:200,nanmean(cor_correct_all),'r',-200:200,nanmean(cor_errors_all),'b')
% legend('Correct','Errors')
% title('Correlogram')
% xlabel('Lag')
% ylabel('r')