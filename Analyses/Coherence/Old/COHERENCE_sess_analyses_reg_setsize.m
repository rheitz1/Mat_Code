%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

cd /volumes/dump2/Coherence/SetSize/Matrices/LFP-LFP/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');

%preallocate


%accidentally used higher resolution (1 ms time-steps) for resp-aligned
%coherence.  THis is why first dimension has more values
spec1_correct_targ_ss2_all(1:71,1:206,1:length(batch_list)) = NaN;
spec1_correct_targ_ss4_all(1:71,1:206,1:length(batch_list)) = NaN;
spec1_correct_targ_ss8_all(1:71,1:206,1:length(batch_list)) = NaN;

spec2_correct_targ_ss2_all(1:71,1:206,1:length(batch_list)) = NaN;
spec2_correct_targ_ss4_all(1:71,1:206,1:length(batch_list)) = NaN;
spec2_correct_targ_ss8_all(1:71,1:206,1:length(batch_list)) = NaN;

coh_correct_targ_ss2_all(1:71,1:206,1:length(batch_list)) = NaN;
coh_correct_targ_ss4_all(1:71,1:206,1:length(batch_list)) = NaN;
coh_correct_targ_ss8_all(1:71,1:206,1:length(batch_list)) = NaN;

coh_correct_resp_ss2_all(1:71,1:206,1:length(batch_list)) = NaN;
coh_correct_resp_ss4_all(1:71,1:206,1:length(batch_list)) = NaN;
coh_correct_resp_ss8_all(1:71,1:206,1:length(batch_list)) = NaN;

cor_correct_targ_ss2_all(1:length(batch_list),1:401) = NaN;
cor_correct_targ_ss4_all(1:length(batch_list),1:401) = NaN;
cor_correct_targ_ss8_all(1:length(batch_list),1:401) = NaN;

wf_sig1_correct_targ_ss2_all(1:length(batch_list),1:901) = NaN;
wf_sig1_correct_targ_ss4_all(1:length(batch_list),1:901) = NaN;
wf_sig1_correct_targ_ss8_all(1:length(batch_list),1:901) = NaN;

wf_sig1_correct_resp_ss2_all(1:length(batch_list),1:901) = NaN;
wf_sig1_correct_resp_ss4_all(1:length(batch_list),1:901) = NaN;
wf_sig1_correct_resp_ss8_all(1:length(batch_list),1:901) = NaN;

wf_sig2_correct_targ_ss2_all(1:length(batch_list),1:901) = NaN;
wf_sig2_correct_targ_ss4_all(1:length(batch_list),1:901) = NaN;
wf_sig2_correct_targ_ss8_all(1:length(batch_list),1:901) = NaN;

wf_sig2_correct_resp_ss2_all(1:length(batch_list),1:901) = NaN;
wf_sig2_correct_resp_ss4_all(1:length(batch_list),1:901) = NaN;
wf_sig2_correct_resp_ss8_all(1:length(batch_list),1:901) = NaN;


