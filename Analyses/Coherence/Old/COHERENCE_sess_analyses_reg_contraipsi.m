%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

cd /volumes/dump2/Coherence/ContraIpsi/Matrices/LFP-LFP/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');

%preallocate
coh_correct_targ_contracontra_all(1:281,1:206,1:length(batch_list)) = NaN;
coh_correct_targ_ipsiipsi_all(1:281,1:206,1:length(batch_list)) = NaN;

% coh_errors_targ_contracontra_all(1:281,1:206,1:length(batch_list)) = NaN;
% coh_errors_targ_ipsiipsi_all(1:281,1:206,1:length(batch_list)) = NaN;
% 
% cor_correct_contra_all(1:length(batch_list),1:401) = NaN;
% cor_correct_ipsi_all(1:length(batch_list),1:401) = NaN;
% cor_errors_contra_all(1:length(batch_list),1:401) = NaN;
% cor_errors_ipsi_all(1:length(batch_list),1:401) = NaN;
% 
% wf_sig1_correct_contra_all(1:length(batch_list),1:3001) = NaN;
% wf_sig1_correct_ipsi_all(1:length(batch_list),1:3001) = NaN;
% wf_sig1_errors_contra_all(1:length(batch_list),1:3001) = NaN;
% wf_sig1_errors_ipsi_all(1:length(batch_list),1:3001) = NaN;
% 
% wf_sig2_correct_contra_all(1:length(batch_list),1:3001) = NaN;
% wf_sig2_correct_ipsi_all(1:length(batch_list),1:3001) = NaN;
% wf_sig2_errors_contra_all(1:length(batch_list),1:3001) = NaN;
wf_sig2_errors_ipsi_all(1:length(batch_list),1:3001) = NaN;

for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'coh_correct_targ_contracontra','coh_correct_targ_ipsiipsi', ...
        'coh_errors_targ_contracontra','coh_errors_targ_ipsiipsi','cor_correct_contra', ...
        'cor_correct_ipsi','cor_errors_contra','cor_errors_ipsi','freqind_targ','freqvals_targ', ...
        'lags','tind_targ','tvals_targ','wf_sig1_correct_contra','wf_sig1_correct_ipsi', ...
        'wf_sig1_errors_contra','wf_sig1_errors_ipsi','wf_sig2_correct_contra', ...
        'wf_sig2_correct_ipsi','wf_sig2_errors_contra','wf_sig2_errors_ipsi','-mat')
    
    coh_correct_targ_contracontra_all(1:2802,1:206,i) = coh_correct_targ_contracontra;
    coh_correct_targ_ipsiipsi_all(1:2802,1:206,i) = coh_correct_targ_ipsiipsi;
    coh_errors_targ_contracontra_all(1:2802,1:206,i) = coh_errors_targ_contracontra;
    coh_errors_targ_ipsiipsi_all(1:2802,1:206,i) = coh_errors_targ_ipsiipsi;
    
    cor_correct_contra_all(i,1:401) = nanmean(cor_correct_contra);
    cor_correct_ipsi_all(i,1:401) = nanmean(cor_correct_ipsi);
    cor_errors_contra_all(i,1:401) = nanmean(cor_errors_contra);
    cor_errors_ipsi_all(i,1:401) = nanmean(cor_errors_ipsi);
    
    wf_sig1_correct_contra_all(i,1:3001) = wf_sig1_correct_contra;
    wf_sig1_correct_ipsi_all(i,1:3001) = wf_sig1_correct_ipsi;
    wf_sig1_errors_contra_all(i,1:3001) = wf_sig1_errors_contra;
    wf_sig1_errors_ipsi_all(i,1:3001) = wf_sig1_errors_ipsi;
    
    wf_sig2_correct_contra_all(i,1:3001) = wf_sig2_correct_contra;
    wf_sig2_correct_ipsi_all(i,1:3001) = wf_sig2_correct_ipsi;
    wf_sig2_errors_contra_all(i,1:3001) = wf_sig2_errors_contra;
    wf_sig2_errors_ipsi_all(i,1:3001) = wf_sig2_errors_ipsi;
    
    clear coh_correct_targ_contracontra coh_correct_targ_ipsiipsi ...
        coh_errors_targ_contracontra coh_errors_targ_ipsiipsi ...
        cor_correct_contra cor_correct_ipsi cor_errors_contra cor_errors_ipsi ...
        wf_sig1_correct_contra wf_sig1_correct_ipsi wf_sig1_errors_contra ...
        wf_sig1_errors_ipsi wf_sig2_correct_contra wf_sig2_correct_ipsi ...
        wf_sig2_errors_contra wf_sig2_errors_ipsi
end
clear batch_list i ans sess
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