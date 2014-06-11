%batch for across-session Coherence analyses

plotFlag = 1;

cd /volumes/Dump2/Coherence/Uber/Matrices/SPK-LFP/SameHemi/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');



%due to size of matrices, am going to separately save

%=========================================================

%preallocate
coh_targ_all.correct_nosub(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_slow(1:281,1:206,1:length(batch_list)) = NaN;

coh_targ_all.errors(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.errors_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.errors_slow(1:281,1:206,1:length(batch_list)) = NaN;


n_all.correct_nosub(1:length(batch_list),1) = NaN;
n_all.correct(1:length(batch_list),1) = NaN;
n_all.correct_fast(1:length(batch_list),1) = NaN;
n_all.correct_slow(1:length(batch_list),1) = NaN;

n_all.errors(1:length(batch_list),1) = NaN;
n_all.errors_fast(1:length(batch_list),1) = NaN;
n_all.errors_slow(1:length(batch_list),1) = NaN;

%RTs_all.correct(1:31,1,1:length(batch_list),1) = NaN;

wf_sig1_targ_all.correct_nosub(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_fast(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_slow(1:length(batch_list),1:3001) = NaN;

wf_sig1_targ_all.errors(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.errors_fast(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.errors_slow(1:length(batch_list),1:3001) = NaN;

wf_sig2_targ_all.correct_nosub(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_fast(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_slow(1:length(batch_list),1:3001) = NaN;

wf_sig2_targ_all.errors(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.errors_fast(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.errors_slow(1:length(batch_list),1:3001) = NaN;


coh_targ_all_SHIFT.correct_nosub(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_slow(1:281,1:206,1:length(batch_list)) = NaN;

coh_targ_all_SHIFT.errors(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.errors_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.errors_slow(1:281,1:206,1:length(batch_list)) = NaN;

for sess = 1:length(batch_list)
    sess
    
    load(batch_list(sess).name,'RTs','coh_targ','coh_resp','n','wf_sig1_targ','wf_sig2_targ', ...
        'wf_sig1_resp','wf_sig2_resp','tout_targ','tout_resp','f_targ','f_resp','-mat')
    
    
    

    %TRY to do this: it will fail when Tin or Din does not exist
    try
        coh_targ_all.correct_nosub(1:281,1:206,sess) = coh_targ.correct_nosub;
        coh_targ_all.correct(1:281,1:206,sess) = coh_targ.correct;
        coh_targ_all.correct_fast(1:281,1:206,sess) = coh_targ.correct_fast;
        coh_targ_all.correct_slow(1:281,1:206,sess) = coh_targ.correct_slow;
        
        coh_targ_all.errors(1:281,1:206,sess) = coh_targ.errors;
        coh_targ_all.errors_fast(1:281,1:206,sess) = coh_targ.errors_fast;
        coh_targ_all.errors_slow(1:281,1:206,sess) = coh_targ.errors_slow;
        
        n_all.correct_nosub(sess,1) = n.correct_nosub;
        n_all.correct(sess,1) = n.correct;
        n_all.correct_fast(sess,1) = n.correct_fast;
        n_all.correct_slow(sess,1) = n.correct_slow;
        
        n_all.errors(sess,1) = n.errors;
        n_all.errors_fast(sess,1) = n.errors_fast;
        n_all.errors_slow(sess,1) = n.errors_slow;
        
        RTs_all.correct_nosub(1:length(RTs.correct_nosub),1,sess) = RTs.correct_nosub;
        RTs_all.correct(1:length(RTs.correct),1,sess) = RTs.correct;
        RTs_all.correct_fast(1:length(RTs.correct_fast),1,sess) = RTs.correct_fast;
        RTs_all.correct_slow(1:length(RTs.correct_slow),1,sess) = RTs.correct_slow;
        
        RTs_all.errors(1:length(RTs.errors),1,sess) = RTs.errors;
        RTs_all.errors_fast(1:length(RTs.errors_fast),1,sess) = RTs.errors_fast;
        RTs_all.errors_slow(1:length(RTs.errors_slow),1,sess) = RTs.errors_slow;
        
        wf_sig1_targ_all.correct_nosub(sess,1:3001) = wf_sig1_targ.correct_nosub;
        wf_sig1_targ_all.correct(sess,1:3001) = wf_sig1_targ.correct;
        wf_sig1_targ_all.correct_fast(sess,1:3001) = wf_sig1_targ.correct_fast;
        wf_sig1_targ_all.correct_slow(sess,1:3001) = wf_sig1_targ.correct_slow;
        
        wf_sig1_targ_all.errors(sess,1:3001) = wf_sig1_targ.errors;
        wf_sig1_targ_all.errors_fast(sess,1:3001) = wf_sig1_targ.errors_fast;
        wf_sig1_targ_all.errors_slow(sess,1:3001) = wf_sig1_targ.errors_slow;
        
        wf_sig2_targ_all.correct_nosub(sess,1:3001) = wf_sig1_targ.correct_nosub;
        wf_sig2_targ_all.correct(sess,1:3001) = wf_sig1_targ.correct;
        wf_sig2_targ_all.correct_fast(sess,1:3001) = wf_sig1_targ.correct_fast;
        wf_sig2_targ_all.correct_slow(sess,1:3001) = wf_sig1_targ.correct_slow;
        
        wf_sig2_targ_all.errors(sess,1:3001) = wf_sig1_targ.errors;
        wf_sig2_targ_all.errors_fast(sess,1:3001) = wf_sig1_targ.errors_fast;
        wf_sig2_targ_all.errors_slow(sess,1:3001) = wf_sig1_targ.errors_slow;
     
    catch
        disp('Skipping...')
        continue
    end
    
    %Now get SHIFT PREDICTOR
   
    keep *_all* tout_targ tout_resp f_targ f_resp plotFlag sess batch_list
    
    try
    load([batch_list(sess).name(1:end-4) '_SHIFT_PREDICTOR.mat'],'coh_targ','coh_resp','-mat')
    
        coh_targ_all_SHIFT.correct_nosub(1:281,1:206,sess) = coh_targ.correct_nosub;
        coh_targ_all_SHIFT.correct(1:281,1:206,sess) = coh_targ.correct;
        coh_targ_all_SHIFT.correct_fast(1:281,1:206,sess) = coh_targ.correct_fast;
        coh_targ_all_SHIFT.correct_slow(1:281,1:206,sess) = coh_targ.correct_slow;
        
        coh_targ_all_SHIFT.errors(1:281,1:206,sess) = coh_targ.errors;
        coh_targ_all_SHIFT.errors_fast(1:281,1:206,sess) = coh_targ.errors_fast;
        coh_targ_all_SHIFT.errors_slow(1:281,1:206,sess) = coh_targ.errors_slow;
    catch
        disp('Missing SHIFT PREDICTOR file')
        continue
    end
end
%forgot to save tout and f in matrices

keep *_all* tout_targ tout_resp f_targ f_resp plotFlag
%==================================================

%take baselines
% 
% if plotFlag == 1
%     figure
%     orient landscape
%     set(gcf,'color','white')
%     
%     subplot(2,2,1)
%     plot(-500:2500,nanmean(wf_sig1_targ_all.correct_Tin),'b',-500:2500,nanmean(wf_sig1_targ_all.correct_Din),'--b',-500:2500,nanmean(wf_sig2_targ_all.correct_Tin),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_Din),'--r')
%     xlim([-100 500])
%     
%     subplot(2,2,2)
%     coh = nanmean(coh_targ_all.correct_Tin,3) - nanmean(coh_targ_all_SHIFT.correct_Tin,3);
%     imagesc(tout_targ,f_targ,abs(coh)')
%     axis xy
%     colorbar
%     xlim([-100 500])
%     title('Shift Corrected Tin Coherence')
%     col(1,1:2) = get(gca,'clim');
%     
%     subplot(2,2,4)
%     coh = nanmean(coh_targ_all.correct_Din,3) - nanmean(coh_targ_all_SHIFT.correct_Din,3);
%     imagesc(tout_targ,f_targ,abs(coh)')
%     axis xy
%     colorbar
%     xlim([-100 500])
%     title('Shift Corrected Din Coherence')
%     col(1,1:2) = get(gca,'clim');
%     
%     newcol = [min(col(:,1)) max(col(:,2))];
%     
%     subplot(2,2,2)
%     set(gca,'clim',newcol)
%     subplot(2,2,4)
%     set(gca,'clim',newcol)
% end
% 