for sess = 1:length(batch_list)
    sess
    load(batch_list(sess).name,'spec1_correct_targ_ss2','spec1_correct_targ_ss4', ...
        'spec1_correct_targ_ss8','spec2_correct_targ_ss2','spec2_correct_targ_ss4', ...
        'spec2_correct_targ_ss8','coh_correct_targ_ss2','coh_correct_targ_ss4', ...
        'coh_correct_targ_ss8','coh_correct_resp_ss2','coh_correct_resp_ss4', ...
        'coh_correct_resp_ss8','cor_correct_targ_ss2','cor_correct_targ_ss4','cor_correct_targ_ss8', ...
        'wf_sig1_correct_targ_ss2','wf_sig1_correct_targ_ss4','wf_sig1_correct_targ_ss8', ...
        'wf_sig1_correct_resp_ss2','wf_sig1_correct_resp_ss4','wf_sig1_correct_resp_ss8', ...
        'wf_sig2_correct_targ_ss2','wf_sig2_correct_targ_ss4','wf_sig2_correct_targ_ss8', ...
        'wf_sig2_correct_resp_ss2','wf_sig2_correct_resp_ss4','wf_sig2_correct_resp_ss8', ...
        'freqind_targ','freqvals_targ','tind_targ','tvals_targ','lags')
    
    spec1_correct_targ_ss2_all(1:71,1:206,sess) = spec1_correct_targ_ss2;
    spec1_correct_targ_ss4_all(1:71,1:206,sess) = spec1_correct_targ_ss4;
    spec1_correct_targ_ss8_all(1:71,1:206,sess) = spec1_correct_targ_ss8;
    
    spec2_correct_targ_ss2_all(1:71,1:206,sess) = spec2_correct_targ_ss2;
    spec2_correct_targ_ss4_all(1:71,1:206,sess) = spec2_correct_targ_ss4;
    spec2_correct_targ_ss8_all(1:71,1:206,sess) = spec2_correct_targ_ss8;
    
    coh_correct_targ_ss2_all(1:71,1:206,sess) = coh_correct_targ_ss2;
    coh_correct_targ_ss4_all(1:71,1:206,sess) = coh_correct_targ_ss4;
    coh_correct_targ_ss8_all(1:71,1:206,sess) = coh_correct_targ_ss8;
    
    coh_correct_resp_ss2_all(1:71,1:206,sess) = coh_correct_resp_ss2;
    coh_correct_resp_ss4_all(1:71,1:206,sess) = coh_correct_resp_ss4;
    coh_correct_resp_ss8_all(1:71,1:206,sess) = coh_correct_resp_ss8;
    
    cor_correct_targ_ss2_all(sess,1:401) = nanmean(cor_correct_targ_ss2);
    cor_correct_targ_ss4_all(sess,1:401) = nanmean(cor_correct_targ_ss4);
    cor_correct_targ_ss8_all(sess,1:401) = nanmean(cor_correct_targ_ss8);
    
    wf_sig1_correct_targ_ss2_all(sess,1:901) = wf_sig1_correct_targ_ss2;
    wf_sig1_correct_targ_ss4_all(sess,1:901) = wf_sig1_correct_targ_ss4;
    wf_sig1_correct_targ_ss8_all(sess,1:901) = wf_sig1_correct_targ_ss8;
    
    wf_sig2_correct_targ_ss2_all(sess,1:901) = wf_sig2_correct_targ_ss2;
    wf_sig2_correct_targ_ss4_all(sess,1:901) = wf_sig2_correct_targ_ss4;
    wf_sig2_correct_targ_ss8_all(sess,1:901) = wf_sig2_correct_targ_ss8;
    
    
    wf_sig1_correct_resp_ss2_all(sess,1:901) = wf_sig1_correct_resp_ss2;
    wf_sig1_correct_resp_ss4_all(sess,1:901) = wf_sig1_correct_resp_ss4;
    wf_sig1_correct_resp_ss8_all(sess,1:901) = wf_sig1_correct_resp_ss8;
    
    wf_sig2_correct_resp_ss2_all(sess,1:901) = wf_sig2_correct_resp_ss2;
    wf_sig2_correct_resp_ss4_all(sess,1:901) = wf_sig2_correct_resp_ss4;
    wf_sig2_correct_resp_ss8_all(sess,1:901) = wf_sig2_correct_resp_ss8;
    
    
    clear spec1_correct_targ_ss2 spec1_correct_targ_ss4 spec1_correct_targ_ss8 ...
        spec2_correct_targ_ss2 spec2_correct_targ_ss4 spec2_correct_targ_ss8 ...
        coh_correct_targ_ss2 coh_correct_targ_ss4 coh_correct_targ_ss8 ...
        coh_correct_resp_ss2 coh_correct_resp_ss4 coh_correct_resp_ss8 ...
        cor_correct_targ_ss2 cor_correct_targ_ss4 cor_correct_targ_ss8 ...
        wf_sig1_correct_targ_ss2 wf_sig1_correct_targ_ss4 wf_sig1_correct_targ_ss8 ...
        wf_sig1_correct_resp_ss2 wf_sig1_correct_resp_ss4 wf_sig1_correct_resp_ss8 ...
        wf_sig2_correct_targ_ss2 wf_sig2_correct_targ_ss4 wf_sig2_correct_targ_ss8 ...
        wf_sig2_correct_resp_ss2 wf_sig2_correct_resp_ss4 wf_sig2_correct_resp_ss8 ...
        
end
clear batch_list i sess ans
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