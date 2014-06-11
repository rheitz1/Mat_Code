%batch for across-session Coherence analyses

plotFlag = 1;

cd /volumes/Dump2/Coherence/Uber/Matrices/SPK-LFP/SameHemi/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');



%due to size of matrices, am going to separately save

%=========================================================

%preallocate
coh_targ_all.correct_Tin(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_Din(1:281,1:206,1:length(batch_list)) = NaN;
coh_resp_all.correct_Tin(1:71,1:206,1:length(batch_list)) = NaN;
coh_resp_all.correct_Din(1:71,1:206,1:length(batch_list)) = NaN;

n_all.correct_Tin(1:length(batch_list),1) = NaN;
n_all.correct_Din(1:length(batch_list),1) = NaN;

wf_sig1_targ_all.correct_Tin(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_Din(1:length(batch_list),1:3001) = NaN;
wf_sig1_resp_all.correct_Tin(1:length(batch_list),1:901) = NaN;
wf_sig1_resp_all.correct_Din(1:length(batch_list),1:901) = NaN;

wf_sig2_targ_all.correct_Tin(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_Din(1:length(batch_list),1:3001) = NaN;
wf_sig2_resp_all.correct_Tin(1:length(batch_list),1:901) = NaN;
wf_sig2_resp_all.correct_Din(1:length(batch_list),1:901) = NaN;



coh_targ_all_SHIFT.correct_Tin(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_Din(1:281,1:206,1:length(batch_list)) = NaN;
coh_resp_all_SHIFT.correct_Tin(1:71,1:206,1:length(batch_list)) = NaN;
coh_resp_all_SHIFT.correct_Din(1:71,1:206,1:length(batch_list)) = NaN;

for sess = 1:length(batch_list)
    sess
    
    load(batch_list(sess).name,'RTs','coh_targ','coh_resp','n','wf_sig1_targ','wf_sig2_targ', ...
        'wf_sig1_resp','wf_sig2_resp','tout_targ','tout_resp','f_targ','f_resp','-mat')
    
    
    

    %TRY to do this: it will fail when Tin or Din does not exist
    try
        coh_targ_all.correct_Tin(1:281,1:206,sess) = coh_targ.correct_Tin;
        coh_targ_all.correct_Din(1:281,1:206,sess) = coh_targ.correct_Din;
        coh_resp_all.correct_Tin(1:71,1:206,sess) = coh_resp.correct_Tin;
        coh_resp_all.correct_Din(1:71,1:206,sess) = coh_resp.correct_Din;
        
        n_all.correct_Tin(sess,1) = n.correct_Tin;
        n_all.correct_Din(sess,1) = n.correct_Din;
        
         RTs_all.correct(1:length(RTs.correct),1,sess) = RTs.correct;
        
        wf_sig1_targ_all.correct_Tin(sess,1:3001) = wf_sig1_targ.correct_Tin;
        wf_sig1_targ_all.correct_Din(sess,1:3001) = wf_sig1_targ.correct_Din;
        wf_sig1_resp_all.correct_Tin(sess,1:901) = wf_sig1_resp.correct_Tin;
        wf_sig1_resp_all.correct_Din(sess,1:901) = wf_sig1_resp.correct_Din;
        
        wf_sig2_targ_all.correct_Tin(sess,1:3001) = wf_sig2_targ.correct_Tin;
        wf_sig2_targ_all.correct_Din(sess,1:3001) = wf_sig2_targ.correct_Din;
        wf_sig2_resp_all.correct_Tin(sess,1:901) = wf_sig2_resp.correct_Tin;
        wf_sig2_resp_all.correct_Din(sess,1:901) = wf_sig2_resp.correct_Din;
    catch
        disp('Skipping...')
        continue
    end
    
    %Now get SHIFT PREDICTOR
   
    keep *_all* tout_targ tout_resp f_targ f_resp plotFlag sess batch_list
    
    try
        load([batch_list(sess).name(1:end-4) '_SHIFT_PREDICTOR.mat'],'coh_targ','coh_resp','-mat')
        
        coh_targ_all_SHIFT.correct_Tin(1:281,1:206,sess) = coh_targ.correct_Tin;
        coh_targ_all_SHIFT.correct_Din(1:281,1:206,sess) = coh_targ.correct_Din;
        coh_resp_all_SHIFT.correct_Tin(1:71,1:206,sess) = coh_resp.correct_Tin;
        coh_resp_all_SHIFT.correct_Din(1:71,1:206,sess) = coh_resp.correct_Din;
    catch
            disp('Missing SHIFT PREDICTOR file')
            continue
    end
end
%forgot to save tout and f in matrices

keep *_all* tout_targ tout_resp f_targ f_resp plotFlag
%==================================================

%take baselines

if plotFlag == 1
    figure
    orient landscape
    set(gcf,'color','white')
    
    subplot(2,2,1)
    plot(-500:2500,nanmean(wf_sig1_targ_all.correct_Tin),'b',-500:2500,nanmean(wf_sig1_targ_all.correct_Din),'--b',-500:2500,nanmean(wf_sig2_targ_all.correct_Tin),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_Din),'--r')
    xlim([-100 500])
    
    subplot(2,2,2)
    coh = nanmean(coh_targ_all.correct_Tin,3) - nanmean(coh_targ_all_SHIFT.correct_Tin,3);
    imagesc(tout_targ,f_targ,abs(coh)')
    axis xy
    colorbar
    xlim([-100 500])
    title('Shift Corrected Tin Coherence')
    col(1,1:2) = get(gca,'clim');
    
    subplot(2,2,4)
    coh = nanmean(coh_targ_all.correct_Din,3) - nanmean(coh_targ_all_SHIFT.correct_Din,3);
    imagesc(tout_targ,f_targ,abs(coh)')
    axis xy
    colorbar
    xlim([-100 500])
    title('Shift Corrected Din Coherence')
    col(1,1:2) = get(gca,'clim');
    
    newcol = [min(col(:,1)) max(col(:,2))];
    
    subplot(2,2,2)
    set(gca,'clim',newcol)
    subplot(2,2,4)
    set(gca,'clim',newcol)
end


